# LAMP Stack Visit Counter - Modular Terraform

## My Visit Counter App is available at http://54.155.3.92/

## Architecture

- **Web Tier**: Apache + HTML/JS frontend (public subnet)
- **App Tier**: Apache + PHP API (private subnet)
- **DB Tier**: MySQL database (private subnet)

## Structure

```
├── modules/
│   ├── networking/     # VPC, subnets, routing
│   ├── security/       # Security groups
│   └── compute/        # EC2 instances + scripts
└── environments/
    └── dev/           # Development environment
```

## Deploy

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

## Access

Visit the URL from terraform output to use the visit counter application.
