To configure AWS CLI using AWS access keys and set up the environment for working with AWS services, follow these steps:

1. **Generate Access Key and Secret Key in AWS Account:**
   - Log in to your AWS account.
   - Navigate to the **Security Credentials**.
   - In the **Access keys** section, click **Create New Access Key**.
   - Note down the **Access Key ID** and **Secret Access Key** (you can download the key file, but keep it secure).

2. **Configure AWS CLI on AWS2 Workspace:**
   - Open your AWS2 Workspace or any integrated code editor like **VS Code** or **GitHub Codespaces**.
   - Open the terminal or command prompt within the workspace.
   - Run the following command:
     ```
     aws configure
     ```
   - Enter the following when prompted:
     - **AWS Access Key ID**: Enter the Access Key ID you generated.
     - **AWS Secret Access Key**: Enter the Secret Access Key you generated.
     - **Default region name** (optional): Enter the AWS region you want to set as default (e.g., `us-east-1`).
     - **Default output format** (optional): Enter the output format, such as `json`, `text`, or `table` (e.g., `json`).

3. **Verify AWS Configuration:**
   To verify that AWS CLI is properly configured, you can check EC2 resources by running the following command:
   ```
   aws ec2 describe-instances
   ```
   This will list the EC2 instances in the configured region.

