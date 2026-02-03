#!/usr/bin/env pwsh

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$majorVersions = 3, 4, 5

foreach ($version in $majorVersions) {
    $tags = Invoke-RestMethod "https://api.github.com/repos/apache/groovy/tags?per_page=100"
    $match = $tags.name | Select-String -Pattern "GROOVY_${version}" | Select-Object -First 1
    
    if (-not $match) {
        Write-Warning "No tag found for Groovy ${version}"
        continue
    }

    $groovyVersion = $match.ToString().replace("GROOVY_", "").replace("_", ".")
    
    Write-Host "Updating Groovy ${version} to ${groovyVersion}"
    
    Get-ChildItem -Recurse -Path "groovy-${version}" -Filter Dockerfile | ForEach-Object {
        (Get-Content -Path $_.FullName) -replace "ENV GROOVY_VERSION=.+", "ENV GROOVY_VERSION=${groovyVersion}" | Set-Content $_.FullName
    }
}
