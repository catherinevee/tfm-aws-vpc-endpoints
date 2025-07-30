# Test configuration for VPC Gateway Endpoints module

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Test VPC
resource "aws_vpc" "test" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "test-vpc"
    Environment = "test"
    Project     = "VPC-Endpoints-Test"
  }
}

# Test route table
resource "aws_route_table" "test" {
  vpc_id = aws_vpc.test.id

  tags = {
    Name        = "test-route-table"
    Environment = "test"
    Project     = "VPC-Endpoints-Test"
  }
}

# Test the module
module "vpc_endpoints" {
  source = "../"

  vpc_id          = aws_vpc.test.id
  aws_region      = "us-east-1"
  route_table_ids = [aws_route_table.test.id]

  name_prefix = "test"
  environment = "test"

  tags = {
    Project    = "VPC-Endpoints-Test"
    Owner      = "TestSuite"
    CostCenter = "99999"
    ManagedBy  = "Terraform"
  }
} 