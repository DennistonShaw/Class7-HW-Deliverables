# # Archived HTTP API implementation from Week 33.
# # Commented out after discovering that Terraform WAF association
# # for this lab requires REST API Gateway resources instead of
# # aws_apigatewayv2 HTTP API resources.

# # Reference:
# # WEEK 34 CLASS 7 video ~00:09:21–00:09:47
# # Teacher explains:
# # - first API Gateway was HTTP
# # - second API Gateway was REST
# # - WAF requires REST API

# # API Gateway

# resource "aws_apigatewayv2_api" "api" {
#   name          = "week33-http-api"
#   protocol_type = "HTTP"
# }

# # Integrations

# resource "aws_apigatewayv2_integration" "python" {
#   api_id           = aws_apigatewayv2_api.api.id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.python.invoke_arn
# }

# resource "aws_apigatewayv2_integration" "node" {
#   api_id           = aws_apigatewayv2_api.api.id
#   integration_type = "AWS_PROXY"
#   integration_uri  = aws_lambda_function.node.invoke_arn
# }

# # Routes

# resource "aws_apigatewayv2_route" "python" {
#   api_id    = aws_apigatewayv2_api.api.id
#   route_key = "GET /python"
#   target    = "integrations/${aws_apigatewayv2_integration.python.id}"
# }

# resource "aws_apigatewayv2_route" "node" {
#   api_id    = aws_apigatewayv2_api.api.id
#   route_key = "GET /node"
#   target    = "integrations/${aws_apigatewayv2_integration.node.id}"
# }

# #Stage

# resource "aws_apigatewayv2_stage" "prod" {
#   api_id      = aws_apigatewayv2_api.api.id
#   name        = "prod"
#   auto_deploy = true
# }


# # Permissions

# resource "aws_lambda_permission" "api_python" {
#   statement_id  = "AllowAPIGatewayInvokePython"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.python.function_name
#   principal     = "apigateway.amazonaws.com"
# }

# resource "aws_lambda_permission" "api_node" {
#   statement_id  = "AllowAPIGatewayInvokeNode"
#   action        = "lambda:InvokeFunction"
#   function_name = aws_lambda_function.node.function_name
#   principal     = "apigateway.amazonaws.com"
# }