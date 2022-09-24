output "namespace_name" {
  value = kubernetes_namespace_v1.hoodie-shop.metadata.0.name
}

output "hoodie_db_location_internal" {
  value = "jdbc:mariadb://${kubernetes_service_v1.hoodie-db-service.metadata.0.name}:${kubernetes_service_v1.hoodie-db-service.spec.0.port.0.port}/hoodiedb"
}

output "hoodie_backend_location_internal" {
  value = "jdbc:mariadb://${kubernetes_service_v1.hoodie-backend-service.metadata.0.name}:${kubernetes_service_v1.hoodie-backend-service.spec.0.port.0.port}/hoodiedb"
}

// run 'terraform apply' again and remove comment from the next outputs

output "hoodie_db_location_external" {
  value = "jdbc:mariadb://${kubernetes_service_v1.hoodie-db-service.status.0.load_balancer.0.ingress.0.hostname}:${kubernetes_service_v1.hoodie-db-service.spec.0.port.0.node_port}/hoodiedb"
}

output "hoodie_backend_location_external" {
  value = "http://${kubernetes_service_v1.hoodie-backend-service.status.0.load_balancer.0.ingress.0.hostname}:${kubernetes_service_v1.hoodie-backend-service.spec.0.port.0.node_port}/catalogue/health"
}
// needed as a dependency for frontend
output "hoodie_backend_location" {
  value = "http://${kubernetes_service_v1.hoodie-backend-service.status.0.load_balancer.0.ingress.0.hostname}:${kubernetes_service_v1.hoodie-backend-service.spec.0.port.0.node_port}"
}

