variable "file_url" {
  type    = string
  default = "https://distro.libre.computer/ci/raspbian/11/2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img.xz"
}

variable "file_checksum_url" {
  type    = string
  default = "https://distro.libre.computer/ci/raspbian/11/SHA256SUMS"
}

variable "host_name" {
  type    = string
  default = "netmaster"
}

variable "user_name" {
  default = env("BUILD_OS_USER")
}

variable "user_password" {
  default   = env("BUILD_OS_USER_PASS")
  sensitive = true
}

variable "image_file_name" {
  type      = string
  default   = "netmaster.img"
}
