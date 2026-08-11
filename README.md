# Hybrid Cloud DevOps Automation PoC

## Infrastructure Provisioning using Terraform (AWS)

This project demonstrates a Hybrid Cloud DevOps Automation Proof of Concept (PoC) developed as part of the DevOps Training Program.

The solution provisions AWS infrastructure using Terraform and will later include Linux automation, Windows automation, CI/CD, monitoring, Microsoft 365 identity integration, and security best practices.

## Project Objectives

* Provision AWS infrastructure using Terraform
* Deploy Linux and Windows servers
* Automate server configuration
* Implement CI/CD pipeline
* Configure monitoring and alerting
* Demonstrate Hybrid Cloud architecture

## Project Structure

Hybrid-Cloud-DevOps-POC/
│
├── terraform/
├── linux/
├── windows/
├── application/
├── cicd/
├── monitoring/
├── architecture/
├── documentation/
└── README.md



## Prerequisites

* AWS Account
* AWS CLI
* Terraform
* Git
* Visual Studio Code
* GitHub Account

## Deployment Steps

### Clone Repository

git clone https://github.com/ashutoshp44/Hybrid-Cloud-DevOps-POC.git

### Navigate to Terraform Folder

cd terraform

### Initialize Terraform

terraform init

### Format Configuration

terraform fmt

### Validate Configuration

terraform validate

### Review Deployment Plan

terraform plan

### Deploy Infrastructure

terraform apply

Type:

yes

after the confirmation prompt.



## AWS Resources Created

* VPC
* Public Subnet
* Internet Gateway
* Route Table
* Route Table Association
* Security Group
* Amazon Linux EC2
* Windows Server EC2

## Verification

Verify the following resources in AWS Console.

* VPC
* EC2 Instances
* Security Group
* Route Table
* Public Subnet



## Terraform Commands

terraform init

terraform fmt

terraform validate

terraform plan

terraform apply

terraform destroy

## Current Status

Completed

* Terraform Project Setup
* Networking
* Security Group
* Linux EC2
* Windows EC2 (In Progress)

Pending

* Linux Automation
* Windows Automation
* CI/CD
* Monitoring
* Security Review



## \## Task 4 – CI/CD Pipeline

## 

## \### Objective

## 

## Implemented a GitHub Actions CI/CD pipeline to automatically deploy the application from the GitHub repository to a Linux EC2 instance.

## 

## \### CI/CD Flow

## 

## GitHub Repository

## &#x20;       ↓

## GitHub Actions

## &#x20;       ↓

## SSH Connection

## &#x20;       ↓

## Linux EC2

## &#x20;       ↓

## Nginx

## &#x20;       ↓

## Application

## 

## \### GitHub Actions Workflow

## 

## The workflow is located at:

## 

## `.github/workflows/deploy.yml`

## 

## The pipeline is triggered automatically whenever code is pushed to the `main` branch.

## 

## \### Deployment Process

## 

## 1\. Checkout the application source code.

## 2\. Configure the SSH key using GitHub Secrets.

## 3\. Connect securely to the Linux EC2 instance.

## 4\. Back up the currently deployed application.

## 5\. Copy the new `index.html` to the EC2 instance.

## 6\. Deploy the application to the Nginx web root.

## 7\. Restart the Nginx service.

## 8\. Verify the application using `curl`.

## 

## \### GitHub Secrets

## 

## The following GitHub Actions secrets are configured:

## 

## \- `EC2\_SSH\_KEY` – SSH private key used for EC2 authentication.

## \- `EC2\_HOST` – Public IP address of the Linux EC2 instance.

## \- `EC2\_USERNAME` – Linux EC2 SSH username.

## 

## Sensitive credentials are stored in GitHub Secrets and are not committed to the repository.

## 

## \### Application Deployment

## 

## The application is deployed to:

## 

## `/usr/share/nginx/html/index.html`

## 

## Nginx is restarted after deployment to make the updated application available.

## 

## \### Application Verification

## 

## The deployment is verified using:

## 

## ```bash

## curl -f http://localhost/

## 

## Author

Ashutosh Pandey

DevOps Training Project

Hybrid Cloud DevOps Automation PoC

