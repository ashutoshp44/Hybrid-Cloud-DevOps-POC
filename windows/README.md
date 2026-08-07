# Windows Server Automation

## Overview
This folder contains the Windows Server automation scripts and reports developed as part of the Hybrid Cloud DevOps Automation PoC.

The objective is to automate common Windows administration tasks using PowerShell and generate a server health report.

---

## Environment

- Cloud Provider: AWS
- Operating System: Windows Server 2022 Datacenter
- Instance Type: t3.medium
- Automation Tool: PowerShell

---

## Folder Structure

```
windows/
│── README.md
│── health_check.ps1
│── health_report.txt
└── SystemEvents.txt
```

---

## Tasks Completed

- Connected to Windows EC2 using Remote Desktop (RDP)
- Verified Windows Server configuration
- Created a local user using PowerShell
- Developed a PowerShell health check script
- Generated a Windows health report
- Exported System Event Logs
- Collected execution screenshots

---

## PowerShell Commands Used

### Display System Information

```powershell
systeminfo
```

### Display Hostname

```powershell
hostname
```

### Display Current Date

```powershell
Get-Date
```

### Create Local User

```powershell
$Password = ConvertTo-SecureString "Admin@123456789Abc!" -AsPlainText -Force

New-LocalUser -Name "devopsuser" `
-Password $Password `
-FullName "DevOps User" `
-Description "User created for Hybrid Cloud DevOps PoC"
```

### Verify Local User

```powershell
Get-LocalUser
```

### Run Health Check Script

```powershell
C:\Scripts\health_check.ps1
```

### View Health Report

```powershell
Get-Content C:\Scripts\health_report.txt
```

### View System Events

```powershell
Get-Content C:\Scripts\SystemEvents.txt
```

---

## Health Check Includes

The PowerShell script collects the following information:

- Computer Name
- Operating System
- Current Date & Time
- CPU Information
- Memory Details
- Disk Usage
- Running Services
- Network Configuration
- Uptime
- Event Log Summary

---

## Generated Reports

| File | Description |
|------|-------------|
| health_report.txt | Windows server health report |
| SystemEvents.txt | Exported Windows System Event Logs |

---

## Output Location

```
C:\Scripts\
```

Generated files:

- health_report.txt
- SystemEvents.txt

---

## Screenshots

The screenshots folder contains:

- Windows RDP Login
- System Information
- Local User Creation
- Health Check Execution
- Health Report
- System Events

---

## Author

Ashutosh Pandey

Hybrid Cloud DevOps Automation PoC