
## Preliminary required tasks before starting
- Clone the GitHub repository via the GitHub website or via the Git client (if installed)
- Download and install Vagrant [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html) 
- Download Packer and move the binary to your Packer folder [https://packer.io/downloads.html](https://packer.io/downloads.html)
- Download and install Virtualbox [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads)
- (For Windows only) install Git SCM [https://git-scm.com/downloads](https://git-scm.com/downloads)

## Install vagrant plugins
```sh

$ vagrant plugin install vagrant-vbguest

$ vagrant plugin install vagrant-reload

```

## Building the FlareVM (automatic box creation)
Install guest additions plugin and move into our working directory.
  
```sh

$ cd Packer

```
  
Now we build and configure the VM. This will download the Win10 ISO from Microsoft, boot it, and install the necessary tools to configure it. This will take a couple hours so do not feel the need to watch it. Red text may display showing errors but it will handle those by itself. If the are fatal errors the operation will stop and display the reason

```sh
$ ./packer build windows_10_flare-packer.json

```


## Build REMnux VM (manual box creation)
Steps:
- Download the REMnux OVA file from [https://docs.remnux.org/install-distro/get-virtual-appliance](https://docs.remnux.org/install-distro/get-virtual-appliance) 
- Import the file into Virtualbox
- Start the REMnux VM so VirtualBox will install Guest Additions
- Update Ubuntu 20.04 LTS packages (Optional) Note: This step will increase the box size 
```sh
$ sudo apt update -y 
$ sudo apt upgrade -y
```
- Enable SSH
```sh
$ sudo systemctl enable --now
```
- Shutdown the REMnux VM
- Run in termnial
```sh

$ VBoxManage list vms 
...
"REMnux" {93af1542-857c-4ae1-bd70-187d70b2029f}
...

$ vagrant package --base 93af1542-857c-4ae1-bd70-187d70b2029f --output ./Boxes/REMnux-v7-focal_virtualbox.box
==> 93af1542-857c-4ae1-bd70-187d70b2029f: Exporting VM...
==> 93af1542-857c-4ae1-bd70-187d70b2029f: Compressing package to: X:/WORK/FlareVM-Win10Enterprise22H2/Boxes/REMnux-v7-focal_virtualbox.box

```
Note: In case `VBoxManage` is not recognized you will need to provide the full path, eg: `/c/Program\ Files/Oracle/VirtualBox/VBoxManage.exe`

## Starting the Virtual Machines


In root directory and start Vagrant

```sh

$ vagrant up

```




The default login for the Flare VM is `analyst:infected`
The default login for the REMnux VM is `remnux:malware`

At this point you have a Windows 10 Enterprise 22H2 virtual machine with the following tools installed:
- [https://github.com/mandiant/flare-vm](https://github.com/mandiant/flare-vm)

and a REMnux v7 focal VM

### Notes
- adjust number of CPUs and amount of memory depending on your local resources in the Vagrant file
- vagrant will check if the boxes are present in the `./Boxes` folder and if not it will pull them from the Vagrant cloud


## IMPORTANT - SAFETY FIRST
### Before starting the malware analysis 
To do this run:
```
./scripts/disconnect-nat.sh 
```
This will disconnect the cable for NIC1, NAT network, in each of the Vagrant VMs created

You can also run these commands to disconnect the NAT networks from NIC1
```
controlvm "MalLab-Demo-FlareVM" setlinkstate1 off
controlvm "MalLab-Demo-REMnux" setlinkstate1 off
```
Or you can do it from the VirtualBox UI.

### Reconnecting the NAT network
To reconnect to the NAT network run:
```
controlvm "MalLab-Demo-FlareVM" setlinkstate1 on
controlvm "MalLab-Demo-REMnux" setlinkstate1 on
```
Or you can do it from the VirtualBox UI.

### Notes:
- if the NAT network is connected on the Flare VM you are exposing your host machine to malware. 
- if the NAT network is connected on theREMnux VM `inetsim` will default to this interface and will not work properly.


## Uploading boxes to Vagrant Cloud
Steps:
- Goto your Vagrant Dashboard [https://app.vagrantup.com/](https://app.vagrantup.com/)
- Click the blue button `New Vgrant Box`
- Add the name and a short description
- Click `Create box`
- Create your first version for the box. This version must match the format [0-9].[0-9].[0-9]
- Create a provider for the box, matching the provider you need locally in Vagrant. `virtualbox` is the most common provider.
- Upload the `.box` file for each provider, or use a url to the .box file that is publicly accessible
- Make sure you release the new version

Docs: [https://developer.hashicorp.com/vagrant/vagrant-cloud/boxes/create](https://developer.hashicorp.com/vagrant/vagrant-cloud/boxes/create)


Note: In order to calculate the SHA256 of the `.box` file (on Windows)
```

certutil -hashfile .\Remnux-v7-focal_virtualbox.box SHA256
SHA256 hash of .\Remnux-v7-focal.box:
0074e83253813da9c1967e4c244b60dab8c88afd
CertUtil: -hashfile command completed successfully.

```

## Troubleshooting

### vagrant up errors
In case of this error
```
...
    MalLab01-FlareVM-Win10Enterprise22H2: WinRM transport: plaintext
An error occurred executing a remote WinRM command.

Shell: Cmd
Command: hostname
Message: HTTPClient::KeepAliveDisconnected: An existing connection was forcibly closed by the remote host. @ io_fillbuf - fd:21
```
just run `vagrant destroy` and `vagrant up` again, this can happen from time to time


## Notes
- The Windows key was taken from [https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj612867(v=ws.11)?redirectedfrom=MSDN#windows-10](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj612867(v=ws.11)?redirectedfrom=MSDN#windows-10)

- Uploading boxes to Vagrant cloud [https://developer.hashicorp.com/vagrant/vagrant-cloud/boxes/create](https://developer.hashicorp.com/vagrant/vagrant-cloud/boxes/create)


## Credits:
- [https://github.com/agorecki/AnalysisLab](https://github.com/agorecki/AnalysisLab)
- [https://github.com/clong/DetectionLab](https://github.com/clong/DetectionLab)
