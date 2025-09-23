terraform {

  required_version = ">= 1.11.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.95.0"
    }
  }
  backend "s3" {
    bucket       = "tf-state-project-url-shortener"
    key          = "dev/terraform.tfstate"
    region       = "eu-west-2"
    encrypt      = "true"
    use_lockfile = true
  }

}


provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = var.aws-tags
  }
}