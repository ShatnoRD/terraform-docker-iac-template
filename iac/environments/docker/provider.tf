terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
    system = {
      source  = "neuspaces/system"
      version = "0.3.0"
    }
  }
}

provider "docker" { host = "tcp://${var.host_ip_address}:2375" }
provider "system" {
  ssh {
    host     = var.host_ip_address
    port     = var.ssh_port
    user     = var.ssh_user
    password = var.ssh_password
  }
}
