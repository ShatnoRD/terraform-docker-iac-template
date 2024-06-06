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


data "docker_registry_image" "nginx" {
  name = "nginx:latest"
}
resource "docker_image" "nginx" {
  name          = data.docker_registry_image.nginx.name
  pull_triggers = [data.docker_registry_image.nginx.sha256_digest]
  keep_locally  = true
}


module "proxy_app_hostmode" {
  source = "../../modules/container"

  image_id       = docker_image.nginx.image_id
  container_name = "nginx-proxy-app1"

  labels = {
    "logging"         = "promtail_user",
    "logging_jobname" = "proxy_app_hostmode"
  }
  ports = {
    80 : 80
  }
  volumes = [
    {
      host_path      = system_file.app_config_file.path,
      container_path = "/etc/nginx/nginx.conf"
    }
  ]
  networks = [{ 
    driver = "host"
  }]
}

module "proxy_app_bridgemode" {
  source = "../../modules/container"

  image_id       = docker_image.nginx.image_id
  container_name = "nginx-proxy-app2"

  labels = {
    "logging"         = "promtail_user",
    "logging_jobname" = "proxy_app_hostmode"
  }
  ports = {
    81 : 80
  }
  volumes = [
    {
      host_path      = system_file.app_config_file.path,
      container_path = "/etc/nginx/nginx.conf"
    }
  ]
  networks = [{ 
    name = docker_network.app_network.name
    driver = docker_network.app_network.driver
    aliases = ["proxy_app_bridgemode"]
  }]
}






