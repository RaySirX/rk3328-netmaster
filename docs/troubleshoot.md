# Troubleshooting

## docker build failure
```
2023/06/11 04:41:41 packer-builder-arm plugin: 2023/06/11 04:41:41 Leaving retrieve loop for rootfs_archive
    arm: unpacking /build/.packer_cache/2761f669ed5caa83ee71315266d4abcbf527fba6.xz to netmaster.img
    arm: unpacking with custom command: [xz --decompress /tmp/image3157465240/2761f669ed5caa83ee71315266d4abcbf527fba6.xz]
    arm: mapping image netmaster.img to free loopback device
    arm: image netmaster.img mapped to /dev/loop0
    arm: mounting /dev/loop0p2 to /tmp/4083959235
==> arm: exit status 32
    arm: unmounting /tmp/4083959235/boot/firmware
==> arm: failed to unmount /tmp/4083959235/boot/firmware: exit status 32
    arm: unmounting /tmp/4083959235
==> arm: failed to unmount /tmp/4083959235: exit status 32
Build 'arm' errored after 52 seconds 870 milliseconds: build was halted

==> Wait completed after 52 seconds 870 milliseconds

==> Some builds didn't complete successfully and had errors:
--> arm: build was halted
```

### docker debug

override entry point
```
rtai@main-popos.home ➜  rk3328-netmaster git:(main) ✗ docker run -d -t --privileged --name packer --entrypoint /bin/bash -v /dev:/dev -v ${PWD}:/build mkaczanowski/packer-builder-arm
68cebcebabadefb9152ce3020948dd6e30c34462cc979f4e96028d7b48542e8c
rtai@main-popos.home ➜  rk3328-netmaster git:(main) ✗ docker ps
CONTAINER ID   IMAGE                             COMMAND       CREATED         STATUS         PORTS     NAMES
68cebcebabad   mkaczanowski/packer-builder-arm   "/bin/bash"   5 seconds ago   Up 4 seconds             packer
rtai@main-popos.home ➜  rk3328-netmaster git:(main) ✗
```

login to packer instance
```
tai@main-popos.home ➜  rk3328-netmaster git:(main) ✗ docker exec -ti packer /bin/bash
root@68cebcebabad:/build# ls
README.md  buildEnv  buildEnv.old  buildIt  defaults  hedlund.json  mkaczanowski-packer-netmaster.json  netmaster.img  setupBuildEnv  setupVars.conf
root@68cebcebabad:/build# ls /
bin  boot  build  dev  entrypoint.sh  etc  home  lib  lib32  lib64  libx32  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
root@68cebcebabad:/build#
```

Run entry point to reproduce error
```
root@68cebcebabad:/build# /entrypoint.sh build mkaczanowski-packer-netmaster.json 
uname -a: Linux 68cebcebabad 6.2.6-76060206-generic #202303130630~1685473338~22.04~995127e SMP PREEMPT_DYNAMIC Tue M x86_64 x86_64 x86_64 GNU/Linux
Register qemu-aarch64
Register qemu-arm
running /bin/packer build mkaczanowski-packer-netmaster.json
2023/06/11 04:30:55 [INFO] Packer version: 1.8.5 [go1.18.9 linux amd64]
2023/06/11 04:30:55 [TRACE] discovering plugins in /usr/bin
2023/06/11 04:30:55 [DEBUG] Discovered plugin: arm = /usr/bin/packer-builder-arm
2023/06/11 04:30:55 [INFO] using external builders: [arm]
2023/06/11 04:30:55 [TRACE] discovering plugins in /root/.config/packer/plugins
2023/06/11 04:30:55 [TRACE] discovering plugins in .
2023/06/11 04:30:55 [TRACE] discovering plugins in /build/.packer_plugins
2023/06/11 04:30:55 [INFO] PACKER_CONFIG env var not set; checking the default config file path
2023/06/11 04:30:55 [INFO] PACKER_CONFIG env var set; attempting to open config file: /root/.packerconfig
2023/06/11 04:30:55 [WARN] Config file doesn't exist: /root/.packerconfig
2023/06/11 04:30:55 [INFO] Setting cache directory: /build/.packer_cache
2023/06/11 04:30:55 [TRACE] Starting external plugin /usr/bin/packer-builder-arm 
2023/06/11 04:30:55 Starting plugin: /usr/bin/packer-builder-arm []string{"/usr/bin/packer-builder-arm"}
2023/06/11 04:30:55 Waiting for RPC address for: /usr/bin/packer-builder-arm
2023/06/11 04:30:55 packer-builder-arm plugin: 2023/06/11 04:30:55 Plugin address: unix /tmp/packer-plugin2908331621
2023/06/11 04:30:55 packer-builder-arm plugin: 2023/06/11 04:30:55 Waiting for connection...
2023/06/11 04:30:55 Received unix RPC address for /usr/bin/packer-builder-arm: addr is /tmp/packer-plugin2908331621
2023/06/11 04:30:55 packer-builder-arm plugin: 2023/06/11 04:30:55 Serving a plugin connection...
2023/06/11 04:30:55 [TRACE] Starting internal plugin packer-provisioner-shell
2023/06/11 04:30:55 Starting plugin: /usr/bin/packer []string{"/usr/bin/packer", "plugin", "packer-provisioner-shell"}
2023/06/11 04:30:55 Waiting for RPC address for: /usr/bin/packer
2023/06/11 04:30:56 packer-provisioner-shell plugin: [INFO] Packer version: 1.8.5 [go1.18.9 linux amd64]
2023/06/11 04:30:56 packer-provisioner-shell plugin: [INFO] PACKER_CONFIG env var not set; checking the default config file path
2023/06/11 04:30:56 packer-provisioner-shell plugin: [INFO] PACKER_CONFIG env var set; attempting to open config file: /root/.packerconfig
2023/06/11 04:30:56 packer-provisioner-shell plugin: [WARN] Config file doesn't exist: /root/.packerconfig
2023/06/11 04:30:56 packer-provisioner-shell plugin: [INFO] Setting cache directory: /build/.packer_cache
2023/06/11 04:30:56 packer-provisioner-shell plugin: args: []string{"packer-provisioner-shell"}
2023/06/11 04:30:56 packer-provisioner-shell plugin: Plugin address: unix /tmp/packer-plugin376435683
2023/06/11 04:30:56 packer-provisioner-shell plugin: Waiting for connection...
2023/06/11 04:30:56 Received unix RPC address for /usr/bin/packer: addr is /tmp/packer-plugin376435683
2023/06/11 04:30:56 packer-provisioner-shell plugin: Serving a plugin connection...
2023/06/11 04:30:56 [TRACE] Starting internal plugin packer-provisioner-shell
2023/06/11 04:30:56 Starting plugin: /usr/bin/packer []string{"/usr/bin/packer", "plugin", "packer-provisioner-shell"}
2023/06/11 04:30:56 Waiting for RPC address for: /usr/bin/packer
2023/06/11 04:30:56 packer-provisioner-shell plugin: [INFO] Packer version: 1.8.5 [go1.18.9 linux amd64]
2023/06/11 04:30:56 packer-provisioner-shell plugin: [INFO] PACKER_CONFIG env var not set; checking the default config file path
2023/06/11 04:30:56 packer-provisioner-shell plugin: [INFO] PACKER_CONFIG env var set; attempting to open config file: /root/.packerconfig
2023/06/11 04:30:56 packer-provisioner-shell plugin: [WARN] Config file doesn't exist: /root/.packerconfig
2023/06/11 04:30:56 packer-provisioner-shell plugin: [INFO] Setting cache directory: /build/.packer_cache
2023/06/11 04:30:56 packer-provisioner-shell plugin: args: []string{"packer-provisioner-shell"}
2023/06/11 04:30:56 packer-provisioner-shell plugin: Plugin address: unix /tmp/packer-plugin2436208527
2023/06/11 04:30:56 packer-provisioner-shell plugin: Waiting for connection...
2023/06/11 04:30:56 Received unix RPC address for /usr/bin/packer: addr is /tmp/packer-plugin2436208527
2023/06/11 04:30:56 packer-provisioner-shell plugin: Serving a plugin connection...
2023/06/11 04:30:56 [TRACE] Starting internal plugin packer-provisioner-shell
2023/06/11 04:30:56 Starting plugin: /usr/bin/packer []string{"/usr/bin/packer", "plugin", "packer-provisioner-shell"}
2023/06/11 04:30:56 Waiting for RPC address for: /usr/bin/packer
2023/06/11 04:30:57 packer-provisioner-shell plugin: [INFO] Packer version: 1.8.5 [go1.18.9 linux amd64]
2023/06/11 04:30:57 packer-provisioner-shell plugin: [INFO] PACKER_CONFIG env var not set; checking the default config file path
2023/06/11 04:30:57 packer-provisioner-shell plugin: [INFO] PACKER_CONFIG env var set; attempting to open config file: /root/.packerconfig
2023/06/11 04:30:57 packer-provisioner-shell plugin: [WARN] Config file doesn't exist: /root/.packerconfig
2023/06/11 04:30:57 packer-provisioner-shell plugin: [INFO] Setting cache directory: /build/.packer_cache
2023/06/11 04:30:57 packer-provisioner-shell plugin: args: []string{"packer-provisioner-shell"}
2023/06/11 04:30:57 packer-provisioner-shell plugin: Plugin address: unix /tmp/packer-plugin1217057415
2023/06/11 04:30:57 packer-provisioner-shell plugin: Waiting for connection...
2023/06/11 04:30:57 Received unix RPC address for /usr/bin/packer: addr is /tmp/packer-plugin1217057415
2023/06/11 04:30:57 packer-provisioner-shell plugin: Serving a plugin connection...
2023/06/11 04:30:57 Preparing build: arm
2023/06/11 04:30:58 Build debug mode: false
2023/06/11 04:30:58 Force build: false
arm: output will be in this color.
2023/06/11 04:30:58 On error: 
2023/06/11 04:30:58 Waiting on builds to complete...

2023/06/11 04:30:58 Starting build run: arm
2023/06/11 04:30:58 Running builder: arm
2023/06/11 04:30:58 [INFO] (telemetry) Starting builder arm
==> arm: Retrieving rootfs_archive
==> arm: Trying https://distro.libre.computer/ci/raspbian/11/2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img.xz?archive=false
2023/06/11 04:30:58 packer-builder-arm plugin: 2023/06/11 04:30:58 Acquiring lock for: https://distro.libre.computer/ci/raspbian/11/2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img.xz?archive=false&checksum=file%3Ahttps%3A%2F%2Fdistro.libre.computer%2Fci%2Fraspbian%2F11%2FSHA256SUMS (/build/.packer_cache/2761f669ed5caa83ee71315266d4abcbf527fba6.xz.lock)
==> arm: Trying https://distro.libre.computer/ci/raspbian/11/2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img.xz?archive=false&checksum=file%3Ahttps%3A%2F%2Fdistro.libre.computer%2Fci%2Fraspbian%2F11%2FSHA256SUMS
2023/06/11 04:31:01 packer-builder-arm plugin: 2023/06/11 04:31:01 Leaving retrieve loop for rootfs_archive
==> arm: https://distro.libre.computer/ci/raspbian/11/2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img.xz?archive=false&checksum=file%3Ahttps%3A%2F%2Fdistro.libre.computer%2Fci%2Fraspbian%2F11%2FSHA256SUMS => /build/.packer_cache/2761f669ed5caa83ee71315266d4abcbf527fba6.xz
    arm: unpacking /build/.packer_cache/2761f669ed5caa83ee71315266d4abcbf527fba6.xz to netmaster.img
    arm: unpacking with custom command: [xz --decompress /tmp/image263876627/2761f669ed5caa83ee71315266d4abcbf527fba6.xz]
    arm: mapping image netmaster.img to free loopback device
    arm: image netmaster.img mapped to /dev/loop0
    arm: mounting /dev/loop0p2 to /tmp/1629027873
==> arm: exit status 32
    arm: unmounting /tmp/1629027873/boot/firmware
==> arm: failed to unmount /tmp/1629027873/boot/firmware: exit status 32
    arm: unmounting /tmp/1629027873
==> arm: failed to unmount /tmp/1629027873: exit status 32
2023/06/11 04:31:51 [INFO] (telemetry) ending arm
==> Wait completed after 53 seconds 252 milliseconds
2023/06/11 04:31:51 machine readable: error-count []string{"1"}
==> Some builds didn't complete successfully and had errors:
2023/06/11 04:31:51 machine readable: arm,error []string{"build was halted"}
==> Builds finished but no artifacts were created.
Build 'arm' errored after 53 seconds 252 milliseconds: build was halted

2023/06/11 04:31:51 [INFO] (telemetry) Finalizing.
==> Wait completed after 53 seconds 252 milliseconds

==> Some builds didn't complete successfully and had errors:
--> arm: build was halted

==> Builds finished but no artifacts were created.
2023/06/11 04:31:51 waiting for all plugin processes to complete...
2023/06/11 04:31:51 /usr/bin/packer-builder-arm: plugin process exited
2023/06/11 04:31:51 /usr/bin/packer: plugin process exited
2023/06/11 04:31:51 /usr/bin/packer: plugin process exited
2023/06/11 04:31:51 /usr/bin/packer: plugin process exited
root@68cebcebabad:/build#
```

Manually reproduce error
```
root@68cebcebabad:/build# losetup -P /dev/loop0 netmaster.img 
root@68cebcebabad:/build# ls
README.md  buildEnv  buildEnv.old  buildIt  defaults  hedlund.json  mkaczanowski-packer-netmaster.json  netmaster.img  setupBuildEnv  setupVars.conf
root@68cebcebabad:/build# losetup -l
NAME       SIZELIMIT OFFSET AUTOCLEAR RO BACK-FILE            DIO LOG-SEC
/dev/loop0         0      0         0  0 /build/netmaster.img   0     512
root@68cebcebabad:/build# lsblk            
NAME          MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
loop0           7:0    0   2.1G  0 loop  
|-loop0p1     259:7    0   256M  0 part  
`-loop0p2     259:8    0   1.8G  0 part  
sda             8:0    1     0B  0 disk  
zram0         252:0    0    16G  0 disk  [SWAP]
nvme0n1       259:0    0 931.5G  0 disk  
|-nvme0n1p1   259:1    0  1022M  0 part  
|-nvme0n1p2   259:2    0     4G  0 part  
|-nvme0n1p3   259:3    0 922.5G  0 part  /etc/hosts
|                                        /etc/hostname
|                                        /etc/resolv.conf
|                                        /build
`-nvme0n1p4   259:4    0     4G  0 part  
  `-cryptswap 253:0    0     4G  0 crypt [SWAP]
root@68cebcebabad:/build# mkdir /tmp/1629027873
root@68cebcebabad:/build# mount /dev/loop0p2 /tmp/1629027873
mount: /tmp/1629027873: mount(2) system call failed: File exists.
root@68cebcebabad:/build#
```

Determine root cause of mount failure "File exists"
The btrfs filesystem is used in raspbian image
btrfs caches UUID of previous mounts
Rerunning "buildIt" will fail as btrfs mounting of raspbian image incorrect assumes image is already mounted in use
```
root@main-popos:~# lsblk -f
NAME          FSTYPE FSVER LABEL     UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
loop0                                                                                    
├─loop0p1     vfat   FAT32 boot      3772-58CD                                           
└─loop0p2     btrfs        rootfs    1cd42925-4305-4a79-bb10-f50d1fda10f8                
```

Clear the btrfs cache
```
root@main-popos:~# btrfs device scan --forget
root@main-popos:~# mount /dev/loop0p2 /tmp/tmp.jm9eizCLIR/mnt
root@main-popos:~# ls
go  HW_PROBE  packer-builder-arm-image  packer.d  README.md
root@main-popos:~# df -h
Filesystem      Size  Used Avail Use% Mounted on
tmpfs           6.2G  4.1M  6.2G   1% /run
/dev/nvme0n1p3  907G  287G  575G  34% /
tmpfs            31G  6.6M   31G   1% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
/dev/nvme0n1p1 1020M  286M  735M  28% /boot/efi
/dev/nvme0n1p2  4.0G  2.5G  1.6G  62% /recovery
tmpfs           6.2G   19M  6.2G   1% /run/user/1000
/dev/loop0p2    1.9G  1.4G  319M  82% /tmp/tmp.jm9eizCLIR/mnt
root@main-popos:~# 
```