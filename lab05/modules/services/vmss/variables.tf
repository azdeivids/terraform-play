variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
  type = string
  default = "lab05"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  type = string
  default = "UK South"
}