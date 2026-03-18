
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

