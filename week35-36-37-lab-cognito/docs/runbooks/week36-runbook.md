# Week 36 Runbook: API Gateway With Cognito Authorizer

## Goal

Use the Cognito user pool from Week 35 to protect the REST API route.

Expected behavior:

```text
No token -> Unauthorized
Valid token -> Lambda response
```

---

## Existing Resources

```text
Cognito user pool: User pool - leodko
App client: week35-cognito-app
REST API: week33-rest-api
Authorizer: dennis-authorizer
Python Lambda: python-function
Node Lambda: node-function
```

---

## 1. Confirm Backend

Confirm the Lambda functions exist:

```text
python-function
node-function
```

If they are missing, recreate them from the included Week 34 `lambda/` and `terraform/` files.

---

## 2. Confirm Authorizer

Go to:

```text
API Gateway -> APIs -> week33-rest-api -> Authorizers
```

Confirm:

```text
Authorizer name: dennis-authorizer
Authorizer type: Cognito
Cognito user pool: User pool - leodko
Token source: Authorization
Token validation: blank
```

---

## 3. Confirm Routes

Go to:

```text
API Gateway -> APIs -> week33-rest-api -> Resources
```

Check:

```text
/python -> GET -> Method request
/node -> GET -> Method request
```

Confirm:

```text
Authorization: dennis-authorizer
Authorization scopes: none
```

---

## 4. Redeploy REST API

REST API changes do not apply until the API is redeployed.

Go to:

```text
API Gateway -> week33-rest-api -> Deploy API
```

Deploy to:

```text
prod
```

---

## 5. Get Fresh IdToken

Use the Week 35 CLI authentication flow to get fresh tokens.

Save the `IdToken` locally:

```bash
id_token="<ID_TOKEN>"
```

Do not commit the token.

---

## 6. Test Without Token

Run:

```bash
curl https://828l6l66o7.execute-api.us-east-1.amazonaws.com/prod/python
```

Expected result:

```text
{"message":"Unauthorized"}
```

---

## 7. Test With Token

*This setup uses `IdToken` for the API Gateway test because the method authorization scopes are set to `none`.*

Run:

```bash
curl "https://828l6l66o7.execute-api.us-east-1.amazonaws.com/prod/python?name=Dennis" \
  -H "Authorization: $id_token"
```

Expected result:

```text
Hello Dennis from Python!
```

---

## Final Check

```text
No token -> Unauthorized
Valid token -> Hello Dennis from Python!
```