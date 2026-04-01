variable "project_id" {
  type        = string
  description = "Идентификатор проекта из console.cloud.ru."
}

variable "auth_key_id" {
  type        = string
  description = "Идентификатор ключа доступа сервисного аккаунта."
  sensitive   = true
}

variable "auth_secret" {
  type        = string
  description = "Секрет ключа доступа сервисного аккаунта."
  sensitive   = true
}
