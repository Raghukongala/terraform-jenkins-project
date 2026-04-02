variable "name" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}
variable "alb_sg_id" {
  type = string
}
variable "target_group_arn" {
  type = string
}
variable "image_uri" {
  type = string
}
variable "app_port" {
  type    = number
  default = 8080
}
variable "cpu" {
  type    = number
  default = 256
}
variable "memory" {
  type    = number
  default = 512
}
variable "desired_count" {
  type    = number
  default = 1
}
variable "app_env" {
  type    = string
  default = "dev"
}
variable "aws_region" {
  type    = string
  default = "ap-south-1"
}
variable "tags" {
  type    = map(string)
  default = {}
}
