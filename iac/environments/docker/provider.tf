terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
    system = {
      source  = "neuspaces/system"
      version = "0.5.0"
    }
  }
}

# provider "docker" { host = "tcp://${var.host_ip_address}:2375" }
provider "docker" { 
  host     = "ssh://${var.ssh_user}@${var.host_ip_address}:${var.ssh_port}"
  ssh_opts = [
    "-o", "StrictHostKeyChecking=no",
    "-o", "UserKnownHostsFile=/dev/null",
    "-i", "${var.ssh_key_file}"
  ]
}

provider "system" {
  ssh {
    host     = var.host_ip_address
    port     = var.ssh_port
    user     = var.ssh_user
    private_key = file(var.ssh_key_file)
  }
}
