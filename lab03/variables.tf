variable "rgname03" {
  description = "Name of the resource group where all the resources will be placed."
  type = string
  default = "tf-vmss-rg"
}
variable "location" {
  description = "Location of the resources"
  type = string
  default = "UK South"
}
variable "vnetname03" {
  description = "Name of the vnet where the vmss will be deployed"
  type = string
  default = "tf-uks-vmssvnet-01"
}
variable "internalsnet03" {
  description = "Name of the where the vmss will be deployed"
  type = string
  default = "tf-uks-vmssvnet-01-snet"
}
variable "tfpip03" {
  description = "Public IP used frot he Load Balancer for the VMSS"
  type = string
  default = "vmss-pip"
}
variable "tflb03" {
  description = "Name of the LB for the VMSS"
  type = string
  default = "vmsslb"
}