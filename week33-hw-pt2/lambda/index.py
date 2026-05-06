def handler(event, context):
    name = event.get("queryStringParameters", {}).get("name", "World")

    return {
        "statusCode": 200,
        "body": f"Hello {name} from Python!"
    }