# rk3328-netmaster

# Headless!  Get over it!

Packerized Raspbian Image as a (for now) standalone network master


## Dockerized onto rk3328
- TP-Link Omada Controller
- Unbound DNS
- PiHole

## Configure It
./defaults

./secrets
-DEFAULT_PI_USER_PASS

## Build It
./buildIt

## Dependencies
go version go1.19.3 linux/amd64

# References
[Packer Raspbian] (https://github.com/hedlund/packer-pi-hole)
