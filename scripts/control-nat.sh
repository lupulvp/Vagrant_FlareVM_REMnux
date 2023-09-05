#!/bin/bash

# Check if two parameters were provided
if [ $# -ne 2 ]; then
  echo "Usage: $0 <vm> <on/off>"
  exit 1
fi

# Path to the VBoxManage.exe executable (adjust as needed)
VBOXMANAGE_EXE="/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"

# Check if VBoxManage.exe exists
if [ ! -f "$VBOXMANAGE_EXE" ]; then
    echo "Error: VBoxManage.exe not found at '$VBOXMANAGE_EXE'"
    exit 1
fi

# Assign the parameters to variables
vm="$1"
status="$2"

# Check if the VM exists
if "$VBOXMANAGE_EXE" showvminfo "$vm" &>/dev/null; then
    "$VBOXMANAGE_EXE" controlvm "$vm" setlinkstate1 "$status" &
    echo "Disconnected cable on NIC1 for $vm"
else
    echo "The VM $vm does not exist."
fi

exit 0

