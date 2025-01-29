variable "aws_region" {
    description = "The AWS region where the resources will be created"
}

variable "ami_value" {
  description = "AMI ID for the EC2 instance"
}

variable "instance_type_value"{
    description = "Type of EC2 instance"  
}

variable "key_name_value" {
    description = "Name of the key pair for accessing the instance"  
}