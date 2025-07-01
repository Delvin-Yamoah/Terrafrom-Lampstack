variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "lampstack"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
  default     = "ami-01f23391a59163da9"
}

variable "key_name" {
  description = "EC2 Key Pair name"
  type        = string
  default     = "lab3-key"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}