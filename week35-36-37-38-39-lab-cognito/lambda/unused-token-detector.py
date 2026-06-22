from datetime import datetime, timedelta, timezone

import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table("token-tracking")


def handler(event, context):
    response = table.scan()
    alerts = []

    for item in response["Items"]:
        if item.get("used") is False:
            issued = datetime.fromisoformat(item["issued_at"])

            if issued.tzinfo is None:
                issued = issued.replace(tzinfo=timezone.utc)

            if datetime.now(timezone.utc) - issued > timedelta(minutes=10):
                alert = f"ALERT: Token unused for user {item['username']}"
                print(alert)
                alerts.append(alert)

    return {
        "alerts": alerts,
        "count": len(alerts)
    }