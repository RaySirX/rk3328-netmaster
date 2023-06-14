# rk3328-netmaster

# Headless!  Get over it!

Packerized Raspbian Image as a (for now) standalone network master

[SDM!] (https://github.com/gitbls/sdm/blob/master/QuickStart.md)
- trying it
- could do away with packer
curl -L https://raw.githubusercontent.com/gitbls/sdm/master/EZsdmInstaller | bash

# Resize image
https://8086.support/content/12/100/en/how-do-i-resize-a-disk-image-raspbian-sd_usb-image.html

To resize the last partition in a disk image, for example a Raspberry Pi SD card image first increase the size of the file on disk using truncate, here we're going to increase it by 500MB.

truncate 2019-06-20-raspbian-buster-full.img --size=+500M
Once the file size has been increased the size of the second partition need to be updated to use all of the remaining space.

parted --script ./2019-06-20-raspbian-buster-full.img resizepart 2 100%
And then the filesystem will need to be extended to the size of the new partition, first enable access to the partitions in the disk image.

losetup -fP --show 2019-06-20-raspbian-buster-full.img
This will return the loop device name, in this example we're going to assume it's "/dev/loop1". 

Then check the filesystem.

e2fsck -f /dev/loop1p2
Now we can do the actual filesystem resize.

resize2fs /dev/loop1p2
If you see no errors then we're done and we can remove the loop interface.

losetup -d /dev/loop1

The size of the disk image has now been extended and the second partition has been increased to use all of the space.

## beware BTRFS!
```
truncate 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.bigger.img --size=+4G
parted --script ./2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.bigger.img resizepart 2 100%
losetup -fP --show 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.bigger.img
btrfs check /dev/loop0p2
btrfs filesystem resize max /dev/loop0p2
```
sudo sdm --customize --wpa /path/to/working/wpa_supplicant.conf --L10n --restart --disable piwiz \
--regen-ssh-host-keys --user myuser --password-user mypassword 2023-05-03-raspios-bullseye-arm64.img

sudo sdm --extend --xmb 4096 --customize --nowpa --L10n --restart --disable piwiz --regen-ssh-host-keys --user config --password-user passw0rd 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img
```

# 
sudo apt install rpi-imager

## Dockerized onto rk3328
- TP-Link Omada Controller
- Unbound DNS
- PiHole

## Configure It
./defaults

./secrets
-DEFAULT_USER_PASS
echo -n passw0rd | sha256sum | awk '{printf "%s",$1 }' | sha256sum

## Build It
./buildIt

PACKER_CONFIG_DIR=$HOME sudo -E $PACKER build -var-file buildEnv/config.json packer-netmaster.json

## Dependencies
go version go1.19.3 linux/amd64

## Build Env Setup

### Scripted
./setupBuildEnv

Packer builders
- mkaczanowski builder
- should also with with solo-io builder

# Copy image to SD card
`losetup -P /dev/loop0 netmaster.img`
`dd bs=4M if=/dev/loop0 of=/dev/sda status=progress`
*DOUBLE DOUBLE CHECK the output device!*

# References
[mkaczanowski builder Packer Raspbian ] (https://github.com/mkaczanowski/packer-builder-arm) 
[solo-io builder Packer Raspbian ] (https://github.com/solo-io/packer-plugin-arm-image) 

[hedlund Packer Raspbian] (https://github.com/hedlund/packer-pi-hole)

[Build a Raspberry Pi image with Packer – packer-builder-arm] https://linuxhit.com/build-a-raspberry-pi-image-packer-packer-builder-arm/
- bdstar -> libarchive-tools
