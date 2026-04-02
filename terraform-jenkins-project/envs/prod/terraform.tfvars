aws_region   = "ap-south-1"
project_name = "myapp"

vpc_cidr        = "10.2.0.0/16"
azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
public_subnets  = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
private_subnets = ["10.2.11.0/24", "10.2.12.0/24", "10.2.13.0/24"]

instance_type = "t3.medium"
db_name       = "appdb"
db_username   = "appuser"
