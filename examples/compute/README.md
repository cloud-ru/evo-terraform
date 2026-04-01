# Примеры Compute-ресурсов

Полные `.tf`-конфигурации для всех ресурсов `cloudru_evolution_compute_*`, готовые к `terraform apply`.
Каждый файл содержит обязательные и опциональные поля ресурса.

## Ресурсы

| Файл | Ресурс | Описание |
|---|---|---|
| `compute_subnet.tf` | `compute_subnet` | Подсеть |
| `compute_disk.tf` | `compute_disk` | Диск |
| `compute_security_group.tf` | `compute_security_group` | Группа безопасности |
| `compute_security_group_rule.tf` | `compute_security_group_rule` | Правила группы безопасности |
| `compute_interface.tf` | `compute_interface` | Сетевой интерфейс |
| `compute_external_ip.tf` | `compute_external_ip` | Публичный IP-адрес |
| `compute_vm.tf` | `compute_vm` | Виртуальная машина |
| `compute_image.tf` | `compute_image` | Пользовательский образ |
| `compute_nat_gateway.tf` | `compute_nat_gateway` | SNAT-шлюз |
| `compute_placement_group.tf` | `compute_placement_group` | Группа размещения |

## Быстрый старт
Скопируйте все файлы из папки `examples/compute.`\
Заполните валидные значения в файле `terraform.tfvars.example` - идентификатор проекта и ключ сервисного аккаунта.

Скачайте и установите провайдер из последнего релиза, затем выполните в папке с конфигурационными файлами:
```bash
terraform init
terraform plan
terraform apply
```

В результате - вы получите запущенную виртуальную машину в подсети `10.10.0.0/24`, с настроеным интерфейсом и direct ip.
Так же в рамках данного примера создаются образ, диск, SNAT шлюз, публичный ip адрес, группа безопасности и правила для неё.

## Особенности

- `port_range` в правилах группы безопасности использует формат `начало:конец` (например `22:22`, `1:65535`).
- `cloud_init_userdata` должен быть в base64 — используйте `base64encode()`.
- `cloud_init_userdata` и `image_metadata` в ВМ взаимоисключающие.
- `remote_ip_prefix` и `remote_security_group_identifier` в правилах взаимоисключающие.
- `subnet_address` задаётся в CIDR-нотации (например `10.10.0.0/24`), нельзя указывать одновременно с `prefix_length`.
- Подсеть должна быть маршрутизируемой (`routed_network = true`) для привязки к VPC.
- DNS-серверы сортируются провайдером по алфавиту — указывайте в отсортированном порядке.
