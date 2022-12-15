locals {
  status = kubernetes_service.app.status # return service status
}
output "service_endpoint" {
  value = try(
    "http://${local.status[0]["load_balancer"][0]["ingress"][0]["hostname"]}", "(error parsing hostname from status)" # try func
  )
  description = "The K8S Service endpoint"
}