[CmdletBinding()]
param(
    [string]$CandidateRoot = 'E:\vvgvoice\p1_native26',
    [string]$OutputDirectory = ''
)
$ErrorActionPreference = 'Stop'
$repoRoot = [IO.Path]::GetFullPath((Join-Path $PSScriptRoot '..\..\..'))
if (-not $OutputDirectory) { $OutputDirectory = Join-Path $repoRoot 'deliveries' }
$OutputDirectory = [IO.Path]::GetFullPath($OutputDirectory)
$packageName = 'voice_native2026_20261005'
$packageRoot = Join-Path $OutputDirectory $packageName
$archive = Join-Path $OutputDirectory ($packageName + '.zip')
if ((Test-Path -LiteralPath $packageRoot) -or (Test-Path -LiteralPath $archive)) {
    throw 'Package destination already exists; choose a new OutputDirectory'
}
$auditPath = Join-Path $repoRoot 'results\voice-p1-20261005\native2026_source_audit.json'
$audit = Get-Content -LiteralPath $auditPath -Encoding UTF8 -Raw | ConvertFrom-Json
foreach ($row in $audit) {
    $source = Join-Path $CandidateRoot $row.path
    if ((Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash -ne $row.native2026) {
        throw ('Candidate identity differs from native2026 audit: ' + $row.path)
    }
}
New-Item -ItemType Directory -Path $packageRoot -Force | Out-Null
function Copy-PackageFile([string]$Source, [string]$RelativePath) {
    $destination = Join-Path $packageRoot $RelativePath
    New-Item -ItemType Directory -Path (Split-Path -Parent $destination) -Force | Out-Null
    Copy-Item -LiteralPath $Source -Destination $destination
}
foreach ($row in $audit) {
    $relative = $row.path
    if ($relative -eq 'README.md') { $relative = 'metadata/original_2024_handoff_README.md' }
    if ($relative -eq 'HANDOFF_SHA256SUMS.json') { $relative = 'metadata/original_HANDOFF_SHA256SUMS.json' }
    Copy-PackageFile (Join-Path $CandidateRoot $row.path) $relative
}
Copy-PackageFile (Join-Path $repoRoot 'docs\voice_2026_handoff.md') 'README.md'
Copy-PackageFile (Join-Path $repoRoot 'docs\voice_native2026_improvement_plan.md') 'docs/IMPROVEMENT_PLAN.md'
Copy-PackageFile (Join-Path $repoRoot 'docs\voice_first_integration_plan.md') 'metadata/voice_first_integration_plan_source.md'
foreach ($name in 'voice_p1_prepare.tcl','voice_p1_simulate.tcl','voice_p1_build.tcl','voice_p1_handoff.tcl') {
    Copy-PackageFile (Join-Path $PSScriptRoot $name) ('board/pynq_z2/scripts/' + $name)
}
Copy-PackageFile (Join-Path $repoRoot 'sim\voice\tb_voice_hybrid_pcm_p1.sv') 'sim/voice/tb_voice_hybrid_pcm_p1.sv'
Copy-PackageFile (Join-Path $repoRoot 'docs\bringup\2026-10-05_pynq-z2_voice_p1.md') 'evidence/2026-10-05_pynq-z2_voice_p1.md'
$evidenceRoot = Join-Path $repoRoot 'results\voice-p1-20261005'
$evidenceNames = @('native2026_source_audit.json','native26_artifacts.json',
    'native26_capture_features.bin','native26_capture_simulate.log',
    'profile_round4_vivado_raw.log','contract_tests.log','handoff_check.log',
    'handoff26_prepare_mcp.json','handoff26_capture_mcp.json',
    'handoff26_capture_simulate.log','handoff26_capture_features.bin')
$evidenceFiles = Get-ChildItem -LiteralPath $evidenceRoot -File | Where-Object {
    $_.Name -in $evidenceNames -or $_.Name -like 'native26_*.rpt' -or
    ($_.Name -like 'profile_*' -and $_.Extension -in '.log','.json','.bin')
}
foreach ($file in $evidenceFiles) { Copy-PackageFile $file.FullName ('evidence/' + $file.Name) }
$artifactRows = Get-Content -LiteralPath (Join-Path $evidenceRoot 'native26_artifacts.json') -Encoding UTF8 -Raw | ConvertFrom-Json
foreach ($name in 'post_synth.dcp','post_route.dcp') {
    $source = Join-Path $CandidateRoot ('hardware\build\voice_hybrid_2s\' + $name)
    $expected = @($artifactRows | Where-Object { $_.path.Replace('\','/') -like ('*/' + $name) })
    if ($expected.Count -ne 1 -or (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash -ne $expected[0].sha256) {
        throw ('Checkpoint identity mismatch: ' + $name)
    }
    Copy-PackageFile $source ('evidence/checkpoints/' + $name)
}
$manifest = @(Get-ChildItem -LiteralPath $packageRoot -Recurse -Force -File | Sort-Object FullName | ForEach-Object {
    [pscustomobject]@{
        file = $_.FullName.Substring($packageRoot.Length + 1).Replace('\','/')
        bytes = $_.Length
        sha256 = (Get-FileHash -LiteralPath $_.FullName -Algorithm SHA256).Hash.ToLowerInvariant()
    }
})
$jsonEncoding = New-Object System.Text.UTF8Encoding($false)
[IO.File]::WriteAllText((Join-Path $packageRoot 'HANDOFF_SHA256SUMS.json'), ($manifest | ConvertTo-Json -Depth 5), $jsonEncoding)
Add-Type -AssemblyName System.IO.Compression.FileSystem
[IO.Compression.ZipFile]::CreateFromDirectory($packageRoot, $archive, [IO.Compression.CompressionLevel]::Optimal, $true)
$archiveInfo = Get-Item -LiteralPath $archive
$archiveIdentity = [pscustomobject]@{
    archive = $archiveInfo.Name
    bytes = $archiveInfo.Length
    sha256 = (Get-FileHash -LiteralPath $archive -Algorithm SHA256).Hash.ToLowerInvariant()
    files = $manifest.Count + 1
    tool = 'Vivado 2026.1'
    status = 'SOURCE_HANDOFF_P1_PENDING_NOT_A_BOARD_RELEASE'
}
[IO.File]::WriteAllText(($archive + '.sha256.json'), ($archiveIdentity | ConvertTo-Json), $jsonEncoding)
Write-Output ($archiveIdentity | ConvertTo-Json)