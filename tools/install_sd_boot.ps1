param(
    [Parameter(Mandatory = $false)]
    [ValidatePattern('^[A-Za-z]$')]
    [string]$DriveLetter
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path (Join-Path $PSScriptRoot "..\")).Path
$source = Join-Path $root "build\boot\BOOT.BIN"

if (-not (Test-Path -LiteralPath $source)) {
    throw "BOOT.BIN not found: $source"
}

if ([string]::IsNullOrWhiteSpace($DriveLetter)) {
    $removable = @(Get-Volume | Where-Object {
        $_.DriveType -eq "Removable" -and $_.DriveLetter
    })
    if ($removable.Count -ne 1) {
        throw "Specify the SD card drive explicitly, for example: -DriveLetter F"
    }
    $DriveLetter = [string]$removable[0].DriveLetter
}

$drive = $DriveLetter.ToUpperInvariant() + ":\"
if (-not (Test-Path -LiteralPath $drive)) {
    throw "Drive not found: $drive"
}

$volume = Get-Volume -DriveLetter $DriveLetter -ErrorAction Stop
if ($volume.FileSystem -and $volume.FileSystem -ne "FAT32") {
    Write-Warning ("{0} is {1}; the board normally expects a FAT32 SD volume." -f $drive, $volume.FileSystem)
}

$target = Join-Path $drive "BOOT.BIN"
$sourceHash = (Get-FileHash -LiteralPath $source -Algorithm SHA256).Hash
Copy-Item -LiteralPath $source -Destination $target -Force
$targetHash = (Get-FileHash -LiteralPath $target -Algorithm SHA256).Hash

if ($sourceHash -ne $targetHash) {
    throw "SD copy verification failed: source and target SHA256 differ"
}

Write-Host "BOOT.BIN installed: $target"
Write-Host "SHA256: $targetHash"
Write-Host "Power off the board, select SD boot mode, insert the card, then power on."
