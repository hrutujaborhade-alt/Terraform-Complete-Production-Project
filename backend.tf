terraform {
    backend "s3" {
      bucket = "infosys-prod-s3-bucket"
      key = "production/terraform.tfstate"
      region = "us-east-1"
      dynamodb_table = "terraform-state-lock"
      encrypt = true
    }
}