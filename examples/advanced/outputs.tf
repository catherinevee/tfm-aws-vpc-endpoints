# Outputs for Advanced VPC Gateway Endpoints Example

output "vpc_id" {
  description = "The ID of the example VPC"
  value       = aws_vpc.example.id
}

output "route_table_ids" {
  description = "The IDs of the example route tables"
  value = {
    private = aws_route_table.private.id
    data    = aws_route_table.data.id
  }
}

output "s3_bucket_name" {
  description = "The name of the example S3 bucket"
  value       = aws_s3_bucket.example.bucket
}

output "s3_bucket_arn" {
  description = "The ARN of the example S3 bucket"
  value       = aws_s3_bucket.example.arn
}

output "dynamodb_table_name" {
  description = "The name of the example DynamoDB table"
  value       = aws_dynamodb_table.example.name
}

output "dynamodb_table_arn" {
  description = "The ARN of the example DynamoDB table"
  value       = aws_dynamodb_table.example.arn
}

output "s3_endpoint_id" {
  description = "The ID of the S3 VPC Gateway Endpoint"
  value       = module.vpc_endpoints.s3_endpoint_id
}

output "s3_endpoint_arn" {
  description = "The ARN of the S3 VPC Gateway Endpoint"
  value       = module.vpc_endpoints.s3_endpoint_arn
}

output "s3_endpoint_service_name" {
  description = "The service name of the S3 VPC Gateway Endpoint"
  value       = module.vpc_endpoints.s3_endpoint_service_name
}

output "dynamodb_endpoint_id" {
  description = "The ID of the DynamoDB VPC Gateway Endpoint"
  value       = module.vpc_endpoints.dynamodb_endpoint_id
}

output "dynamodb_endpoint_arn" {
  description = "The ARN of the DynamoDB VPC Gateway Endpoint"
  value       = module.vpc_endpoints.dynamodb_endpoint_arn
}

output "dynamodb_endpoint_service_name" {
  description = "The service name of the DynamoDB VPC Gateway Endpoint"
  value       = module.vpc_endpoints.dynamodb_endpoint_service_name
}

output "endpoint_ids" {
  description = "Map of all endpoint IDs"
  value       = module.vpc_endpoints.endpoint_ids
}

output "endpoint_arns" {
  description = "Map of all endpoint ARNs"
  value       = module.vpc_endpoints.endpoint_arns
}

output "endpoint_service_names" {
  description = "Map of all endpoint service names"
  value       = module.vpc_endpoints.endpoint_service_names
}

output "route_table_associations" {
  description = "Map of route table associations by service"
  value       = module.vpc_endpoints.route_table_associations
} 