*Notes: Detailed class notes and troubleshooting steps can be found in `README-snyk.md`*
  
## Week 30 – Jenkins + Snyk IaC Pipeline

### Overview

This pipeline integrates security scanning into a CI/CD workflow using Jenkins and Snyk.

The goal is to automatically detect infrastructure misconfigurations in Terraform before deployment.

---

### Pipeline Flow

1. Jenkins pulls code from GitHub
2. Snyk scans Terraform files for security issues (IaC scanning)
3. Terraform initializes the infrastructure
4. Terraform generates an execution plan
5. Optional manual approval step allows destruction of resources

---

### What Snyk Scans

Snyk scans the Terraform files located in:

```
week30-hw-snyk/armageddon-lab-1
```

It checks for:

* misconfigured cloud resources
* insecure defaults (e.g. public access)
* policy violations
* known infrastructure risks

---

### Key Jenkins Stages

- **Checkout** → pulls repo into Jenkins workspace
- **Snyk IaC Scan Test** → scans Terraform for vulnerabilities
- **Snyk IaC Scan Monitor** → reports results to Snyk dashboard
- **Terraform Init** → initializes Terraform
- **Terraform Plan** → previews infrastructure changes
- **Optional Destroy** → manual approval step

---

### Key Challenges & Fixes

- Git authentication issues → resolved by using correct GitHub credentials
- Jenkins credential scope issues → fixed by creating credentials in correct context
- Snyk CLI not found → replaced with `npx snyk`
- npm permission errors → avoided global install
- Incorrect working directory → fixed with correct `dir()` path
- Tool configuration mismatch → corrected Jenkins tool naming

---

### Outcome

Successfully built a working DevSecOps pipeline that:

- integrates security into CI/CD
- scans Infrastructure as Code before deployment
- validates Terraform changes safely
- includes manual control for destructive actions

## Future Improvements

### Centralized Pipeline Architecture

A future enhancement is to separate the Jenkins pipeline from the application code into its own repository.

This would allow:

- one pipeline to scan multiple repositories  
- centralized security and CI/CD logic  
- better separation between infrastructure and pipeline design  

**Concept:**

- pipeline repo → contains Jenkinsfile  
- target repo → contains Terraform code  
- Jenkins pulls target repo and runs Snyk scans  

This approach aligns with real-world DevSecOps practices where pipelines are reusable and not tied to a single project.