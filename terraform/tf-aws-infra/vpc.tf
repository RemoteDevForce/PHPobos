module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.env_name}-${var.region}-vpc"

  cidr                   = var.cidr
  private_subnets        = split(",", var.private_subnets)
  public_subnets         = split(",", var.public_subnets)
  database_subnets       = split(",", var.database_subnets)
  elasticache_subnets    = split(",", var.cache_subnets)
  azs                    = split(",", var.azs)
  enable_dns_support     = true
  enable_nat_gateway     = true
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  tags = {
    "ManagedBy"   = "Terraform"
    "Name"        = "${var.env_name}-${var.region}-vpc"
    "Environment" = var.env_name
  }
}