# =============================================================================
# cloudru_evolution_compute_security_group_rule — Полный пример
# =============================================================================
# Создание правил группы безопасности (входящий и исходящий трафик).
# Включены все обязательные и опциональные поля.
#
# Формат port_range: "начало:конец" (например "80:80" или "1:65535").
# Поля remote_ip_prefix и remote_security_group_identifier взаимоисключающие.
# =============================================================================

# Разрешить входящий SSH (порт 22)
resource "cloudru_evolution_compute_security_group_rule" "ingress_ssh" {
  # Обязательные
  security_group_id = cloudru_evolution_compute_security_group.example.id
  direction         = "TRAFFIC_DIRECTION_INGRESS"
  ether_type        = "ETHER_TYPE_IPV4"
  ip_protocol       = "IP_PROTOCOL_TCP"
  port_range        = "22:22"

  # Опциональные
  description      = "Разрешить входящий SSH"
  remote_ip_prefix = "0.0.0.0/0"
}

# Разрешить входящий HTTP (порт 80)
resource "cloudru_evolution_compute_security_group_rule" "ingress_http" {
  # Обязательные
  security_group_id = cloudru_evolution_compute_security_group.example.id
  direction         = "TRAFFIC_DIRECTION_INGRESS"
  ether_type        = "ETHER_TYPE_IPV4"
  ip_protocol       = "IP_PROTOCOL_TCP"
  port_range        = "80:80"

  # Опциональные
  description      = "Разрешить входящий HTTP"
  remote_ip_prefix = "0.0.0.0/0"
}

# Разрешить входящий HTTPS (порт 443)
resource "cloudru_evolution_compute_security_group_rule" "ingress_https" {
  # Обязательные
  security_group_id = cloudru_evolution_compute_security_group.example.id
  direction         = "TRAFFIC_DIRECTION_INGRESS"
  ether_type        = "ETHER_TYPE_IPV4"
  ip_protocol       = "IP_PROTOCOL_TCP"
  port_range        = "443:443"

  # Опциональные
  description      = "Разрешить входящий HTTPS"
  remote_ip_prefix = "0.0.0.0/0"
}

# Разрешить весь исходящий TCP-трафик
resource "cloudru_evolution_compute_security_group_rule" "egress_all" {
  # Обязательные
  security_group_id = cloudru_evolution_compute_security_group.example.id
  direction         = "TRAFFIC_DIRECTION_EGRESS"
  ether_type        = "ETHER_TYPE_IPV4"
  ip_protocol       = "IP_PROTOCOL_TCP"
  port_range        = "1:65535"

  # Опциональные
  description      = "Разрешить весь исходящий TCP-трафик"
  remote_ip_prefix = "0.0.0.0/0"
}

# Разрешить весь TCP-трафик от той же группы безопасности
resource "cloudru_evolution_compute_security_group_rule" "ingress_from_sg" {
  # Обязательные
  security_group_id = cloudru_evolution_compute_security_group.example.id
  direction         = "TRAFFIC_DIRECTION_INGRESS"
  ether_type        = "ETHER_TYPE_IPV4"
  ip_protocol       = "IP_PROTOCOL_TCP"
  port_range        = "1:65535"

  # Опциональные (remote_security_group_identifier вместо remote_ip_prefix)
  description = "Разрешить весь TCP от той же группы безопасности"

  remote_security_group_identifier = {
    id = cloudru_evolution_compute_security_group.example.id
  }
}
