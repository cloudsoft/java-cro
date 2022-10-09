terraform {
  required_version = ">= 1.1.7"

  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "/Users/iuliana/.kube/config"
}