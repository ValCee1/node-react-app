provider "aws" {
  region  = var.AWS_REGION
  profile = "react-node-app"
}

provider "github" {
  token = var.github_token
  owner = var.github_user
}
