# =============================================================================
# cloudru_evolution_compute_image — Полный пример
# =============================================================================
# Создание пользовательского образа.
# Включены все обязательные и опциональные поля.
# =============================================================================

resource "cloudru_evolution_compute_image" "example" {
  project_id = var.project_id

  # Обязательные
  name = "tf-example-image"

  zone_identifiers = {
    value = [{
      name = "ru.AZ-1"
    }]
  }

  # Опциональные
  description        = "Пример пользовательского образа, созданного через Terraform"
  display_name       = "TF Example Image"
  min_cpu            = 1
  min_ram            = 1
  min_disk           = 10
  user_data_template = <<-TEMPLATE
    #cloud-config
    package_update: true
  TEMPLATE
}
