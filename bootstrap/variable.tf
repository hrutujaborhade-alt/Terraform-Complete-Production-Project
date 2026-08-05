variable "bucket_name" {
  default = "infosys-prod-s3-bucket"
}

variable "dynamodb_table_name" {
  default = "terraform-state-lock"
}