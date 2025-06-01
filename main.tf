resource "kubernetes_namespace" "hello" {
    metadata {
        name = "hello"
    }
}

resource "kubernetes_manifest" "deployment_hello_deployment" {
  manifest = {
    "apiVersion" = "apps/v1"
    "kind" = "Deployment"
    "metadata" = {
      "labels" = {
        "app" = "hello"
      }
      "name" = "hello-deployment"
      "namespace" = kubernetes_namespace.hello.metadata[0].name
    }
    "spec" = {
      "replicas" = 1
      "selector" = {
        "matchLabels" = {
          "app" = "hello"
        }
      }
      "template" = {
        "metadata" = {
          "labels" = {
            "app" = "hello"
          }
        }
        "spec" = {
          "containers" = [
            {
              "image" = "kaldyka/hello-go:latest"
              "name" = "hello-container"
              "ports" = [
                {
                  "containerPort" = 80
                },
              ]
            },
          ]
        }
      }
    }
  }
}

resource "kubernetes_manifest" "service_hello_service" {
  manifest = {
    "apiVersion" = "v1"
    "kind" = "Service"
    "metadata" = {
      "name" = "hello-service"
      "namespace" = kubernetes_namespace.hello.metadata[0].name
    }
    "spec" = {
      "ports" = [
        {
          "port" = 80
          "protocol" = "TCP"
          "targetPort" = 80
        },
      ]
      "selector" = {
        "app" = "hello"
      }
      "type" = "LoadBalancer"
    }
  }
}
