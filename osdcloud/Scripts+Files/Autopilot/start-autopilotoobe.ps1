# start-autopilotoobe.ps1
$env:Path += ";C:\Program Files\WindowsPowerShell\Scripts"

function Write-textMenuList($menuItems,$menuQuestion,$defaultItem) {
    while ($menuReturn -lt 1) {
        $i = 0
        foreach ($menuItem in [array]$menuItems) {
            Write-Host ("  [{0}]`t" -F $i) -ForegroundColor Cyan -NoNewline
            Write-Host ("{0}" -F $menuitem) -ForegroundColor Gray
            $i++
        }
        $defaultSelect  = $menuItems[$defaultItem]
        $menuSelect     = $(Write-Host $menuQuestion -ForegroundColor Yellow -NoNewline) + $(Write-Host " [Default:"$defaultSelect" ] " -ForegroundColor White -NoNewline; Read-Host)
        $menuReturn     = $menuItems[$menuSelect]
        $menuReturn
    }
}

$list = "ATLO-HAzDJ", "Chair-HAzDJ", "COMM-HAzDJ", "DENO-HAzDJ", "eMini-HAzDJ", "Nuc-HAzDJ", "OALJ-HAzDJ", "OExD-HAzDJ", "OExDiT-HAzDJ", "OExS-HAzDJ", "OGeC-HAzDJ", "WashDC-AzDJ", "DENO-AzDJ", "ATLO-AzDJ", "OExDiT-AzDJ"
$selected = Write-textMenuList -menuItems $list -menuQuestion "Choose AutopilotEnroll GroupTag" -defaultItem 0

Write-Host "You selected: $selected" -ForegroundColor Green

#endregion MAIN SCRIPT
# Set execution policy
Set-ExecutionPolicy -Scope Process -ExecutionPolicy unrestricted -Force
Write-Host -ForegroundColor Cyan "(i) Installing required components`n"
# Install required modules
$ModulesToInstall = @(
    "Get-WindowsAutoPilotInfo",
    "WindowsAutopilotIntune",
    "Az",
    "Get-windowsautopilotinfocommunity",
    "Microsoft.Graph.Authentication",
    "WindowsAutopilotIntuneCommunity"
)

foreach ($module in $ModulesToInstall) {
    if (-not (Get-Module -Name $module -ListAvailable)) {
        Write-Host "Installing module: $module" -ForegroundColor Yellow
        Install-Script -Name $module -Repository PSGallery -Force 
        Install-Module -Name $module -Repository PSGallery -Force
    } else {
        Write-Host "Module already installed: $module" -ForegroundColor Green
    }
}
# Import AzSpConnect-MgGraph.ps1 script
$GistUrl = "https://gist.githubusercontent.com/oshrc-support/f6983e592204ec3511fbbedb3dbc5a73/raw/AzSpConnect-MgGraph.ps1"
$ScriptContent = Invoke-RestMethod -Uri $GistUrl
Invoke-Expression $ScriptContent

# Set variables for AppId, TenantId, and GroupTag
$AppId = "fa7b9855-a9de-4dcf-9be8-28603d3c266b"
$TenantId = "332f08e4-4a3b-4f06-a065-c4f6f8f8474d"
$GroupTag = $SelectedGroupTag

# Run Get-WindowsAutoPilotInfo cmdlet with appropriate parameters
try {
    Get-WindowsAutoPilotInfoCommunity -Online -AppId $AppId -TenantId $TenantId -GroupTag $GroupTag -ErrorAction Stop
} catch {
    Write-Host "Error encountered: $_" -ForegroundColor Red
    Get-WindowsAutoPilotInfo -Online -AppId $AppId -TenantId $TenantId -GroupTag $GroupTag -ErrorAction Stop}