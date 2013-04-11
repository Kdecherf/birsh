birsh
=====

**birsh** is a replacement to **libvirt** but in bash and without XML files (and with many less features, I admit) :)

I created this bash script to be able to quickly start virtual machines with **KVM** or **systemd-nspawn** (more or less container mode) on my laptop without playing with ton of XML files or an awful GUI tool.

This tool lacks features at this time like graphical screen, removable media boot and the code is not necessarily beautiful but it works for me :) (and you can contribute)


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

`screen` is used to give you an access to the serial console of a KVM virtual machine. `qemu-nbd` and `kpartx` are used for the `nspawn` mode (see below).


Usage
-----

First of all, there are two modes on this tool: `start` which starts a virtual machine using KVM and `nspawn` which "boots" a virtual machine using `systemd-nspawn` (container).

The second mode is useful if you want to boot only one virtual machine without network needs (here the network is shared with the host) like quick test of a patch, build or software. The first mode can be used for as many times as you want.

At this time, this tool does not provide disk management so I let you manage your disks with `qemu-img` as you want. Just keep in mind that I only use qcow2 format in this tool.

I consider you have some bootable disks in your `IMAGESFOLDER`, for example ubuntu.qcow2, exherbo.qcow2 and php.qcow2.

To boot a KVM image: `birsh start name -m memorysize`
> where *name* is the name of the disk without the extension (eg. ubuntu, exherbo and php)
> and *memorysize* is the size of memory in MB

In this case, the tool will give you a prompt to the QEMU monitor socket after the start. Typing `quit` in the monitor or powering off the virtual machine will release the socket and destroy the virtual machine.

If you need to connect to the console (eg. the network or SSH don't work): `birsh serial name`
> where *name* is the name of a started virtual machine

**Note**: To be able to use this feature, you must set `console=ttyS0` on the virtual machines's kernel boot argument



To spawn a container with systemd: `birsh nspawn name`
> where *name* is the name of the disk without the extension

It will mount the disk in a folder (`MOUNTFOLDER`/name) and boot it. You only have one shell for this machine.

