resource "kubernetes_service_v1" "hoodie-db-service" {
  metadata {
    namespace = kubernetes_namespace_v1.hoodie-shop.id
    name = "hoodie-db"

    labels = {
      role = "hoodie-db-service"
      groupId: "hoodie-shop"
    }
  }
  spec {
    selector = {
      "name" : kubernetes_deployment_v1.hoodie-db-deployment.metadata.0.name
    }
    port {
      port = 3306
      target_port = "3306"
      protocol = "TCP"
    }
    type = "NodePort"
  }
}

resource "kubernetes_deployment_v1" "hoodie-db-deployment" {
  metadata {
    namespace = kubernetes_namespace_v1.hoodie-shop.id
    name = "hoodie-db"

    labels = {
      role = "hoodie-db-deployment"
      groupId: "hoodie-shop"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        test = "hoodie-db"
      }
    }

    template {
      metadata {
        labels = {
          test = "hoodie-db"
        }
      }

      spec {
        container {
          image = "hoodie-db:1.0"
          name  = "hoodie-db"

          env {
            name = "MARIADB_ROOT_PASSWORD"
            value = "mypass"
          }
          env {
            name = "MARIADB_USER"
            value= "catalogue_user"
          }
          env {
            name= "MARIADB_PASSWORD"
            value= "catalogue_pass"
          }
          env {
            name= "MARIADB_DATABASE"
            value= "hoodiedb"
          }

          port {
            container_port = 3306
            protocol = "TCP"
          }

        /*  resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }*/

          /*liveness_probe {
            exec {
              path = "/"
              port = 80

              http_header {
                name  = "X-Custom-Header"
                value = "Awesome"
              }
            }

            initial_delay_seconds = 3
            period_seconds        = 3
          }*/
        }
      }
    }
  }
}