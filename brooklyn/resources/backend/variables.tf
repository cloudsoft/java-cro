variable "hoodie_backend_namespace" {
  type = string
}

variable "hoodie_db_port" {
  type = string
}

variable "hoodie_db_host" {
  type = string
}

variable "aws_account" {}

variable "service_type" {}

// 1.0 for M1, 1.1 for linux/amd64
variable "image_version" {}

variable "suffix" {}