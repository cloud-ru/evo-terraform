- [ВНИМАНИЕ: minor release 2.1.4](#внимание-minor-release-214)
- [Быстрый старт](#быстрый-старт)
- [Структура репозитория](#структура-репозитория)
- [Поддерживаемые ресурсы](#поддерживаемые-ресурсы)
- [Обратная связь](#обратная-связь)

## ВНИМАНИЕ: minor release 2.1.4

**Вышел релиз провайдера 2.1.4 (minor update).
Внимательно ознакомьтесь с [release note](https://github.com/cloud-ru/evo-terraform/blob/main/releases/2.1.4.md)!**

Документация из директорий ``guides`` и ``troubleshooting`` находится в разделах [Инструкции](https://cloud.ru/docs/terraform-evolution/ug/topics/guides?source-platform=Evolution) и [Решение проблем](https://cloud.ru/docs/terraform-evolution/ug/topics/troubleshooting?source-platform=Evolution) на официальном сайте Cloud.ru

## Быстрый старт

Для начала работы с Terraform-провайдером Cloud.ru Evolution воспользуйтесь [руководством по быстрому старту](https://cloud.ru/docs/terraform-evolution/ug/topics/quickstart)

## Структура репозитория

```
.
├── reference/                      — справочник по всем ресурсам и data sources провайдера
│   ├── data-sources/               — описание источников данных (data source)
│   ├── resources/                  — описание управляемых ресурсов (resource)
│   └── main.tf                     — пример основного конфигурационного файла, с метаданными провайдера (id проекта, ключ сервисного аккаунта)
└── releases/                       — release notes по версиям провайдера
```

## Поддерживаемые ресурсы

Провайдер поддерживает ресурсы следующих сервисов Cloud.ru Evolution:

| Сервис | Описание |
|--------|----------|
| IaaS | Виртуальные машины, диски, подсети и другие ресурсы |
| Bare Metal | Аренда выделенных серверов |
| Managed Kubernetes (mk8s) | Кластеры и node-pools |
| VPC | Виртуальные частные сети |
| Magic Router | Маршрутизация между VPC |
| DNS | Публичные и приватные зоны |
| Network Load Balancer | Сетевые балансировщики нагрузки |
| Object Storage (S3) | Объектное хранилище |
| Kafka | Брокер сообщений |
| Redis | In-memory база данных |
| Managed PostgreSQL | Управляемая СУБД |
| IAM | Сервисные аккаунты, ключи доступа, группы |
| Spark | Фреймворк для обработки и анализа больших объемов данных |
| Trino | Система для выполнения SQL-запросов |
| Managed BI | Сервис бизнес аналитики |
| Managed Clickhouse | Управляемая СУБД |

Полный список поддерживаемых ресурсов и датасорсов — в папке [reference](reference/).

## Обратная связь

Обратную связь можно оставить в консоли Cloud.ru Evolution: **Помощь и документация** → **Есть предложения?**