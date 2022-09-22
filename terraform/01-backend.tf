resource "kubernetes_service_v1" "hoodie-backend-service" {
  metadata {
    namespace = kubernetes_namespace_v1.hoodie-shop.id
    name = "hoodie-backend-native"

    labels = {
      role = "hoodie-backend-service"
      groupId: "hoodie-shop"
    }
  }
  spec {
    selector = {
      "name" : kubernetes_deployment_v1.hoodie-backend-native-deployment.metadata.0.name
    }
    port {
      port = 3306
      target_port = "3306"
      protocol = "TCP"
    }
    type = "NodePort"
  }
}

resource "kubernetes_deployment_v1" "hoodie-backend-native-deployment" {
  metadata {
    namespace = kubernetes_namespace_v1.hoodie-shop.id
    name = "hoodie-backend-native"

    labels = {
      role = "hoodie-backend-deployment"
      groupId: "hoodie-shop"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "hoodie-backend-native"
      }
    }

    template {
      metadata {
        labels = {
          test = "hoodie-backend-native"
        }
      }

      spec {
        container {
          image = "hoodie-bck-native:1.0"
          name  = "hoodie-backend-native"

          resources {
            requests = {
              cpu: "250m"
              memory: "250Mi"
            }
          }
          port {
            container_port = 8082
            protocol = "TCP"
          }
          env {
            name = "DB_HOST"
            value = kubernetes_service_v1.hoodie-db-service.metadata.0.name
          }
          env {
            name ="DB_PORT"
            value = kubernetes_service_v1.hoodie-db-service.spec.0.port.0.port
          }
        }
      }
    }
  }
}