const { DynamoDBClient, UpdateItemCommand } = require("@aws-sdk/client-dynamodb");

const dynamodb = new DynamoDBClient({});

async function markTokenUsed(event) {
    const headers = event.headers || {};
    const tokenId = headers["x-token-id"] || headers["X-Token-Id"];

    if (!tokenId) {
        console.log("No x-token-id header provided");
        return null;
    }

    await dynamodb.send(new UpdateItemCommand({
        TableName: "token-tracking",
        Key: {
            token_id: { S: tokenId }
        },
        UpdateExpression: "SET used = :u",
        ExpressionAttributeValues: {
            ":u": { BOOL: true }
        }
    }));

    console.log(`Marked token as used: ${tokenId}`);
    return tokenId;
}

exports.handler = async (event) => {
    console.log("Incoming event:", JSON.stringify(event));

    const claims = event.requestContext?.authorizer?.claims || {};
    const rawGroups = claims["cognito:groups"] || [];
    const groups = Array.isArray(rawGroups) ? rawGroups : [rawGroups];

    const path = event.resource;
    const name = event.queryStringParameters?.name || "Unknown";

    console.log("Cognito groups:", JSON.stringify(groups));

    if (path === "/node" && !groups.includes("Admin")) {
        return {
            statusCode: 403,
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
                error: "Access denied",
                groups: groups
            })
        };
    }

    const tokenId = await markTokenUsed(event);

    const response = {
        message: `HELLO ${name.toUpperCase()} FROM NODE!`,
        groups: groups,
        token_id: tokenId
    };

    console.log("Response:", JSON.stringify(response));

    return {
        statusCode: 200,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(response),
    };
};