### **Steps to Create and Deploy the Project**

In this Terraform project, we will be setting up an AWS environment that consists of a Virtual Private Cloud (VPC), subnet, an EC2 instance, and a web server application running on the instance. The following are the steps to set up this environment:

---

### **1. Define AWS Provider Configuration**

The first step is to define the AWS provider configuration, which tells Terraform that we are using AWS as our cloud provider and specifies the region for the resources.

```hcl
provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}
```

- **Purpose:** This block sets the AWS region where your resources will be created.
- **Example:** `us-east-1` is the region where AWS resources will be provisioned (you can change it to any region you prefer).

---

### **2. Define a CIDR Block Variable**

We will define a CIDR (Classless Inter-Domain Routing) block for our VPC. This variable will be used to allocate the IP address range for the VPC.

```hcl
variable "cidr" {
  default = "10.0.0.0/16"  # This defines the IP range for the VPC
}
```

- **Purpose:** The CIDR block defines the IP range for our network. Here, `10.0.0.0/16` allows for 65,536 addresses within the VPC.

---

### **3. Create AWS Key Pair**

AWS EC2 instances require a key pair for SSH access. This key pair will be used to authenticate access to the EC2 instance.

```hcl
resource "aws_key_pair" "example" {
  key_name   = "terraform-demo-abhi"  # Replace with your desired key name
  public_key = file("~/.ssh/id_rsa.pub")  # Path to your public key file
}
```

- **Purpose:** This resource creates an SSH key pair on AWS so that we can SSH into the EC2 instance.
- **Note:** The `public_key` is the public key that you generate on your local machine. The corresponding private key will be used for SSH access.

---

### **4. Create AWS VPC**

Now, we will create the VPC using the CIDR block defined earlier.

```hcl
resource "aws_vpc" "myvpc" {
  cidr_block = var.cidr  # This will use the CIDR block defined in the variable
}
```

- **Purpose:** This creates a new Virtual Private Cloud (VPC) in AWS with the specified IP range.
- **Use Case:** A VPC allows you to isolate your resources within a private network on AWS.

---

### **5. Create AWS Subnet**

Next, we will create a subnet within the VPC to host the EC2 instance. Subnets are used to segment the VPC's IP address range.

```hcl
resource "aws_subnet" "sub1" {
  vpc_id                  = aws_vpc.myvpc.id
  cidr_block              = "10.0.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
}
```

- **Purpose:** This creates a subnet in the VPC with the `10.0.0.0/24` CIDR block and ensures that instances launched in this subnet receive a public IP address.
- **Use Case:** The subnet allows us to segment our VPC and isolate different resources within different IP ranges.

---

### **6. Create AWS Internet Gateway**

An Internet Gateway allows resources in your VPC to access the internet.

```hcl
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id
}
```

- **Purpose:** This creates an Internet Gateway and attaches it to the VPC so that resources within the VPC can access the internet.

---

### **7. Create AWS Route Table and Routes**

Route tables control the routing of traffic within the VPC. We will create a route table that allows internet traffic to flow through the Internet Gateway.

```hcl
resource "aws_route_table" "RT" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"  # Allow all outbound traffic
    gateway_id = aws_internet_gateway.igw.id
  }
}
```

- **Purpose:** This defines a route in the route table that directs all outbound traffic to the Internet Gateway.
- **Use Case:** With this route, instances in the subnet can access the internet.

---

### **8. Associate Route Table with Subnet**

Next, we associate the created route table with the subnet to apply the routing rules.

```hcl
resource "aws_route_table_association" "rta1" {
  subnet_id      = aws_subnet.sub1.id
  route_table_id = aws_route_table.RT.id
}
```

- **Purpose:** This ensures that the subnet uses the route table created earlier for routing traffic.

---

### **9. Create Security Group for the EC2 Instance**

Security groups act as virtual firewalls for EC2 instances, controlling inbound and outbound traffic. We will create a security group to allow SSH and HTTP traffic.

```hcl
resource "aws_security_group" "webSg" {
  name   = "web"
  vpc_id = aws_vpc.myvpc.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Web-sg"
  }
}
```

- **Purpose:** This security group allows:
  - **HTTP** traffic on port 80 from anywhere (`0.0.0.0/0`).
  - **SSH** access on port 22 from anywhere for remote login.
  - **Outbound** traffic to any destination.

---

### **10. Launch EC2 Instance**

Finally, we launch an EC2 instance within the VPC, associating it with the subnet, security group, and SSH key pair created earlier.

```hcl
resource "aws_instance" "server" {
  ami                    = "ami-0261755bbcb8c4a84"  # Replace with a valid AMI
  instance_type          = "t2.micro"
  key_name      = aws_key_pair.example.key_name
  vpc_security_group_ids = [aws_security_group.webSg.id]
  subnet_id              = aws_subnet.sub1.id

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")  # Replace with the path to your private key
    host        = self.public_ip
  }

  # File provisioner to copy a file from local to remote EC2 instance
  provisioner "file" {
    source      = "app.py"  # Replace with the path to your local file
    destination = "/home/ubuntu/app.py"  # Replace with the path on the remote instance
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Hello from the remote instance'",
      "sudo apt update -y",  # Update package lists (for ubuntu)
      "sudo apt-get install -y python3-pip",  # Example package installation
      "cd /home/ubuntu",
      "sudo pip3 install flask",
      "sudo python3 app.py &",
    ]
  }
}
```

- **Purpose:** This EC2 instance:
  - Is launched in the subnet we created.
  - Is configured with the specified security group.
  - Is provisioned with an SSH key for remote access.
  - Runs a Python application (`app.py`) after installation of required dependencies (`Flask`).

---

### **Summary**

In this Terraform script:
1. We define the **AWS provider** and the **CIDR block**.
2. We create a **key pair** for SSH access, a **VPC**, **subnet**, and an **internet gateway** for internet access.
3. We configure routing using **route tables**.
4. A **security group** is created to allow HTTP and SSH access.
5. Finally, an **EC2 instance** is provisioned and configured to run a Python application (`app.py`) after installing necessary dependencies.

By running `terraform apply`, Terraform will create all the infrastructure in AWS and configure the EC2 instance according to your specifications.
