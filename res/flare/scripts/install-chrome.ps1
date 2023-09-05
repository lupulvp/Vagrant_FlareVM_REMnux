# Define the URL for the Chrome installer
$chromeInstallerUrl = "https://dl.google.com/chrome/install/latest/chrome_installer.exe"

# Define the path where the installer will be downloaded
$installerPath = "$env:USERPROFILE\Downloads\chrome_installer.exe"

# Download the Chrome installer
Invoke-WebRequest -Uri $chromeInstallerUrl -OutFile $installerPath

# Install Chrome silently
Start-Process -FilePath $installerPath -ArgumentList "/silent /install" -Wait

# Clean up the installer file
Remove-Item -Path $installerPath