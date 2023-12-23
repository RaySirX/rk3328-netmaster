# rk3328-netmaster

PI variant rk3328

Packerized Raspbian Image as a network master
- pihole + unbound
- omada controller

## Spotty arm64 support - use dockers for now
Ideally all software would be directly installed onto PI without adding another layer of virt and control
Unfortunately, package support for arm64 is still lacking

All software will be installed into dockers running on PI

# Resize image - 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.6gig.img.xz

2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img.xz
- 2 Gig OS "/" disk

2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.6gig.img.xz
- resized 6 Gig OS "/" disk

1. Create copy 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.6gig.img.xz
`sudo cp 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img.xz 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.6gig.img.xz`

1. Uncompress image 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.6gig.img.xz
`unxz 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.6gig.img.xz`

2. Resize image using sdm +4 Gigs => 6 Gigs
`sudo sdm --extend --xmb 4096 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.6gig.img`
3. Compress image 
`xz 2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.6gig.img`

4. Update SHA256 file
sha256sum *.zx | tee SHA256SUM

## Build Env Setup
./setupBuildEnv

## Configure It
### .secrets - export env var of secrets
- BUILD_OS_USER_PASS - BUILD_OS_USER password

### defaults - export env var of settings

## Build It
./buildIt 2>&1 | tee buildIt.log

## Dependencies
### go version go1.19.3 linux/amd64

### Packer builders
- mkaczanowski builder
- should also with with solo-io builder

# Copy image to SD card

`sudo sdm --customize --L10n --autologin --regen-ssh-host-keys --user ${BUILD_OS_USER?} --password-user ${BUILD_OS_USER_PASS?} 2023-05-03-raspios-bullseye-arm64.img`
'sudo sdm --burn /dev/sda --hostname mypi1 --expand-root 2023-05-03-raspios-bullseye-arm64.img'

`losetup -P /dev/loop0 netmaster.img`
`dd bs=4M if=/dev/loop0 of=/dev/sda status=progress`
*DOUBLE DOUBLE CHECK the output device!*

# References
- [Libre Computer - ROC RK3328] (https://libre.computer/products/roc-rk3328-cc/)
- [mkaczanowski builder Packer Raspbian ] (https://github.com/mkaczanowski/packer-builder-arm) 
- [solo-io builder Packer Raspbian ] (https://github.com/solo-io/packer-plugin-arm-image) 
- [hedlund Packer Raspbian] (https://github.com/hedlund/packer-pi-hole)
- [Build a Raspberry Pi image with Packer – packer-builder-arm] https://linuxhit.com/build-a-raspberry-pi-image-packer-packer-builder-arm/
- [SDM!] (https://github.com/gitbls/sdm/blob/master/QuickStart.md)
`curl -L https://raw.githubusercontent.com/gitbls/sdm/master/EZsdmInstaller | bash`
- [Resize OS disk of image] (https://8086.support/content/12/100/en/how-do-i-resize-a-disk-image-raspbian-sd_usb-image.html)
- [Pi-Hole + Unbound on Docker] (https://github.com/chriscrowe/docker-pihole-unbound)
- [Omada Controller Docker] (https://github.com/mbentley/docker-omada-controller)

# Mermaid

## Sequence diagram [<a href="https://mermaid-js.github.io/mermaid/#/sequenceDiagram">docs</a> - <a href="https://mermaid.live/edit#pako:eNo9kMluwjAQhl_F-AykQMuSA1WrbuLQQ3v1ZbAnsVXHkzrjVhHi3etQwKfRv4w-z0FqMihL2eF3wqDxyUEdoVHhwTuNk-12RzaU4g29JzHMY2HpV0BE0VO6V8ETtdkGz1Zb1F8qiPyG5LX84mrLAmpwoWNh-5a0pWCiAxUwGBXeiVHEU4oq8V_6AHYUwAu2lLLTjVQ4bc1rT2yleI0IfJG320faZ9ABbk-Jz3hZnFxBduR9L2oiM5Jj2WBswJn8-cMArSRbbFDJMo8GK0ielVThmKOpNcD4bBxTlGUFvsOxhMT02QctS44JL6HzAS-iJzCYOwfJfTscunYd542aQuXqQU_RZ9kyt11ZFIM9rR3btJ9qaorOGQuR7c9mWSznyzXMF7hcLeBusTB6P9usq_ntrDKrm9kc5PF4_AMJE56Z">live editor</a>]

```
sequenceDiagram
Alice->>John: Hello John, how are you?
loop Healthcheck
    John->>John: Fight against hypochondria
end
Note right of John: Rational thoughts!
John-->>Alice: Great!
John->>Bob: How about you?
Bob-->>John: Jolly good!
```

```mermaid
sequenceDiagram
Alice->>John: Hello John, how are you?
loop Healthcheck
    John->>John: Fight against hypochondria
end
Note right of John: Rational thoughts!
John-->>Alice: Great!
John->>Bob: How about you?
Bob-->>John: Jolly good!
```

