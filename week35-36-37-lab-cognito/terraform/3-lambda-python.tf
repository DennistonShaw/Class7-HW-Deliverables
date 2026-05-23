resource "aws_lambda_function" "python" {
  function_name = "python-function"
  role          = aws_iam_role.week33_lambda_role.arn
  handler       = "index.handler"
  runtime       = "python3.11"

  filename = "../lambda/python.zip"
  source_code_hash = filebase64sha256("../lambda/python.zip")
}

# zip python.zip index.py