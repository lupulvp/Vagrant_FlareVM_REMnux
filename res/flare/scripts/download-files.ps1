param ([String] $file_url, [String] $file_path)

Write-Host "Downloading $file_url to $file_path"

# # this method is very slow
# Invoke-WebRequest -Uri $file_url -OutFile $file_path

# # this method is faster
(New-Object System.Net.WebClient).DownloadFile($file_url, $file_path)

Write-Host "Downloaded $file_url to $file_path"