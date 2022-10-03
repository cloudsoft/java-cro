resource "kubernetes_service_v1" "hoodie-frontend-service" {
  metadata {
    namespace = var.hoodie_frontend_namespace
    name = "hoodie-frontend"

    labels = {
      role = "hoodie-frontend-service"
    }
  }
  spec {
    selector = {
      name = kubernetes_deployment_v1.hoodie-frontend-deployment.metadata.0.name
    }
    type = "NodePort"
    port {
      port = 3000
      target_port = "3000"
      protocol = "TCP"
    }
  }
}

resource "kubernetes_deployment_v1" "hoodie-frontend-deployment" {
  metadata {
    namespace = var.hoodie_frontend_namespace
    name = "hoodie-frontend"

    labels = {
      role = "hoodie-frontend-deployment"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "hoodie-frontend"
      }
    }

    template {
      metadata {
        labels = {
          name = "hoodie-frontend"
        }
      }

      spec {
        container {
          image = "${var.aws_account}.dkr.ecr.eu-west-2.amazonaws.com/hoodie-frontend:latest"
          #image = "hoodie-frontend:1.0"
          image_pull_policy = "IfNotPresent"
          name  = "hoodie-frontend"

          env {
            name = "REACT_APP_BACKEND_URL"
            value = "http://${var.hoodie_backend_host}:${var.hoodie_backend_port}"
          }

          port {
            container_port = 3000
            protocol = "TCP"
          }

          liveness_probe {
            tcp_socket {
              port = "3000"
            }
            initial_delay_seconds = 20
            period_seconds = 50
          }
        }
      }
    }
  }

}
