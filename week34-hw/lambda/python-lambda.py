import json
from datetime import datetime, timezone

def lambda_handler(event, context):
    print("Incoming event:", json.dumps(event))

    name = event.get("queryStringParameters", {}).get("name", "Unknown")

    response = {
        "message": f"Hello {name}, Dennis, Theo, Aaron from Python!",
        "timestamp": datetime.now(timezone.utc).isoformat()
    }

    print("Response:", json.dumps(response))

    return {
        "statusCode": 200,
        "headers": {"Content-Type": "application/json"},
        "body": json.dumps(response)
    }