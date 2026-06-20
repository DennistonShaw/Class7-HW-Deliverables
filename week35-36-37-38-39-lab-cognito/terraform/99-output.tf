# # old output for api.http.tf, not sure if we need to keep it around for reference

# output "api_url" {
#   value = aws_apigatewayv2_api.api.api_endpoint
# }

#####################################

output "api_url" {
  value = aws_api_gateway_stage.prod.invoke_url
}

output "python_url" {
  value = "${aws_api_gateway_stage.prod.invoke_url}/python?name=Dennis"
}

output "node_url" {
  value = "${aws_api_gateway_stage.prod.invoke_url}/node?name=Dennis"
}