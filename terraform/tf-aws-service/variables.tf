//Required
variable "env_name" {}
variable "region" {}
variable "app_name" {}
variable "image_name" {}
variable "docker_tag" {}

//Defaults
variable "reserved_memory" {
  default = 64
}
variable "max_memory" {
  default = 128
}
variable "internal_alb" {
  default = false
  description = "If the ALB is an internal load balancer or exposed to public"
}
// Lock this down to your liking or create your own with terraform
variable "ecs_iam_role" {
  default = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}
// Lock this down to your liking or create your own with terraform
variable "ecs_as_iam_role" {
  default = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceAutoscaleRole"
}
variable "service_min" {
  default = 2
}
variable "service_max" {
  default = 5
}
variable "service_desired" {
  default = 2
}
variable "delete_protection" {
   default = false
}
variable "cpu_scale_up" {
  default = 80
}
variable "cpu_scale_down" {
  default = 50
}