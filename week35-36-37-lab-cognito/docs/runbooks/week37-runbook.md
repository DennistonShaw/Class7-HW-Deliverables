# Week 37 Runbook: Cognito Token Script With SECRET_HASH

## Goal

Run the adapted Cognito token script and use the returned token to test protected API Gateway routes.

This runbook uses my existing Cognito setup:

```text
App client with client secret
SECRET_HASH required
Authenticator app MFA
SOFTWARE_TOKEN_MFA
IdToken used for API Gateway test because authorization scopes are set to none
```

---

## Files Used

```text
scripts/get-token-with-secret-hash.py
scripts/secret_hash.py
token-output-local.txt
```

`token-output-local.txt` is local-only and ignored by git.

---

## 1. Confirm Local Output File Is Ignored

Run:

```bash
git check-ignore -v token-output-local.txt
```

Expected result:

```text
.gitignore rule is shown for token-output-local.txt
```

---

## 2. Run the Token Script

Run:

```bash
python3 scripts/get-token-with-secret-hash.py
```

The script prompts for:

```text
Username
Password
App client secret
Authenticator app code
```

Do not save or commit:

```text
password
client secret
MFA code
SECRET_HASH
AccessToken
IdToken
RefreshToken
```

---

## 3. Screenshot-Safe Mode

When prompted:

```text
Save real curl commands to token-output-local.txt? Type YES only when testing locally:
```

Press Enter for screenshot-safe mode.

Expected result:

```text
AUTHENTICATION SUCCESSFUL
SAFE TOKEN SUMMARY
TOKEN EXPIRATION
API TEST COMMANDS
```

The terminal curl commands should show:

```text
<ID_TOKEN_REDACTED>
```

Screenshot proof:

```text
screenshots/week37/01-token-script-success-redacted.png
```

---

## 4. Local API Test Mode

Run the script again:

```bash
python3 scripts/get-token-with-secret-hash.py
```

When prompted:

```text
Save real curl commands to token-output-local.txt? Type YES only when testing locally:
```

Type:

```text
YES
```

This writes real curl commands to:

```text
token-output-local.txt
```

Do not screenshot, commit, or share this file.

---

## 5. Test Protected API Routes

Open the local-only file:

```bash
cat token-output-local.txt
```

Copy and run the Node curl command.

Expected result:

```text
HELLO DENNIS FROM NODE!
```

Copy and run the Python curl command.

Expected result:

```text
Hello Dennis from Python!
```

Screenshot proof:

```text
screenshots/week37/02-api-curl-success-redacted.png
```

Make sure the screenshot does not expose the real token.

---

## Final Result

```text
The adapted Python script authenticated with Cognito.
SECRET_HASH was included.
SOFTWARE_TOKEN_MFA was completed.
Cognito returned tokens.
API Gateway accepted the Cognito IdToken.
The protected Node and Python routes reached Lambda successfully.
```

## Security Checklist

Before commit or push:

```bash
git ls-files docs/notes/scratch-pad.txt token-output-local.txt
grep -RIn "eyJ\|client secret: \|Client secret: \|SECRET_HASH=.*\|RefreshToken\": \"eyJ\|AccessToken\": \"eyJ\|IdToken\": \"eyJ" README.md docs scripts screenshots 2>/dev/null
```

Expected result:

```text
No tracked scratch pad or token-output-local.txt.
No real token values found in committed files.
```
