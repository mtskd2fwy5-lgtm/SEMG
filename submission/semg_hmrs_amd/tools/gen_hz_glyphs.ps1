# Compatibility entry point; no fallback to proprietary system fonts.
param([switch]$UpdateMain)
$ErrorActionPreference = 'Stop'
& python (Join-Path $PSScriptRoot 'gen_hz_glyphs.py')
if ($LASTEXITCODE -ne 0) { throw 'Source Han Sans glyph generation failed' }

