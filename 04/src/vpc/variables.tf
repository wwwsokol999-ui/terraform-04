variable "env_name" {
  type        = string
  description = "VPC network and subnet name"
}

variable "zone" {
  type        = string
  description = "Yandex Cloud availability zone"
}

variable "cidr" {
  type        = string
  description = "Subnet CIDR"
}

