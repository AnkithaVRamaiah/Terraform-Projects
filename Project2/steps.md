## Project Title: **Terraform-Based EC2 Instance Deployment Using Modules and Outputs**

### Overview:
This project demonstrates how to create and manage AWS resources, specifically an EC2 instance, using Terraform. We will follow best practices by separating concerns into different Terraform configuration files: `main.tf`, `variables.tf`, `terraform.tfvars`, and `outputs.tf`. Additionally, we will use modules for code reusability and outputs for easy access to critical information like the public IP of the EC2 instance.

---

### Steps to Create the Project:

#### **1. Prerequisites**
   - **IDE Setup**: Install a code editor like **Visual Studio Code (VS Code)** or use **GitHub Codespaces** for writing Terraform scripts.
   - **Install Terraform**: Download and install Terraform from its official website and ensure it's added to your system's PATH.
   - **AWS Configuration**: Configure AWS credentials using the AWS CLI by running `aws configure` with your `Access Key`, `Secret Key`, and `Region`.

---

### **2. File Structure**
Your project directory should be structured like this:
```
terraform-ec2-project/
├── main.tf
├── modules/
│   └── ec2_instance/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
```
- **`terraform-ec2-project/`**: Root directory for the Terraform configuration.
- **`main.tf`**: The root module’s entry point, calling reusable modules and defining any high-level configuration.
- **`modules/ec2_instance/`**: A subdirectory for the reusable EC2 instance module.
  - **`main.tf`**: Defines the EC2 instance resource and any related configuration.
  - **`variables.tf`**: Declares variables required by the EC2 module.
  - **`outputs.tf`**: Captures and exports outputs, like the public IP of the EC2 instance, to the root module.

---

### **3. Create the `modules/ec2_instance/` Directory**
The `modules` directory holds reusable Terraform modules. Each module should be isolated, self-contained, and reusable across multiple configurations. Here, `ec2_instance/` is the specific module for creating EC2 instances.

---

### **4. Create the `main.tf` File in the `ec2_instance` Module**
This file defines the actual AWS resources, such as the EC2 instance. It uses variables defined in `variables.tf` to make the module reusable and flexible. Ensure all resource names and dependencies are well-documented.

---

### **5. Create the `variables.tf` File in the `ec2_instance` Module**
The `variables.tf` file declares input variables for the module. For example:
- `aws_region`: The AWS region for resource creation.
- `ami_value`: The Amazon Machine Image (AMI) to use.
- `instance_type`: The EC2 instance type.
- `key_name`: The SSH key name.

This makes the module configurable from the root module or any other Terraform configuration using it.

---

### **6. Create the `outputs.tf` File in the `ec2_instance` Module**
The `outputs.tf` file exports useful values, such as:
- The public IP address of the EC2 instance (`aws_instance.EC2.public_ip`).
- The instance ID or private IP if required.

These outputs make information from the module accessible to the root module.

---

### **7. Create the `main.tf` File in the Root Module**
The root module’s `main.tf` acts as the entry point for Terraform. It:
- Specifies the AWS provider and configuration (e.g., region).
- Calls the `ec2_instance` module using the `module` block.
- Optionally defines additional outputs for reuse or display.

### Final Output:
By the end of this project, Terraform will create an EC2 instance on AWS, and you'll see the instance's public IP displayed in the terminal. You can now connect to the instance via SSH or use it for your application.  

This project not only simplifies infrastructure management but also ensures reusability and adherence to best practices for efficient cloud resource deployment.


