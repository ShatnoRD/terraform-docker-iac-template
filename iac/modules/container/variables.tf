variable "image_id" {
  type        = string
  description = "The ID of the Docker image to use for the container."
}

variable "container_name" {
  type        = string
  description = "The name to assign to the container."
}

variable "container_command" {
  type        = list(string)
  default     = null
  description = "The command to run inside the container."
}

variable "container_user" {
  type        = string
  default     = null
  description = "The user to use inside the container."
}

variable "container_memory_limit" {
  type        = number
  default     = null
  description = "The memory limit for the container in bytes."
}

variable "restart_policy" {
  type        = string
  default     = "unless-stopped"
  description = "The restart policy for the container (e.g., 'always', 'unless-stopped')."
}

variable "labels" {
  type        = map(string)
  default     = {}
  description = "Labels to apply to the container."
}

variable "ports" {
  type        = map(number)
  default     = {}
  description = "Ports to expose from the container. The map keys are the container ports, and the values are the host ports."
}

# Environment variables to set inside the container.
variable "envs" {
  type        = map(string)
  default     = {}
  description = "Environment variables to set inside the container."
}

variable "volumes" {
  type = list(object({
    host_path      = string
    container_path = string
    read_only      = optional(string)
  }))
  default     = []
  description = "Volumes to mount into the container. Each volume is an object with host_path, container_path, and optional read_only attributes."
}

variable "networks" {
  type = list(object({
    name    = optional(string)
    driver  = string
    aliases = optional(set(string))
  }))
  description = "Networks to connect the container to. Each network is an object with optional name, driver, and optional aliases attributes."
}