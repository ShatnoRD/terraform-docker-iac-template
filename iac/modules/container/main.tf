terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

resource "docker_container" "default" {
  image        = "${var.image_name}:${var.image_tag}"
  name         = var.container_name
  restart      = var.restart_policy

  network_mode = var.network.driver

  env          = [for key, value in var.envs : "${key}=${value}"]
  command      = var.container_command
  user         = var.container_user

  dynamic "labels" {
    for_each = var.labels
    content {
      label = labels.key
      value = labels.value
    }
  }

  dynamic "ports" {
    for_each = var.ports
    content {
      external = ports.key
      internal = ports.value
    }
  }

  dynamic "volumes" {
    for_each = var.volumes
    content {
      host_path      = volumes.value["host_path"]
      container_path = volumes.value["container_path"]
      read_only      = volumes.value["read_only"]
    }
  }

  // Only create the "networks_advanced" block if the name is null
  dynamic "networks_advanced" {
    for_each = var.network.name != null ? [0] : []
    content {
      name    = var.network.name
      aliases = var.network.aliases
    }
  }
}

