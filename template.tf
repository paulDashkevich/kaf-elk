resource "local_file" "AnsibleInventory" {
  content = templatefile("ansible/inventory.tpl",
    {
      ip               = ah_cloud_server.pcm.*.ips.0.ip_address,
      int_ip           = ah_private_network_connection.lan1.*.ip_address,
      int_ip2          = ah_private_network_connection.lan2.*.ip_address,
      ext_elk          = ah_cloud_server.elk.*.ips.0.ip_address,
      elk_ip           = ah_private_network_connection.elk_lan.*.ip_address,
      ext_kafka        = ah_cloud_server.kafka.*.ips.0.ip_address,
      kafka_ip         = ah_private_network_connection.kafka_lan.*.ip_address,
      proxy_reverse_ip = ah_cloud_server.pcm[3].*.ips.0.reverse_dns
    }
  )
  filename = "hosts"
}
