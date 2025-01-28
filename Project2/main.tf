provider "aws" {
}

module "ec2_instance" {
  source = "./modules/ec2_instance"
  aws_region = "us-east-1"
  ami_value = "ami-0411d0" # replace this
  instance_type_value = "t2.micro"
  key_name_value      = "xyz" # replace this/

}

output "public_ip_address" {
  description = "The public IP address of the EC2 instance"
  value       = module.ec2_instance["public-ip-address"]
}