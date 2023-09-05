param ([String] $file_url, [String] $file_path)

Write-Host "Downloading $file_url to $file_path"
Invoke-WebRequest -Uri $file_url -OutFile $file_path