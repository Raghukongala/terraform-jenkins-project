aws_region    = "ap-south-1"
project_name  = "myapp"

vpc_cidr        = "10.0.0.0/16"
azs             = ["ap-south-1a", "ap-south-1b"]
public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]

instance_type = "t3.micro"

db_name     = "appdb"
db_username = "appuser"
# db_password is injected by Jenkins from AWS Secrets Manager / Jenkins credentials
