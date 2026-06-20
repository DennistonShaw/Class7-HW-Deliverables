import json

def handler(event, context):
    claims = event.get("requestContext", {}).get("authorizer", {}).get("claims", {})
    groups = claims.get("cognito:groups", [])

    route_path = (
        event.get("resource")
        or event.get("path")
        or event.get("rawPath")
        or event.get("requestContext", {}).get("resourcePath")
        or ""
    )

    name = event.get("queryStringParameters", {}).get("name", "World")

    if "/python" in route_path and "General" not in groups:
        return {
            "statusCode": 403,
            "body": json.dumps({
                "error": "Access denied",
                "groups": groups
            })
        }

    return {
        "statusCode": 200,
        "body": json.dumps({
            "message": f"Hello {name} from Python!",
            "groups": groups
        })
    }