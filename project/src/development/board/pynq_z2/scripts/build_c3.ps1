param(
    [string]$Vivado = "D:\Xilinx\Vivado\2026.1\Vivado\bin\vivado.bat",
    [switch]$RefreshDependencies
)

$ErrorActionPreference = "Stop"
if (-not (Test-Path $Vivado)) {
    throw "Vivado executable not found: $Vivado"
}

$preparePs7 = Join-Path $PSScriptRoot "prepare_c0_ps7_config.ps1"
$prepareRgb2Dvi = Join-Path $PSScriptRoot "prepare_c3_rgb2dvi.ps1"
$buildScript = Join-Path $PSScriptRoot "build_c3.tcl"

if ($RefreshDependencies) {
    & $preparePs7 -Force
    & $prepareRgb2Dvi -Force
} else {
    & $preparePs7
    & $prepareRgb2Dvi
}

& $Vivado -mode batch -source $buildScript -notrace
exit $LASTEXITCODE