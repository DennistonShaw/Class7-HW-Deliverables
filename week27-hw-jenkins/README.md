# Zion class 7 - Week 27 & 28
- ### Jenkins 
- ### CI/CD Pipeline
- ### BAM Challenges

---

## Overview

Demonstrate building a CI/CD pipeline using Jenkins, GitHub, and Terraform, including plugin automation, webhook triggers, and IAM-based security.

---


## Armageddon Requirement (Primary Deliverable)

### Requirements to get paste this rubicon

* [x] Deploy an S3 bucket using Terraform  
* [x] Upload screenshots proving "THEO SAID you passed Armageddon"  
* [x] Include a repository link file (`armageddon-link.txt` or `.md`)  
* [x] Successfully trigger a Jenkins pipeline via webhook from your own GitHub repo  
* [x] Submit repository link in class chat  

---

### Implementation
* Terraform/
  * [`auth.tf`](../week27-hw-jenkins/terraform/auth.tf)
  * [`main.tf`](../week27-hw-jenkins/terraform/main.tf)
* Jenkins/
  * [`jenkins file`](../week27-hw-jenkins/jenkins/Jenkinsfile)
  * [`user data`](../week27-hw-jenkins/jenkins/v2-user-data-w-jenkins-plugins2.sh)

---

### Notes / Evidence


* [`armageddon-proof/`](https://github.com/DennistonShaw/Class7-HW-Deliverables/tree/main/week27-hw-jenkins/armageddon-proof)

This section contains proof of completing the primary lab requirement, including:
- S3-hosted artifacts
- Webhook-triggered pipeline execution
- Submission verification

---

# WEEK 27

## Homework

* [x] Rebuild the Jenkins server as an EC2 OR in a Docker image, using Java 21 instead of Java 17
  

- contained in the next section (BAM 1 challenge)

---

## BAM 1 — Plugin Automation

### Requirements

* [x] Script out adding the Jenkins plugins, so that when the server is built and ready for interaction, the necessary plugins are already installed

#### Mandatory Plugins

* [x] AWS Credentials
* [x] Pipeline: AWS steps
* [x] Terraform
* [x] Snyk
* [x] Pipeline: GCP steps
* [x] Google Cloud Platform SDK::Auth
* [x] Github integration
* [x] Github Authentication
* [x] Pipeline: Github

### Implementation

* [`v2-user-data-w-jenkins-plugins2.sh`](./jenkins/v2-user-data-w-jenkins-plugins2.sh)
* [`jenkins-plugins.txt`](./jenkins/jenkins-plugins.txt)

### Notes / Evidence

* [`docs/01-setup-jenkins.md`](./docs/01-setup-jenkins.md)
* [`Plugin Automation`](./docs/05-auto-plugin-setup-ids.md)

---

# WEEK 28

## Homework

* [x] Successfully deploy a Jenkins pipeline build using a GitHub repo in your account
* [x] Jenkinsfile must have the terraform validate, format, and destroy stages added
* [x] Show screenshots of both the successful build and the Jenkinsfile with the additional stages

---

## BAM 1 — Environment Setup

### Requirements

* [x] Modify the startup script to include terraform, AWS, and Python
* [x] Update the java version used to either Java 21 or 25
* [x] Upload a screenshot of all 4 versions (terraform, AWS, Python, Java) after connecting to the server's/container's command line
* [x] Show evidence via screenshots

### Implementation

* [`v2-user-data-w-jenkins-plugins2.sh`](./jenkins/v2-user-data-w-jenkins-plugins2.sh)

### Notes / Evidence (screenshots)

* [`Jenkins setup`](./docs/01-setup-jenkins.md)
* [`user data updates`](./jenkins/auto-plugin-setup-ids.md)
  
---

## BAM 2 — IAM Least Privilege

### Requirements

* [x] Create an IAM user with least privilege to deploy infrastructure on the pipeline  
* [x] Do your best to restrict access  
* [x] List out the IAM permissions granted  
* [x] Write out your methodology behind doing so  

---

### Implementation / Methodology / Evidence (screenshots)

* [`IAM Setup`](./docs/04-iam.md)


---

### Permissions

Current Policy:
- AdministratorAccess (AWS managed policy)

Permissions Granted:
- Full access to all AWS services and resources, including:
  - EC2 (create, modify, delete instances)
  - S3 (create buckets, read/write objects)
  - IAM (create and manage roles, users, and policies)
  - CloudWatch (logs and monitoring)
  - VPC (networking resources)
  - Any additional services used by Terraform

Scope:
- All resources ("*")

Note:
This policy was used temporarily to validate pipeline functionality and will be replaced with a least-privilege custom policy.

---

### Least-Privilege Policy (Implemented)

- S3:
  - s3:CreateBucket
  - s3:ListBucket
  - s3:GetObject
  - s3:PutObject
  - s3:DeleteObject

- EC2:
  - ec2:Describe*
  - ec2:RunInstances
  - ec2:TerminateInstances
  - ec2:CreateTags
  - ec2:DeleteTags

- IAM:
  - iam:PassRole
  - iam:GetRole

---

## BAM 3 — Jenkins Pipeline Triggers

### Requirements

* [x] Write out and define what each of the pipeline triggers does in Jenkins  
* [x] Which trigger(s) would be used when a GitHub repo is updated?  
* [x] What would be good for testing environments?  
* [x] What works better within production?  

---

### Notes

**Trigger Definitions**

* `pollSCM` → Jenkins checks the repository on a schedule and triggers a build if changes are detected  
* `webhook` → GitHub sends an event to Jenkins immediately when the repository is updated  
* `cron` → Jenkins runs the pipeline on a scheduled time whether code changed or not  
* `upstream` → Jenkins triggers this job after another Jenkins job completes  

---

**GitHub Repo Updates**

* I would use webhooks

---

**Testing Environment**

- Webhooks for real-time testing  
- Cron for scheduled test runs  
  - Cron is a scheduler on Linux systems.
  - It runs commands automatically at specific times or intervals

---

**Production Environment**

- Webhooks as the primary trigger for immediate response to approved changes  
- Upstream triggers for controlled promotion between jobs or environments  

---

