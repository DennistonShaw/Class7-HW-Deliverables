# Add GitHub Webhook Trigger to Jenkins

## Prerequisites
- Jenkins running on EC2
- Jenkins reachable from the internet (e.g. `http://<EC2-PUBLIC-IP>:8080`)
- Repo with Jenkinsfile and terraform script 
- Github and git plugins

---


## Jenkins Config

### Make a pipeline 

1. Jenkins dashboard → New Item
2. Name it
3. Select: Pipeline
4. Click OK

### Enable GitHub Trigger 

In job configuration:

- Triggers → GitHub hook trigger for GITScm polling

### Configure

- Definition: Pipeline script from SCM
- SCM: Git
- Add HTTP repo URL
- Branch:
  `*/main`
- Script Path:
  Jenkinsfile




Save pipeline

---

## Add GitHub Webhook 
Go to Github

Repository → Settings → Webhooks → Add webhook

- Payload URL:
  `http://<YOUR-JENKINS-URL>/github-webhook/`

- Content type:
  `application/json`

- Events:
  Just the push event

Save

---

## Test

Option A:
```bash
git commit --allow-empty -m "test webhook"
git push origin main
```

Option B:
- GitHub → Webhook → Recent Deliveries
- Redeliver

---





## Troubleshooting

### Expected Result
- Push event occurs on repo
- Webhook sent from GitHub
- Jenkins job starts automatically

### Common issues
Jenkins not reachable:
- Ensure public IP or DNS
- Open port 8080 in security group

Incorrect webhook URL:
- Must end with `/github-webhook/`

No build triggered:
- Verify trigger enabled in Jenkins
- Check webhook delivery status (200 OK)

## What Is Happing and How It Works

### What a Webhook Is

A webhook is an HTTP callback.

- One system sends an HTTP request to another system when an event happens
- No polling is required
- It is event-driven

In this case:
- GitHub = sender
- Jenkins = receiver

---

### What Happens Step by Step

1. You push code to GitHub
2. GitHub detects a `push` event
3. GitHub sends an HTTP POST request to:
   `http://<jenkins-url>/github-webhook/`
4. Jenkins receives the request
5. Jenkins matches the event to a configured job
6. Jenkins triggers the pipeline
7. Jenkins reads the `Jenkinsfile` from the repo
8. Pipeline runs

---

### What the Webhook Sends

GitHub sends a JSON payload that includes:

- Repository name
- Branch
- Commit ID
- Commit message
- Author

Example (simplified):

```json
{
  "ref": "refs/heads/main",
  "repository": {
    "full_name": "aaron-dm-mcdonald/new-jenkins-s3-test"
  },
  "head_commit": {
    "id": "abc123",
    "message": "update"
  }
}
```

---
# Part 1 of 2

## Set up Jenkins to expect a Webhook
The difference between the first Pipline and this is the Triggers

Go to Jenkins -> name it -> choose Pipeline

**Configure:**
- in Tiggers select GitHub hook trigger for GITcm polling
  
**Pipeline:**

- **Definition:**
  - Pipeline script from SCM
    - **SCM:**
      - git
    - **Repository URL:**
      - https://github.com/DennistonShaw/Class7-HW-Deliverables.git
    - **Brances to build:**
      - */main
    - **Script path:**
      - week27-hw-jenkins/Jenkinsfile/
- Apply
- Save

![github settings](./Screenshots/1.png)

---

# Part 2 of 2 

## Tell Github to make a Webhook when the commits happen

Go to Github -> Repository -> Settings

![github settings](./Screenshots/2.png)

![github settings](./Screenshots/3.png)

**Add Webhook** (might have to confirm access)

Payload URL:
- http://ec2-54-234-154-238.compute-1.amazonaws.com:8080/week27-hw-jenkins/Jenkinsfile/
  - http:// + URL + Port + Script Path

**Content Type**
- Application/json

`Add Webhook`

![github settings](./Screenshots/4.png)

Go back to Jenkins and Build now to send a trigger