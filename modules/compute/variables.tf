variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type"
  type        = string
}

variable "key_name" {
  description = "Key pair name"
  type        = string
}

variable "web_subnet_id" {
  description = "Web subnet ID"
  type        = string
}

variable "app_subnet_id" {
  description = "App subnet ID"
  type        = string
}

variable "db_subnet_id" {
  description = "DB subnet ID"
  type        = string
}

variable "web_sg_id" {
  description = "Web security group ID"
  type        = string
}

variable "app_sg_id" {
  description = "App security group ID"
  type        = string
}

variable "db_sg_id" {
  description = "DB security group ID"
  type        = string
}