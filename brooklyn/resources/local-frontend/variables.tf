variable "hoodie_frontend_namespace" {
  type = string
}

variable "hoodie_backend_port" {
  type = string
}

variable "hoodie_backend_host" {
  type = string
}

variable "aws_account" {}

variable "service_type" {}

// 1.0 for M1, 1.1 for linux/amd64 - the frontend revealed this mess and made this necesssary
variable "image_version" {}