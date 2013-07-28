birsh
=====

**birsh** is a replacement to **libvirt** but in bash and without XML files (and with many less features, I admit) :)

I created this bash script to be able to quickly start virtual machines with **KVM** or **systemd-nspawn** (more or less container mode) on my laptop without playing with ton of XML files or an awful GUI tool.

The second mode is useful if you want to boot only one virtual machine without network needs (here the network is shared with the host) like quick test of a patch, build or software. The first mode can be used as many times as you want.

This tool lacks features at this time like graphical screen, removable media boot, disk management and the code is not necessarily beautiful but it works for me :) (and you can contribute)


Installation
------------

Just `make install`


Configuration
-------------

The main configuration file is `/etc/birsh/settings` and let you set the following items:

* `IMAGESFOLDER`: folder containing all disks
* `MOUNTFOLDER`: folder where to mount disks (for `nspawn`)
* `TMPFOLDER`: folder to put monitor sockets and temporary files (for `start`)
* `BRIDGE`: network device name for the bridge (for `start`)
* `BRIDGEUP`: optional setting to specify commands to execute after the bridge is up (eg. DHCP server)
* `GATEWAY`: network address of the host
* `NETWORK`: network to use for virtual machines (used for NAT)

The tool will automatically set NAT using `iptables` and create a /24 private network.


Requirements
------------

You must have these tools installed on your host: `brctl`, `ip`, `iptables`, `qemu-nbd`, `kpartx`, `socat`, `screen`, `systemd-nspawn` (optional).

`screen` is used to give you an access to the serial console of a KVM virtual machine. You should set `console=ttyS0` on the virtual machine's kernel boot argument to be able to use this feature.

`qemu-nbd` and `kpartx` are used for the `nspawn` mode.


Usage
-----

**birsh** _command_ _[options]_

### Commands

**birsh start** _name_ _-m size_ _[-g]_ _[-s num]_  
Start a new virtual machine using _qemu-kvm_. Return the QEMU monitor socket.

* _name_ (mandatory): name of the disk to boot on
* **-m** _size_ (mandatory): set _size_ MB of memory to the virtual machine
* **-g**: enable graphical output
* **-s** _num_: set _num_ CPUs to the virtual machine


**birsh nspawn** _name_  
Start a new container using _systemd-nspawn_. Return a chrooted shell.

* _name_ (mandatory): name of the disk to boot on

**birsh serial** _name_  
Attach a screen to the serial console of a virtual machine (only for _qemu-kvm_)

* _name_ (mandatory): name of the disk to attach console on

**birsh list**  
List all available qcow2 disk files in `IMAGESFOLDER`. Files in subfolders are excluded.


Examples
--------

I consider you have some bootable disks in your `IMAGESFOLDER`, for example ubuntu.qcow2, exherbo.qcow2 and php.qcow2.

Boot the php virtual machine using `qemu-kvm` with 512 MB of memory:
> birsh start php -m 512

_Note: this command will output a prompt to the QEMU monitor socket. Typing `quit` in this monitor or powering off the virtual machine will release the socket and destroy the machine._


Attach to the php serial console (after `birsh start php`):
> birsh serial php


Spawn a container for the disk exherbo:
> birsh nspawn exherbo

_Note: this command will mount the disk exherbo.qcow2 in `MOUNTFOLDER`/exherbo and boot it._


License
-------

This tool is released under the [ISC license](http://www.isc.org/software/license "ISC license"). See the LICENSE file for more information.
