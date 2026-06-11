# Clear-TempFiles.ps1
# Reports on temporary files in the user's TEMP folder.
# THIS VERSION ONLY LOOKS - it does not delete anything yet.

# --- Find the temp folder ---
$tempPath = $env:TEMP
Write-Output "Scanning temp folder: $tempPath"
Write-Output ""

# --- Gather the files ---
$tempFiles = Get-ChildItem -Path $tempPath -Recurse -File -ErrorAction SilentlyContinue

# --- Count them and add up their size ---
$fileCount = $tempFiles.Count
$totalBytes = ($tempFiles | Measure-Object -Property Length -Sum).Sum
$totalMB = [math]::Round($totalBytes / 1MB, 2)

# --- Report ---
Write-Output "Found $fileCount files."
Write-Output "Total space used: $totalMB MB"
# --- Delete the temp files ---
Write-Output ""
Write-Output "Deleting temp files..."
$tempFiles | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue

# --- Scan again to confirm ---
$remainingFiles = Get-ChildItem -Path $tempPath -Recurse -File -ErrorAction SilentlyContinue
$remainingCount = $remainingFiles.Count
$remainingBytes = ($remainingFiles | Measure-Object -Property Length -Sum).Sum
$remainingMB = [math]::Round($remainingBytes / 1MB, 2)

Write-Output ""
Write-Output "Done."
Write-Output "Files remaining: $remainingCount"
Write-Output "Space still used: $remainingMB MB"