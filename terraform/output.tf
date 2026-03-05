output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_role.arn
}

output "aws_region" {
  value = var.AWS_REGION
}

output "ecr_repo_url" {
  value = aws_ecr_repository.app_repo.repository_url
}

output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}
