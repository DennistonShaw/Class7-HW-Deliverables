# Class 7 Zion
#### Week 30
#### Date: 03-31-2026
#### Teacher: Charles Manning
#### Topic: SYNK LAB
---

Theo spoke about over using or abusing AI

GO OVER SNYK CLASS!!!

for github actions we will have to know snyk

Class 7 (Tuesday)
Special guest Charles Manning (former student)
Topic: Snyk

# What is Snyk?

**Snyk** is a developer-focused security tool that helps you find and fix vulnerabilities in your code, dependencies, containers, and infrastructure (like Terraform or Kubernetes).

---

## What Snyk Does

Snyk acts as a **security scanner built for developers**, not just security teams.

It automatically checks your projects for known vulnerabilities and tells you:
- what’s wrong
- how serious it is
- how to fix it (often with exact code suggestions)

---

## What Snyk Scans

### 1. Dependencies

If you install packages (npm, pip, Maven, etc.), Snyk checks them against a vulnerability database.

**Example:**
- You install an outdated library
- That library has a known vulnerability
- Snyk flags it and suggests a safe version

---

### 2. Source Code (SAST)

Snyk scans your code for common security issues:
- SQL injection
- insecure authentication
- exposed secrets

---

### 3. Containers

If you are using Docker:
- Scans base images (Ubuntu, Node, etc.)
- Detects OS-level vulnerabilities

---

### 4. Infrastructure as Code (IaC)

Snyk can scan:
- Terraform
- CloudFormation
- Kubernetes

**Example:**
- Misconfigured S3 bucket
- Public access enabled unintentionally
- Snyk flags it as a security risk

---

## Why Snyk Matters

Most real-world security breaches come from:
- outdated dependencies
- misconfigured cloud resources
- exposed secrets

Snyk helps catch these issues **before deployment**.

---

## DevSecOps Context

Snyk is part of the **DevSecOps** model:

- Dev → build it
- Ops → run it
- Sec → secure it during development

---

## Summary

- Snyk = security tool for developers
- Scans code, dependencies, containers, and infrastructure
- Integrates into CI/CD pipelines
- Helps prevent vulnerabilities before production

---

## Next Steps

- Install Snyk CLI
- Connect to your GitHub repository
- Add Snyk to your Jenkins pipeline
- Scan your Terraform projects

```bash
npm install -g snyk
snyk auth
snyk test
```

---

## Spin up Jenkins

- go to manager → installed plugins
- verify Snyk Security Plugin is installed:
  - Manage Jenkins → Plugins → installed plugins → search snyk
- if not installed, install it

- go to management → tools
- scroll down to Snyk installations → click + Add Snyk

- in the dropdown type `snyk` (all lowercase)
- OS platform architecture → Linux (amd64)

- click Add Snyk again
- name: `snyk`
- OS platform → Auto-detection

- click Apply → Save

---

## Log into Snyk

- check email → search snyk
- sign in and authorize Snyk
- it will take you to your GitHub to authorize
- authorize Snyk through phone app
- it will take you back to https://app.snyk.io
- confirm GitHub is successfully connected

---

# Add Credentials

## Snyk Credentials

### Snyk API token

- go back to Jenkins
- `Manage Jenkins` → `Credentials`
- click `Global` then `Add Credential`
- select `Snyk API token`
- in the ID field type `snyk-api-token`

Get token:
- go back to Snyk
- bottom left click your name → `Account settings`
- click in the box under Key and copy the code
- save the code somewhere because we will use it more than once

Back in Jenkins:
- paste the code in the Token field
- click `Create`

### Secret text

- go back to `Add credentials`
- select `Secret text`
- in ID field type `snyk-api-token-string`
- paste code
- click `Create`

### Secret text (add another one)

- go back to `Add credentials`
- select `Secret text`
- in ID field type `snyk-org-slug`

Get it from:
- go back to Snyk
- go to `Organization` on the left side → `Settings` → `Organization ID`
- copy ID and paste it in Jenkins Secret field

- click `Create`

Note:
- Consistent naming conventions for Snyk credentials are critical in an organizational environment, where multiple integrations exist and credentials may need to be managed, rotated, or assigned across different teams, projects, or external entities.

---

## Github Credentials

### Username with password

- type in username: exact same as GitHub user name (`DennistonShaw`)
- password to GitHub:
  - user navigation window (top right icon) → `Settings`
  - scroll down to `Developer settings`

- go to `Personal access tokens` → `Tokens (classic)` → `Generate new token` → `Generate new token (classic)`
- may have to confirm access here
- in the Note field: `jenkins-github-token`
- click `Generate token`
- next screen copy the token code because once you leave the screen you can't get it back
- paste it somewhere safe

Back in Jenkins:
- paste password/token
- ID: `github-creds`
- click `Create`

---

## Jenkins file

From Aaron's repo:
- https://github.com/aaron-dm-mcdonald/new-jenkins-s3-test/blob/Charles-Snyk/Jenkinsfile

Make sure the credentials map the code.

I needed to change the 3 occurrences of:
- `aws-iam-user-creds`

to:
- `JenkinsTest`

because this was the name of my AWS credentials.

---

## Set up a New pipeline

- go to Jenkins → `+ New Item`
- enter a name: `week30-snyk`
- click `Pipeline`
- click `OK`

- scroll down to Pipeline
- under `Definition` change dropdown to `Pipeline script from SCM`
- under `SCM` change dropdown to `Git`

- Repository URL:
  ```text
  https://github.com/DennistonShaw/Class7-HW-Deliverables.git
  ```

- Branch:
  ```text
  */main
  ```

- Credentials:
  ```text
  github-creds
  ```

- Script Path:
  ```text
  week30-hw-snyk/Jenkinsfile
  ```

---

## Important Note – Running Snyk with My Own Jenkinsfile

During this lab, I ran into an issue when trying to follow Charles’s Jenkinsfile directly.

My environment is already customized from previous labs (Terraform, Jenkins setup, credentials, plugins, and AMI builds), so using Charles’s Jenkinsfile exactly as-is did not match my setup.

### Key Realization

I do not need to copy Terraform or project files into the same folder as the Jenkinsfile.

Instead, I can:

- keep my Jenkinsfile in its own folder or repository
- have Jenkins pull and scan code from other repositories or folders
- use Snyk to scan those external projects

### Example Concept

- Jenkinsfile → defines the pipeline logic
- target code → lives in another folder or repo (e.g., Terraform, Armageddon projects)

Jenkins workflow:
- load Jenkinsfile
- clone or access target repo
- run Snyk scan on that code

### Why This Matters

This approach is:
- cleaner (no duplicated files)
- more flexible (can scan multiple projects)
- closer to real-world DevOps workflows

### Decision

For this lab, I will:
- create my own Jenkinsfile
- adapt it to my environment
- use my existing Terraform projects as scan targets
- keep my pipeline self-contained and fully within my control

### Insight

- I prefer to keep my pipelines self-contained and under my control, rather than relying on external structures or assumptions
- This allows me to solve problems directly in my environment instead of working around mismatches between setups

left off at:
- https://youtu.be/jbfbPNTPZao?list=PLzfyR91ut1X3Dtxbub2F2kUuRrPK7_-Gs&t=6404

## SNYK MENTAL NOTE

- Jenkins runs a Jenkinsfile, and Snyk scans whatever files exist in the Jenkins workspace at that moment

OR

- Snyk scans what Jenkins sees

**What I'm doing in class:**
- repo has Terraform → Jenkins pulls → Snyk scans it

**What I really want Jenkins to do (future setup):**
- Jenkins pulls repo A → clones repo B → Snyk scans repo B

---

## Week 30 – Completing Jenkins + Snyk IaC Pipeline

### Objective

Successfully integrate Snyk into a Jenkins pipeline to scan Terraform (Infrastructure as Code) before running Terraform commands.

---

### Final Working Flow

- Jenkins pulls repository from GitHub
- Jenkins runs the pipeline defined in `Jenkinsfile`
- Snyk scans Terraform files for security issues
- Terraform initializes and generates a plan
- Optional manual step allows resource destruction

---

### Key Implementation Steps

- created new pipeline job in Jenkins using:
  - **Pipeline script from SCM**
  - GitHub repository as source
  - script path:
    ```text
    week30-hw-snyk/Jenkinsfile
    ```

- configured required credentials:
  - `github-creds` (GitHub access)
  - `snyk-api-token`
  - `snyk-api-token-string`
  - `snyk-org-slug`
  - `JenkinsTest` (AWS credentials)

- ensured Snyk plugin and tool configuration were set in Jenkins

---

### Critical Realizations

- **Snyk scans what Jenkins sees in the workspace**
  - correct working directory was required:
    ```text
    week30-hw-snyk/armageddon-lab-1
    ```

- Jenkins tool configuration does not guarantee CLI availability
  - direct CLI usage required adjustments

- using `npx snyk` avoids:
  - missing binary issues
  - permission errors from global npm installs

---

### Final Snyk Command Used

```bash
npx snyk auth $SNYK_TOKEN
npx snyk iac test --org=$SNYK_ORG --severity-threshold=high || true
```

---

### Key Lessons Learned

- always verify execution path inside Jenkins (`dir()` matters)
- Jenkins environment may differ from local machine (PATH issues)
- avoid assuming tools are installed — validate or install at runtime
- use `npx` to simplify CLI execution in CI environments
- keep pipelines aligned with your actual repo structure

---

### Outcome

- successfully executed a full Jenkins pipeline with:
  - Snyk IaC security scanning
  - Terraform initialization and planning
  - controlled manual destroy step

- pipeline is now fully functional and reproducible

---

## I Realized Today – Debugging Patterns

The issues I hit today were not random — they all fit into repeatable patterns.

When something breaks, ask:

### 1. Command Not Found

→ Tool missing or not in PATH  

**Fix:**
- check:
```bash
which <tool>
```
- install it OR use correct command

---

### 2. Permission Denied

→ Wrong user / install location  

**Fix:**
- don’t install globally  
- use:
```bash
npx <tool>
```

---

### 3. Works Locally, Fails in Jenkins

→ Environment mismatch  

**Fix:**
- Jenkins ≠ local machine  
- verify tools exist inside Jenkins runtime  

---

### 4. Tool Configured but Not Working

→ Config ≠ actual availability  

**Fix:**
- don’t trust config  
- test the command directly in pipeline  

---

### 5. No Results / Nothing Found

→ Wrong working directory  

**Fix:**
- check where Jenkins is running  
- use correct `dir()`  

---

### Core Rule

- Jenkins runs the pipeline  
- Snyk scans what exists in the workspace  

→ **Snyk scans what Jenkins sees**

---

### Big Takeaway

- don’t memorize tools  
- identify the pattern  
- apply the fix  

---

This is the framework I used to fix today’s pipeline.