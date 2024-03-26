# inherited
variable "image_name" {
  type = string
}
variable "image_tag" {
  type = string
}
variable "container_name" {
  type = string
}
variable "container_command" {
  type    = list(string)
  default = null
}
variable "container_user" {
  type    = string
  default = null
}

variable "restart_policy" {
  type    = string
  default = "unless-stopped"
}

variable "labels" {
  type    = map(string)
  default = {}
}
variable "ports" {
  type    = map(number)
  default = {}
}
variable "envs" {
  type    = map(string)
  default = {}
}

variable "volumes" {
  type = list(object({
    host_path      = string
    container_path = string
    read_only      = optional(string)
  }))
  default = []
}

variable "network" {
  type = object({
    name    = optional(string)
    driver  = string
    aliases = optional(set(string))
  })
}