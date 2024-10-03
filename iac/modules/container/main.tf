terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.2"
    }
  }
}

resource "docker_container" "default" {
  image        = var.image_id
  name         = var.container_name
  restart      = var.restart_policy

  network_mode = var.networks[0].driver

  env          = [for key, value in var.envs : "${key}=${value}"]
  command      = var.container_command
  user         = var.container_user
  
  memory       = var.container_memory_limit
  
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
      host_path      = volumes.value.host_path
      container_path = volumes.value.container_path
      read_only      = volumes.value.read_only
    }
  }

  // Only create the "networks_advanced" block if the name is not null
  dynamic "networks_advanced" {
    for_each = { for idx, network in var.networks : idx => network if network.name != null }
    content {
      name    = networks_advanced.value.name
      aliases = networks_advanced.value.aliases
    }
  }
}