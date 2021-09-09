output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = var.cidr
}

output "public_subnet_ids" {
  value = module.vpc.public_subnets
}

output "public_subnets" {
  value = var.public_subnets
}

output "private_subnet_ids" {
  value = module.vpc.private_subnets
}

output "private_subnets" {
  value = var.private_subnets
}

output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "bastion_id" {
  value = aws_instance.bastion.id
}

output "cluster_id" {
  value = aws_ecs_cluster.ecs.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.ecs.name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app.repository_url
}