# Test outputs for VPC Gateway Endpoints module

output "vpc_id" {
  description = "The ID of the test VPC"
  value       = aws_vpc.test.id
}

output "route_table_id" {
  description = "The ID of the test route table"
  value       = aws_route_table.test.id
}

output "s3_endpoint_id" {
  description = "The ID of the S3 VPC Gateway Endpoint"
  value       = module.vpc_endpoints.s3_endpoint_id
}

output "dynamodb_endpoint_id" {
  description = "The ID of the DynamoDB VPC Gateway Endpoint"
  value       = module.vpc_endpoints.dynamodb_endpoint_id
}

output "endpoint_ids" {
  description = "Map of all endpoint IDs"
  value       = module.vpc_endpoints.endpoint_ids
} 