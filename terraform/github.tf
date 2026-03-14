resource "github_actions_secret" "aws_role" {
  repository      = var.app_name
  secret_name     = "AWS_ROLE_ARN"
  plaintext_value = aws_iam_role.github_actions.arn
}

resource "github_actions_secret" "ecr_repo_url" {
  repository      = var.app_name
  secret_name     = "ECR_REPOSITORY_URL"
  plaintext_value = aws_ecr_repository.app.repository_url
}

resource "github_actions_secret" "ec2_public_ip" {
  repository      = var.app_name
  secret_name     = "EC2_HOST"
  plaintext_value = aws_instance.app_server.public_ip
}

resource "github_actions_secret" "EC2_SSH_KEY" {
  repository      = var.app_name
  secret_name     = "EC2_SSH_KEY"
  plaintext_value = file(var.PATH_TO_PRIVATE_KEY)
}

resource "github_actions_variable" "aws_region" {
  value         = var.AWS_REGION
  repository    = var.app_name
  variable_name = "AWS_REGION"

}

resource "github_actions_variable" "ecr_repository" {
  value         = var.app_name
  repository    = var.app_name
  variable_name = "ECR_REPOSITORY"

}

