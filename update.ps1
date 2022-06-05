$groovyVersion = $($args[0])

dir -Recurse -Filter Dockerfile | ForEach-Object {
    (Get-Content -Path $_.FullName) -replace "ENV GROOVY_VERSION .+", "ENV GROOVY_VERSION ${groovyVersion}" | Set-Content $_.FullName
}
(Get-Content -Path .github/workflows/ci.yaml) -replace "expectedGroovyVersion: .+", "expectedGroovyVersion: ${groovyVersion}" | Set-Content .github/workflows/ci.yaml
