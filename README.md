# ☁️ AWS Web Application | VPC • ALB • Auto Scaling • Bastion Host

A production-style, highly available web application architecture built on **Amazon Web Services (AWS)** using a custom VPC, public and private subnets, Application Load Balancer, Auto Scaling Group, NAT Gateways, and a Bastion Host.

The project deploys a simple **Tic Tac Toe web application 🎮** on EC2 instances running inside private subnets. The application is not directly exposed to the internet. Incoming HTTP traffic is handled by an **Application Load Balancer (ALB)**, which distributes requests across healthy EC2 instances.

---

## 📌 Project Overview

This project demonstrates how to design and deploy a **secure and highly available AWS web application architecture**.

### Key objectives

* Create a custom AWS VPC
* Deploy resources across **2 Availability Zones**
* Separate public and private resources using subnets
* Deploy application servers in private subnets
* Use an **Application Load Balancer** for incoming HTTP traffic
* Use an **Auto Scaling Group** for application availability
* Use **NAT Gateways** for outbound internet access from private subnets
* Use a **Bastion Host** for administrative SSH access
* Configure health checks using an ALB Target Group
* Deploy and serve a Tic Tac Toe web application using Python HTTP Server

---

## 🏗️ Architecture

```text
                              🌍 Internet
                                  │
                                  ▼
                     ┌────────────────────────┐
                     │  Application Load      │
                     │      Balancer (ALB)    │
                     │     Public Subnets     │
                     └────────────┬───────────┘
                                  │
                    ┌─────────────┴─────────────┐
                    │                           │
                    ▼                           ▼
          ┌──────────────────┐        ┌──────────────────┐
          │   EC2 Instance   │        │   EC2 Instance   │
          │   Private Subnet │        │   Private Subnet │
          │                  │        │                  │
          │   Tic Tac Toe    │        │   Tic Tac Toe    │
          │  Python Server   │        │  Python Server   │
          └──────────────────┘        └──────────────────┘
                    ▲                           ▲
                    │                           │
                    └──────── Auto Scaling ─────┘

                  🛡️ Bastion Host
                  Public Subnet
                       │
                       │ SSH
                       ▼
              Private EC2 Instances


       Private Subnets ───────► NAT Gateway ───────► Internet
```

---

## ☁️ AWS Services Used

| Service                          | Purpose                                                |
| -------------------------------- | ------------------------------------------------------ |
| 🧩 **Amazon VPC**                | Creates the isolated network environment               |
| 🌐 **Public Subnets**            | Host ALB and Bastion Host                              |
| 🔒 **Private Subnets**           | Host application EC2 instances                         |
| 🖥️ **Amazon EC2**               | Runs the web application                               |
| 📈 **Auto Scaling Group**        | Maintains the desired number of application instances  |
| ⚖️ **Application Load Balancer** | Distributes incoming HTTP traffic                      |
| 🎯 **Target Group**              | Registers EC2 instances and performs health checks     |
| 🌐 **NAT Gateway**               | Provides outbound internet access to private instances |
| 🛡️ **Bastion Host**             | Provides controlled SSH access to private instances    |
| 🔐 **Security Groups**           | Controls inbound and outbound traffic                  |
| 🐧 **Ubuntu**                    | Operating system for EC2 instances                     |
| 🐍 **Python HTTP Server**        | Serves the web application                             |
| 🎮 **HTML/CSS/JavaScript**       | Frontend Tic Tac Toe application                       |

---

# 📁 Project Structure

```text
CloudScale-WebApp/
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
```

---

# 🔐 Network Architecture

The VPC uses the following structure:

```text
VPC
│
├── Availability Zone 1
│   ├── Public Subnet
│   │   ├── Application Load Balancer
│   │   └── Bastion Host
│   │
│   └── Private Subnet
│       └── EC2 Application Server
│
└── Availability Zone 2
    ├── Public Subnet
    │   └── Application Load Balancer
    │
    └── Private Subnet
        └── EC2 Application Server
```

### VPC Configuration

* **VPC CIDR:** `10.0.0.0/16`
* **Availability Zones:** 2
* **Public Subnets:** 2
* **Private Subnets:** 2
* **NAT Gateways:** 1 per Availability Zone
* **DNS Hostnames:** Enabled
* **DNS Resolution:** Enabled

---

# 🚀 Deployment Steps

## 1️⃣ Create the VPC

Create a custom VPC with:

```text
VPC CIDR: 10.0.0.0/16
```

Create:

* 2 Public Subnets
* 2 Private Subnets
* Internet Gateway
* NAT Gateway in each Availability Zone
* Route Tables for public and private subnets

### Screenshots

```text
screenshots/01-vpc.png
screenshots/02-subnets.png
screenshots/03-nat-gateway.png
```

---

# 2️⃣ Create Security Groups

Create separate security groups for the ALB, application instances, and Bastion Host.

### ALB Security Group

Allow:

```text
Inbound:
HTTP 80 → 0.0.0.0/0
```

### Application Security Group

Allow:

```text
HTTP 80 → ALB Security Group
SSH 22  → Bastion Host Security Group
```

For production environments, SSH should be restricted as much as possible.

### Bastion Security Group

Allow:

```text
SSH 22 → Your Trusted IP
```

Avoid allowing:

```text
0.0.0.0/0
```

for SSH in a production environment.

---

# 3️⃣ Create the Launch Template

Create a Launch Template for the application EC2 instances.

Example configuration:

```text
Name: prod-example

AMI:
Ubuntu

Instance Type:
t3.micro

Key Pair:
Your EC2 Key Pair

Subnet:
Private Subnets

Security Group:
Application Security Group
```

The Launch Template is used by the Auto Scaling Group to launch application instances.

### Screenshot

```text
screenshots/04-launch-template.png
```

---

# 4️⃣ Create the Auto Scaling Group

Create an Auto Scaling Group using the Launch Template.

Example configuration:

```text
Name: Aws-prod-example

Minimum Capacity:
1

Desired Capacity:
2

Maximum Capacity:
4
```

Select both private subnets.

The Auto Scaling Group ensures that the application can maintain the desired number of instances.

### Screenshot

```text
screenshots/05-auto-scaling-group.png
```

---

# 5️⃣ Create the Bastion Host

Launch an EC2 instance in a **public subnet**.

The Bastion Host acts as a secure jump server for administrative access to private EC2 instances.

Example configuration:

```text
Subnet:
Public Subnet

Public IP:
Enabled

Security Group:
Bastion Security Group

Port:
22 / SSH
```

### Screenshot

```text
screenshots/06-bastion-host.png
```

---

# 6️⃣ Connect to Private EC2 Instances

The private EC2 instances do not have public IP addresses.

Access them through the Bastion Host.

### Connect to Bastion Host

From your local machine:

```bash
ssh -i your-key.pem ubuntu@<BASTION_PUBLIC_IP>
```

Then connect from the Bastion Host to the private EC2 instance:

```bash
ssh -i your-key.pem ubuntu@<PRIVATE_INSTANCE_IP>
```

> **Security recommendation:** In production, prefer AWS Systems Manager Session Manager or SSH agent forwarding rather than copying private key files onto the Bastion Host.

---

# 7️⃣ Deploy the Web Application

After connecting to the private EC2 instance, install the required packages.

```bash
bash scripts/install.sh
```

Copy the application files:

```text
app/index.html
```

Then start the web server:

```bash
bash scripts/start-server.sh
```

The application is served on:

```text
Port 80
```

Repeat the deployment process for the application instances as required.

### Screenshot

```text
screenshots/07-private-ec2.png
```

---

# 8️⃣ Create the Target Group

Create a Target Group for the application EC2 instances.

Example:

```text
Target Type:
Instances

Protocol:
HTTP

Port:
80

Health Check Path:
/ 
```

Register the private EC2 instances with the Target Group.

The ALB uses the Target Group health checks to determine which instances are healthy and ready to receive traffic.

### Screenshot

```text
screenshots/08-target-group.png
```

---

# 9️⃣ Create the Application Load Balancer

Create an **Internet-facing Application Load Balancer**.

Configuration:

```text
Scheme:
Internet-facing

IP Address Type:
IPv4

Subnets:
2 Public Subnets

Listener:
HTTP : 80
```

Configure the listener to forward requests to the application Target Group.

### Traffic Flow

```text
Internet
   │
   ▼
Application Load Balancer
   │
   ▼
Target Group
   │
   ├── Private EC2 Instance 1
   │
   └── Private EC2 Instance 2
```

### Screenshot

```text
screenshots/09-load-balancer.png
```

---

# 🔟 Test the Application

After configuring the ALB, copy the **DNS name** of the Load Balancer.

Open it in your browser:

```text
http://<ALB-DNS-NAME>
```

The Tic Tac Toe application should be displayed.

```text
Internet
    │
    ▼
ALB
    │
    ├────────► EC2 Instance 1
    │
    └────────► EC2 Instance 2
```

The ALB distributes incoming requests between healthy application instances.

### Screenshot

```text
screenshots/10-web-application.png
```

---

# 🎮 Application

The project includes a simple **Tic Tac Toe web application** built using frontend technologies.

The application is hosted on EC2 instances running inside private subnets.

### Application Flow

```text
User
  │
  ▼
ALB
  │
  ▼
Target Group
  │
  ├── EC2 Instance 1
  │
  └── EC2 Instance 2
```

---

# 🔒 Security Considerations

This architecture follows several important AWS security practices.

### Private Application Servers

Application EC2 instances are deployed in private subnets and do not require public IP addresses.

### ALB-Based Access

Users access the application through the Application Load Balancer rather than directly accessing EC2 instances.

### Restricted Security Groups

Application traffic should only be accepted from the ALB Security Group.

SSH access should only be allowed from the Bastion Host Security Group.

### Bastion Host

Administrative access to private instances is performed through the Bastion Host.

### NAT Gateway

Private instances can access the internet for required outbound operations without being directly reachable from the internet.

---

# 📊 Traffic Flow

```text
                    Internet
                       │
                       ▼
                ┌─────────────┐
                │     ALB     │
                │ Public Subnet
                └──────┬──────┘
                       │
                 Target Group
                  /           \
                 ▼             ▼
          Private EC2     Private EC2
                 │             │
                 └──────┬──────┘
                        │
                  NAT Gateway
                        │
                        ▼
                    Internet
```

Administrative traffic:

```text
Administrator
      │
      ▼
Bastion Host
      │
      ▼
Private EC2
```

---

# 🧪 Validation Checklist

After deployment, verify the following:

```text
✓ VPC is created
✓ Two Availability Zones are configured
✓ Public and private subnets are available
✓ NAT Gateways are operational
✓ Bastion Host is reachable
✓ Private EC2 instances are running
✓ Auto Scaling Group is healthy
✓ Target Group shows healthy targets
✓ ALB listener is configured
✓ ALB health checks are passing
✓ Web application is accessible through ALB DNS
```

---

# 🧹 Cleanup

AWS resources can generate charges, especially NAT Gateways and Load Balancers.

When the project is no longer required, delete the resources.

Recommended cleanup order:

```text
1. Application Load Balancer
2. Target Group
3. Auto Scaling Group
4. Launch Template
5. Bastion Host
6. NAT Gateways
7. Internet Gateway
8. Route Tables
9. Subnets
10. VPC
```

Always verify that resources have been terminated successfully.

---

# 💡 Key Learnings

Through this project, I gained practical experience with:

* AWS VPC architecture
* Public and private subnet design
* Multi-AZ architecture
* Application Load Balancer
* Target Groups and health checks
* EC2
* Auto Scaling Groups
* NAT Gateway
* Bastion Host
* AWS Security Groups
* Linux and SSH
* Application deployment on EC2
* High availability concepts
* Secure network architecture

---

# 🚀 Future Improvements

The architecture can be further improved by adding:

* 🔧 Terraform for Infrastructure as Code
* 🔄 Jenkins CI/CD pipeline
* 🐳 Docker containerization
* ☸️ Amazon EKS
* 📊 CloudWatch monitoring and alarms
* 🔐 AWS Systems Manager Session Manager
* 🔑 AWS Secrets Manager
* 🌐 Route 53
* 🔒 HTTPS using AWS Certificate Manager
* 🗄️ Amazon RDS for persistent data
* 📈 Dynamic Auto Scaling policies

---

# 📸 Project Screenshots

🧩 VPC




🌐 Subnets




🌐 NAT Gateway




🚀 Launch Template




📈 Auto Scaling Group




🛡️ Bastion Host




🖥️ Private EC2




🎯 Target Group




⚖️ Application Load Balancer




🎮 Web Application

# 👩‍💻 Author

## Sayali Kadwade

**Cloud & DevOps Engineer**

Interested in:

* ☁️ Cloud Computing
* 🚀 DevOps
* 🔄 CI/CD
* 🐳 Docker
* ☸️ Kubernetes
* 🏗️ Infrastructure as Code
* 🤖 Automation

---

# ⭐ Support

If you find this project useful or interesting, consider giving the repository a ⭐ on GitHub.

**Repository:**
https://github.com/sayalikadwade-18/CloudScale-WebApp
