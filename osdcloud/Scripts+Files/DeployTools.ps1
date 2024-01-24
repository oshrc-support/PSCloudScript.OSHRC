# Define tools directory
$toolsDir = "C:\Tools"

# Function to download and install a tool
function New-DownloadInstall {
    param(
        [string]$Uri,
        [string]$OutFile,
        [string]$Arguments = ""
    )

    Invoke-WebRequest -Uri $Uri -OutFile $OutFile
    Start-Process -Wait -FilePath $OutFile -ArgumentList $Arguments
    Remove-Item -Path $OutFile -Force
}

# Function to extract a zip file
function New-extract {
    param(
        [string]$ZipPath,
        [string]$Destination
    )

    Expand-Archive -Path $ZipPath -DestinationPath $Destination -Force
    Remove-Item -Path $ZipPath -Force
}

# Create tools directory
New-Item -ItemType Directory -Path $toolsDir -Force
Set-Location -Path $toolsDir

# Download and install Win32OpenSSL
$opensslUri = "http://slproweb.com/download/Win32OpenSSL_Light-1_0_1h.exe"
New-DownloadInstall -Uri $opensslUri -OutFile "Win32OpenSSL_Light-1_0_1h.exe" -Arguments "/silent /verysilent /sp- /suppressmsgboxes"

# Download and install PSWindowsUpdate
$psWindowsUpdateUri = "http://gallery.technet.microsoft.com/scriptcenter/2d191bcd-3308-4edd-9de2-88dff796b0bc/file/41459/25/PSWindowsUpdate.zip"
New-DownloadInstall -Uri $psWindowsUpdateUri -OutFile "$toolsDir\PSWindowsUpdate.zip"
New-extract -ZipPath "$toolsDir\PSWindowsUpdate.zip" -Destination "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"

# Optional: Return to the original location
Set-Location -Path $PSScriptRoot
