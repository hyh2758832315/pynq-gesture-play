param(
    [string]$HostName = "192.168.2.99",
    [string]$UserName = "xilinx",
    [string]$SshTarget = "pynq-z2",
    [string]$SourceAddress = "192.168.2.1",
    [string]$ExpectedMac = "",
    [string]$ExpectedRemoteHostName = "pynq",
    [string]$RemoteDirectory = "/home/xilinx/voice-view-game/camera-bringup",
    [ValidateSet("LoadOnly", "Xclk", "ChipId", "Dvp")]
    [string]$Phase = "LoadOnly",
    [ValidateRange(1, 100)]
    [int]$Reads = 1,
    [switch]$ConfirmWiring,
    [switch]$LocalOnly
)

$ErrorActionPreference = "Stop"

$boardRoot = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
$outputDirectory = Join-Path $boardRoot "output"
$files = [ordered]@{
    "camera_overlay.bit" = Join-Path $outputDirectory "camera_overlay.bit"
    "camera_overlay.hwh" = Join-Path $outputDirectory "camera_overlay.hwh"
    "verify_camera.py" = Join-Path $boardRoot "verify_camera.py"
    "camera_driver.py" = Join-Path $boardRoot "camera_driver.py"
}
$frozenHashes = @{
    "camera_overlay.bit" = "DE76E49E591AADEAF1D14E65C1D90F0A6A47FC5C15E2A14D2A232698B4DF2545"
    "camera_overlay.hwh" = "BD4065C1F461869F765AE8C16097410569CD1864CD17E783B25EAD1F907E726D"
}
$localHashes = @{}

foreach ($entry in $files.GetEnumerator()) {
    if (-not (Test-Path -LiteralPath $entry.Value -PathType Leaf)) {
        throw "Missing camera deployment file: $($entry.Value)"
    }
    $hash = (Get-FileHash -LiteralPath $entry.Value -Algorithm SHA256).Hash.ToUpperInvariant()
    $localHashes[$entry.Key] = $hash
    if ($frozenHashes.ContainsKey($entry.Key) -and $hash -ne $frozenHashes[$entry.Key]) {
        throw "Frozen artifact hash mismatch for $($entry.Key): $hash"
    }
    Write-Host "CAMERA_LOCAL_SHA256 $($entry.Key) $hash"
}

Write-Host "CAMERA_LOCAL_GATE=PASS"
if ($LocalOnly) {
    Write-Host "CAMERA_DEPLOY_STATUS=LOCAL_ONLY"
    exit 0
}
if (-not $ConfirmWiring) {
    throw "Real-board deployment requires -ConfirmWiring after checking power, heat, and jumper wiring"
}

$sourceIp = Get-NetIPAddress -AddressFamily IPv4 -IPAddress $SourceAddress -ErrorAction Stop |
    Select-Object -First 1
$pingOutput = & ping.exe -S $SourceAddress -n 1 -w 1000 $HostName | Out-String
if ($pingOutput -notmatch "TTL=") {
    throw "PYNQ did not answer source-bound ICMP from $SourceAddress"
}
$neighbor = Get-NetNeighbor -InterfaceIndex $sourceIp.InterfaceIndex -IPAddress $HostName -ErrorAction Stop
$actualMac = $neighbor.LinkLayerAddress.ToUpperInvariant()
if ($neighbor.State -in @("Incomplete", "Unreachable") -or $actualMac -eq "00-00-00-00-00-00") {
    throw "PYNQ ARP resolution failed: state=$($neighbor.State), MAC=$actualMac"
}
if ($ExpectedMac -and $actualMac -ne $ExpectedMac.ToUpperInvariant()) {
    throw "PYNQ ARP identity mismatch: expected=$ExpectedMac, actual=$actualMac"
}
Write-Host "CAMERA_ARP_GATE=PASS interface=$($sourceIp.InterfaceIndex) mac=$actualMac"

$target = $SshTarget
$sshArguments = @(
    "-b", $SourceAddress,
    "-o", "BatchMode=yes",
    "-o", "ConnectTimeout=5",
    "-o", "ServerAliveInterval=2",
    "-o", "ServerAliveCountMax=3"
)
$scpArguments = @(
    "-o", "BindAddress=$SourceAddress",
    "-o", "BatchMode=yes",
    "-o", "ConnectTimeout=5",
    "-o", "ServerAliveInterval=2",
    "-o", "ServerAliveCountMax=3"
)

$identityOutput = @(& ssh @sshArguments $target "hostname; id -un; uptime -p")
if ($LASTEXITCODE -ne 0) {
    throw "PYNQ SSH preflight failed with exit code $LASTEXITCODE"
}
if ($identityOutput.Count -lt 2 -or
    $identityOutput[0].Trim() -ne $ExpectedRemoteHostName -or
    $identityOutput[1].Trim() -ne $UserName) {
    throw "PYNQ SSH identity mismatch: $($identityOutput -join '; ')"
}
$identityOutput | ForEach-Object { Write-Host "CAMERA_REMOTE_IDENTITY $_" }
Write-Host "CAMERA_SSH_IDENTITY_GATE=PASS"
& ssh @sshArguments $target "mkdir -p '$RemoteDirectory' && chmod 0755 '$RemoteDirectory'"
if ($LASTEXITCODE -ne 0) {
    throw "Unable to create remote camera directory"
}

& scp @scpArguments `
    $files["camera_overlay.bit"] `
    $files["camera_overlay.hwh"] `
    $files["verify_camera.py"] `
    $files["camera_driver.py"] `
    "${target}:$RemoteDirectory/"
if ($LASTEXITCODE -ne 0) {
    throw "Camera deployment upload failed with exit code $LASTEXITCODE"
}

$remoteHashOutput = & ssh @sshArguments $target (
    "cd '$RemoteDirectory' && sha256sum camera_overlay.bit camera_overlay.hwh verify_camera.py camera_driver.py"
)
if ($LASTEXITCODE -ne 0) {
    throw "Remote SHA-256 command failed with exit code $LASTEXITCODE"
}
$remoteHashes = @{}
foreach ($line in $remoteHashOutput) {
    if ($line -match "^([0-9a-fA-F]{64})\s+(.+)$") {
        $remoteHashes[$Matches[2].Trim()] = $Matches[1].ToUpperInvariant()
    }
}
foreach ($fileName in $files.Keys) {
    if (-not $remoteHashes.ContainsKey($fileName)) {
        throw "Remote SHA-256 output is missing $fileName"
    }
    if ($remoteHashes[$fileName] -ne $localHashes[$fileName]) {
        throw "Remote SHA-256 mismatch for $fileName"
    }
}
Write-Host "CAMERA_REMOTE_HASH_GATE=PASS"

$plOwnerService = "voice-view-shell.service"
& ssh @sshArguments $target (
    "sudo -n systemctl disable --now '$plOwnerService' >/dev/null && " +
    "sudo -n systemctl mask --runtime '$plOwnerService' >/dev/null && " +
    "! systemctl is-active --quiet '$plOwnerService'"
)
if ($LASTEXITCODE -ne 0) {
    throw "Unable to acquire exclusive PL ownership from $plOwnerService"
}
Write-Host "CAMERA_PL_OWNER_GATE=PASS service=$plOwnerService state=inactive boot_disabled=true runtime_masked=true"

$systemState = (& ssh @sshArguments $target "systemctl is-system-running --wait" | Out-String).Trim()
if ($systemState -notin @("running", "degraded")) {
    throw "PYNQ system startup did not settle: $systemState"
}
foreach ($bootService in @("bootpy.service", "clear_pl_statefile.service")) {
    $serviceState = @(& ssh @sshArguments $target "systemctl show '$bootService' -p ActiveState -p Result")
    if ($LASTEXITCODE -ne 0 -or
        $serviceState -notcontains "ActiveState=inactive" -or
        $serviceState -notcontains "Result=success") {
        throw "PYNQ boot service gate failed for $bootService`: $($serviceState -join ', ')"
    }
}
Write-Host "CAMERA_BOOT_SERVICES_GATE=PASS system=$systemState bootpy=success clear_pl_statefile=success"

if ($Phase -eq "LoadOnly") {
    $evidenceName = "camera_load_evidence.json"
    $verifyArguments = "--load-only"
    $timeoutSeconds = 30
} elseif ($Phase -eq "Xclk") {
    $evidenceName = "camera_xclk_evidence.json"
    $verifyArguments = "--no-download --xclk-only"
    $timeoutSeconds = 15
} elseif ($Phase -eq "Dvp") {
    $evidenceName = "camera_dvp_evidence.json"
    $verifyArguments = "--dvp-only"
    $timeoutSeconds = 15
} else {
    $evidenceName = "camera_id_$($Reads)_evidence.json"
    $verifyArguments = "--no-download --reads $Reads"
    $timeoutSeconds = 20
}
$remoteCommand = "cd '$RemoteDirectory' && sudo -n timeout --signal=TERM ${timeoutSeconds}s env XILINX_XRT=/usr /usr/local/share/pynq-venv/bin/python -u verify_camera.py camera_overlay.bit $verifyArguments --evidence '$evidenceName'"
& ssh @sshArguments $target $remoteCommand
$verifyExitCode = $LASTEXITCODE

$ownerState = (& ssh @sshArguments $target "systemctl is-active '$plOwnerService' || true" | Out-String).Trim()
if ($ownerState -ne "inactive") {
    throw "PL owner service changed state during Camera verification: $ownerState"
}
Write-Host "CAMERA_PL_OWNER_POST_GATE=PASS service=$plOwnerService state=$ownerState"

$evidenceDirectory = Join-Path $boardRoot "evidence"
New-Item -ItemType Directory -Force -Path $evidenceDirectory | Out-Null
& scp @scpArguments "${target}:$RemoteDirectory/$evidenceName" $evidenceDirectory
if ($LASTEXITCODE -ne 0) {
    Write-Warning "Camera evidence file was not downloaded"
}
if ($verifyExitCode -ne 0) {
    throw "Camera $Phase verification failed with exit code $verifyExitCode"
}

Write-Host "CAMERA_DEPLOY_STATUS=PASS phase=$Phase reads=$Reads"
