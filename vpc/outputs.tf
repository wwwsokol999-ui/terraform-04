output "network_id" {
  value       = yandex_vpc_network.this.id
  description = "VPC network ID"
}

output "subnet_id" {
  value       = yandex_vpc_subnet.this.id
  description = "Subnet ID"
}

output "subnet" {
  value       = yandex_vpc_subnet.this
  description = "Subnet resource information"
}
