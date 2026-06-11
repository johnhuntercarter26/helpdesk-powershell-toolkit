# Get-ComputerHealth.ps1
# A simple health-check script that reports basic system vitals
# and saves the report to a text file.

# --- Gather the information ---
$computerName = $env:COMPUTERNAME
$currentUser  = $env:USERNAME

$os = Get-CimInstance -ClassName Win32_OperatingSystem
$totalRAM = [math]::Round($os.TotalVisibleMemorySize / 1MB, 2)
$freeRAM  = [math]::Round($os.FreePhysicalMemory / 1MB, 2)

$disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"
$totalDisk = [math]::Round($disk.Size / 1GB, 2)
$freeDisk  = [math]::Round($disk.FreeSpace / 1GB, 2)

# --- Build the report ---
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$report = @"
===== Computer Health Report =====
Generated: $timestamp

Computer Name:   $computerName
Logged-in User:  $currentUser

Total RAM (GB):  $totalRAM
Free RAM (GB):   $freeRAM

Total Disk (GB): $totalDisk
Free Disk (GB):  $freeDisk
==================================
"@

# --- Show it on screen ---
Write-Output $report

# --- Save it to a file ---
$fileName = "HealthReport_$computerName.txt"
$report | Out-File -FilePath $fileName

Write-Output "Report saved to: $fileName"