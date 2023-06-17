# a build block invokes sources and runs provisioning steps on them. The
# documentation for build blocks can be found here:
# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  name = "netmaster"
  sources = ["source.arm.rk3328_xz_sha256"]

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
