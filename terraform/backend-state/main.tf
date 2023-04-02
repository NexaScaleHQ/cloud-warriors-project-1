provider "aws" {
  region     = "eu-west"
  access_key = var.aws_access_key 
  secret_key = var.aws_secret_key 
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "nginx-web-server-backend-state"

  # lifecycle {
  #   prevent_destroy = true
  # }

  versioning {
    enabled = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"       
      }
    }
  }
}
