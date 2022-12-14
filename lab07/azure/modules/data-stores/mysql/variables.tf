# remote state variables
variable "remote_state_rg" {
  description = "RG where the remote state st account is being stored"
  type        = string
}
variable "remote_state_st_acc" {
  description = "Container blob where the remote state will be stored"
  type        = string
}
variable "remote_state_key" {
  description = "Path to the storage account remote state key"
  type        = string
}
variable "tfstate_container" {
  description = "Name of the container where the tf state file is to be stored"
  type        = string
}
# set TF_VAR_dev_subscription=<id>
variable "dev_subscription" {
  description = "Development subscription id"
  type        = string
  sensitive   = true
}
# set TF_VAR_prod_subscription=<id>
variable "prod_subscription" {
  description = "Production subscription id"
  type        = string
  sensitive   = true
}
# resource variables
variable "rg_prefix" {
  description = "Resource group prefix to be used during deployment"
  type        = string
}
variable "location" {
  description = "Location where resources are to be created"
  type        = string
}
variable "pdnsz" {
  description = "Deploy private dns zone"
  type        = bool
}
# set TF_VAR_db_username=<username>
variable "db_username" {
  description = "MySQL DB Username"
  type        = string
  sensitive   = true
}
# set TF_VAR_db_password=<password>
variable "db_password" {
  description = "MySQL DB User password"
  type        = string
  sensitive   = true
}
variable "backup_retention_days" {
  description = "Backup retention days for the mysql flexible server"
  type        = number
  default     = 7
}
variable "geo_redundant_backup_enabled" {
  description = "Enable/disable GEO redundancy"
  type        = bool
}