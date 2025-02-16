# AWS SFTP Transfer Server with S3 Backend

This Terraform project sets up a secure SFTP server using AWS Transfer Family with an S3 bucket backend, complete with Route53 DNS configuration and IAM roles.

## Features

- AWS Transfer Family SFTP server
- S3 bucket backend for file storage
- Route53 DNS configuration with custom domain
- IAM roles and policies for secure access
- Application Load Balancer integration

## Prerequisites

- Terraform >= 1.0
- AWS CLI configured with appropriate credentials
- A registered domain name (for Route53 configuration)

## Usage

1. Clone this repository
2. Update the variables in `main.tf` with your configuration:


## Load Balancer Considerations

This infrastructure uses direct DNS routing without a load balancer since we're utilizing AWS managed services with their own endpoints. Here's why:

### When You Don't Need a Load Balancer
- Using AWS services with built-in endpoints (API Gateway, S3, RDS, etc.)
- Domain pointing to a single service
- Using Route 53 for direct traffic routing to AWS service endpoints
- No need for SSL termination or request distribution

### When You Would Need a Load Balancer
- Distributing traffic across multiple instances/containers
- SSL/TLS termination requirements
- Health checks and automatic failover needs
- Handling varying loads
- Running custom web servers (e.g., EC2 instances)
- Layer 7 (application layer) routing requirements

### Current Implementation
This infrastructure uses Route 53 to directly route traffic to AWS service endpoints, eliminating the need for a load balancer. This approach:
- Reduces infrastructure costs
- Simplifies the architecture
- Leverages AWS's built-in high availability
- Maintains security through AWS's native service endpoints
