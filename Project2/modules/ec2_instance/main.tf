provider "aws" {
region = var.region_value
  
}

resource "aws_instance" "Project2" {
 ami = var.ami_value
 instance_type = var.instance_type_value
 key_name = var.key_name_value
}