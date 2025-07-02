#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# NOTE: run something like `git fetch origin` before this script to ensure all remote branch references are up-to-date!

# front-load the "command-not-found" notices
bashbrew --version > $null

$gitRemote = (git remote -v | Select-String 'groovy/docker-groovy' | ForEach-Object { $_.Line.Split()[0] })[0]

@"
Maintainers: Keegan Witt <keeganwitt@gmail.com> (@keeganwitt)
GitRepo: https://github.com/groovy/docker-groovy.git
"@

$usedTags = @{}
$archesLookupCache = @{}

$commit = git rev-parse "refs/remotes/$gitRemote/master"
$common = @"
GitFetch: refs/heads/master
GitCommit: $commit
"@

$allDirectories = git ls-tree -r --name-only "$commit" |
                 Where-Object { $_ -match '/Dockerfile$' } |
                 ForEach-Object { $_ -replace '/Dockerfile$', '' }

$directoriesWithSortKeys = @()
foreach ($dir in $allDirectories) {
    $jdkPart = ($dir -split '-')[0] -replace 'jdk', ''
    $jdkNum = [int]$jdkPart

    $primaryJdkSort = if ($jdkNum -in @(21, 17, 11, 8)) { 0 } else { 1 }
    $secondaryJdkSort = if ($jdkNum -eq 999) { $jdkNum } else { -$jdkNum }

    $variantSort = 0 # Default for plain
    if ($dir -match 'alpine') { $variantSort = 1 }

    $suiteSort = -2 # Default (noble or unspecified)
    if ($dir -match 'jammy') { $suiteSort = -1 }

    $directoriesWithSortKeys += [PSCustomObject]@{
        Directory = $dir
        SortKeys = @($primaryJdkSort, $secondaryJdkSort, $variantSort, $suiteSort, $dir)
    }
}

$directories = $directoriesWithSortKeys |
               Sort-Object -Property { $_.SortKeys[0] }, { $_.SortKeys[1] }, { $_.SortKeys[2] }, { $_.SortKeys[3] }, { $_.SortKeys[4] } |
               Select-Object -ExpandProperty Directory

$firstVersion = $null
foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        continue
    }

    $dockerfile = git show "${commit}:$dir/Dockerfile"

    $from = $dockerfile | Select-String -Pattern '^FROM ' | ForEach-Object { $_.Line -split ' ' | Select-Object -Last 1 }
    $version = $dockerfile | Select-String -Pattern '^ENV GROOVY_VERSION' | ForEach-Object { $_.Line -split '=' | Select-Object -Last 1 }
    if ($version -match '^\d+\.\d+$') {
        $version = "$version.0"
    }

    if (-not $firstVersion) {
        $firstVersion = $version
    }
    if ($version -ne $firstVersion) {
        Write-Error "$dir contains $version (compared to $firstVersion in $($directories[0]))"
    }

    $fromTag = $from.Split(':')[-1]
    $suite = $fromTag -replace '-jdk$', '' -replace '.*-', ''
    $jdk = $dir.Split('-')[0]

    switch -wildcard ($dir) {
        '*-alpine'   { $variant = 'alpine' }
        default      { $variant = '' }
    }

    $tags = @()
    $versions = @(
        "$version",
        "$($version -replace '\.\d+$')",
        "$($version -replace '\.\d+\.\d+$')",
        ''
    )

    $tags += $versions | ForEach-Object {
        if ($variant) {
            "$_-$jdk-$variant"
        } else {
            "$_-$jdk"
        }
    }

    switch ($variant) {
        '' {
            $tags += $versions | ForEach-Object { "$_-$jdk-$suite" }
            $tags += 'latest'
            $tags += $versions | ForEach-Object { "$_-jdk" }
            $tags += $versions
            $tags += $versions | ForEach-Object { "$_-jdk-$suite" }
            $tags += $versions | ForEach-Object { "$_-$suite" }
        }
        'alpine' {
            $tags += $versions | ForEach-Object { "$_-jdk-alpine" }
            $tags += $versions | ForEach-Object { "$_-alpine" }
        }
    }

    $actualTags = @()
    foreach ($tag in $tags) {
        $tag = $tag -replace '^-', '' # remove leading hyphen if any
        if (-not $tag -or $usedTags.ContainsKey($tag)) {
            continue
        }
        $usedTags[$tag] = 1
        $actualTags += $tag
    }
    $actualTagsString = $actualTags -join ', '

    # Cache values to avoid excessive lookups for repeated base images
    $arches = $archesLookupCache[$from]
    if (-not $arches) {
        # Using backtick as delimiter in Go template avoids issues with comma in join function
        $arches = (bashbrew cat --format '{{ join `, ` .TagEntry.Architectures }}' "https://github.com/docker-library/official-images/raw/HEAD/library/$from")
        $archesLookupCache[$from] = $arches
    }

    @"

Tags: $actualTagsString
Architectures: $arches
$common
Directory: $dir
"@
}
