# Outputs for Basic VPC Gateway Endpoints Example

output "vpc_id" {
  description = "The ID of the example VPC"
  value       = aws_vpc.example.id
}

output "route_table_id" {
  description = "The ID of the example route table"
  value       = aws_route_table.example.id
}

output "s3_endpoint_id" {
  description = "The ID of the S3 VPC Gateway Endpoint"
  value       = module.vpc_endpoints.s3_endpoint_id
}

output "s3_endpoint_arn" {
  description = "The ARN of the S3 VPC Gateway Endpoint"
  value       = module.vpc_endpoints.s3_endpoint_arn
}

output "dynamodb_endpoint_id" {
  description = "The ID of the DynamoDB VPC Gateway Endpoint"
  value       = module.vpc_endpoints.dynamodb_endpoint_id
}

output "dynamodb_endpoint_arn" {
  description = "The ARN of the DynamoDB VPC Gateway Endpoint"
  value       = module.vpc_endpoints.dynamodb_endpoint_arn
}

output "endpoint_ids" {
  description = "Map of all endpoint IDs"
  value       = module.vpc_endpoints.endpoint_ids
}

output "endpoint_arns" {
  description = "Map of all endpoint ARNs"
  value       = module.vpc_endpoints.endpoint_arns
} 