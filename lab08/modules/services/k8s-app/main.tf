terraform {
  required_version = "< 2.0.0"
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
}

locals {
  pod_labels = {
    app = var.name
  }
}
# create k8s deployment
resource "kubernetes_deployment" "app" {
  metadata {
    name = var.name
  }

  spec {
    replicas = var.replicas
    template {
      metadata {
        labels = local.pod_labels
      }
      # specify which docker container to run in the pod
      spec {
        container {
          name  = var.name  # name used for the container
          image = var.image # docker image to run

          port {
            container_port = var.container_port # ports to be exposed in the cn
          }
          dynamic "env" {
            for_each = var.environment_variables # env var to expose to the cn
            content {
              name  = env.key
              value = env.value
            }
          }
        }
      }

    }
    # tell k8s deployment what to target
    selector {
      match_labels = local.pod_labels # manage deployments for the pod template defined above
    }
  }
}
# create k8s service
resource "kubernetes_service" "app" {
  # identify the target and object in API calls
  metadata {
    name = var.name
  }
  spec {
    type = "LoadBalancer" # deploy lb
    port {
      port        = 80 # rout traffic to port 80
      target_port = var.container_port
      protocol    = "TCP"
    }
    # specify the targeted service
    selector = local.pod_labels
  }
}
