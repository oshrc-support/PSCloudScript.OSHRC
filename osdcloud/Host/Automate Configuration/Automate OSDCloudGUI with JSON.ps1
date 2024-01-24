#Requires -RunAsAdministrator

$Automate = @'
{
    "BrandName":  "OSHRC Workplace 2024",
    "BrandColor":  "RED",
    "OSActivation":  "Retail",
    "OSEdition":  "Pro",
    "OSLanguage":  "en-US",
    "OSImageIndex":  5,
    "OSName":  "Windows 11 23H2 x64",
    "OSReleaseID":  "23H2",
    "OSVersion":  "Windows 11",
    "OSActivationValues":  [
                                "Retail",
                                "Volume"
                            ],
    "OSEditionValues":  [
                            "Enterprise",
                            "Pro",
                            "Pro for Workstation"
                        ],
    "OSLanguageValues":  [
                                "en-us"
                            ],
    "OSNameValues":  [
                            "Windows 11 23H2 x64"
                        ],
    "OSReleaseIDValues":  [
                                "23H2"
                            ],
    "OSVersionValues":  [
                            "Windows 11"
                        ],
    "ClearDiskConfirm":  false,
    "restartComputer":  false,
    "updateDiskDrivers":  true,
    "updateFirmware":  true,
    "updateNetworkDrivers":  true,
    "updateSCSIDrivers":  true
}
'@

$AutomateISO = "$(Get-OSDCloudWorkspace)\Media\OSDCloud\Automate"
if (!(Test-Path $AutomateISO)) {
    New-Item -Path $AutomateISO -ItemType Directory -Force
}
$Automate | Out-File -FilePath "$AutomateISO\Start-OSDCloudGUI.json" -Force


$AutomateUSB = "$(Get-OSDCloudWorkspace)\Media\Automate"
if (!(Test-Path $AutomateUSB)) {
    New-Item -Path $AutomateUSB -ItemType Directory -Force
}
$Automate | Out-File -FilePath "$AutomateUSB\Start-OSDCloudGUI.json" -Force

# Run Edit-OSDCloudWinPE to rebuild
Edit-OSDCloudWinPE -StartOSDCloudGUI -Brand 'OSHRC Workplace 2024'

# Test in a Virtual Machine
New-OSDCloudVM