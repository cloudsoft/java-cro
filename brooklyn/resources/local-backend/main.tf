resource "kubernetes_service_v1" "hoodie-backend-service" {
  metadata {
    namespace = var.hoodie_backend_namespace
    name = "hoodie-backend"

    labels = {
      role = "hoodie-backend-service"
    }
  }
  spec {
    selector = {
      name = kubernetes_deployment_v1.hoodie-backend-deployment.metadata.0.name
    }
    type = var.service_type
    port {
      port = 8082
      target_port = "8082"
      protocol = "TCP"
    }
  }
}

resource "kubernetes_deployment_v1" "hoodie-backend-deployment" {
  metadata {
    namespace = var.hoodie_backend_namespace
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
          image = "${var.aws_account}.dkr.ecr.eu-west-2.amazonaws.com/hoodie-backend:${var.image_version}" // not really needed here since native images are build only for amd64, but kept for consistency
          #image = "hoodie-backend:1.0"
          image_pull_policy = "IfNotPresent"
          name  = "hoodie-backend"

          env {
            name = "DB_HOST"
            value = var.hoodie_db_host
          }
          env {
            name ="DB_PORT"
            value = var.hoodie_db_port
          }
          env {
            name ="DB_USER"
            value = "catalogue_user"
          }
          env {
            name ="DB_PASS"
            value = "catalogue_pass"
          }
          env {
            name ="DB_SCHEMA"
            value = "hoodiedb"
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

}
