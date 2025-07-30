# Basic VPC Gateway Endpoints Example

This example demonstrates basic usage of the VPC Gateway Endpoints module with minimal configuration.

## What This Example Creates

- A VPC with CIDR block `10.0.0.0/16`
- A route table for the VPC
- S3 VPC Gateway Endpoint (enabled by default)
- DynamoDB VPC Gateway Endpoint (enabled by default)
- Route table associations for both endpoints

## Usage

1. **Initialize Terraform**:
   ```bash
   terraform init
   ```

2. **Review the plan**:
   ```bash
   terraform plan
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply
   ```

4. **View outputs**:
   ```bash
   terraform output
   ```

## Configuration

This example uses the following configuration:

```hcl
module "vpc_endpoints" {
  source = "../../"

  vpc_id          = aws_vpc.example.id
  aws_region      = "us-east-1"
  route_table_ids = [aws_route_table.example.id]

  name_prefix = "example"
  environment = "dev"

  tags = {
    Project     = "VPC-Endpoints-Demo"
    Owner       = "DevOps"
    CostCenter  = "12345"
    ManagedBy   = "Terraform"
  }
}
```

## Key Features Demonstrated

- **Default Configuration**: Both S3 and DynamoDB endpoints are created by default
- **Route Table Association**: Endpoints are automatically associated with the specified route table
- **Tagging**: Consistent tagging strategy applied to all resources
- **Output Exposure**: All important endpoint information is exposed as outputs

## Cleanup

To destroy the resources created by this example:

```bash
terraform destroy
```

## Next Steps

After running this example, you can:

1. Test connectivity to S3 and DynamoDB from within the VPC
2. Modify the configuration to add custom endpoint policies
3. Explore the advanced example for more complex configurations 