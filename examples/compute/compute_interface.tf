# =============================================================================
# cloudru_evolution_compute_interface — Полный пример
# =============================================================================
# Создание сетевого интерфейса, привязанного к подсети и группе безопасности.
# Включены все обязательные и опциональные поля.
# =============================================================================

resource "cloudru_evolution_compute_interface" "example" {
  project_id = var.project_id

  # Обязательные
  name = "tf-example-interface"

  zone_identifier = {
    name = "ru.AZ-1"
  }

  # Опциональные
  description                = "Пример сетевого интерфейса, созданного через Terraform"
  subnet_id                  = cloudru_evolution_compute_subnet.example.id
  interface_security_enabled = true

  security_groups_identifiers = {
    value = [{
      id = cloudru_evolution_compute_security_group.example.id
    }]
  }

  # Назначить новый публичный IP-адрес интерфейсу
  external_ip_specs = {
    new_external_ip = true
  }

  type = "INTERFACE_TYPE_REGULAR"
}
