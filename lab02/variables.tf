variable "rgname01" {
  description = "Name of the resource group where all the resources will be placed."
  type        = string
  default     = "tf-websrv-rg-001"
}
variable "appsvcname" {
  description = "Name of the app service plan."
  type        = string
  default     = "appsvc-plan-001"
}
variable "webappname" {
  description = "Name of the web app."
  type        = string
  default     = "tfapp001"
}