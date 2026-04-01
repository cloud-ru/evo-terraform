# =============================================================================
# cloudru_evolution_compute_vm — Полный пример
# =============================================================================
# Создание виртуальной машины с диском, сетевым интерфейсом и cloud-init.
# Включены все обязательные и опциональные поля.
#
# Зависимости: compute_disk, compute_interface, compute_placement_group
#
# Поля cloud_init_userdata и image_metadata взаимоисключающие.
# Значение cloud_init_userdata должно быть в формате base64.
# =============================================================================

resource "cloudru_evolution_compute_vm" "example" {
  project_id = var.project_id

  # Обязательные
  name = "tf-example-vm"

  zone_identifier = {
    name = "ru.AZ-1"
  }

  flavor_identifier = {
    name = "gen-1-1"
  }

  # Опциональные
  description = "Пример виртуальной машины, созданной через Terraform"

  disk_identifiers = [{
    disk_id = cloudru_evolution_compute_disk.example.id
  }]

  network_interfaces = [{
    interface_id = cloudru_evolution_compute_interface.example.id
  }]

  placement_group_id = cloudru_evolution_compute_placement_group.example.id

  cloud_init_userdata = base64encode(<<-CLOUDINIT
    #cloud-config
    package_update: true
    packages:
      - curl
      - wget
    runcmd:
      - echo "Hello from Terraform!" > /tmp/hello.txt
  CLOUDINIT
  )
}
