param(
    [string]$Vivado = "D:\Xilinx\Vivado\2026.1\Vivado\bin\vivado.bat",
    [switch]$RefreshPs7Config
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path $Vivado)) {
    throw "Vivado executable not found: $Vivado"
}

$prepareScript = Join-Path $PSScriptRoot "prepare_c0_ps7_config.ps1"
$buildScript = Join-Path $PSScriptRoot "build_c0.tcl"

if ($RefreshPs7Config) {
    & $prepareScript -Force
} else {
    & $prepareScript
}
if ($LASTEXITCODE -ne 0) {
    exit $LASTEXITCODE
}

& $Vivado -mode batch -source $buildScript -notrace
exit $LASTEXITCODE