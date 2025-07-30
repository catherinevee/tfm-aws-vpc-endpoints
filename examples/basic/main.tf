# Basic VPC Gateway Endpoints Example
# This example demonstrates basic usage of the VPC Gateway Endpoints module

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
    Name        = "example-vpc"
    Environment = "dev"
    Project     = "VPC-Endpoints-Demo"
  }
}

# Create a route table for the VPC
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name        = "example-route-table"
    Environment = "dev"
    Project     = "VPC-Endpoints-Demo"
  }
}

# Use the VPC Gateway Endpoints module
module "vpc_endpoints" {
  source = "../../"

  vpc_id          = aws_vpc.example.id
  aws_region      = "us-east-1"
  route_table_ids = [aws_route_table.example.id]

  name_prefix = "example"
  environment = "dev"

  tags = {
    Project    = "VPC-Endpoints-Demo"
    Owner      = "DevOps"
    CostCenter = "12345"
    ManagedBy  = "Terraform"
  }
} 