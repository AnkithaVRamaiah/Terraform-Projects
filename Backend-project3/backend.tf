terraform {
  backend "s3" {
    bucket         = "S3bucket" # change this
    key            = "anki/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-lock"
  }
}
