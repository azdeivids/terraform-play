variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type        = string
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  type        = string
  default     = "UK South"
}
# variables to specify the remote state
variable "remote_state_rg" {
  description = "RG where the remote state st account is being stored"
  type = string  
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
variable "enable_autoscaling" {
  description = "Enable or disable autoscaling using"
  type = bool
}