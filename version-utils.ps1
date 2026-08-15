function ConvertTo-GroovyVersion([string] $GitHubTag) {
    $version = $GitHubTag -replace '^GROOVY_', ''
    $version = $version -replace '_', '.'
    $version = $version -replace '\.ALPHA\.', '-alpha-'
    $version = $version -replace '\.BETA\.', '-beta-'
    $version = $version -replace '\.RC\.', '-rc-'
    return $version
}

function Test-GroovyPrerelease([string] $Version) {
    return $Version -cmatch '^[0-9]+\.[0-9]+\.[0-9]+-(alpha|beta|rc)-[0-9]+$'
}

function Get-GroovyTagVersions([string] $Version) {
    if (Test-GroovyPrerelease $Version) {
        return @($Version, ($Version -replace '\.\d+$'), ($Version -replace '\.\d+\.\d+$'))
    }
    return @(
        $Version,
        ($Version -replace '\.\d+$'),
        ($Version -replace '\.\d+\.\d+$'),
        ''
    )
}
