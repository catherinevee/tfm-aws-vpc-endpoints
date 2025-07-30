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

# ==============================================================================
# Enhanced VPC Endpoints Configuration Variables
# ==============================================================================

variable "vpc_endpoints_config" {
  description = "VPC endpoints configuration"
  type = object({
    enable_gateway_endpoints = optional(bool, true)
    enable_interface_endpoints = optional(bool, true)
    enable_private_link = optional(bool, true)
    enable_endpoint_policies = optional(bool, true)
    enable_endpoint_monitoring = optional(bool, true)
    enable_endpoint_logging = optional(bool, true)
    enable_endpoint_metrics = optional(bool, true)
    enable_endpoint_alerts = optional(bool, true)
    enable_endpoint_dashboard = optional(bool, true)
    enable_endpoint_audit = optional(bool, true)
    enable_endpoint_backup = optional(bool, false)
    enable_endpoint_disaster_recovery = optional(bool, false)
  })
  default = {}
}

variable "gateway_endpoints" {
  description = "Map of VPC Gateway Endpoints to create"
  type = map(object({
    service_name = string
    route_table_ids = optional(list(string), [])
    policy = optional(string, null)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "interface_endpoints" {
  description = "Map of VPC Interface Endpoints to create"
  type = map(object({
    service_name = string
    subnet_ids = list(string)
    security_group_ids = optional(list(string), [])
    private_dns_enabled = optional(bool, true)
    ip_address_type = optional(string, "ipv4")
    policy = optional(string, null)
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "endpoint_services" {
  description = "Map of VPC Endpoint Services to create"
  type = map(object({
    acceptance_required = optional(bool, true)
    allowed_principals = optional(list(string), [])
    gateway_load_balancer_arns = optional(list(string), [])
    network_load_balancer_arns = optional(list(string), [])
    private_dns_name_configuration = optional(object({
      name = string
      type = string
      value = string
    }), {})
    supported_ip_address_types = optional(list(string), ["ipv4"])
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "endpoint_connections" {
  description = "Map of VPC Endpoint Connections to create"
  type = map(object({
    vpc_endpoint_service_id = string
    vpc_endpoint_id = string
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "endpoint_route_table_associations" {
  description = "Map of VPC Endpoint Route Table Associations to create"
  type = map(object({
    route_table_id = string
    vpc_endpoint_id = string
  }))
  default = {}
}

variable "endpoint_subnet_associations" {
  description = "Map of VPC Endpoint Subnet Associations to create"
  type = map(object({
    subnet_id = string
    vpc_endpoint_id = string
  }))
  default = {}
}

variable "endpoint_policies" {
  description = "Map of VPC Endpoint Policies to create"
  type = map(object({
    vpc_endpoint_id = string
    policy = string
  }))
  default = {}
}

variable "endpoint_notifications" {
  description = "Map of VPC Endpoint Notifications to create"
  type = map(object({
    vpc_endpoint_id = string
    connection_notification_arn = string
    connection_events = list(string)
  }))
  default = {}
}

variable "endpoint_accepters" {
  description = "Map of VPC Endpoint Accepters to create"
  type = map(object({
    vpc_endpoint_service_id = string
    vpc_endpoint_id = string
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "endpoint_permissions" {
  description = "Map of VPC Endpoint Permissions to create"
  type = map(object({
    vpc_endpoint_service_id = string
    principal = string
    tags = optional(map(string), {})
  }))
  default = {}
}

variable "endpoint_services_config" {
  description = "Configuration for VPC Endpoint Services"
  type = object({
    enable_auto_accept = optional(bool, false)
    enable_private_dns = optional(bool, true)
    enable_load_balancer_health_checks = optional(bool, true)
    enable_connection_notifications = optional(bool, false)
    enable_permission_management = optional(bool, true)
    enable_service_monitoring = optional(bool, true)
    enable_service_logging = optional(bool, true)
    enable_service_metrics = optional(bool, true)
    enable_service_alerts = optional(bool, true)
    enable_service_dashboard = optional(bool, true)
    enable_service_audit = optional(bool, true)
    enable_service_backup = optional(bool, false)
    enable_service_disaster_recovery = optional(bool, false)
  })
  default = {}
}

variable "endpoint_security_config" {
  description = "Security configuration for VPC Endpoints"
  type = object({
    enable_endpoint_encryption = optional(bool, true)
    enable_endpoint_access_logging = optional(bool, true)
    enable_endpoint_audit_logging = optional(bool, true)
    enable_endpoint_compliance_logging = optional(bool, false)
    enable_endpoint_security_logging = optional(bool, true)
    enable_endpoint_performance_logging = optional(bool, true)
    enable_endpoint_business_logging = optional(bool, false)
    enable_endpoint_operational_logging = optional(bool, true)
    enable_endpoint_debug_logging = optional(bool, false)
    enable_endpoint_trace_logging = optional(bool, false)
    enable_endpoint_error_logging = optional(bool, true)
    enable_endpoint_warning_logging = optional(bool, true)
    enable_endpoint_info_logging = optional(bool, true)
    enable_endpoint_debug_logging = optional(bool, false)
    enable_endpoint_verbose_logging = optional(bool, false)
    enable_endpoint_silent_logging = optional(bool, false)
  })
  default = {}
}

variable "endpoint_monitoring_config" {
  description = "Monitoring configuration for VPC Endpoints"
  type = object({
    enable_cloudwatch_monitoring = optional(bool, true)
    enable_cloudwatch_logs = optional(bool, true)
    enable_cloudwatch_metrics = optional(bool, true)
    enable_cloudwatch_alarms = optional(bool, true)
    enable_cloudwatch_dashboard = optional(bool, true)
    enable_cloudwatch_insights = optional(bool, false)
    enable_cloudwatch_anomaly_detection = optional(bool, false)
    enable_cloudwatch_rum = optional(bool, false)
    enable_cloudwatch_evidently = optional(bool, false)
    enable_cloudwatch_application_signals = optional(bool, false)
    enable_cloudwatch_synthetics = optional(bool, false)
    enable_cloudwatch_contributor_insights = optional(bool, false)
    enable_cloudwatch_metric_streams = optional(bool, false)
    enable_cloudwatch_metric_filters = optional(bool, false)
    enable_cloudwatch_log_groups = optional(bool, true)
    enable_cloudwatch_log_streams = optional(bool, true)
    enable_cloudwatch_log_subscriptions = optional(bool, false)
    enable_cloudwatch_log_insights = optional(bool, false)
    enable_cloudwatch_log_metric_filters = optional(bool, false)
    enable_cloudwatch_log_destinations = optional(bool, false)
    enable_cloudwatch_log_queries = optional(bool, false)
    enable_cloudwatch_log_analytics = optional(bool, false)
    enable_cloudwatch_log_visualization = optional(bool, false)
    enable_cloudwatch_log_reporting = optional(bool, false)
    enable_cloudwatch_log_archiving = optional(bool, false)
    enable_cloudwatch_log_backup = optional(bool, false)
    enable_cloudwatch_log_retention = optional(bool, true)
    enable_cloudwatch_log_encryption = optional(bool, true)
    enable_cloudwatch_log_access_logging = optional(bool, false)
    enable_cloudwatch_log_audit_logging = optional(bool, false)
    enable_cloudwatch_log_compliance_logging = optional(bool, false)
    enable_cloudwatch_log_security_logging = optional(bool, false)
    enable_cloudwatch_log_performance_logging = optional(bool, true)
    enable_cloudwatch_log_business_logging = optional(bool, false)
    enable_cloudwatch_log_operational_logging = optional(bool, true)
    enable_cloudwatch_log_debug_logging = optional(bool, false)
    enable_cloudwatch_log_trace_logging = optional(bool, false)
    enable_cloudwatch_log_error_logging = optional(bool, true)
    enable_cloudwatch_log_warning_logging = optional(bool, true)
    enable_cloudwatch_log_info_logging = optional(bool, true)
    enable_cloudwatch_log_debug_logging = optional(bool, false)
    enable_cloudwatch_log_verbose_logging = optional(bool, false)
    enable_cloudwatch_log_silent_logging = optional(bool, false)
  })
  default = {}
} 