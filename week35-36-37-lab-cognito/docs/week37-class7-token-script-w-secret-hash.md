# Week 37 Class 7: Token Script With SECRET_HASH

## Lab Goal

This lab uses a Python script to authenticate with Cognito and return tokens.

The important part of this lab is that the app client has a client secret, so the script must include `SECRET_HASH`.

Expected result:

```text
The Python script runs successfully and returns Cognito tokens.
```

## What Was Already Completed

The Cognito setup was completed in Week 35:

```text
Cognito user pool: User pool - leodko
App client: week35-cognito-app
User: dennis-cognito
MFA: Authenticator app
```

Week 36 confirmed that API Gateway accepts a valid Cognito token and allows the request to reach Lambda.

## Week 37 Focus

Week 37 focuses on scripting the token flow:

```text
Python script
  -> USER_PASSWORD_AUTH
  -> SECRET_HASH included
  -> SOFTWARE_TOKEN_MFA challenge
  -> AuthenticationResult
```