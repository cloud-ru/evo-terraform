# =============================================================================
# cloudru_evolution_compute_placement_group — Полный пример
# =============================================================================
# Создание группы размещения для управления распределением ВМ по хостам.
# Включены все обязательные и опциональные поля.
# =============================================================================

resource "cloudru_evolution_compute_placement_group" "example" {
  project_id = var.project_id

  # Обязательные
  name   = "tf-example-placement-group"
  policy = "PLACEMENT_GROUP_POLICY_SOFT_ANTI_AFFINITY"

  # Опциональные
  description = "Пример группы размещения, созданной через Terraform"
}
