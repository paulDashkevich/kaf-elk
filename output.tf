output "external_ip_address" {
  value = ah_cloud_server.pcm.*.ips.0.ip_address
}

output "internal_ip0" {
  value = ah_private_network_connection.lan1.*.ip_address
}

output "internal_ip1" {
  value = ah_private_network_connection.lan2.*.ip_address
}

output "reverse_dns" {
  value = ah_cloud_server.pcm[3].*.ips.0.reverse_dns
}

output "ELK_ext" {
  value = ah_cloud_server.elk.*.ips.0.ip_address
}

output "ELK_int" {
  value = ah_private_network_connection.elk_lan.*.ip_address
}
output "KAFKA_ext" {
  value = ah_cloud_server.kafka.*.ips.0.ip_address
}
output "KAFKA_int" {
  value = ah_private_network_connection.kafka_lan.*.ip_address
}
