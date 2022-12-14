# set TF_VAR_dev_subscription=<id>
variable "dev_subscription" {
  description = "Dev subscription id"
  type = string
  sensitive = true
}
# set TF_VAR_prod_subscription=<id>
variable "prod_subscription" {
  description = "Production subscription id"
  type = string
  sensitive = true
}