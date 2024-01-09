# Managing terraform backend using S3 bucket to store terraform state file & dyanamo database table for locking mechanism
terraform {
  backend "s3" {
    # Insert your terraform state file storage bucket name below
    bucket = "naveen-terraform-remote-state-bucket"
    # Insert your terraform state file path in S3 bucket below
    key = "terraform.tfstate"
    # Insert your terraform state file located region below
    region = "us-east-1"
    # Insert your dynamo db table name below to track terraform locking mechanism
    dynamodb_table = "terraform-lock"
  }
  required_providers {
    aws = {
      version = "~>5.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.region
}

