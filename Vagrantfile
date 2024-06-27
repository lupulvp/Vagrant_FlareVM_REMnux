require 'yaml'

config_file = YAML.load(File.read('config.yaml'))

STACK_NAME = config_file["stack_name"]

SAMPLE_SRC_PATH = config_file["sample_src_path"]
SAMPLE_DEST_PATH = config_file["sample_dest_path"]

SYSINTERNALS_SRC_PATH = "https://download.sysinternals.com/files/SysinternalsSuite.zip"
SYSINTERNALS_DEST_PATH = "C:\\Users\\analyst\\Desktop\\SysinternalsSuite.zip"

FLARE_VM = {
  "name" => "#{STACK_NAME}-FlareVM",
  "box" => File.exist?("./Boxes/FlareVM-Win10Enterprise22H2_virtualbox.box") ? "./Boxes/FlareVM-Win10Enterprise22H2_virtualbox.box" : config_file["flare_vm_box"],
  "version" => File.exist?("./Boxes/FlareVM-Win10Enterprise22H2_virtualbox.box") ? nil : config_file["flare_vm_box_version"],
  "username" => "analyst",
  "password" => "infected",
  "memory" => config_file["flare_vm_memory"],
  "cpus" => config_file["flare_vm_cpus"],
  "vram" => 128
}

REMNUX_VM = {
  "name" => "#{STACK_NAME}-REMnux",
  "box" => File.exist?("./Boxes/REMnux-v7-focal_virtualbox.box") ? "./Boxes/REMnux-v7-focal_virtualbox.box" : config_file["remnux_vm_box"],
  "version" => File.exist?("./Boxes/REMnux-v7-focal_virtualbox.box") ? nil : config_file["remnux_vm_box_version"],
  "username" => "remnux",
  "password" => "malware",
  "memory" => config_file["remnux_vm_memory"],
  "cpus" => config_file["remnux_vm_cpus"],
  "vram" => 128
}


Vagrant.configure("2") do |config|
  # Flare VM
  config.vm.define FLARE_VM["name"] do |flare|
    flare.vm.box = FLARE_VM["box"]
    if FLARE_VM["version"] != nil
      flare.vm.box_version = FLARE_VM["version"]
    end

    flare.trigger.after [:up] do |trigger|
      trigger.info = "Disconnecting NAT network cable to #{FLARE_VM["name"]}..."
      trigger.run = {inline: "bash ./scripts/control-nat.sh \"#{FLARE_VM["name"]}\" \"off\""}
    end

    flare.vm.hostname = FLARE_VM["name"]
    flare.vm.guest = :windows
    flare.vm.synced_folder ".", "/vagrant", disabled: true  # disable synced folder
    flare.vm.network :private_network, virtualbox__intnet: "flarenet", auto_config: false

    flare.vm.communicator = "winrm"
    flare.winrm.basic_auth_only = true
    flare.winrm.transport = :plaintext
    flare.winrm.username = FLARE_VM["username"]
    flare.winrm.password = FLARE_VM["password"]
    flare.vm.boot_timeout = 1200
    flare.winrm.timeout = 1200
    flare.winrm.retry_limit = 20

    # Provisioning
    flare.vm.provision "shell", inline: "echo 'Provisioning Flare VM...'"

    # Download malware samples
    flare.vm.provision "shell", path: "./res/flare/scripts/download-files.ps1", privileged: true, args: "-file_url #{SAMPLE_SRC_PATH} -file_path #{SAMPLE_DEST_PATH}"

    # Download sysinternals - as a backup for the Flare packages
    flare.vm.provision "shell", path: "./res/flare/scripts/download-files.ps1", privileged: true, args: "-file_url #{SYSINTERNALS_SRC_PATH} -file_path #{SYSINTERNALS_DEST_PATH}"

    # # Install Google Chrome - now included in the Flare packages
    # flare.vm.provision "shell", path: "./res/flare/scripts/install-chrome.ps1", privileged: false

    # Configure Windows network
    flare.vm.provision "shell", path: "./res/flare/scripts/configure-windows-network.ps1", privileged: true, args: "-adapterName 'Ethernet 2' -ip '10.100.0.105' -gateway '10.100.0.1' -dns '10.100.0.1'"

    # Configure Windows settings
    # flare.vm.provision "file", source: "./res/flare/config/shutup10.cfg", destination: "C:\\Users\\analyst\\AppData\\Local\\Temp\\"
    # flare.vm.provision "file", source: "./res/flare/config/MakeWindows10GreatAgain.reg", destination: "C:\\Users\\analyst\\AppData\\Local\\Temp\\"
    # flare.vm.provision "shell", path: "./res/flare/scripts/MakeWindows10GreatAgain.ps1", privileged: false

    # # Install Sysinternals - now included in the Flare packages
    # flare.vm.provision "shell", path: "./scripts/install-sysinternals.ps1", privileged: false

    # Finished provisioning
    flare.vm.provision "shell", inline: "echo 'Provisioning ended, rebooting...'"
    # Reboot the VM
    flare.vm.provision :reload

    flare.vbguest.auto_update = false if Vagrant.has_plugin?("vagrant-vbguest")

    flare.vm.provider "virtualbox" do |flare_vb, override|
      flare_vb.gui = true
      flare_vb.name = FLARE_VM["name"]

      flare_vb.customize ["modifyvm", :id, "--memory", FLARE_VM["memory"]]
      flare_vb.customize ["modifyvm", :id, "--cpus", FLARE_VM["cpus"]]
      flare_vb.customize ["modifyvm", :id, "--vram", FLARE_VM["vram"]]
      flare_vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      flare_vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end

  # REMnux VM
  config.vm.define REMNUX_VM["name"] do |remnux|
    remnux.vm.box = REMNUX_VM["box"]
    if REMNUX_VM["version"] != nil
      remnux.vm.box_version = REMNUX_VM["version"]
    end

    remnux.trigger.after [:up] do |trigger|
      trigger.info = "Disconnecting NAT network cable to #{REMNUX_VM["name"]}..."
      trigger.run = {inline: "bash ./scripts/control-nat.sh \"#{REMNUX_VM["name"]}\" \"off\""}
    end

    remnux.vm.hostname = REMNUX_VM["name"]
    remnux.vm.synced_folder ".", "/vagrant", disabled: true  # disable synced folder
    remnux.vm.network :private_network, virtualbox__intnet: "flarenet", auto_config: false

    remnux.ssh.username = REMNUX_VM["username"]
    remnux.ssh.password = REMNUX_VM["password"]

    # Provisioning
    remnux.vm.provision "shell", inline: "echo 'Provisioning REMnux VM...'"

    # Configure inetsim
    remnux.vm.provision "file", source: "./res/remnux/config/inetsim.conf", destination: "$HOME/inetsim.conf"

    # Configure network
    remnux.vm.provision "file", source: "./res/remnux/config/01-netcfg.yaml", destination: "$HOME/01-netcfg.yaml"

    # Custom provisioning script
    remnux.vm.provision "shell", path: "./res/remnux/scripts/remnux-provisioning.sh", privileged: true

    # Finished provisioning
    remnux.vm.provision "shell", inline: "echo 'Provisioning ended, rebooting...'"
    # Reboot the VM
    remnux.vm.provision :reload

    remnux.vbguest.auto_update = false if Vagrant.has_plugin?("vagrant-vbguest")

    remnux.vm.provider "virtualbox" do |remnux_vb, override|
      remnux_vb.gui = true
      remnux_vb.name = REMNUX_VM["name"]

      remnux_vb.customize ["modifyvm", :id, "--memory", REMNUX_VM["memory"]]
      remnux_vb.customize ["modifyvm", :id, "--cpus", REMNUX_VM["cpus"]]
      remnux_vb.customize ["modifyvm", :id, "--vram", REMNUX_VM["vram"]]
      remnux_vb.customize ["modifyvm", :id, "--clipboard", "bidirectional"]
      remnux_vb.customize ["setextradata", "global", "GUI/SuppressMessages", "all" ]
    end
  end
end
