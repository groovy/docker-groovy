#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# NOTE: run something like `git fetch origin` before this script to ensure all remote branch references are up-to-date!

# front-load the "command-not-found" notices
bashbrew --version > $null

@"
Maintainers: Keegan Witt <keeganwitt@gmail.com> (@keeganwitt)
GitRepo: https://github.com/groovy/docker-groovy.git
"@

$usedTags = @{}
$archesLookupCache = @{}

$commit = git rev-parse HEAD
$branch = git rev-parse --abbrev-ref HEAD
$common = @"
GitFetch: refs/heads/$branch
"@

$allDirectories = git ls-tree -r --name-only "$commit" |
                 Where-Object { $_ -match '/Dockerfile$' } |
                 ForEach-Object { $_ -replace '/Dockerfile$', '' }

$directoriesWithSortKeys = @()
foreach ($dir in $allDirectories) {
    # dir is like groovy-3/jdk11
    $groovyPart = $dir.Split('/')[0].Split('-')[1]
    $groovyNum = [int]$groovyPart
    $groovySort = -$groovyNum

    $jdkPart = $dir.Split('/')[1].Split('-')[0] -replace 'jdk', ''
    $jdkNum = [int]$jdkPart

    $primaryJdkSort = if ($jdkNum -in @(21, 17, 11, 8)) { 0 } else { 1 }
    $secondaryJdkSort = if ($jdkNum -eq 999) { $jdkNum } else { -$jdkNum }

    $variantSort = 0 # Default for plain
    if ($dir -match 'alpine') { $variantSort = 1 }

    $suiteSort = -2 # Default (noble or unspecified)
    if ($dir -match 'jammy') { $suiteSort = -1 }

    $directoriesWithSortKeys += [PSCustomObject]@{
        Directory = $dir
        SortKeys = @($groovySort, $primaryJdkSort, $secondaryJdkSort, $variantSort, $suiteSort, $dir)
    }
}

$directories = $directoriesWithSortKeys |
               Sort-Object -Property { $_.SortKeys[0] }, { $_.SortKeys[1] }, { $_.SortKeys[2] }, { $_.SortKeys[3] }, { $_.SortKeys[4] }, { $_.SortKeys[5] } |
               Select-Object -ExpandProperty Directory

$firstVersions = @{}
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

    $majorVersion = $version.Split('.')[0]

    if (-not $firstVersions.ContainsKey($majorVersion)) {
        $firstVersions[$majorVersion] = $version
    }
    if ($version -ne $firstVersions[$majorVersion]) {
        Write-Error "$dir contains $version (compared to $($firstVersions[$majorVersion]) in other images of major version $majorVersion)"
    }

    # Get the git commit for the specific directory
    $majorDir = $dir -split '/' | Select-Object -First 1
    $commit = git log -1 --format='%H' -- "$majorDir"

    $fromTag = $from.Split(':')[-1]
    $suite = $fromTag -replace '-jdk$', '' -replace '.*-', ''
    $dirName = $dir | Split-Path -Leaf
    $jdk = $dirName.Split('-')[0]

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
            if ($version -match "^5\.") {
                $tags += 'latest'
            }
            $tags += $versions | ForEach-Object { "$_-jdk" }
            $tags += $versions
            $tags += $versions | ForEach-Object { "$_-jdk-$suite" }
            $tags += $versions | ForEach-Object { "$_-$suite" }
        }
        'alpine' {
            $tags += $versions | ForEach-Object { "$_-jdk-alpine" }
            $tags += $versions | ForEach-Object { "$_-alpine" }
            if ($version -match "^5\.") {
                $tags += 'alpine'
            }
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
GitCommit: $commit
Directory: $dir
"@
}
