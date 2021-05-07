resource "ah_cloud_server" "pcm" {
  backups    = false
  count      = 8
  name       = "node_${count.index}"
  datacenter = var.ah_dc
  image      = var.ah_image_type
  product    = var.ah_machine_type
  ssh_keys   = [var.ah_fp]
}
#######################################################ELK
resource "ah_cloud_server" "elk" {
  backups    = false
  count      = 1
  name       = "elk_${count.index}"
  datacenter = var.ah_dc
  image      = var.ah_image_type
  product    = var.ah_machine_type2
  ssh_keys   = [var.ah_fp]
}
#######################################################ELK
###KAFKA##################################################
resource "ah_cloud_server" "kafka" {
  backups    = false
  count      = 1
  name       = "kafka_${count.index}"
  datacenter = var.ah_dc
  image      = var.ah_image_type
  product    = var.ah_machine_type2
  ssh_keys   = [var.ah_fp]
}
###KAFKA##################################################
resource "ah_volume" "harddrive" {
    name        = "hdd"
    product     = var.ah_hdd
    file_system = "ext4"
    size        = "2"
}
resource "ah_volume_attachment" "add-hdd" {
  cloud_server_id = ah_cloud_server.pcm[0].id
    volume_id     = ah_volume.harddrive.id
    depends_on = [
        ah_cloud_server.pcm
    ]
}

resource "ah_private_network" "lan1" {
  ip_range = "10.1.0.0/27"
  name     = "LAN1"
    depends_on = [
    ah_cloud_server.pcm
    ]
}

resource "ah_private_network_connection" "lan1" {
  count              = 8
  cloud_server_id    = ah_cloud_server.pcm[count.index].id
  private_network_id = ah_private_network.lan1.id
  ip_address         = "10.1.0.1${count.index}"
}
#######################################################ELK
resource "ah_private_network_connection" "elk_lan" {
  count              = 1
  cloud_server_id    = ah_cloud_server.elk[count.index].id
  private_network_id = ah_private_network.lan2.id
  ip_address         = "10.1.1.7"
}
#######################################################ELK
###KAFKA##################################################
resource "ah_private_network_connection" "kafka_lan" {
  count              = 1
  cloud_server_id    = ah_cloud_server.kafka[count.index].id
  private_network_id = ah_private_network.lan2.id
  ip_address         = "10.1.1.8"
}
###KAFKA##################################################

resource "ah_private_network" "lan2" {
  ip_range = "10.1.1.0/27"
  name     = "LAN2"
  depends_on = [
    ah_private_network.lan1
    ]
}
resource "ah_private_network_connection" "lan2" {
  count              = 3
  cloud_server_id    = ah_cloud_server.pcm[count.index].id
  private_network_id = ah_private_network.lan2.id
  ip_address         = "10.1.1.1${count.index}"
  depends_on = [
  ah_private_network_connection.lan1
 ]
}