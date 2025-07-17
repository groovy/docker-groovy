#!/usr/bin/env pwsh
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$groovyVersion = $(((Invoke-WebRequest "https://api.github.com/repos/apache/groovy/tags" | ConvertFrom-Json).name | Select-String -Pattern "GROOVY_4" | Select-Object -First 1).ToString().replace("GROOVY_", "").replace("_", "."))

Write-Host "Updating to Groovy $groovyVersion"

dir -Recurse -Filter Dockerfile | ForEach-Object {
    (Get-Content -Path $_.FullName) -replace "ENV GROOVY_VERSION=.+", "ENV GROOVY_VERSION=${groovyVersion}" | Set-Content $_.FullName
}
(Get-Content -Path .github/workflows/ci.yaml) -replace "expectedGroovyVersion: .+", "expectedGroovyVersion: ${groovyVersion}" | Set-Content .github/workflows/ci.yaml
