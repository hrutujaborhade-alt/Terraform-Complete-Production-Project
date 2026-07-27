locals {

  prefix = "${var.company}-${var.project}-${var.environment}"

  common_tags = {

    company     = var.company
    project     = var.project
    environment = var.environment
    ManagedBy   = "Terraform "
    Owner       = "Cloud Team"

  }
}