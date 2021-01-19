terraform {
  required_version = ">= 0.12.26"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.22.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "aws_s3_bucket_private" {
  source = "../../modules/aws-s3-private"

  bucket_name     = format("example-%s-worm-%s", data.aws_caller_identity.current.account_id, var.name)
  logging_enabled = var.enable_logging
  tags            = var.tags

  object_lock_configuration = {
    mode = var.worm_mode
    days = var.worm_retention_days
  }
}

data "aws_caller_identity" "current" {
}
