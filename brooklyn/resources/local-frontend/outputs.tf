output "namespace_name" {
  value = var.hoodie_frontend_namespace
}

output "hoodie_frontend_location_internal" {
  value = "http://${kubernetes_service_v1.hoodie-frontend-service.metadata.0.name}:${kubernetes_service_v1.hoodie-frontend-service.spec.0.port.0.port}/catalogue/hoodie"
}

output "hoodie_frontend_port_internal" {
  value = kubernetes_service_v1.hoodie-frontend-service.spec.0.port.0.port
}

// run 'terraform apply' again and remove comment from the next outputs
/*
output "hoodie_db_location_external" {
  value = "jdbc:mariadb://${kubernetes_service_v1.hoodie-db-service.status.0.load_balancer.0.ingress.0.hostname}:${kubernetes_service_v1.hoodie-db-service.spec.0.port.0.node_port}/hoodiedb"
}*/
