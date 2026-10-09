terraform {
  required_providers {
    cloudru = {
      # NOTE: Это обязательные параметры
      # Если вы используете dev_overrides в .terraformc, то полное имя
      # провайдера будет cloud.ru/cloudru/cloud
      source  = "cloudru/cloud"
      version = "2.1.4"
    }
  }
}

provider "cloudru" {
  # NOTE: Это опциональный параметр.
  # Идентификатор проекта вы можете взять из личного кабинета
  # console.cloud.ru.
  project_id = ""

  # Создайте персональный ключ доступа для сервисного аккаунта в личном кабинете
  # по инструкции: https://cloud.ru/docs/console_api/ug/topics/guides__api_key?source-platform=Evolution.
  # NOTE: Это опциональные параметры.
  # Значения auth_key_id и auth_secret в конфигурации имеют приоритет.
  # Если параметр не указан, используется соответствующая переменная окружения:
  # AUTH_KEY_ID для auth_key_id и AUTH_SECRET для auth_secret.
  # Для использования переменных окружения удалите или закомментируйте
  # соответствующие строки ниже. Пустая строка не включает fallback.
  # Если итоговое значение любого из параметров пустое, провайдер вернёт ошибку.
  auth_key_id = ""
  auth_secret = ""

  # Регион объектного хранилища.
  # На текущий момент поддерживается только один регион - ru-central-1.
  # NOTE: Это опциональный параметр
  region = "ru-central-1"

  # Идентификатор тенанта объектного хранилища.
  # Скопируйте его из console.cloud.ru, открыв вкладку "Object storage".
  # NOTE: Это опциональный параметр
  object_storage_tenant_id = ""

  # Ендпоинты сервисов продуктов.
  # NOTE: Это опциональные параметры
  # Используйте данный блок, если хотите переопределить провайдер на другие адреса.
  endpoints = {
    # IAM
    iam_endpoint = "iam.api.cloud.ru:443"

    # === Продукты группы IaaS ===
    # Виртуальные машины
    compute_endpoint = "compute.api.cloud.ru:443"

    # Аренда baremetal серверов
    baremetal_endpoint = "baremetal.api.cloud.ru:443"
    # ===

    # Managed Kubernetes
    mk8s_endpoint = "mk8s.api.cloud.ru:443"

    # === Продукты группы Network ===
    # VPC
    vpc_endpoint = "vpc.api.cloud.ru:443"

    # Magic router
    magic_router_endpoint = "magic-router.api.cloud.ru:443"

    # DNS
    dns_endpoint = "dns.api.cloud.ru:443"

    # Load balancer
    nlb_endpoint = "nlb.api.cloud.ru:443"
    # ===

    # === Продукты группы DBaaS ===
    # Kafka
    kafka_endpoint = "kafka.api.cloud.ru:443"

    # Redis
    redis_endpoint = "redis.api.cloud.ru:443"

    # PostgreSQL
    postgresql_endpoint = "postgresql.api.cloud.ru:443"

    # Clickhouse
    clickhouse_endpoint = "clickhouse.api.cloud.ru:443"
    # ===

    # === Продукты группы DataPlatform ===
    # Spark
    spark_endpoint = "dataplatform.api.cloud.ru:443"

    # Trino
    trino_endpoint = "dataplatform.api.cloud.ru:443"

    # Metastore
    metastore_endpoint = "dataplatform.api.cloud.ru:443"

    # BI
    bi_endpoint = "dataplatform.api.cloud.ru:443"
    
    # Data Platform
    dataplatform_endpoint = "dataplatform.api.cloud.ru:443"
    # ===

    # Artifact Registry
    artifact_registry_endpoint = "ar.api.cloud.ru:443"

    # Объектное хранилище (S3)
    object_storage_endpoint = "https://s3.cloud.ru"

    # Работа с организациями
    cloud_platform_endpoint = "organization.api.cloud.ru:443"

    # Менеджер ресурсов
    rm_endpoint = "resource-manager.api.cloud.ru"
  }
}
