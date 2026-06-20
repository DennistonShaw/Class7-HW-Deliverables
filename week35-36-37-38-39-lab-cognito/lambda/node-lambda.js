exports.handler = async (event) => {
    console.log("Incoming event:", JSON.stringify(event));

    const claims = event.requestContext?.authorizer?.claims || {};
    const groups = claims["cognito:groups"] || [];

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

    const response = {
        message: `HELLO ${name.toUpperCase()} FROM NODE!`,
        groups: groups
    };

    console.log("Response:", JSON.stringify(response));

    return {
        statusCode: 200,
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(response),
    };
};
