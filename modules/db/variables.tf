variable "subnet_id" {
  description = "The private subnet ID"
  type        = string
}

variable "security_group_id" {
  description = "Security group for the database instance"
  type        = string
}

variable "key_name" {
  description = "Name of the key pair to use for SSH access"
  type        = string
}
