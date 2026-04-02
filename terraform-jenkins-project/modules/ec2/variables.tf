variable "name"             { type = string }
variable "vpc_id"           { type = string }
variable "subnet_ids"       { type = list(string) }
variable "alb_sg_ids"       { type = list(string) }
variable "target_group_arns" { type = list(string) }
variable "instance_type"    { type = string; default = "t3.micro" }
variable "app_port"         { type = number; default = 8080 }
variable "min_size"         { type = number; default = 1 }
variable "max_size"         { type = number; default = 4 }
variable "desired_capacity" { type = number; default = 2 }
variable "user_data"        { type = string; default = "#!/bin/bash\nyum update -y" }
variable "tags"             { type = map(string); default = {} }
