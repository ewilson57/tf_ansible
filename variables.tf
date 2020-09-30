variable "prefix" {
  description = "The prefix used for all resources"
  default     = "ansible"
}

variable "location" {
  description = "The Azure Region in which the resources should exist"
  default     = "South Central US"
}

variable "router_wan_ip" {}
variable "admin_username" {}
variable "admin_password" {}
variable "ssh_key" {}
