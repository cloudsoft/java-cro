terraform {
  required_version = ">= 1.1.7"
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}