# Generate 16x16 CJK glyphs for the LCD font table (SimHei, auto-centered).
# ASCII-only script: chars are built from Unicode code points.
# Emits a C table: { u32 cp; u8 g[32]; }  row-major, 2 bytes/row, MSB=leftmost.
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing

# U+808C U+7535 U+4EFF U+751F U+624B U+9759 U+6B62 U+5F20 U+5F00 U+63E1
# U+62F3 U+8155 U+5C48 U+4F38 U+6B63 U+5E38 U+8F7B U+5EA6 U+75B2 U+91CD
# U+95E8 U+63A7
# U+83DC U+5355 U+6A21 U+5F0F U+76D1 U+6D4B U+8BB0 U+5F55 U+6821 U+51C6
# U+9884 U+7559
$cps = @(0x808C,0x7535,0x4EFF,0x751F,0x624B,0x9759,0x6B62,0x5F20,0x5F00,
         0x63E1,0x62F3,0x8155,0x5C48,0x4F38,0x6B63,0x5E38,0x8F7B,0x5EA6,
         0x75B2,0x91CD,0x95E8,0x63A7,
         0x83DC,0x5355,0x6A21,0x5F0F,0x76D1,0x6D4B,0x8BB0,0x5F55,0x6821,
         0x51C6,0x9884,0x7559)

$fam = (New-Object System.Drawing.Text.InstalledFontCollection).Families |
       Where-Object { $_.Name -eq 'SimHei' } | Select-Object -First 1
if (-not $fam) {
    $fam = (New-Object System.Drawing.Text.InstalledFontCollection).Families |
           Where-Object { $_.Name -eq 'Microsoft YaHei' } | Select-Object -First 1
}
if (-not $fam) {
    $fam = (New-Object System.Drawing.Text.InstalledFontCollection).Families |
           Where-Object { $_.Name -eq 'SimSun' } | Select-Object -First 1
}
if (-not $fam) { throw 'no CJK font found' }
Write-Host "font: $($fam.Name)"
$font = New-Object System.Drawing.Font($fam.Name, 16,
        [System.Drawing.GraphicsUnit]::Pixel)

$bmp = New-Object System.Drawing.Bitmap(24, 24)
$gfx = [System.Drawing.Graphics]::FromImage($bmp)
$gfx.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::SingleBitPerPixelGridFit
$brush = [System.Drawing.Brushes]::White
$bg    = [System.Drawing.Color]::Black

$sb = New-Object System.Text.StringBuilder
foreach ($cp in $cps) {
    $ch = [char]$cp
    $gfx.Clear($bg)
    $gfx.DrawString([string]$ch, $font, $brush, 4, 4)

    $minR = 99; $maxR = -1; $minC = 99; $maxC = -1
    for ($r = 0; $r -lt 24; $r++) {
        for ($c = 0; $c -lt 24; $c++) {
            if ($bmp.GetPixel($c, $r).R -gt 127) {
                if ($r -lt $minR) { $minR = $r }
                if ($r -gt $maxR) { $maxR = $r }
                if ($c -lt $minC) { $minC = $c }
                if ($c -gt $maxC) { $maxC = $c }
            }
        }
    }
    if ($maxR -lt 0) { throw ('no ink for U+{0:X4}' -f $cp) }
    $h = $maxR - $minR + 1; $w = $maxC - $minC + 1
    if ($h -gt 16 -or $w -gt 16) { throw ('U+{0:X4} ink {1}x{2} exceeds 16x16' -f $cp,$w,$h) }
    $top  = [Math]::Min(8, [Math]::Max(0, [int](($minR + $maxR) / 2) - 8))
    $left = [Math]::Min(8, [Math]::Max(0, [int](($minC + $maxC) / 2) - 8))

    [void]$sb.Append(('    {{ 0x{0:X4}, {{' -f $cp))
    $vals = New-Object 'System.Collections.Generic.List[int]'
    for ($r = 0; $r -lt 16; $r++) {
        $hi = 0; $lo = 0
        for ($c = 0; $c -lt 8; $c++) {
            if ($bmp.GetPixel($left + $c, $top + $r).R -gt 127) { $hi = $hi -bor (0x80 -shr $c) }
            if ($bmp.GetPixel($left + 8 + $c, $top + $r).R -gt 127) { $lo = $lo -bor (0x80 -shr $c) }
        }
        $vals.Add($hi); $vals.Add($lo)
    }
    for ($i = 0; $i -lt 32; $i += 8) {
        [void]$sb.Append(('0x{0:X2},0x{1:X2},0x{2:X2},0x{3:X2},0x{4:X2},0x{5:X2},0x{6:X2},0x{7:X2},' -f `
            $vals[$i],$vals[$i+1],$vals[$i+2],$vals[$i+3],$vals[$i+4],$vals[$i+5],$vals[$i+6],$vals[$i+7]))
    }
    [void]$sb.AppendLine(('}},  /* U+{0:X4} ink {1}x{2} */' -f $cp,$w,$h))
}
Write-Output $sb.ToString()
$gfx.Dispose(); $bmp.Dispose(); $font.Dispose()
