⚙️ AWS Web Application with VPC, ALB, Auto Scaling & Bastion Host 

📌 Project Overview
This project demonstrates a highly available, production-style AWS architecture using a custom VPC, public and private subnets across two Availability Zones, a Bastion Host, an Auto Scaling Group, and an Application Load Balancer (ALB).
A simple static web application — 🎮 Tic Tac Toe — is deployed on EC2 instances running inside private subnets. The private instances do not have direct inbound internet access and are reachable through the ALB for application traffic. Administrative SSH access is performed through the Bastion Host.
🏷️ Tech & Services Used
Service
Purpose
🧩 VPC
Custom network with public and private subnets across 2 AZs
🌐 NAT Gateway
Provides outbound internet access for private subnets
🖥️ EC2 (Ubuntu)
Hosts the web application
📈 Auto Scaling Group
Maintains EC2 capacity across private subnets
🛡️ Bastion Host
Provides secure SSH access to private instances
⚖️ Application Load Balancer
Distributes HTTP traffic across healthy EC2 targets
🎯 Target Group
Performs health checks and routes traffic to EC2 instances
🐍 Python HTTP Server
Serves the static web application on port 80

🏗️ Architecture Diagram
                             🌍 Internet
                                  │
                        ┌──────────────────┐
                        │ ⚖️ Application    │
                        │   Load Balancer   │
                        │  (Public Subnets) │
                        └─────────┬─────────┘
                                  │
                  ┌───────────────┴───────────────┐
                  │                                │
         ┌────────▼────────┐              ┌────────▼────────┐
         │ 🖥️ EC2 Instance 1│              │ 🖥️ EC2 Instance 2│
         │  Private Subnet  │              │  Private Subnet  │
         │ 📈 Auto Scaling  │              │ 📈 Auto Scaling  │
         └──────────────────┘              └──────────────────┘

         🛡️ Bastion Host (Public Subnet)
                  │
                  └────── Secure SSH Access

📁 Repository Structure
aws-ha-webapp-private-subnet/
│
├── README.md
│
├── architecture/
│   └── architecture-diagram.png
│
├── app/
│   └── index.html
│
├── scripts/
│   ├── install.sh
│   └── start-server.sh
│
└── screenshots/
    ├── 01-vpc.png
    ├── 02-subnets.png
    ├── 03-nat-gateway.png
    ├── 04-launch-template.png
    ├── 05-auto-scaling-group.png
    ├── 06-bastion-host.png
    ├── 07-private-ec2.png
    ├── 08-target-group.png
    ├── 09-load-balancer.png
    └── 10-web-application.png

✅ Prerequisites
🔑 AWS account with permissions for VPC, EC2, Auto Scaling, and ELB
🗝️ Existing EC2 Key Pair (aphs.pem used in this project)
💻 Basic familiarity with AWS Console and SSH
🚀 Step-by-Step Setup
1️⃣ Create the VPC
📸 screenshots/01-vpc.png · screenshots/02-subnets.png · screenshots/03-nat-gateway.png
Name: Prod-example
CIDR: 10.0.0.0/16
2 Availability Zones
2 public subnets + 2 private subnets
NAT Gateway: 1 per AZ
DNS hostnames and DNS resolution: Enabled
2️⃣ Create a Launch Template
📸 screenshots/04-launch-template.png
Name: prod-example
AMI: Ubuntu
Instance type: t3.micro
Key pair: aphs
Security Group: Aws-prod-example
Inbound: SSH (22) from the Bastion Host/security group
Inbound: HTTP (80) from the ALB security group
Outbound: Required application/internet traffic
3️⃣ Create the Auto Scaling Group
📸 screenshots/05-auto-scaling-group.png
Name: Aws-prod-example
Subnets: 2 private subnets
Desired capacity: 2
Minimum capacity: 1
Maximum capacity: 4
Scaling policy: None
4️⃣ Launch the Bastion Host
📸 screenshots/06-bastion-host.png
Launch 1 EC2 instance in a public subnet
Key pair: aphs
Auto-assign public IP: Enabled
Security group: Allow inbound SSH (22) only from your trusted IP address
5️⃣ Deploy the Application on Private Instances
📸 screenshots/07-private-ec2.png
# Copy the key from the local machine to the Bastion Host
scp -i aphs.pem aphs.pem ubuntu@<bastion-public-ip>:/home/ubuntu/

# On the Bastion Host
chmod 400 aphs.pem

# Connect to the private EC2 instance
ssh -i aphs.pem ubuntu@<private-instance-ip>

# On the private EC2 instance
bash scripts/install.sh

# Copy/paste the application into index.html
vi index.html

# Start the web server
bash scripts/start-server.sh

Repeat the deployment for the required private EC2 instances.
Production note: For a production environment, avoid copying private key files to the Bastion Host. Prefer AWS Systems Manager Session Manager or secure SSH agent forwarding.
6️⃣ Create the Target Group
📸 screenshots/08-target-group.png
Name: Prod-Ex
Target type: Instances
Protocol: HTTP
Port: 80
Health check path: /
Register the private EC2 instances as targets
7️⃣ Create the Application Load Balancer
📸 screenshots/09-load-balancer.png
Name: aws-prod-ex
Scheme: Internet-facing
IP address type: IPv4
Subnets: 2 public subnets
Security Group: Allow inbound HTTP (80)
Listener: HTTP : 80
Forward traffic to the Prod-Ex Target Group
8️⃣ Test the Application
📸 screenshots/10-web-application.png
Open the ALB DNS name in a web browser.
The Application Load Balancer distributes incoming traffic across healthy EC2 instances running the Tic Tac Toe application in private subnets. 🎉
🔐 Security Notes
🚫 Private EC2 instances do not accept direct inbound internet traffic.
⚖️ Application traffic reaches private instances through the ALB.
🛡️ Administrative SSH access is provided through the Bastion Host.
🔒 Restrict SSH access to trusted IP addresses or security groups.
🔄 In production, prefer AWS Systems Manager Session Manager instead of copying .pem files to the Bastion Host.
🌐 NAT Gateways provide outbound internet connectivity for private instances when required.
🧹 Cleanup
To avoid unnecessary AWS charges, delete the resources after completing the project.
Recommended cleanup order:
Load Balancer
      ↓
Target Group
      ↓
Auto Scaling Group
      ↓
Launch Template
      ↓
NAT Gateways
      ↓
Bastion Host
      ↓
VPC and associated resources

👤 Author
Sayali Kadwade
🚀 Cloud & DevOps Engineer
☁️ AWS | Docker | Jenkins | Terraform | Ansible
🐧 Linux | Git | GitHub | Python

