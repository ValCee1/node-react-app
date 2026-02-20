variable "AWS_REGION" {
}

variable "app-name" {
  type= string
  default = "node-react"
}
variable "env" {
  type= string
}

variable "vpc_cidr" {
  type = string
}