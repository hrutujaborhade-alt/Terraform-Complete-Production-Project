variable "aws_region" {
  description = "AWS Region"
  type        = string
}

variable "company" {
  description = "Company Name"
  type        = string
}

variable "project" {
  description = "project Name"
  type        = string
}

variable "environment" {
  description = "environment"
  type        = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_app_subnet_cidrs" {
  type = list(string)
}

variable "private_db_subnet_cidrs" {
  type = list(string)
}

variable "ami_id" {
  type = string
}

variable "instance_type" {
  type = string
}

variable "notification_mail" {
  type = string
}

variable "db_name" {
  type = string
}
variable "db_password" {
  type = string
  sensitive = true
}