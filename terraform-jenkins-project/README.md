# Terraform Jenkins Project

Production-grade Terraform infrastructure with Jenkins CI/CD pipeline.

## Architecture

```
terraform-jenkins-project/
├── Jenkinsfile                  # Full CI/CD pipeline
├── bootstrap/                   # One-time: S3 state bucket + DynamoDB lock
├── modules/
│   ├── vpc/                     # VPC, subnets, NAT, route tables
│   ├── ec2/                     # ASG + Launch Template + IAM + SSM
│   ├── rds/                     # PostgreSQL Multi-AZ RDS
│   └── s3/                      # Encrypted, versioned S3 bucket
├── envs/
│   ├── dev/                     # Dev: minimal cost, no NAT, single-AZ RDS
│   ├── staging/                 # Staging: NAT gateway, single-AZ RDS
│   └── prod/                    # Prod: Multi-AZ RDS, 3 AZs, deletion protection
└── scripts/
    └── inject-secrets.sh        # Pulls DB password from Secrets Manager
```

## Prerequisites

| Tool       | Version  |
|------------|----------|
| Terraform  | >= 1.7   |
| tflint     | latest   |
| checkov    | latest   |
| AWS CLI    | v2       |

Jenkins plugins required:
- `pipeline-aws` (withAWS step)
- `ansicolor`
- `timestamper`

## Step 1 — Bootstrap Remote State (run once)

```bash
cd bootstrap
terraform init
terraform apply
# Note the output: state_bucket and lock_table
```

Update the `backend "s3"` block in each `envs/*/main.tf` with the real account ID.

## Step 2 — Store DB Password in Secrets Manager

```bash
aws secretsmanager create-secret \
  --name "myapp/dev/db-password" \
  --secret-string "YourStrongPassword123!"
```

Repeat for `staging` and `prod`.

## Step 3 — Jenkins Setup

1. Add AWS credentials in Jenkins → Credentials → `aws-credentials` (type: AWS)
2. Create a Pipeline job pointing to this repo
3. Set `Jenkinsfile` as the pipeline script

## Step 4 — Run the Pipeline

Trigger the pipeline with parameters:
- `ENV`: `dev` / `staging` / `prod`
- `ACTION`: `plan` / `apply` / `destroy`
- `AUTO_APPROVE`: `false` (always require approval for prod)

## Pipeline Stages

```
Checkout → Init → Validate + TFLint + Checkov → Plan → Approval → Apply/Destroy → Output
```

- `plan` — always runs, no approval needed
- `apply` / `destroy` — requires manual approval (mandatory for prod)
- Checkov security scan results published as JUnit test report
- Plan saved as artifact for audit trail

## Environment Differences

| Setting            | dev        | staging     | prod           |
|--------------------|------------|-------------|----------------|
| NAT Gateway        | ❌          | ✅           | ✅              |
| RDS Multi-AZ       | ❌          | ❌           | ✅              |
| RDS Instance       | t3.micro   | t3.small    | r6g.large      |
| Deletion Protection | ❌         | ❌           | ✅              |
| ASG desired        | 1          | 2           | 4              |
| ASG max            | 2          | 3           | 10             |

## Security Highlights

- IMDSv2 enforced on all EC2 instances
- S3 state bucket: versioned, encrypted, public access blocked
- RDS: encrypted at rest, no public access, CloudWatch logs enabled
- Secrets never in tfvars — injected via Secrets Manager at pipeline runtime
- Checkov SAST scan on every pipeline run
