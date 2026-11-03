$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..\..')).Path
& python (Join-Path $root 'sim\test_decode_sd_record.py')
if ($LASTEXITCODE -ne 0) { throw 'SD decode test failed' }

