# Week 27 & Week 28 Assignments

## WEEK 27 — 3/14 Assignments

### Homework
- [ ] Rebuild the Jenkins server as an EC2 OR in a Docker image, using Java 21 instead of Java 17

### Be A Man Challenge
- [ ] Script out adding the Jenkins plugins, so that when the server is built and ready for interaction, the necessary plugins are already installed

#### Mandatory Plugins
- [ ] AWS Credentials
- [ ] Pipeline: AWS steps
- [ ] Terraform
- [ ] Snyk
- [ ] Pipeline: GCP steps
- [ ] Google Cloud Platform SDK::Auth
- [ ] Github integration
- [ ] Github Authentication
- [ ] Pipeline: Github

---

## WEEK 28 — 3/17 Assignments

### Homework
- [ ] Successfully deploy a Jenkins pipeline build using a GitHub repo in your account  
- [ ] Jenkinsfile must have the terraform validate, format, and destroy stages added  
- [ ] Show screenshots of both the successful build and the Jenkinsfile with the additional stages  

---

### BAM 1
- [ ] Modify the startup script to include terraform, AWS, and Python  
- [ ] Update the java version used to either Java 21 or 25  
- [ ] Upload a screenshot of all 4 versions (terraform, AWS, Python, Java) after connecting to the server's/container's command line  
- [ ] Show evidence via screenshots  

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