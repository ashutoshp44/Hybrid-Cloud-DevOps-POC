# Hybrid Cloud DevOps Automation PoC

## Infrastructure Provisioning using Terraform (AWS)

This project demonstrates a Hybrid Cloud DevOps Automation Proof of Concept (PoC) developed as part of the DevOps Training Program.

The solution provisions AWS infrastructure using Terraform and will later include Linux automation, Windows automation, CI/CD, monitoring, Microsoft 365 identity integration, and security best practices.

## Project Objectives

- Provision AWS infrastructure using Terraform
- Deploy Linux and Windows servers
- Automate server configuration
- Implement CI/CD pipeline
- Configure monitoring and alerting
- Demonstrate Hybrid Cloud architecture

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

- AWS Account
- AWS CLI
- Terraform
- Git
- Visual Studio Code
- GitHub Account

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

- VPC
- Public Subnet
- Internet Gateway
- Route Table
- Route Table Association
- Security Group
- Amazon Linux EC2
- Windows Server EC2

## Verification

Verify the following resources in AWS Console.

- VPC
- EC2 Instances
- Security Group
- Route Table
- Public Subnet


## Terraform Commands

terraform init

terraform fmt

terraform validate

terraform plan

terraform apply

terraform destroy

## Current Status

Completed

- Terraform Project Setup
- Networking
- Security Group
- Linux EC2
- Windows EC2 (In Progress)

Pending

- Linux Automation
- Windows Automation
- CI/CD
- Monitoring
- Security Review


## Author

Ashutosh Pandey

DevOps Training Project

Hybrid Cloud DevOps Automation PoC



