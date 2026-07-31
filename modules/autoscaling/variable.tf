variable "name_prefix" {
  
}

variable "common_tags" {
  type = map(string)
}

variable "launch_template_id" {
  
}

variable "target_group_arn" {
  
}

variable "private_subnet_ids" {
  type = list(string)
}