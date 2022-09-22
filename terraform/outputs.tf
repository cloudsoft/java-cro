output "namespace_name" {
  value = kubernetes_namespace_v1.hoodie-shop.id
}

output "hoodie_db_location" {
  value = "jdbc:mariadb://${kubernetes_service_v1.hoodie-db-service.status.0.load_balancer.0.ingress.0.hostname}:${kubernetes_service_v1.hoodie-db-service.spec.0.port.0.node_port}/hoodiedb"
}

output "hoodie_db_service_name" {
  value = kubernetes_service_v1.hoodie-db-service.metadata.0.name
}

output "hoodie_backend_location" {
  value = "http://${kubernetes_service_v1.hoodie-backend-service.status.0.load_balancer.0.ingress.0.hostname}:${kubernetes_service_v1.hoodie-backend-service.spec.0.port.0.node_port}/catalogue/hoodie"
}