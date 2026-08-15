$ErrorActionPreference = 'Stop'
. "$PSScriptRoot\..\version-utils.ps1"

function Assert-Equal([string] $Expected, [string] $Actual) {
    if ($Expected -cne $Actual) {
        throw "Expected $Expected, got $Actual"
    }
}

function Assert-TagVersions([string] $Version, [string[]] $Expected) {
    [string[]] $actual = @(Get-GroovyTagVersions $Version)
    Assert-Equal $Expected.Count $actual.Count
    for ($index = 0; $index -lt $Expected.Count; $index++) {
        Assert-Equal $Expected[$index] $actual[$index]
    }
}

Assert-Equal '4.0.0-alpha-1' (ConvertTo-GroovyVersion 'GROOVY_4_0_0_ALPHA_1')
Assert-Equal '4.0.0-beta-2' (ConvertTo-GroovyVersion 'GROOVY_4_0_0_BETA_2')
Assert-Equal '4.0.0-rc-3' (ConvertTo-GroovyVersion 'GROOVY_4_0_0_RC_3')
Assert-Equal '4.0.0' (ConvertTo-GroovyVersion 'GROOVY_4_0_0')
if (-not (Test-GroovyPrerelease '4.0.0-alpha-1')) { throw 'Expected alpha prerelease' }
if (-not (Test-GroovyPrerelease '4.0.0-beta-2')) { throw 'Expected beta prerelease' }
if (-not (Test-GroovyPrerelease '4.0.0-rc-3')) { throw 'Expected rc prerelease' }
if (Test-GroovyPrerelease '4.0.0') { throw 'Expected stable version to be rejected' }
if (Test-GroovyPrerelease 'x4.0.0-alpha-1') { throw 'Expected malformed version to be rejected' }
if (Test-GroovyPrerelease '4.0.0-ALPHA-1') { throw 'Expected uppercase prerelease label to be rejected' }
Assert-TagVersions '6.0.0-beta-2' @('6.0.0-beta-2', '6.0', '6')
Assert-TagVersions '5.1.0' @('5.1.0', '5.1', '5', '')

Write-Output 'version-utils.ps1 tests passed'
