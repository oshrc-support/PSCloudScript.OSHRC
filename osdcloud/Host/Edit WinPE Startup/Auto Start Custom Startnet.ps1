#Requires -RunAsAdministrator

$Startnet = @'
start PowerShell -NoL -C Start-OSDCloudGUI -OSBuild 23H2 -OSEdition Pro -OSLanguage en-Us -OSLicense Retail
'@

Edit-OSDCloudWinPE -Startnet $Startnet