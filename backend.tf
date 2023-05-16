terraform {
  backend "s3" {
    bucket  = "team-warriors-web-server-backend-state"
    key     = "team-warriors-web-server/development/terraform.tfstate"
    region  = "eu-west-1"
    encrypt = false
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
