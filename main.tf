# VPC Gateway Endpoints Module
# This module creates VPC Gateway Endpoints for S3 and DynamoDB services

# VPC Gateway Endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  count = var.enable_s3_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = merge(
    {
      Name        = "${var.name_prefix}-s3-endpoint"
      Environment = var.environment
      Service     = "S3"
      Type        = "Gateway"
    },
    var.tags
  )
}

# VPC Gateway Endpoint for DynamoDB
resource "aws_vpc_endpoint" "dynamodb" {
  count = var.enable_dynamodb_endpoint ? 1 : 0

  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.aws_region}.dynamodb"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = var.route_table_ids

  tags = merge(
    {
      Name        = "${var.name_prefix}-dynamodb-endpoint"
      Environment = var.environment
      Service     = "DynamoDB"
      Type        = "Gateway"
    },
    var.tags
  )
}

# VPC Endpoint Policy for S3 (optional)
resource "aws_vpc_endpoint_policy" "s3" {
  count = var.enable_s3_endpoint && var.s3_endpoint_policy != null ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  policy          = var.s3_endpoint_policy
}

# VPC Endpoint Policy for DynamoDB (optional)
resource "aws_vpc_endpoint_policy" "dynamodb" {
  count = var.enable_dynamodb_endpoint && var.dynamodb_endpoint_policy != null ? 1 : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  policy          = var.dynamodb_endpoint_policy
}

# Route table associations for S3 endpoint
resource "aws_vpc_endpoint_route_table_association" "s3" {
  count = var.enable_s3_endpoint && length(var.route_table_ids) > 0 ? length(var.route_table_ids) : 0

  vpc_endpoint_id = aws_vpc_endpoint.s3[0].id
  route_table_id  = var.route_table_ids[count.index]
}

# Route table associations for DynamoDB endpoint
resource "aws_vpc_endpoint_route_table_association" "dynamodb" {
  count = var.enable_dynamodb_endpoint && length(var.route_table_ids) > 0 ? length(var.route_table_ids) : 0

  vpc_endpoint_id = aws_vpc_endpoint.dynamodb[0].id
  route_table_id  = var.route_table_ids[count.index]
} 