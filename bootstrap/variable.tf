variable "bucket_name" {
  default = "infosys_prod_s3_bucket"
}

variable "dynamodb_table_name" {
  default = "terraform-state-lock"
}