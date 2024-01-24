# Set global transcript file name and start transcript logging
$Global:Transcript = "$(Get-Date -Format 'yyyy-MM-dd-HHmmss')-OOBEScripts.log"
$TranscriptPath = Join-Path -Path "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\OSD" -ChildPath $Global:Transcript
Start-Transcript -Path $TranscriptPath -ErrorAction Stop

# Terminate any running sysprep processes
Get-Process sysprep -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Cleanup actions
Remove-Item -Path "C:\Windows\Panther\unattend.xml" -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Windows\Setup\Scripts\init.ps1" -Recurse -Force -ErrorAction SilentlyContinue # Prevent loop after OOBE

# Download init2.ps1 from GitHub and rename to init.ps1
$GitHubFileUrl = 'https://raw.githubusercontent.com/oshrc-support/osdcloud/main/Scripts/init2.ps1'
$DestinationFolder = 'C:\Windows\Setup\Scripts'
$NewFileName = 'init.ps1'
$DestinationPath = Join-Path -Path $DestinationFolder -ChildPath $NewFileName

# Download file with retry mechanism and error handling
$downloadSuccess = $false
do {
    try {
        Invoke-WebRequest -Uri $GitHubFileUrl -OutFile $DestinationPath -ErrorAction Stop
        Write-Host "File downloaded successfully."
        $downloadSuccess = $true
    } catch {
        Write-Host "An error occurred while downloading. Retrying..."
        Start-Sleep -Seconds 5
    }
} while (-not $downloadSuccess)

# Generate SetupComplete.cmd file
$SetupCompleteCMDContent = @"
powershell.exe -command set-executionpolicy bypass -force
powershell.exe -file "%~dp0init.ps1"
"@
$SetupCompleteCMDPath = 'C:\Windows\Setup\Scripts\SetupComplete.cmd'
$SetupCompleteCMDContent | Out-File -FilePath $SetupCompleteCMDPath -Encoding ascii -Force

# Terminate any running sysprep processes again
Get-Process sysprep -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Execute OSD Cleanup Script
Write-Host -ForegroundColor DarkGray "Executing OSD Cleanup Script"
Start-Process -FilePath "PowerShell" -ArgumentList "iex (irm https://raw.githubusercontent.com/oshrc-support/osdcloud/main/Scripts/cleanup-osdcloud.ps1)" -Wait

# Download unattend.xml from GitHub and place it in the sysprep folder
$FileUrl = 'https://raw.githubusercontent.com/oshrc-support/osdcloud/main/sysprep/unattend.xml'
$DestinationPath = 'C:\Windows\system32\sysprep\unattend.xml'

$unattendDownloaded = $false
do {
    try {
        Invoke-WebRequest -Uri $FileUrl -OutFile $DestinationPath -ErrorAction Stop
        Write-Host "Download successful. File saved at: $DestinationPath"
        $unattendDownloaded = $true
    } catch {
        Write-Host "Download failed. Retrying..."
        Start-Sleep -Seconds 5
    }
} while (-not $unattendDownloaded)

# Execute sysprep
Start-Process -FilePath "C:\Windows\System32\Sysprep\sysprep.exe" -ArgumentList "/oobe /quiet /reboot /unattend:$DestinationPath" -Wait 
exit(0)