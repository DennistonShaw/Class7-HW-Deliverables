# Triggering a Webhook (End-to-End Flow)

---

## Table of Contents

- [Purpose](#purpose)

- [Steps](#steps)
  - [1. Launch Jenkins from AMI](#1-launch-jenkins-from-ami)
  - [2. Access Jenkins](#2-access-jenkins)
  - [3. Confirm IAM Configuration](#3-confirm-iam-configuration)
  - [4. Ensure Webhook is Configured](#4-ensure-webhook-is-configured)
    - [In GitHub](#in-github)
    - [In Jenkins](#in-jenkins)
  - [5. Trigger the Webhook](#5-trigger-the-webhook)

- [What Happens](#what-happens)
- [Expected Result](#expected-result)
- [Current IAM State for This Phase](#current-iam-state-for-this-phase)

<a id="table-of-contents"></a>

---

## Purpose

This section demonstrates the full CI/CD flow from infrastructure deployment to automated pipeline execution via webhook trigger.

For this stage of the assignment, the Jenkins IAM group temporarily retains `AdministratorAccess` so the pipeline can be validated end-to-end before least-privilege hardening is finalized.

---

## Steps

### 1. Launch Jenkins from AMI

- Go to AWS → EC2 → AMIs  
- Select your custom Jenkins AMI  
- Launch instance  

Ensure the security group allows:
- Port `8080` (Jenkins UI)  
- Port `22` (SSH, if needed)  

```bash
sudo systemctl status jenkins
```

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

### 2. Access Jenkins

Open browser:


http://<EC2-PUBLIC-IP>:8080


- Log in using your configured credentials  
- Verify your pipeline job exists  
- Confirm Jenkins is running normally before testing the webhook  

---

### 3. Confirm IAM Configuration

To maintain continuity with the earlier build, use the same IAM naming and configuration:

- **IAM Group:** `dennis-jenkins-test-1`
- **IAM User:** `jenkins-test-01`

For this phase, the group may still include:

- `AdministratorAccess` *(temporary, for full validation)*
- `jenkins-terraform-least-privilege` *(custom policy created for later hardening)*

**Access Key Setup**
- Create the access key under the IAM user
- Select: **Command Line Interface (CLI)**
- Add the same description format used previously, if applicable

**Important**
- Assign the IAM user to the group during creation
- Do **not** attach policies directly to the user

---

### 4. Ensure Webhook is Configured

#### In GitHub

- Go to your repository → **Settings → Webhooks**
- Confirm webhook exists:


http://<JENKINS-URL>/github-webhook/


- Confirm the webhook is set to:
  - **Just the push event**

---

#### In Jenkins

- Open your pipeline job
- Ensure the trigger is enabled:


GitHub hook trigger for GITScm polling

Pipeline
- Definition
  - Pipeline script from SCM
    - SCM
      - Git
        - Repository 
          - Repository URL (Green Code button in the root repository)
        - Script Path ie: week27-hw-jenkins/Jenkinsfile

- Apply
- Save

---

### 5. Trigger the Webhook

Run:

```bash
git commit --allow-empty -m "trigger webhook"
git push origin main
```
- this triggers the webhook without changing the code but still counts as a new commit because you can't push to github if nothings changed
- now you can

```bash
git push origin main
```

[🔝 Back to Table of Contents](#table-of-contents)

---

## What Happens

1. Code is pushed to GitHub  
2. GitHub sends a webhook (HTTP POST request)  
3. Jenkins receives the request  
4. Jenkins triggers the pipeline  
5. Terraform runs  
6. The S3 bucket is created  
7. Files from `armageddon-proof/` are uploaded into the S3 bucket  

[🔝 Back to Table of Contents](#table-of-contents)

---

## Expected Result

- Jenkins job starts automatically  
- Build appears in the Jenkins dashboard  
- Pipeline stages execute successfully  
- Terraform creates the S3 bucket  
- Files from `armageddon-proof/` appear in the S3 bucket  

**Screenshots confirm:**
- GitHub push happened  
- Jenkins triggered  
- Webhook worked  
- S3 object upload succeeded  

[🔝 Back to Table of Contents](#table-of-contents)

---

## Current IAM State for This Phase

- `AdministratorAccess` remains attached temporarily  
- Used only to ensure successful end-to-end pipeline execution  
- Will be removed after validation to enforce least privilege  

[🔝 Back to Table of Contents](#table-of-contents)

---