# HOW TO - Resize Raspbian with BTRFS root "/"

## Setup copy original image file to "bigger"

```
root@main-popos:/rk3328-netmaster/downloads# cp 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.bigger.img
root@main-popos:/rk3328-netmaster/downloads#
root@main-popos:/rk3328-netmaster/downloads# ls -l
total 20716076
-rw-r--r-- 1 root root 10842275840 Jun 13 18:28 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.bigger.img
-rw-r--r-- 1 root root 10842275840 Jun 13 08:20 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img
root@main-popos:rk3328_rapsbian/rk3328-netmaster/downloads# 
```

## Mount image file as /dev/loop0
```
root@main-popos:/rk3328-netmaster/downloads# losetup -P /dev/loop0 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.bigger.img 
root@main-popos:/rk3328-netmaster/downloads# losetup -J
{
   "loopdevices": [
      {
         "name": "/dev/loop0",
         "sizelimit": 0,
         "offset": 0,
         "autoclear": false,
         "ro": false,
         "back-file": "/rk3328-netmaster/downloads/2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.bigger.img",
         "dio": false,
         "log-sec": 512
      }
   ]
}
root@main-popos:/rk3328-netmaster/downloads# lsblk -f /dev/loop0
NAME      FSTYPE FSVER LABEL  UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
loop0                                                                             
├─loop0p1 vfat   FAT32 boot   3772-58CD                                           
└─loop0p2 btrfs        rootfs 1cd42925-4305-4a79-bb10-f50d1fda10f8                
root@main-popos:/rk3328-netmaster/downloads# 
```

## Mount root "/" BTRS partition loop0p2

```
root@main-popos:/rk3328-netmaster/downloads# mount /dev/loop0p2 /tmp/tmp.0gx1yFDGpn
root@main-popos:/rk3328-netmaster/downloads# df -h /tmp/tmp.0gx1yFDGpn
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0p2    1.9G  1.8G   64K 100% /tmp/tmp.0gx1yFDGpn
root@main-popos:/rk3328-netmaster/downloads# 
```

## BTRS resize filesystem

```
root@main-popos:/rk3328-netmaster/downloads# df -h /tmp/tmp.0gx1yFDGpn
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0p2    1.9G  1.8G   64K 100% /tmp/tmp.0gx1yFDGpn
root@main-popos:/rk3328-netmaster/downloads# btrfs filesystem resize +4G /tmp/tmp.0gx1yFDGpn
Resize device id 1 (/dev/loop0p2) from 1.84GiB to 5.84GiB
root@main-popos:/rk3328-netmaster/downloads# df -h /tmp/tmp.0gx1yFDGpn
Filesystem      Size  Used Avail Use% Mounted on
/dev/loop0p2    5.9G  1.8G  4.0G  30% /tmp/tmp.0gx1yFDGpn
root@main-popos:/rk3328-netmaster/downloads# 
```

## Unmount and cleanup

```
root@main-popos:/rk3328-netmaster/downloads# umount /tmp/tmp.0gx1yFDGpn
root@main-popos:/rk3328-netmaster/downloads# losetup -d /dev/loop0
root@main-popos:/rk3328-netmaster/downloads# losetup -J
{
   "loopdevices": [

   ]
}
root@main-popos:/rk3328-netmaster/downloads# 
```