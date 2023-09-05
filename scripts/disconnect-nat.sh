#!/bin/bash

# Path to the VBoxManage.exe executable (adjust as needed)
VBOXMANAGE_EXE="/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"

# Check if VBoxManage.exe exists
if [ ! -f "$VBOXMANAGE_EXE" ]; then
  echo "Error: VBoxManage.exe not found at '$VBOXMANAGE_EXE'"
  exit 1
fi

#!/bin/bash

directory=".vagrant/machines"

# List all directories (folders) in the specified directory
vms=$(ls -d ${directory}/* | awk -F/ '{print $(NF)}')
echo $vms

# Loop through and print each VM(folder) name 
for vm in $vms; do
    # Disconnect cable on NIC1
    "$VBOXMANAGE_EXE" controlvm "$vm" setlinkstate1 off
    echo "Disconnected cable on NIC1 for $vm"
done