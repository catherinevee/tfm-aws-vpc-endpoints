# VPC Gateway Endpoints Module Outputs

output "s3_endpoint_id" {
  description = "The ID of the S3 VPC Gateway Endpoint"
  value       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].id : null
}

output "s3_endpoint_arn" {
  description = "The ARN of the S3 VPC Gateway Endpoint"
  value       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].arn : null
}

output "s3_endpoint_service_name" {
  description = "The service name of the S3 VPC Gateway Endpoint"
  value       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].service_name : null
}

output "dynamodb_endpoint_id" {
  description = "The ID of the DynamoDB VPC Gateway Endpoint"
  value       = var.enable_dynamodb_endpoint ? aws_vpc_endpoint.dynamodb[0].id : null
}

output "dynamodb_endpoint_arn" {
  description = "The ARN of the DynamoDB VPC Gateway Endpoint"
  value       = var.enable_dynamodb_endpoint ? aws_vpc_endpoint.dynamodb[0].arn : null
}

output "dynamodb_endpoint_service_name" {
  description = "The service name of the DynamoDB VPC Gateway Endpoint"
  value       = var.enable_dynamodb_endpoint ? aws_vpc_endpoint.dynamodb[0].service_name : null
}

output "endpoint_ids" {
  description = "Map of endpoint IDs by service"
  value = {
    s3       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].id : null
    dynamodb = var.enable_dynamodb_endpoint ? aws_vpc_endpoint.dynamodb[0].id : null
  }
}

output "endpoint_arns" {
  description = "Map of endpoint ARNs by service"
  value = {
    s3       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].arn : null
    dynamodb = var.enable_dynamodb_endpoint ? aws_vpc_endpoint.dynamodb[0].arn : null
  }
}

output "endpoint_service_names" {
  description = "Map of endpoint service names by service"
  value = {
    s3       = var.enable_s3_endpoint ? aws_vpc_endpoint.s3[0].service_name : null
    dynamodb = var.enable_dynamodb_endpoint ? aws_vpc_endpoint.dynamodb[0].service_name : null
  }
}

output "route_table_associations" {
  description = "Map of route table associations by service"
  value = {
    s3 = var.enable_s3_endpoint && length(var.route_table_ids) > 0 ? {
      for i, rt_id in var.route_table_ids : rt_id => aws_vpc_endpoint_route_table_association.s3[i].id
    } : {}
    dynamodb = var.enable_dynamodb_endpoint && length(var.route_table_ids) > 0 ? {
      for i, rt_id in var.route_table_ids : rt_id => aws_vpc_endpoint_route_table_association.dynamodb[i].id
    } : {}
  }
} 