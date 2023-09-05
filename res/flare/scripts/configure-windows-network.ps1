param ([String] $adapterName, [String] $ip, [String] $gateway, [String] $dns)

# # Define the network adapter name
# $adapterName = "Ethernet 2"

# # Define the desired IP configuration
# $ip = "10.100.0.104"
# $gateway = "10.100.0.1"
# $dns = "10.100.0.102"

Write-Host "Configuring IP address for $adapterName..."
Write-Host "IP: $ip"
Write-Host "Gateway: $gateway"
Write-Host "DNS: $dns"

# Get the network adapter object
$adapter = Get-NetAdapter | Where-Object { $_.Name -eq $adapterName }

if ($adapter) {
    # Set the IP address, subnet mask, and gateway
    $adapter | Set-NetIPInterface -Dhcp Disabled
    $adapter | New-NetIPAddress -IPAddress $ip -PrefixLength 24 -DefaultGateway $gateway

    # Set the DNS servers
    $adapter | Set-DnsClientServerAddress -ServerAddresses $dns

    Write-Host "IP configuration for $adapterName has been set."
} else {
    Write-Host "Network adapter $adapterName not found."
}