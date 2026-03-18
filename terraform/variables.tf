variable "AWS_REGION" {
}

variable "app_name" {
  type    = string
  default = "node-react"
}
variable "availability_zone" {
  type = string
}

variable "ALL_IP" {
  default = "0.0.0.0/0"
}

variable "ami" {
  type = string
}
variable "env" {
  type = string
}
variable "GITHUB_REPO" {
  type = string
}
variable "github_user" {
  type = string
}
variable "github_token" {
  type      = string
  sensitive = true
}
variable "instance_type" {
  type = string
}
variable "MONGO_USERNAME" {
  type = string
}
variable "MONGO_PASSWORD" {
  type = string
}
variable "MONGO_URI" {
  type = string
}
variable "OPEN_PORTS" {
  type = list(string)
}

variable "PATH_TO_PRIVATE_KEY" {
  type = string
}
variable "PATH_TO_PUBLIC_KEY" {
  type = string
}
variable "subnet_cidr" {
  type = list(string)
}

variable "SSH_IPS" {
  type = list(string)

}
variable "SSH_PORT" {
  type    = number
  default = 22
}

variable "vpc_cidr" {
  type = string
}

