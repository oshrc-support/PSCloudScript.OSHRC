# Script to write OSD Complete and register the Schedule Task that will monitor HYbrid Join, MDM enrollment, Defender for endpoint omboarding.

# Define log file path
$logFilePath = "$env:ProgramData\Microsoft\IntuneManagementExtension\Logs\DefenderOnboarding.log"

function WriteToLogFile {
    param([string]$message)
    "$message - $(Get-Date)" | Out-File -Append -FilePath $logFilePath
}

# Write OSD completion to log file
WriteToLogFile "OSD Complete"

# Define URL and task name for the scheduled task
$XmlFileUrl = 'https://raw.githubusercontent.com/oshrc-support/osdcloud/main/Scripts/WaitForOnboarding/WaitforOnboarding.xml'
$TaskName = 'WaitforOnboarding'

# Initialize download success flag and XML content variable
$downloadSuccess = $false
$xmlContent = $null

# Loop until the XML file is successfully downloaded
while (-not $downloadSuccess) {
    try {
        # Attempt to download the XML file
        $xmlContent = Invoke-WebRequest -Uri $XmlFileUrl -ErrorAction Stop
        $downloadSuccess = $true
        Write-Host "XML file downloaded successfully."
    } catch {
        Write-Host "An error occurred while downloading. Retrying..."
        Start-Sleep -Seconds 5
    }
}

# Check if the XML content was successfully retrieved
if ($xmlContent) {
    try {
        # Register the scheduled task using the downloaded XML
        Register-ScheduledTask -Xml $xmlContent.Content -TaskName $TaskName
        Write-Host "Scheduled task '$TaskName' registered successfully."
    } catch {
        Write-Host "An error occurred while registering the scheduled task: $_"
    }
} else {
    Write-Host "Failed to download the XML file."
}
