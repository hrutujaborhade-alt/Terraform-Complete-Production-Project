variable "name_prefix" {

}

variable "common_tags" {
  type = map(string)
}

variable "db_subnet_ids" {
  type = list(string)
}

variable "db_security_group_ids" {

}

variable "db_name" {

}

variable "db_password" {

}

variable "username" {
  default = "admin"
}