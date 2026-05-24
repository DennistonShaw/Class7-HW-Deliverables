import base64
import getpass
import hashlib
import hmac
import json
from datetime import datetime, timezone

import boto3

# =========================
# Lab Note
# =========================
#
# This script is adapted from Theo's Week 37 Cognito token script.
#
# Theo's original script assumes:
# - the app client does NOT have a client secret
# - no SECRET_HASH is required
# - MFA uses SMS_MFA
# - the script mainly prints the AccessToken
#
# My lab setup is different:
# - my app client HAS a client secret
# - Cognito requires SECRET_HASH
# - my MFA uses an authenticator app, which returns SOFTWARE_TOKEN_MFA
# - my Week 36 API Gateway test used IdToken because authorization scopes were set to none
#
# This version keeps Theo's token-retriever idea, but adapts it to my
# existing secure client-secret setup.
#
# Screenshot safety:
# - by default, this script does NOT print full AccessTokens or IdTokens
# - by default, this script prints redacted curl examples
# - only type YES at the token prompt when testing locally

# =========================
# Configuration
# =========================

APP_CLIENT_NAME = "week35-cognito-app"
CLIENT_ID = "6ucaoqbp5vt31bmm4ch663kefj"
REGION = "us-east-1"
API_BASE = "https://828l6l66o7.execute-api.us-east-1.amazonaws.com/prod"

# =========================
# Colors
# =========================

GREEN = "\033[92m"
RED = "\033[91m"
CYAN = "\033[96m"
YELLOW = "\033[93m"
RESET = "\033[0m"

# =========================
# SECRET_HASH
# =========================

def get_secret_hash(username, client_id, client_secret):
    message = username + client_id

    digest = hmac.new(
        client_secret.encode("utf-8"),
        message.encode("utf-8"),
        hashlib.sha256,
    ).digest()

    return base64.b64encode(digest).decode("utf-8")

# =========================
# JWT Decode
# =========================

def decode_jwt(token):
    try:
        payload = token.split(".")[1]
        payload += "=" * (-len(payload) % 4)
        decoded = base64.urlsafe_b64decode(payload)

        return json.loads(decoded)

    except Exception as e:
        print(f"{RED}Failed to decode JWT:{RESET} {e}")
        return None

# =========================
# Token Expiration
# =========================

def format_expiration(exp):
    exp_time = datetime.fromtimestamp(exp, tz=timezone.utc)
    now = datetime.now(timezone.utc)
    remaining = exp_time - now

    return exp_time, remaining

# =========================
# User Input
# =========================

print(f"{CYAN}")
print("========================================")
print("  COGNITO TOKEN RETRIEVER")
print("========================================")
print(f"{RESET}")

print(f"{YELLOW}IMPORTANT:{RESET} This version includes SECRET_HASH because the app client has a client secret.")
print(f"{YELLOW}SCREENSHOT SAFE:{RESET} Full tokens are hidden by default.\n")

username = input("Username: ")
password = getpass.getpass("Password: ")
client_secret = getpass.getpass("App client secret: ")

secret_hash = get_secret_hash(username, CLIENT_ID, client_secret)

# =========================
# Cognito Client
# =========================

client = boto3.client("cognito-idp", region_name=REGION)

try:
    response = client.initiate_auth(
        ClientId=CLIENT_ID,
        AuthFlow="USER_PASSWORD_AUTH",
        AuthParameters={
            "USERNAME": username,
            "PASSWORD": password,
            "SECRET_HASH": secret_hash,
        },
    )

    # =========================
    # Handle MFA Challenge
    # =========================

    if response.get("ChallengeName") == "SOFTWARE_TOKEN_MFA":
        print(f"\n{YELLOW}SOFTWARE TOKEN MFA REQUIRED{RESET}")

        code = input("Enter authenticator app code: ")

        response = client.respond_to_auth_challenge(
            ClientId=CLIENT_ID,
            ChallengeName="SOFTWARE_TOKEN_MFA",
            Session=response["Session"],
            ChallengeResponses={
                "USERNAME": username,
                "SOFTWARE_TOKEN_MFA_CODE": code,
                "SECRET_HASH": secret_hash,
            },
        )

    elif response.get("ChallengeName") == "SMS_MFA":
        print(f"\n{YELLOW}SMS MFA REQUIRED{RESET}")

        code = input("Enter SMS MFA code: ")

        response = client.respond_to_auth_challenge(
            ClientId=CLIENT_ID,
            ChallengeName="SMS_MFA",
            Session=response["Session"],
            ChallengeResponses={
                "USERNAME": username,
                "SMS_MFA_CODE": code,
                "SECRET_HASH": secret_hash,
            },
        )

    # =========================
    # Extract Tokens
    # =========================

    auth = response["AuthenticationResult"]

    access_token = auth["AccessToken"]
    id_token = auth["IdToken"]

    print(f"\n{GREEN}AUTHENTICATION SUCCESSFUL{RESET}")

    # =========================
    # Safe Token Summary
    # =========================

    decoded = decode_jwt(access_token)

    print(f"\n{CYAN}========== SAFE TOKEN SUMMARY =========={RESET}\n")

    if decoded:
        print(f"Username   : {decoded.get('username', '<not shown>')}")
        print(f"Token Use  : {decoded.get('token_use', '<not shown>')}")
        print(f"Scope      : {decoded.get('scope', '<not shown>')}")

        groups = decoded.get("cognito:groups", [])

        print(f"\n{CYAN}========== GROUP MEMBERSHIP =========={RESET}")

        if groups:
            for group in groups:
                print(f" - {group}")
        else:
            print("No groups assigned")

        exp = decoded.get("exp")

        if exp:
            exp_time, remaining = format_expiration(exp)

            print(f"\n{CYAN}========== TOKEN EXPIRATION =========={RESET}")
            print(f"Expires At (UTC): {exp_time}")
            print(f"Time Remaining : {remaining}")

    # =========================
    # Screenshot vs Local Test Note
    # =========================
    #
    # The script successfully gets real Cognito tokens after login.
    #
    # For homework screenshots, I do NOT want to print real tokens because
    # AccessTokens and IdTokens are sensitive temporary credentials.
    #
    # By default, this script prints curl commands with:
    #
    #   <ID_TOKEN_REDACTED>
    #
    # That output is safe to screenshot because it proves the script reached
    # the API test step without exposing the real token.
    #
    # If I need to actually test the API from the terminal, I can type YES
    # when the script asks whether to save real curl commands locally.
    #
    # Only type YES for local testing.
    # Do not screenshot, commit, or share token-output-local.txt when real tokens are saved.

    # =========================
    # API Test Commands
    # =========================

    print_real_tokens = input(
        f"\n{YELLOW}Save real curl commands to token-output-local.txt? Type YES only when testing locally:{RESET} "
    )

    show_real_tokens = print_real_tokens == "YES"

    terminal_authorization_value = "<ID_TOKEN_REDACTED>"
    local_file_authorization_value = id_token if show_real_tokens else "<ID_TOKEN_REDACTED>"

    python_curl_terminal = f'''curl "{API_BASE}/python?name=Dennis" \\
  -H "Authorization: {terminal_authorization_value}"
'''

    node_curl_terminal = f'''curl "{API_BASE}/node?name=Dennis" \\
  -H "Authorization: {terminal_authorization_value}"
'''

    python_curl_local_file = f'''curl "{API_BASE}/python?name=Dennis" \\
  -H "Authorization: {local_file_authorization_value}"
'''

    node_curl_local_file = f'''curl "{API_BASE}/node?name=Dennis" \\
  -H "Authorization: {local_file_authorization_value}"
'''

    output_file = "token-output-local.txt"

    local_output = f"""Week 37 Cognito Token Script Local Output

Username: {username}
App Client Name: {APP_CLIENT_NAME}
Client ID: {CLIENT_ID}
Region: {REGION}
API Base: {API_BASE}

ChallengeName: SOFTWARE_TOKEN_MFA
Authentication: successful

Token Use: {decoded.get("token_use", "<not shown>") if decoded else "<not shown>"}
Scope: {decoded.get("scope", "<not shown>") if decoded else "<not shown>"}
Groups: {", ".join(groups) if decoded and groups else "none"}
Expires At UTC: {exp_time if decoded and decoded.get("exp") else "<not shown>"}

Python curl command:
{python_curl_local_file}

Node curl command:
{node_curl_local_file}
"""

    with open(output_file, "w", encoding="utf-8") as file:
        file.write(local_output)

    print(f"\n{CYAN}========== API TEST COMMANDS =========={RESET}\n")

    print("Screenshot-safe mode: terminal token values are redacted.\n")

    print("Python Endpoint using IdToken:\n")
    print(python_curl_terminal)

    print("Node Endpoint using IdToken:\n")
    print(node_curl_terminal)

    if show_real_tokens:
        print(f"{YELLOW}WARNING:{RESET} Real curl commands were saved to {output_file}.")
        print("Do not screenshot, commit, or share that file.\n")
    else:
        print(f"Redacted local summary saved to {output_file}.\n")

    print(f"{GREEN}Done.{RESET}\n")

except Exception as e:
    print(f"\n{RED}AUTHENTICATION FAILED{RESET}\n")
    print(str(e))