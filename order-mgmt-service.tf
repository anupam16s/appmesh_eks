resource "kubernetes_deployment" "ordermgmt-app" {
  metadata {
    name = "ordermgmt-app"
    labels = {
      app     = "ordermgmt"
      version = "v1"
    }
    namespace = "<Namespace_name>"
  }

  spec {
    replicas = var.REPLCIA_COUNT_ORDERMGMT_SERVICE
    selector {
      match_labels = {
        app     = "ordermgmt"
        version = "v1"
      }
    }
    template {
      metadata {
        labels = {
          app     = "ordermgmt"
          version = "v1"
        }
      }
      spec {
        container {
          image = var.ordermgmt_image
          name  = "ordermgmt-app"
          env {
             name  = "-Dupdate.inventory.url"
             value = var.inventory_url
           }
          port {
            container_port = 8080
          }

        }
      }
    }
  }
  depends_on = [helm_release.appmesh-resources-local]
}

resource "kubernetes_service" "ordermgmt-service" {
  metadata {
    name      = "ordermgmt"
    namespace = "<Namespace_name>"
  }
  spec {
    selector = {
      app     = "ordermgmt"
      version = "v1"
    }
    port {
      port = 8080
    }
  }
}

# #canary
#
resource "kubernetes_deployment" "ordermgmt-app-canary" {
  metadata {
    name = "ordermgmt-app-${var.appimage_version}"
    labels = {
      app     = "ordermgmt"
      version = "v2"
    }
    namespace = "<Namespace_name>"
  }

  spec {
    replicas = var.REPLCIA_COUNT_ORDERMGMT_SERVICE
    selector {
      match_labels = {
        app     = "ordermgmt"
        version = "v2"
      }
    }
    template {
      metadata {
        labels = {
          app     = "ordermgmt"
          version = "v2"
        }
      }
      spec {
        container {
          image = var.ordermgmt_image_canary
          name  = "ordermgmt-app-${var.appimage_version}"
          env {
             name  = "-Dupdate.inventory.url"
             value = var.inventory_url
           }
          port {
            container_port = 8080
          }

        }
      }
    }
  }
   depends_on = [helm_release.appmesh-resources-local]
}

resource "kubernetes_service" "ordermgmt-service-canary" {
  metadata {
    name      = "ordermgmt${var.appimage_version}"
    namespace = "<Namespace_name>"
  }
  spec {
    selector = {
      app     = "ordermgmt"
      version = "v2"
    }
    port {
      port = 8080
    }
  }
}
#end of canary
