variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  type        = string
}

variable "name_prefix" {
  description = "Resource naming prefix"
  type        = string
}

variable "common_tags" {
  description = "common tags"

  type = map(string)
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