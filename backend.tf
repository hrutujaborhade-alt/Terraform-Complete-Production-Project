terraform {
    backend "s3" {
      bucket = "infosys_prod_s3_bucket"
      key = "production/terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "terraform-state-lock"
      encrypt = true
    }
}