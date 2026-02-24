
# ECR Repository

resource "aws_ecr_repository" "app" {
  name = "${var.env}-app"

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"
}
