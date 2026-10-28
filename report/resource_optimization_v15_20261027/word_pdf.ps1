param([string]$Source,[string]$Destination)
$ErrorActionPreference='Stop'
$word=$null;$doc=$null
try {
 $word=New-Object -ComObject Word.Application
 $word.Visible=$false;$word.DisplayAlerts=0
 $word.AutomationSecurity=3
 $doc=$word.Documents.Open($Source,$false,$true)
 $doc.ExportAsFixedFormat($Destination,17)
 Write-Output 'WORD_PDF_EXPORT_PASS'
} finally {
 if($doc){$doc.Close(0);[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($doc)}
 if($word){$word.Quit();[void][Runtime.InteropServices.Marshal]::FinalReleaseComObject($word)}
}
