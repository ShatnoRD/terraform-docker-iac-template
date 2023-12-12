resource "system_folder" "app_data_folder" {
  path = "${var.host_data_path}/proxy-app"
}

resource "system_folder" "app_config_folder" {
  path = "${system_folder.app_data_folder.path}/config"
}

resource "system_file" "app_config_file" {
  path   = "${system_folder.app_config_folder.path}/nginx.conf"
  source = "../../../data/app/config/nginx.conf"
}


resource "docker_network" "app_network" {
  name   = "app-network"
  driver = "bridge"
}

module "proxy_app_hostmode" {
  source = "../../modules/container"

  image_name     = "nginx"
  image_tag      = "latest"
  container_name = "nginx-proxy-app1"

  labels = {
    "logging"         = "promtail_user",
    "logging_jobname" = "proxy_app_hostmode"
  }
  ports = {
    80 = 80
  }
  volumes = [
    {
      host_path      = system_file.app_config_file.path,
      container_path = "/etc/nginx/nginx.conf"
    }
  ]
  network = { 
    driver = "host"
  }
}

module "proxy_app_bridgemode" {
  source = "../../modules/container"

  image_name     = "nginx"
  image_tag      = "latest"
  container_name = "nginx-proxy-app2"

  labels = {
    "logging"         = "promtail_user",
    "logging_jobname" = "proxy_app_hostmode"
  }
  ports = {
    81 = 80
  }
  volumes = [
    {
      host_path      = system_file.app_config_file.path,
      container_path = "/etc/nginx/nginx.conf"
    }
  ]
  network = { 
    name = docker_network.app_network.name
    driver = docker_network.app_network.driver
    aliases = ["app_net"]
  }
}






