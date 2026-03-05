# Output the ARN of the IAM role for GitHub Actions to use in the workflow
output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "aws_region" {
  value = var.AWS_REGION
}

# Output the ECR repository URL and EC2 instance public IP for use in GitHub Actions
output "ecr_repo_url" {
  value = aws_ecr_repository.app.repository_url
}

output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}
