terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
    # random = {
    #   source  = "hashicorp/random"
    #   version = "3.0.1"
    # }
  }
  # required_version = ">= 1.1.0"
  # cloud {
  #   organization = "Simple-Pro"

  #   workspaces {
  #     name = "GitHub-actions"
  #   }
  # }
}
provider "aws" {
  shared_credentials_files = ["~/.aws/credentials"]
  # profile                  = "Pearl_IAM"
  region = "eu-west-1"
}
