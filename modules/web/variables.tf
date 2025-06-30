variable "subnet_id" {
  description = "The public subnet ID for the web server"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the web server"
  type        = string
}

variable "app_host" {
  description = "IP or hostname of the application server"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use for SSH access"
  type        = string
}
