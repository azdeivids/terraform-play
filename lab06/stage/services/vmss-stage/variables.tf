variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type        = string
  default = "tf-lab06"
}

variable "remote_state_rg" {
  description = "RG where the remote state st account is being stored"
  type = string
  default = "terraform-state-storage-uksouth"
}
variable "remote_state_st_acc" {
  description = "Container blob where the remote state will be stored"
  type        = string
  default = "tfstate428150812"
}
variable "remote_state_key" {
  description = "Path to the storage account remote state key"
  type        = string
  default = "terraform.tfstate"
}
variable "tfstate_container" {
  description = "Name of the container where the tf state file is to be stored"
  type        = string
  default = "tfstate"
}