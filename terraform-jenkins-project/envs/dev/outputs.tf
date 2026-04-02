output "vpc_id"          { value = module.vpc.vpc_id }
output "private_subnets" { value = module.vpc.private_subnet_ids }
output "public_subnets"  { value = module.vpc.public_subnet_ids }
output "db_endpoint"     { value = module.rds.db_endpoint }
output "assets_bucket"   { value = module.s3_assets.bucket_id }
output "asg_name"        { value = module.ec2.asg_name }
