param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$pynqCommit = "19ed17d4fd4ea71f95a97d30f8ccd0d62b8dbaaa"
$expectedSha256 = "AB0A99865CE597B68E72F4DB71B8D5D3D60929613183FAE27EF44DB6A985CFE3"
$sourceUrl = "https://raw.githubusercontent.com/Xilinx/PYNQ/$pynqCommit/boards/Pynq-Z2/base/base.tcl"
$generatedDir = Join-Path $PSScriptRoot "..\generated"
$outputPath = Join-Path $generatedDir "pynq_z2_ps7_config.tcl"

if ((Test-Path $outputPath) -and -not $Force) {
    Write-Host "C0_PS7_CONFIG=$outputPath"
    Write-Host "C0_PS7_CONFIG_STATUS=EXISTS"
    exit 0
}

$temporaryPath = Join-Path $env:TEMP "pynq_z2_base_v3.1.tcl"
Invoke-WebRequest -Uri $sourceUrl -OutFile $temporaryPath

$actualSha256 = (Get-FileHash -Algorithm SHA256 $temporaryPath).Hash
if ($actualSha256 -ne $expectedSha256) {
    throw "Official base.tcl SHA-256 mismatch: expected $expectedSha256, got $actualSha256"
}

$source = Get-Content -Raw $temporaryPath
$startMarker = "# Create instance: ps7_0, and set properties"
$endMarker = "# Create instance: ps7_0_axi_periph, and set properties"
$startIndex = $source.IndexOf($startMarker)
$endIndex = $source.IndexOf($endMarker, $startIndex)
if ($startIndex -lt 0 -or $endIndex -le $startIndex) {
    throw "Could not locate the PS7 configuration block in official base.tcl"
}

$header = @"
# Generated from Xilinx/PYNQ Pynq-Z2 base.tcl.
# PYNQ tag: v3.1
# Commit: $pynqCommit
# Source SHA-256: $expectedSha256
# Regenerate with board/pynq_z2/scripts/prepare_c0_ps7_config.ps1 -Force

"@
$ps7Block = $source.Substring($startIndex, $endIndex - $startIndex).TrimEnd() + "`r`n"

New-Item -ItemType Directory -Force $generatedDir | Out-Null
[System.IO.File]::WriteAllText($outputPath, $header + $ps7Block, [System.Text.Encoding]::ASCII)

Write-Host "C0_PS7_CONFIG=$outputPath"
Write-Host "C0_PS7_CONFIG_STATUS=GENERATED"
Write-Host "C0_PS7_SOURCE_SHA256=$actualSha256"