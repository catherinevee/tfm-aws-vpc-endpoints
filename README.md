# AWS VPC Gateway Endpoints Terraform Module

This Terraform module creates VPC Gateway Endpoints for AWS services, specifically S3 and DynamoDB. VPC Gateway Endpoints allow you to privately connect your VPC to AWS services without requiring an internet gateway, NAT device, VPN connection, or AWS Direct Connect connection.

## Architecture

```
VPC → Gateway Endpoint → S3/DynamoDB
```

## Features

- **S3 Gateway Endpoint**: Enables private access to S3 from within your VPC
- **DynamoDB Gateway Endpoint**: Enables private access to DynamoDB from within your VPC
- **Optional Endpoint Policies**: Configure fine-grained access control for each endpoint
- **Route Table Associations**: Automatically associate endpoints with specified route tables
- **Comprehensive Tagging**: Consistent tagging strategy for resource management
- **Conditional Creation**: Enable/disable endpoints based on your requirements
- **Validation**: Input validation to prevent configuration errors

## Usage

### Basic Usage

```hcl
module "vpc_endpoints" {
  source = "./tfm-aws-vpc-endpoints"

  vpc_id          = "vpc-12345678"
  aws_region      = "us-east-1"
  route_table_ids = ["rtb-12345678", "rtb-87654321"]
  
  name_prefix = "my-app"
  environment = "prod"
  
  tags = {
    Project     = "MyProject"
    Owner       = "DevOps"
    CostCenter  = "12345"
  }
}
```

### Advanced Usage with Custom Policies

```hcl
module "vpc_endpoints" {
  source = "./tfm-aws-vpc-endpoints"

  vpc_id          = "vpc-12345678"
  aws_region      = "us-east-1"
  route_table_ids = ["rtb-12345678"]

  enable_s3_endpoint     = true
  enable_dynamodb_endpoint = true

  # Custom S3 endpoint policy
  s3_endpoint_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = [
          "arn:aws:s3:::my-bucket/*"
        ]
      }
    ]
  })

  # Custom DynamoDB endpoint policy
  dynamodb_endpoint_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem"
        ]
        Resource = [
          "arn:aws:dynamodb:us-east-1:123456789012:table/my-table"
        ]
      }
    ]
  })

  name_prefix = "secure-app"
  environment = "prod"
  
  tags = {
    Project     = "SecureApp"
    Owner       = "SecurityTeam"
    CostCenter  = "67890"
    Compliance  = "SOC2"
  }
}
```

### Selective Endpoint Creation

```hcl
module "vpc_endpoints" {
  source = "./tfm-aws-vpc-endpoints"

  vpc_id          = "vpc-12345678"
  aws_region      = "us-east-1"
  route_table_ids = ["rtb-12345678"]

  # Only create S3 endpoint
  enable_s3_endpoint     = true
  enable_dynamodb_endpoint = false

  name_prefix = "s3-only"
  environment = "dev"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_id | The ID of the VPC where the gateway endpoints will be created | `string` | n/a | yes |
| aws_region | The AWS region where the VPC endpoints will be created | `string` | `"us-east-1"` | no |
| route_table_ids | List of route table IDs to associate with the VPC endpoints | `list(string)` | `[]` | no |
| enable_s3_endpoint | Whether to create a VPC Gateway Endpoint for S3 | `bool` | `true` | no |
| enable_dynamodb_endpoint | Whether to create a VPC Gateway Endpoint for DynamoDB | `bool` | `true` | no |
| s3_endpoint_policy | A policy to attach to the S3 VPC endpoint | `string` | `null` | no |
| dynamodb_endpoint_policy | A policy to attach to the DynamoDB VPC endpoint | `string` | `null` | no |
| name_prefix | Prefix to be used for naming the VPC endpoints | `string` | `"vpc-endpoint"` | no |
| environment | Environment name for tagging purposes | `string` | `"dev"` | no |
| tags | A map of tags to assign to the VPC endpoints | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| s3_endpoint_id | The ID of the S3 VPC Gateway Endpoint |
| s3_endpoint_arn | The ARN of the S3 VPC Gateway Endpoint |
| s3_endpoint_service_name | The service name of the S3 VPC Gateway Endpoint |
| dynamodb_endpoint_id | The ID of the DynamoDB VPC Gateway Endpoint |
| dynamodb_endpoint_arn | The ARN of the DynamoDB VPC Gateway Endpoint |
| dynamodb_endpoint_service_name | The service name of the DynamoDB VPC Gateway Endpoint |
| endpoint_ids | Map of endpoint IDs by service |
| endpoint_arns | Map of endpoint ARNs by service |
| endpoint_service_names | Map of endpoint service names by service |
| route_table_associations | Map of route table associations by service |

## Examples

### Basic Example

See the `examples/basic` directory for a complete working example.

### Advanced Example

See the `examples/advanced` directory for examples with custom policies and advanced configurations.

## Best Practices

### Security

1. **Use Endpoint Policies**: Always configure endpoint policies to restrict access to only the necessary resources
2. **Principle of Least Privilege**: Grant only the minimum required permissions
3. **Regular Policy Reviews**: Periodically review and update endpoint policies

### Cost Optimization

1. **Selective Endpoint Creation**: Only create endpoints for services you actually use
2. **Monitor Usage**: Use AWS Cost Explorer to monitor endpoint usage
3. **Clean Up Unused Endpoints**: Remove endpoints that are no longer needed

### Operational Excellence

1. **Consistent Tagging**: Use consistent tagging strategy across all resources
2. **Environment Separation**: Use different configurations for different environments
3. **Documentation**: Document endpoint policies and their purposes

## Common Use Cases

### Private S3 Access

```hcl
# Enable private S3 access for application servers
module "vpc_endpoints" {
  source = "./tfm-aws-vpc-endpoints"

  vpc_id          = module.vpc.vpc_id
  route_table_ids = module.vpc.private_route_table_ids

  enable_s3_endpoint     = true
  enable_dynamodb_endpoint = false

  s3_endpoint_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "arn:aws:s3:::my-app-bucket/*"
        ]
      }
    ]
  })
}
```

### Secure DynamoDB Access

```hcl
# Enable private DynamoDB access with restricted permissions
module "vpc_endpoints" {
  source = "./tfm-aws-vpc-endpoints"

  vpc_id          = module.vpc.vpc_id
  route_table_ids = module.vpc.private_route_table_ids

  enable_s3_endpoint     = false
  enable_dynamodb_endpoint = true

  dynamodb_endpoint_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = "*"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:DeleteItem",
          "dynamodb:Query",
          "dynamodb:Scan"
        ]
        Resource = [
          "arn:aws:dynamodb:us-east-1:123456789012:table/my-app-table"
        ]
      }
    ]
  })
}
```

## Troubleshooting

### Common Issues

1. **Endpoint Not Accessible**: Ensure route tables are properly associated
2. **Policy Denied**: Check endpoint policies for correct permissions
3. **Region Mismatch**: Verify the AWS region matches your resources

### Validation Errors

The module includes comprehensive validation for:
- VPC ID format (must start with 'vpc-')
- Route table ID format (must start with 'rtb-')
- AWS region format
- JSON policy format
- Tag key length limits

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This module is licensed under the MIT License. See the LICENSE file for details.

## Support

For issues and questions:
1. Check the troubleshooting section
2. Review AWS VPC Endpoints documentation
3. Open an issue in the repository