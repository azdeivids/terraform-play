module "simple_webapp" {
  source         = "../../modules/services/k8s-app"
  name           = "simple-webapp"
  image          = "training/webapp"
  replicas       = 2
  container_port = 5000
}