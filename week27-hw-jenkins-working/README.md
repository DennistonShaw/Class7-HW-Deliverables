# Week 27 & Week 28 Assignments

## WEEK 27 — 3/14 Assignments

### Homework
- [x] Rebuild the Jenkins server as an EC2 OR in a Docker image, using Java 21 instead of Java 17

### BAM 1
- [x] Script out adding the Jenkins plugins, so that when the server is built and ready for interaction, the necessary plugins are already installed

#### Mandatory Plugins
- [x] AWS Credentials
- [x] Pipeline: AWS steps
- [x] Terraform
- [x] Snyk
- [x] Pipeline: GCP steps
- [x] Google Cloud Platform SDK::Auth
- [x] Github integration
- [x] Github Authentication
- [x] Pipeline: Github

---

## WEEK 28 — 3/17 Assignments

### Homework
- [x] Successfully deploy a Jenkins pipeline build using a GitHub repo in your account  
- [x] Jenkinsfile must have the terraform validate, format, and destroy stages added  
- [x] Show screenshots of both the successful build and the Jenkinsfile with the additional stages  

---

### BAM 1
- [x] Modify the startup script to include terraform, AWS, and Python  
- [x] Update the java version used to either Java 21 or 25  
- [x] Upload a screenshot of all 4 versions (terraform, AWS, Python, Java) after connecting to the server's/container's command line  
- [x] Show evidence via screenshots  

---

### BAM 2
- [ ] Create an IAM user with least privilege to deploy infrastructure on the pipeline  
- [ ] Do your best to restrict access  
- [ ] List out the IAM permissions granted  
- [ ] Write out your methodology behind doing so  

---

### BAM 3
- [ ] Write out and define what each of the pipeline triggers does in Jenkins  
- [ ] Which trigger(s) would be used when a GitHub repo is updated?  
- [ ] What would be good for testing environments?  
- [ ] What works better within production?  