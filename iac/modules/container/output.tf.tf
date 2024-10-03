output "container_id" {
  description = "The ID of the Docker container."
  value       = docker_container.default.id
}

output "container_name" {
  description = "The name of the Docker container."
  value       = docker_container.default.name
}

output "container_network_data" {
  description = "The network data of the Docker container. Returns empty list for host mode"
  value = [
    for network in docker_container.default.network_data : {
      gateway                = network.gateway
      global_ipv6_address    = network.global_ipv6_address
      global_ipv6_prefix_length = network.global_ipv6_prefix_length
      ip_address             = network.ip_address
      ip_prefix_length       = network.ip_prefix_length
      ipv6_gateway           = network.ipv6_gateway
      mac_address            = network.mac_address
      network_name           = network.network_name
    }
    if network.ip_address != ""
  ]
}