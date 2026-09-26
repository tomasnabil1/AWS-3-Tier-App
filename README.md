# AWS 3-Tier Architecture with Terraform

A modular AWS 3-tier infrastructure built and managed using Terraform.

The project provisions a highly available network architecture across multiple Availability Zones, with an internet-facing Application Load Balancer, private EC2 web servers, a private MySQL RDS database, and an S3 remote backend for Terraform state management.

## Architecture

```text
                         Internet
                            |
                            v
                 Application Load Balancer
                   /                   \
                  v                     v
        Private EC2-1             Private EC2-2
          Nginx                     Nginx
                  \                 /
                   \               /
                    v             v
                      MySQL RDS
                    Private Subnets
```

The infrastructure is distributed across two Availability Zones in `us-east-1`.

## AWS Services

* Amazon VPC
* Public and Private Subnets
* Internet Gateway
* NAT Gateway
* Elastic IP
* Application Load Balancer
* EC2
* RDS MySQL
* Security Groups
* Amazon S3

## Terraform Modules

The infrastructure is separated into reusable Terraform modules:

### Network

Responsible for:

* VPC
* Public subnets
* Private application subnets
* Private database subnets
* Internet Gateway
* NAT Gateway
* Route tables
* Security Groups
* RDS DB Subnet Group

### Compute

Responsible for:

* Two EC2 instances
* Nginx web servers
* Application Load Balancer
* Target Group
* Target Group Attachments
* HTTP Listener

The EC2 instances are deployed inside private subnets and receive traffic through the Application Load Balancer.

### Database

Responsible for:

* MySQL RDS instance
* Private database deployment
* Database subnet configuration
* Security Group integration

The database is not publicly accessible.

## Remote State

Terraform state is stored remotely in Amazon S3.

The state bucket uses:

* S3 Versioning
* Server-side encryption
* Block Public Access
* Terraform state locking

This prevents the Terraform state from being stored only on a local machine and provides safer state management.

## Security

The architecture follows a layered network design:

```text
Internet
   |
   v
ALB Security Group
   |
   | HTTP : 80
   v
EC2 Security Group
   |
   | MySQL : 3306
   v
RDS Security Group
```

The EC2 instances do not require public IP addresses, and the RDS database is deployed in private database subnets.

## Project Structure

```text
Infrastructure_3tier_app/
│
├── Modules/
│   ├── Network/
│   ├── Compute/
│   └── Database/
│
├── main.tf
├── variables.tf
├── outputs.tf
├── provider.tf
├── backend.tf
├── s3.tf
├── terraform.tfvars
├── .terraform.lock.hcl
└── .gitignore
```

> `terraform.tfvars` and Terraform state files are excluded from Git and must not be committed because they may contain sensitive values.

## Deployment

Initialize Terraform:

```bash
terraform init
```

Format and validate the configuration:

```bash
terraform fmt -recursive
terraform validate
```

Review the infrastructure changes:

```bash
terraform plan
```

Deploy:

```bash
terraform apply
```

## Testing

After deployment, retrieve the Application Load Balancer DNS name:

```bash
terraform output alb_dns_name
```

Open the returned address using HTTP.

The ALB distributes requests between the two private EC2 web servers running Nginx.

Example responses:

```text
Hello from EC2-1
```

or:

```text
Hello from EC2-2
```

## Infrastructure as Code

The entire AWS infrastructure is managed through Terraform, allowing the environment to be recreated consistently from code.

To remove the infrastructure:

```bash
terraform destroy
```
