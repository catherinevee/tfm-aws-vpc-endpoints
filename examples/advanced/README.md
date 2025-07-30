# Advanced VPC Gateway Endpoints Example

This example demonstrates advanced usage of the VPC Gateway Endpoints module with custom policies, multiple route tables, and security best practices.

## What This Example Creates

- A VPC with CIDR block `10.0.0.0/16`
- Two route tables (private and data)
- S3 bucket for demonstration
- DynamoDB table for demonstration
- S3 VPC Gateway Endpoint with custom policy
- DynamoDB VPC Gateway Endpoint with custom policy
- Route table associations for both endpoints

## Security Features

### Custom Endpoint Policies

This example implements restrictive endpoint policies that:

1. **S3 Endpoint Policy**:
   - Restricts access to a specific S3 bucket only
   - Allows only specific S3 actions (GetObject, PutObject, DeleteObject, ListBucket)
   - Requires requests to originate from the VPC (aws:SourceVpc condition)

2. **DynamoDB Endpoint Policy**:
   - Restricts access to a specific DynamoDB table only
   - Allows only specific DynamoDB actions (GetItem, PutItem, UpdateItem, DeleteItem, Query, Scan)
   - Requires requests to originate from the VPC (aws:SourceVpc condition)

### Multiple Route Tables

The example creates two route tables to demonstrate:
- **Private Route Table**: For application subnets
- **Data Route Table**: For data processing subnets

Both route tables are associated with the VPC endpoints, ensuring all traffic to S3 and DynamoDB goes through the private endpoints.

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

## Configuration Details

### S3 Endpoint Policy

```hcl
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
```

### DynamoDB Endpoint Policy

```hcl
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
```

## Key Features Demonstrated

- **Custom Policies**: Fine-grained access control for each endpoint
- **VPC Source Validation**: Ensures requests originate from the VPC
- **Multiple Route Tables**: Demonstrates complex routing scenarios
- **Resource-Specific Access**: Restricts access to specific S3 buckets and DynamoDB tables
- **Comprehensive Tagging**: Security and compliance tags
- **Complete Output Exposure**: All endpoint information available as outputs

## Testing the Configuration

After deployment, you can test the endpoints:

1. **S3 Access Test**:
   ```bash
   # From an EC2 instance in the VPC
   aws s3 ls s3://your-bucket-name
   aws s3 cp test.txt s3://your-bucket-name/
   ```

2. **DynamoDB Access Test**:
   ```bash
   # From an EC2 instance in the VPC
   aws dynamodb put-item --table-name secure-vpc-endpoints-demo --item '{"id":{"S":"test123"}}'
   aws dynamodb get-item --table-name secure-vpc-endpoints-demo --key '{"id":{"S":"test123"}}'
   ```

## Security Considerations

1. **Principle of Least Privilege**: Only necessary permissions are granted
2. **VPC Isolation**: All traffic stays within AWS network
3. **Resource-Level Access Control**: Access restricted to specific resources
4. **Audit Trail**: All access is logged through CloudTrail
5. **Compliance**: Tags support compliance requirements (SOC2, etc.)

## Cleanup

To destroy the resources created by this example:

```bash
terraform destroy
```

**Note**: This will delete the S3 bucket and DynamoDB table along with all their data.

## Next Steps

After running this example, you can:

1. Modify the policies to add more restrictive conditions
2. Add additional route tables for different subnet types
3. Integrate with existing VPC infrastructure
4. Add monitoring and alerting for endpoint usage
5. Implement additional security controls (VPC Flow Logs, etc.) 