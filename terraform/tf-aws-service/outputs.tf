output "alb_dns" {
  value = aws_alb.alb.dns_name
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app.repository_url
}