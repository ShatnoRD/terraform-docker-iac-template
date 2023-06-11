terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
}

provider "docker" { host = "tcp://192.168.1.115:2375" }
# provider "docker" { host = "ssh://root@192.168.1.115:22" }

