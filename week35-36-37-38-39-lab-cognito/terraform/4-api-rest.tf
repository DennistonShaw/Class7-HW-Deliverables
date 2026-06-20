# REST API Gateway

resource "aws_api_gateway_rest_api" "api" {
  name = "week33-rest-api-tf"
}

# Resources

resource "aws_api_gateway_resource" "python" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "python"
}

resource "aws_api_gateway_resource" "node" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "node"
}

# Methods

resource "aws_api_gateway_method" "python" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.python.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "node" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.node.id
  http_method   = "GET"
  authorization = "NONE"
}

# Integrations

resource "aws_api_gateway_integration" "python" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.python.id
  http_method             = aws_api_gateway_method.python.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.python.invoke_arn
}

resource "aws_api_gateway_integration" "node" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.node.id
  http_method             = aws_api_gateway_method.node.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.node.invoke_arn
}

# Deployment and Stage

resource "aws_api_gateway_deployment" "api" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_integration.python,
    aws_api_gateway_integration.node
  ]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.node.id,
      aws_api_gateway_method.node.id,
      aws_api_gateway_integration.node.id,
      aws_api_gateway_resource.python.id,
      aws_api_gateway_method.python.id,
      aws_api_gateway_integration.python.id
    ]))
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  deployment_id = aws_api_gateway_deployment.api.id
  stage_name    = "prod"
}

# Permissions

resource "aws_lambda_permission" "api_python" {
  statement_id  = "AllowAPIGatewayInvokePython"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.python.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "api_node" {
  statement_id  = "AllowAPIGatewayInvokeNode"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.node.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}