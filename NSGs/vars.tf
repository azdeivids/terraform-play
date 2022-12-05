variable "location" {
  type = string
  default = "uksouth"
}

variable "prefix" {
  type = string
  default = "tf-demo-01"
}

variable "ssh-source-address" {
  type = string
  default = "*"
}