#create s3

terraform {
  backend "s3" {
    bucket = "s3statebackend1-gthri"
    key = "state"
    region = "us-east-1"
    dynamodb_table = "state-lock"
  }
}








resource "aws_s3_bucket" "mybucket" {
  bucket = "s3statebackend1-gthri"
  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
        
      }
    }
  }
}

#create dynamodb
resource "aws_dynamodb_table" "statelock" {
  name = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
