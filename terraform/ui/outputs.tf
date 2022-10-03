output "namespace_name" {
  value = var.hoodie_shop_namespace
}

output "hoodie_ui_location_internal" {
  value = "jdbc:mariadb://${kubernetes_service_v1.hoodie-frontend-service.metadata.0.name}:${kubernetes_service_v1.hoodie-frontend-service.spec.0.port.0.port}/hoodiedb"
}

// run 'terraform apply' again and remove comment from the next outputs
output "hoodie_ui_location_external" {
  value = "http://${kubernetes_service_v1.hoodie-frontend-service.status.0.load_balancer.0.ingress.0.hostname}:${kubernetes_service_v1.hoodie-frontend-service.spec.0.port.0.node_port}/catalog"
}

