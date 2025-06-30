variable "subnet_id" {
  description = "The private subnet ID for the app server"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID for the app server"
  type        = string
}

variable "db_host" {
  description = "IP or hostname of the MySQL server"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use for SSH access"
  type        = string
}