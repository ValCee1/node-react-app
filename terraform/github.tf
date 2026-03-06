resource "github_actions_secret" "aws_role" {
  repository      = var.app_name
  secret_name     = "AWS_ROLE_ARN"
  plaintext_value = aws_iam_role.github_actions.arn
}

resource "github_actions_secret" "ec2_repo_url" {
  repository      = var.app_name
  secret_name     = "EC2_REPO_URL"
  plaintext_value = aws_ecr_repository.app.repository_url
}

resource "github_actions_secret" "ec2_public_ip" {
  repository      = var.app_name
  secret_name     = "EC2_PUBLIC_IP"
  plaintext_value = aws_instance.app_server.public_ip
}

resource "github_actions_secret" "aws_region" {
  repository      = var.app_name
  secret_name     = "AWS_REGION"
  plaintext_value = var.AWS_REGION
}

