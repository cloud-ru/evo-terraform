# =============================================================================
# cloudru_evolution_compute_subnet — Полный пример
# =============================================================================
# Создание подсети в указанной зоне доступности.
# Включены все обязательные и опциональные поля.
# =============================================================================

resource "cloudru_evolution_compute_subnet" "example" {
  project_id = var.project_id

  # Обязательные
  name = "tf-example-subnet"

  zone_identifier = {
    name = "ru.AZ-1"
  }

  # Опциональные
  description    = "Пример подсети, созданной через Terraform"
  subnet_address = "10.10.0.0/24"
  routed_network = true
  default        = false
  vpc_id         = "57b8f93a-b433-4da9-b24f-87cc69da9afc"

  dns_servers = {
    value = ["8.8.4.4", "8.8.8.8"]
  }
}
