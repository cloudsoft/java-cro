## namespace
resource "kubernetes_namespace_v1" "hoodie-shop" {
  metadata {
    annotations = {
      name = "hoodie-shop-annotation"
    }

    labels = {
      demo = "hoodie-db-namespace"
    }

    name = "hoodie-shop"
  }
}