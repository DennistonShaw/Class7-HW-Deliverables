# Week 35-36-37-38-39 Cognito Security Lab

This folder contains my Cognito authentication, authorization, RBAC, and security monitoring labs for Class 7.

These labs build on the earlier Lambda, API Gateway, and WAF work:

```text
Week 33: Lambda + API Gateway foundation
Week 34: REST API + WAF updates
Week 35: Cognito User Pools, MFA, JWT tokens, and API Gateway authorization
Week 36: API Gateway invocation using Cognito authorization
Week 37: Python token retrieval with SECRET_HASH
Week 38: Cognito Groups and RBAC
Week 39: Token tracking, detection, EventBridge scheduling, and CloudWatch monitoring
```

## Architecture Progression

```text
Week 33
    Lambda + API Gateway

Week 34
    WAF + REST API

Week 35
    Cognito Authentication

Week 36
    Protected API Access

Week 37
    Programmatic Token Retrieval

Week 38
    Role-Based Access Control (RBAC)

Week 39
    Token Lifecycle Monitoring
```

## Security Monitoring Flow

```text
User Login
    -> Cognito Authentication
    -> JWT Token Issued
    -> Token Tracked in DynamoDB
    -> Protected API Access
    -> Token Marked Used
    -> Unused Token Detection
    -> EventBridge Schedule
    -> CloudWatch Alert
```

## Why Week 34 Files Are Included

This repository includes the latest Lambda and Terraform files from Week 34 so the Cognito labs remain self-contained.

The Cognito labs depend on these backend Lambda functions:

```text
python-function
node-function
```

These functions are protected by:

```text
API Gateway
Cognito Authorizer
Cognito Groups
RBAC logic
```

## Technologies Used

```text
AWS Lambda
Amazon API Gateway
Amazon Cognito
Amazon DynamoDB
Amazon EventBridge Scheduler
Amazon CloudWatch
AWS IAM
Python
Node.js
Terraform
```

## Folder Structure

```text
week35-36-37-38-39-lab-cognito/
├── README.md
├── docs/
├── lambda/
├── scripts/
├── screenshots/
└── terraform/
```

## Security Note

No production secrets, tokens, or credentials are committed.

Excluded items include:

```text
Passwords
Client Secrets
SECRET_HASH values
Session tokens
AccessTokens
IdTokens
RefreshTokens
.env files
token-output-local.txt
```
