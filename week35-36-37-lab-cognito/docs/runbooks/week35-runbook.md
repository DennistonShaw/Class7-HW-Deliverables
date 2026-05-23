# Week 35 Runbook: Cognito Token Authentication

## Goal

Create a Cognito user pool, authenticate a user with MFA, and get JWT tokens.

Expected result:

```text
Cognito returns AuthenticationResult with AccessToken, IdToken, and RefreshToken.
```

---

## Existing Backend

This lab uses the REST API and Lambda backend from the earlier Lambda/API Gateway labs.

Backend functions:

```text
python-function
node-function
```

REST API:

```text
week33-rest-api
```

---

## 1. Create Cognito User Pool

Go to:

```text
Cognito -> User pools -> Create user pool
```

Use:

```text
Application type: Traditional web application
Application name: week35-cognito-app
Sign-in options: Username, Email
Self-registration: enabled
Required attributes: email
Return URL: http://localhost:8080
```

Click:

```text
Create user directory
```

---

## 2. Create User Through Hosted Login Page

Open:

```text
Applications -> App clients -> week35-cognito-app -> View login page
```

Click:

```text
Sign up
```

Create the test user:

```text
Username: dennis-cognito
Email: <your-real-email>
Password: <your-password>
```

Check email for the verification code.

Enter the verification code.

Expected result:

```text
User is confirmed.
Cognito redirects to http://localhost:8080.
```

If nginx appears, the redirect worked.

---

## 3. Require MFA

Go to:

```text
Cognito -> User pools -> User pool - leodko -> Sign-in
```

Edit:

```text
Multi-factor authentication
```

Set:

```text
MFA enforcement: Require MFA
MFA method: Authenticator apps
```

Save changes.

---

## 4. Set Up Authenticator App

Open the hosted login page again:

```text
Applications -> App clients -> week35-cognito-app -> View login page
```

Sign in:

```text
Username: dennis-cognito
Password: <your-password>
```

When Cognito prompts for MFA setup:

```text
Scan QR code with authenticator app
Enter 6-digit code
Complete sign-in
```

Expected result:

```text
Sign-in succeeds and redirects to http://localhost:8080.
```

---

## 5. Confirm App Client Settings

Open:

```text
Cognito -> User pools -> User pool - leodko -> Applications -> App clients -> week35-cognito-app
```

Copy locally:

```text
Client ID
Client secret
```

Do not commit the real client secret.

Edit app client settings and confirm:

```text
ALLOW_USER_PASSWORD_AUTH
ALLOW_REFRESH_TOKEN_AUTH
Authentication flow session duration: 15 minutes
```

---

## 6. Set Terminal Variables

In terminal:

```bash
cognito_username="dennis-cognito"
password="<your-password>"
client_id="<CLIENT_ID>"
client_secret="<CLIENT_SECRET>"
region="us-east-1"
```

Confirm safe values:

```bash
echo "$cognito_username"
echo "$client_id"
echo "$region"
echo ${#password}
echo ${#client_secret}
```

Do not echo the actual password or client secret.

---

## 7. Generate SECRET_HASH

Run:

```bash
secret_hash=$(python3 secret_hash.py "$cognito_username" "$client_id" "$client_secret")
echo ${#secret_hash}
```

Expected result:

```text
44
```

---

## 8. Start Authentication

Run:

```bash
aws cognito-idp initiate-auth \
  --region "$region" \
  --auth-flow USER_PASSWORD_AUTH \
  --client-id "$client_id" \
  --auth-parameters USERNAME="$cognito_username",PASSWORD="$password",SECRET_HASH="$secret_hash"
```

Expected result:

```text
SOFTWARE_TOKEN_MFA
```

Copy the returned `Session`.

Set:

```bash
session="<SESSION_TOKEN>"
```

Confirm:

```bash
echo ${#session}
```

Expected result:

```text
A number greater than 20
```

---

## 9. Respond to MFA Challenge

Get the current 6-digit code from the authenticator app.

Set:

```bash
mfa_code="<AUTHENTICATOR_APP_CODE>"
```

Run:

```bash
aws cognito-idp respond-to-auth-challenge \
  --region "$region" \
  --client-id "$client_id" \
  --challenge-name SOFTWARE_TOKEN_MFA \
  --challenge-responses USERNAME="$cognito_username",SOFTWARE_TOKEN_MFA_CODE="$mfa_code",SECRET_HASH="$secret_hash" \
  --session "$session"
```

Expected result:

```text
AuthenticationResult
```

---

## 10. Save Tokens Locally

Save tokens locally:

```bash
access_token="<ACCESS_TOKEN>"
id_token="<ID_TOKEN>"
```

Confirm without exposing them:

```bash
echo ${#access_token}
echo ${#id_token}
```

Expected result:

```text
Large numbers
```

---

## Final Check

```text
Cognito returned AuthenticationResult.
Tokens were generated successfully.
```

Do not commit:

```text
passwords
client secrets
secret hashes
sessions
AccessTokens
IdTokens
RefreshTokens
```