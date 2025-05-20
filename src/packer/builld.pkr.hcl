build {
  sources = [
    "source.azure-arm.vm",
    "source.amazon-ebs.vm",
    "source.googlecompute.vm"
  ]

  # Install nginx (shared)
  provisioner "shell" {
    execute_command = local.execute_command
    script          = "./scripts/install-nginx.sh"
  }

  # Upload HTML template (shared)
  provisioner "file" {
    source      = "./files/index.html.tpl"
    destination = "/tmp/index.html.tpl"
  }

  provisioner "shell" {
    execute_command = local.execute_command
    script          = "./scripts/update-message.sh"
    env = {
      CUSTOM_MESSAGE = "Hello AWS!"
      CUSTOM_COLOR   = "orange"
    }
    only = ["amazon-ebs.vm"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    script          = "./scripts/update-message.sh"
    env = {
      CUSTOM_MESSAGE = "Hello Azure!"
      CUSTOM_COLOR   = "blue"
    }
    only = ["azure-arm.vm"]
  }

  provisioner "shell" {
    execute_command = local.execute_command
    script          = "./scripts/update-message.sh"
    env = {
      CUSTOM_MESSAGE = "Hello Google Cloud!"
      CUSTOM_COLOR   = "green"
    }
    only = ["googlecompute.vm"]
  }

  provisioner shell {
    execute_command = local.execute_command
    inline          = ["/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    only            = ["azure-arm.vm"]
  }

}