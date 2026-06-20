resource "aws_lambda_function" "node" {
  function_name = "node-function"
  role          = aws_iam_role.week33_lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs18.x"

  filename = "../lambda/node.zip"
  source_code_hash = filebase64sha256("../lambda/node.zip")
}

# zip node.zip index.js