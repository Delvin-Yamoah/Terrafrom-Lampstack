# 3-Tier LAMP Stack on AWS

A scalable 3-tier LAMP (Linux, Apache, MySQL, PHP) stack deployed on AWS using Terraform.

## Architecture

### Tier 1: Web/Presentation Layer

- **Apache HTTP Server** in public subnet
- Serves as reverse proxy to application tier
- Only entry point from internet
- No application logic or database connections

### Tier 2: Application Layer

- **Nginx + PHP-FPM** in private subnet
- Handles business logic and database connections
- Processes PHP applications
- Only accessible from web tier

### Tier 3: Data Layer

- **MySQL Database** in private subnet
- Stores application data
- Only accessible from application tier
- Most secure/isolated tier

## Network Flow

```
Internet → Web Server → App Server → Database
```

## Infrastructure Components

- **VPC** with public and private subnets
- **Internet Gateway** for public subnet access
- **NAT Gateway** for private subnet internet access
- **Security Groups** with tier-specific access rules
- **EC2 Instances** for each tier

## Prerequisites

- AWS CLI configured
- Terraform installed
- SSH key pair created in AWS (lab3-key)

## Deployment

1. Clone and navigate to directory:

```bash
cd lampstack
```

2. Initialize Terraform:

```bash
terraform init
```

3. Plan deployment:

```bash
terraform plan
```

4. Deploy infrastructure:

```bash
terraform apply
```

5. Access application:

```bash
http://<web_public_ip>
```

## Security Features

- **Network Segmentation**: Each tier in separate subnets
- **Security Groups**: Restrictive access between tiers
- **Private Subnets**: App and DB tiers not directly accessible
- **NAT Gateway**: Secure internet access for private instances

## Troubleshooting

Check logs on each tier:

```bash
# Web tier
sudo tail -f /var/log/apache2/error.log

# App tier
sudo tail -f /var/log/nginx/error.log
sudo systemctl status php8.1-fpm

# Service status
sudo netstat -tlnp | grep :80
```

## Outputs

- `web_public_ip`: Public IP of web server
- `app_private_ip`: Private IP of application server
- `db_private_ip`: Private IP of database server
