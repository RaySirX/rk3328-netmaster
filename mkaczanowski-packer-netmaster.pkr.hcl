variable "distro_url" {
  type    = string
  default = "https://distro.libre.computer/ci/raspbian/11/2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img.xz"
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

source "arm" "rk3328_rapsbian" {
  file_urls             = ["${var.distro_url}"]
  file_checksum_url     = "https://distro.libre.computer/ci/raspbian/11/SHA256SUMS"
  file_checksum_type    = "sha256"
  file_target_extension = "xz"
  file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]
  image_path            = "${var.image_file_name}"
  image_size            = "2G"
  image_type            = "dos"
  image_build_method    = "reuse"
  image_chroot_env      = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
  image_partitions {
    filesystem   = "fat"
    mountpoint   = "/boot/firmware"
    name         = "boot"
    size         = "256M"
    start_sector = "2048"
    type         = "c"
  }
  image_partitions {
    filesystem   = "ext4"
    mountpoint   = "/"
    name         = "root"
    size         = "0"
    start_sector = "526336"
  }
  qemu_binary_destination_path = "/usr/bin/qemu-aarch64-static"
  qemu_binary_source_path      = "/usr/bin/qemu-aarch64-static"
}

source "arm" "rk3328_netmaster" {
  file_urls             = ["downloads/2022-09-22-raspbian-bullseye-arm64+roc-rk3328-cc.img.xz"]
  file_checksum_url     = "downloads/SHA256SUMS"
  file_checksum_type    = "sha256"
  file_target_extension = "xz"
  file_unarchive_cmd    = ["xz", "--decompress", "$ARCHIVE_PATH"]
  image_path            = "${var.image_file_name}"
  image_size            = "4G"
  image_type            = "dos"
  image_build_method    = "reuse"
  image_chroot_env      = ["PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/sbin:/bin:/sbin"]
  image_partitions {
    filesystem   = "fat"
    mountpoint   = "/boot/firmware"
    name         = "boot"
    size         = "256M"
    start_sector = "2048"
    type         = "c"
  }
  image_partitions {
    filesystem   = "ext4"
    mountpoint   = "/"
    name         = "root"
    size         = "0"
    start_sector = "526336"
  }
  qemu_binary_destination_path = "/usr/bin/qemu-aarch64-static"
  qemu_binary_source_path      = "/usr/bin/qemu-aarch64-static"
}

# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  sources = ["source.arm.rk3328_netmaster"]

  provisioner "shell" {
      script = "installIt.d/sanity-check"
  }

  provisioner "shell" {
    scripts = [
      "installIt.d/10-raspbian-setup-default-user",
      "installIt.d/20-enable-ssh",
      "installIt.d/25-set-hostname",
      "installIt.d/50-install-pihole",
    ]
  }

  provisioner "shell" {
      script = "installIt.d/sanity-check"
  }
}
