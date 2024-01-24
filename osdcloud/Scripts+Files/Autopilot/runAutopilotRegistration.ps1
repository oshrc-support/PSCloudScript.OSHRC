# PowerShell Script: RunAutopilotRegistration.ps1

$gistUrl = "https://gist.githubusercontent.com/oshrc-support/0e362743673606600ec4a9af5b1eec20/raw/AzSpConnect-AzAccount.ps1"

# Option 1
Invoke-RestMethod -Uri $gistUrl | Invoke-Expression

# Assuming this is the correct way to get the secret and run it as a command.
$autopilotRegistrationCommand = (Get-AzKeyVaultSecret -VaultName oshrcap -Name start-autopilotregistration -AsPlainText)
Invoke-Expression $autopilotRegistrationCommand

# Pause at the end if running interactively
if ($Host.Name -eq "ConsoleHost") {
    Write-Host "Press any key to continue ..."
    $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
}
