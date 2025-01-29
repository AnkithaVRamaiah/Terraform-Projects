provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "backend" {
  instance_type = "t2.micro"
  ami = "ami-053b0d53c279acc90" # change this
}

resource "aws_s3_bucket" "s3_bucket" {
  bucket = "S3bucket" # change this
}
