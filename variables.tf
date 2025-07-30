# VPC Gateway Endpoints Module Variables

variable "vpc_id" {
  description = "The ID of the VPC where the gateway endpoints will be created"
  type        = string

  validation {
    condition     = can(regex("^vpc-", var.vpc_id))
    error_message = "VPC ID must be a valid VPC ID starting with 'vpc-'."
  }
}

variable "aws_region" {
  description = "The AWS region where the VPC endpoints will be created"
  type        = string
  default     = "us-east-1"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.aws_region))
    error_message = "AWS region must be a valid region identifier."
  }
}

variable "route_table_ids" {
  description = "List of route table IDs to associate with the VPC endpoints"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for rt_id in var.route_table_ids : can(regex("^rtb-", rt_id))
    ])
    error_message = "All route table IDs must be valid route table IDs starting with 'rtb-'."
  }
}

variable "enable_s3_endpoint" {
  description = "Whether to create a VPC Gateway Endpoint for S3"
  type        = bool
  default     = true
}

variable "enable_dynamodb_endpoint" {
  description = "Whether to create a VPC Gateway Endpoint for DynamoDB"
  type        = bool
  default     = true
}

variable "s3_endpoint_policy" {
  description = "A policy to attach to the S3 VPC endpoint. If not provided, the default policy allows all access"
  type        = string
  default     = null

  validation {
    condition     = var.s3_endpoint_policy == null || can(jsondecode(var.s3_endpoint_policy))
    error_message = "S3 endpoint policy must be valid JSON."
  }
}

variable "dynamodb_endpoint_policy" {
  description = "A policy to attach to the DynamoDB VPC endpoint. If not provided, the default policy allows all access"
  type        = string
  default     = null

  validation {
    condition     = var.dynamodb_endpoint_policy == null || can(jsondecode(var.dynamodb_endpoint_policy))
    error_message = "DynamoDB endpoint policy must be valid JSON."
  }
}

variable "name_prefix" {
  description = "Prefix to be used for naming the VPC endpoints"
  type        = string
  default     = "vpc-endpoint"

  validation {
    condition     = length(var.name_prefix) > 0 && length(var.name_prefix) <= 50
    error_message = "Name prefix must be between 1 and 50 characters."
  }
}

variable "environment" {
  description = "Environment name for tagging purposes"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod", "test"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod, test."
  }
}

variable "tags" {
  description = "A map of tags to assign to the VPC endpoints"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for key, value in var.tags : length(key) > 0 && length(key) <= 128
    ])
    error_message = "Tag keys must be between 1 and 128 characters."
  }
} 