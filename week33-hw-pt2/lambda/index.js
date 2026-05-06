exports.handler = async (event) => {
  const name = event.queryStringParameters?.name || "World";

  return {
    statusCode: 200,
    body: `HELLO ${name.toUpperCase()} FROM NODE!`
  };
};