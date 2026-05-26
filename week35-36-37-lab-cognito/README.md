# Week 35-36-37 Cognito Lab

This folder contains my Cognito lab work for Class 7.

These labs build on the earlier Lambda/API Gateway work:

```text
Week 33: Lambda + API Gateway foundation
Week 34: REST API + WAF updates
Week 35: Cognito user pool, MFA, JWT tokens, and API Gateway authorization
Week 36: API Gateway invocation using Cognito User Pool authorization
Week 37: Python token script with SECRET_HASH
```

## Why Week 34 Files Are Included

I included the latest `lambda/` and `terraform/` files from Week 34 so this folder is self-contained.

Week 34 is the most recent backend version because it includes the REST API and WAF updates.

The Cognito labs depend on these backend Lambda functions existing:

```text
python-function
node-function
```

If those functions are missing, API Gateway can return a backend error even when Cognito is working.

## Flow

```text
Client
  -> WAF
  -> API Gateway REST API
  -> Cognito Authorizer
  -> Lambda
```

![]()

## Folder Structure

```text
week35-36-37-lab-cognito/
├── README.md
├── docs/
├── lambda/
├── terraform/
├── scripts/
└── screenshots/
```

## Security Note

Did not commit real secrets or tokens.

Did not commit:

```text
passwords
client secrets
secret hashes
sessions
AccessTokens
IdTokens
RefreshTokens
```

---