resource "kubernetes_service_v1" "hoodie_frontend_service" {
  metadata {
    namespace = var.hoodie_frontend_namespace
    name = "hoodie-frontend"

    labels = {
      role = "hoodie-frontend-service"
    }
  }
  spec {
    selector = {
      name = kubernetes_deployment_v1.hoodie_frontend_deployment.metadata.0.name
    }
    type = var.service_type
    port {
      port = 3000
      target_port = "3000"
      protocol = "TCP"
    }
  }
}

resource "kubernetes_deployment_v1" "hoodie_frontend_deployment" {
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
          image = "${var.aws_account}.dkr.ecr.eu-west-2.amazonaws.com/hoodie-frontend:${var.image_version}"
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
            http_get {
              path = "/catalog"
              port = 3000
            }
            failure_threshold = 1
            initial_delay_seconds = 45  # the frontend needs to be built so yeap... this takes a while
            period_seconds = 10
          }
          readiness_probe {
            http_get {
              path = "/catalog"
              port = 3000
            }
            failure_threshold = 1
            period_seconds = 1
          }
        }
      }
    }
  }

}
