resource "kubernetes_service_v1" "hoodie-backend-service" {
  metadata {
    namespace = kubernetes_namespace_v1.hoodie-shop.metadata.0.name
    name = "hoodie-backend"

    labels = {
      role = "hoodie-backend-service"
    }
  }
  spec {
    selector = {
      name = kubernetes_deployment_v1.hoodie-backend-deployment.metadata.0.name
    }
    type = "NodePort"
    port {
      port = 8082
      target_port = "8082"
      protocol = "TCP"
    }
  }
}

resource "kubernetes_deployment_v1" "hoodie-backend-deployment" {
  metadata {
    namespace = kubernetes_namespace_v1.hoodie-shop.metadata.0.name
    name = "hoodie-backend"

    labels = {
      role = "hoodie-backend-deployment"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "hoodie-backend"
      }
    }

    template {
      metadata {
        labels = {
          name = "hoodie-backend"
        }
      }

      spec {
        container {
          image = "hoodie-backend:1.0"
          name  = "hoodie-backend"

          env {
            name = "DB_HOST"
            value = kubernetes_service_v1.hoodie-db-service.metadata.0.name
          }
          env {
            name ="DB_PORT"
            value = kubernetes_service_v1.hoodie-db-service.spec.0.port.0.port
          }

          port {
            container_port = 8082
            protocol = "TCP"
          }

          liveness_probe {
            tcp_socket {
              port = "8082"
            }
            initial_delay_seconds = 20
            period_seconds = 50
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_deployment_v1.hoodie-db-deployment
  ]
}
