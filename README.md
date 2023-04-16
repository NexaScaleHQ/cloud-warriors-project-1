# nginx web-server on aws with terraform

## Setup VPC and networking topology.
- Create VPC
- Create Internet gateway
- Create custom route table
- Create a subnet
- Associate subnet with route table
- Create Security Group to allow port 22, 80, 443

## Provision Compute Service

- Create Key-pair
- Create Compute instance (ec2)
- Launch ngnix-server script on instance

# How to Run/Contribute
### START HERE: Initialize the instance

- Navigate to the terraform backend-state folder. `cd terraform/backend-state`.
- Export your credentials:
```bash
  export AWS_ACCESS_KEY_ID="anaccesskey"
  export AWS_SECRET_ACCESS_KEY="asecretkey"
  export AWS_REGION="eu-west-1"
```
- **Pull recent state**: Run the `terraform init` command to pull the recent state from the s3 bucket

### Provisioning the instances

- Navigate to resources directory. `cd ../resources
- **Make your changes: Update where necessary**
- **Formatting**: `terraform fmt -recursive`. This format your changes to standard
- **Plan**: Run the `terraform plan` command. This allows you see your changes that will be provisioned
- **Apply**: Run the `terraform apply` command.

### Destroy the instances

`terraform destroy`
