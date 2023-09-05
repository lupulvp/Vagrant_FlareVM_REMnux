#!/bin/bash

# run VBoxManage.exe with all script arguments

# Path to the VBoxManage.exe executable (adjust as needed)
VBOXMANAGE_EXE="/c/Program Files/Oracle/VirtualBox/VBoxManage.exe"

# Check if VBoxManage.exe exists
if [ ! -f "$VBOXMANAGE_EXE" ]; then
  echo "Error: VBoxManage.exe not found at '$VBOXMANAGE_EXE'"
  exit 1
fi

# Pass all script arguments to VBoxManage.exe
"$VBOXMANAGE_EXE" "$@"
