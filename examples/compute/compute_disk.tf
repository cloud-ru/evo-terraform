# =============================================================================
# cloudru_evolution_compute_disk — Полный пример
# =============================================================================
# Создание диска в указанной зоне доступности.
# Включены все обязательные и опциональные поля.
# =============================================================================

resource "cloudru_evolution_compute_disk" "example" {
  project_id = var.project_id

  # Обязательные
  name = "tf-example-disk"
  size = 20

  zone_identifier = {
    name = "ru.AZ-1"
  }

  disk_type_identifier = {
    name = "SSD"
  }

  # Опциональные
  description = "Пример диска, созданного через Terraform"
  bootable    = true
  image_id    = "474c9e98-760f-4e54-aaa9-70024814f2b0"
  encrypted   = false
  readonly    = false
  shared      = false
}
