resource "local_file" "inventory" {
  content = templatefile("${path.module}/inventory.tftpl", {
    webservers = yandex_compute_instance.web
    databases  = values(yandex_compute_instance.db)
    storage    = yandex_compute_instance.storage
  })

  filename = "${path.module}/inventory.ini"
}
