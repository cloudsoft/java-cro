resource "kubernetes_service_v1" "hoodie_db_service" {
  metadata {
    namespace = var.hoodie_db_namespace
    name = "hoodie-db"

    labels = {
      role = "hoodie-db-service"
    }
  }
  spec {
    selector = {
      "name" : kubernetes_deployment_v1.hoodie_db_deployment.metadata.0.name
    }
    type = var.service_type
    port {
      port = 3306
      target_port = "3306"
      protocol = "TCP"
    }
  }
}

resource "kubernetes_deployment_v1" "hoodie_db_deployment" {
  metadata {
    namespace = var.hoodie_db_namespace
    name = "hoodie-db"

    labels = {
      role = "hoodie-db-deployment"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "hoodie-db"
      }
    }

    template {
      metadata {
        labels = {
          name = "hoodie-db"
        }
      }

      spec {
        container {
          image = "${var.aws_account}.dkr.ecr.eu-west-2.amazonaws.com/hoodie-db:${var.image_version}"
          #image = "hoodie-db:1.0"
          image_pull_policy = "IfNotPresent"
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

          liveness_probe {
            tcp_socket {
              port = "3306"
            }
            initial_delay_seconds = 20
            period_seconds = 50
          }
        }
      }
    }
  }
}