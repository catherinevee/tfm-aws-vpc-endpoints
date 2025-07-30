# Advanced VPC Gateway Endpoints Example
# This example demonstrates advanced usage with custom policies and selective endpoint creation

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create a VPC for demonstration
resource "aws_vpc" "example" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "advanced-vpc"
    Environment = "prod"
    Project     = "Secure-VPC-Endpoints"
  }
}

# Create multiple route tables for different subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name        = "private-route-table"
    Environment = "prod"
    Project     = "Secure-VPC-Endpoints"
    Type        = "Private"
  }
}

resource "aws_route_table" "data" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name        = "data-route-table"
    Environment = "prod"
    Project     = "Secure-VPC-Endpoints"
    Type        = "Data"
  }
}

# Create S3 bucket for demonstration
resource "aws_s3_bucket" "example" {
  bucket = "secure-vpc-endpoints-demo-${random_string.bucket_suffix.result}"

  tags = {
    Name        = "secure-vpc-endpoints-demo"
    Environment = "prod"
    Project     = "Secure-VPC-Endpoints"
  }
}

# Create DynamoDB table for demonstration
resource "aws_dynamodb_table" "example" {
  name         = "secure-vpc-endpoints-demo"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Name        = "secure-vpc-endpoints-demo"
    Environment = "prod"
    Project     = "Secure-VPC-Endpoints"
  }
}

# Random string for unique bucket name
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Use the VPC Gateway Endpoints module with custom policies
module "vpc_endpoints" {
  source = "../../"

  vpc_id          = aws_vpc.example.id
  aws_region      = "us-east-1"
  route_table_ids = [aws_route_table.private.id, aws_route_table.data.id]

  # Enable both endpoints
  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  # Custom S3 endpoint policy - restrict access to specific bucket
  s3_endpoint_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowS3Access"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.example.arn,
          "${aws_s3_bucket.example.arn}/*"
        ]
        Condition = {
          StringEquals = {
            "aws:SourceVpc" = aws_vpc.example.id
          }
        }
      }
    ]
  })

  # Custom DynamoDB endpoint policy - restrict access to specific table
  dynamodb_endpoint_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowDynamoDBAccess"
        Effect = "Allow"
        Principal = {
          AWS = "*"
        }
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = aws_dynamodb_table.example.arn
        Condition = {
          StringEquals = {
            "aws:SourceVpc" = aws_vpc.example.id
          }
        }
      }
    ]
  })

  name_prefix = "secure"
  environment = "prod"

  tags = {
    Project    = "Secure-VPC-Endpoints"
    Owner      = "SecurityTeam"
    CostCenter = "67890"
    Compliance = "SOC2"
    DataClass  = "Confidential"
    ManagedBy  = "Terraform"
  }
} 