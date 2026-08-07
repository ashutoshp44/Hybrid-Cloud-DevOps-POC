# Linux Server Automation

## Overview
This task demonstrates Linux server automation on an Amazon Linux EC2 instance hosted in AWS. The objective was to automate server configuration, deploy a sample web application, perform server health checks, and generate a health report.

## Environment
- Cloud Platform: AWS
- Operating System: Amazon Linux 2023
- Web Server: Nginx
- Instance Type: t3.micro
- Automation: Bash Script

## Activities Performed

### 1. Connected to Linux EC2
Connected securely to the Amazon Linux EC2 instance using SSH and an AWS key pair.

Command used:

```bash
ssh -i hybrid-cloud-key.pem ec2-user@<Linux_Public_IP>
```

### 2. Updated the Server

```bash
sudo yum update -y
```

### 3. Installed Nginx

```bash
sudo yum install nginx -y
```

### 4. Started and Enabled Nginx

```bash
sudo systemctl start nginx
sudo systemctl enable nginx
```

### 5. Verified Service Status

```bash
sudo systemctl status nginx
```

### 6. Verified Web Application
Opened the Linux EC2 public IP in a browser and confirmed that the Nginx welcome page was displayed successfully.

### 7. Created Health Check Script

Created a Bash script named:

```
health_check.sh
```

The script checks:
- CPU utilization
- Memory utilization
- Disk utilization
- Running services
- Server uptime

### 8. Executed the Script

```bash
chmod +x health_check.sh
./health_check.sh
```

### 9. Generated Health Report

The script generated a health report containing:
- CPU usage
- Memory usage
- Disk usage
- Running services
- Server uptime

## Files

```
linux/
├── scripts/
│   ├── health_check.sh
│   └── health_report.txt
├── screenshots/
└── README.md
```

## Outcome

- Successfully provisioned and configured an Amazon Linux EC2 instance.
- Deployed a sample web application using Nginx.
- Automated Linux server health monitoring with a Bash script.
- Generated a server health report for operational monitoring.