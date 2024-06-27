(New-Object net.webclient).DownloadFile('https://raw.githubusercontent.com/mandiant/flare-vm/main/install.ps1',"C:\Users\analyst\Desktop\install.ps1")

Unblock-File "C:\Users\analyst\Desktop\install.ps1"

Set-ExecutionPolicy Unrestricted -Force

C:\Users\analyst\Desktop\install.ps1 -password infected -noWait -noGui -noChecks
