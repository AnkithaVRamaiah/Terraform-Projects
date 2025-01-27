provider "aws"{
region = "us-east-1"  # Replace with your desired region
}

resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-04b4f1a9cf54c11d0"  # This is an example AMI ID (Amazon Machine Image) for an EC2 instance
  instance_type = "t2.micro"               # This is the type of EC2 instance (t2.micro is part of the free tier)

  key_name = "har"  # This associates the SSH key with the EC2 instance

  # Add tags for identification
  tags = {
    Name = "MyEC2Instance"
  }
}