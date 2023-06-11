resource "docker_image" "app1" {
  name         = "nginx:latest"
  keep_locally = false
}

resource "docker_container" "app1" {
  image   = docker_image.app1.image_id
  name    = "nginx-app"
  restart = "unless-stopped"
  labels {
    label = "logging"
    value = "promtail"
  }
  labels {
    label = "logging_jobname"
    value = "app1"
  }
  ports {
    internal = 8123
    external = 8123
  }
  volumes {
    host_path      = "${var.host_data_path}/app1"
    container_path = "/config"
  }
  network_mode = "host"
}

