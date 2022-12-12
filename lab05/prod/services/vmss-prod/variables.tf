variable "remote_state_rg" {
  desdescription = "RG where the remote state st account is being stored"
  typtype = string  
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