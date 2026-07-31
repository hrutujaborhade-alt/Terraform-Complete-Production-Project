variable "name_prefix" {
  
}
variable "common_tags" {
  
}

variable "vpc_id" {
  
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "alb_security_group_id" {
  type = string
}
