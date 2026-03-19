# Backend ECR Repository
resource "aws_ecr_repository" "backend" {
  name         = "${var.app_name}/backend"
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Environment = var.env
    ManagedBy   = "terraform"
  }
}

# Frontend ECR Repository
resource "aws_ecr_repository" "frontend" {
  name         = "${var.app_name}/frontend"
  force_delete = true
  image_scanning_configuration {
    scan_on_push = true
  }

  image_tag_mutability = "MUTABLE"

  tags = {
    Environment = var.env
    ManagedBy   = "terraform"
  }
}

# Lifecycle policy - keeps only the most recent images to control storage costs
resource "aws_ecr_lifecycle_policy" "backend" {
  repository = aws_ecr_repository.backend.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 2 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 2
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

resource "aws_ecr_lifecycle_policy" "frontend" {
  repository = aws_ecr_repository.frontend.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 1 image"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 1
        }
        action = {
          type = "expire"
        }

      }
    ]
  })
}
