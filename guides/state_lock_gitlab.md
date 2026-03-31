# Блокировка Terraform-состояния в GitLab через GitLab CI

Инструкция описывает, как настроить хранение и блокировку Terraform‑состояния (state) в GitLab, если Terraform запускается из GitLab CI, а не локально.

## 1. Зачем нужна блокировка 

Terraform хранит текущее состояние инфраструктуры в `terraform.tfstate`.
При каждом `plan/apply` Terraform:

1. Читает состояние.
2. Рассчитывает изменения.
3. Pаписывает обновленное состояние.

Если два пайплайна или два job’а одновременно работают с одним и тем же state, возможны гонки и порча инфраструктуры.
Locking гарантирует, что в один момент времени только один процесс изменяет state, а остальные ждут или падают с ошибкой блокировки.

GitLab умеет выступать как удаленный backend для Terraform и обеспечивать централизованное хранение и блокировку state.

## 2. Схема работы с GitLab backend

Terraform в GitLab CI использует HTTP-backend, подключенный к GitLab API:

```
projects/{PROJECT_ID}/terraform/state/{STATE_NAME}
└── /lock — блокировка state
```

Последовательность при `terraform plan/apply`:
1. Terraform запрашивает lock (HTTP `POST` на `/lock`).
2. Если lock получен — читает/пишет state.
3. По завершении снимает lock (HTTP `DELETE` на `/lock`).
Результат: только один job изменяет state одновременно.

GitLab хранит данные в своем хранилище (БД или object storage), но вы работаете только с HTTP‑API.

## 3. Подготовка GitLab-проекта

### 3.1. Project ID

Project ID указан в разделе **Проект → Settings → General → Project ID (внизу страницы)**.
Вы можете использовать тот же проект, где хранится Terraform-код.

### 3.2. Имя state (STATE_NAME)

`STATE_NAME` — это произвольный идентификатор state. 
Примеры:

- `dev`, `stage`, `prod`
- `network-dev`, `k8s-prod` и т.п.

Формат: латинские буквы, цифры, `-`, `_`, (без `/`).

Вы можете использовать отдельный state на каждый environment/branch, например:

- `STATE_NAME = "prod"`
- `STATE_NAME = "dev"`
- или `STATE_NAME = "$CI_COMMIT_REF_SLUG"` (по ветке).

## 4. Настройка Terraform backend (GitLab HTTP)

Создайте (или отредактируйте) файл `backend.tf` в корне Terraform‑проекта.

Пример (GitLab.com, один state `prod`):

```hcl path=null start=null
terraform {
  backend "http" {
    address        = "https://gitlab.com/api/v4/projects/1234567/terraform/state/prod"
    lock_address   = "https://gitlab.com/api/v4/projects/1234567/terraform/state/prod/lock"
    unlock_address = "https://gitlab.com/api/v4/projects/1234567/terraform/state/prod/lock"

    lock_method    = "POST"
    unlock_method  = "DELETE"

    # время ожидания между попытками взять lock
    retry_wait_min = 5
  }
}
```

Если GitLab self‑hosted, замените `https://gitlab.com` на ваш домен, например:

```hcl path=null start=null
address        = "https://gitlab.example.com/api/v4/projects/1234567/terraform/state/prod"
```

> **Важно:**
> Не храните в backend‑блоке чувствительные данные (логин/токен).
> Настройте аутентификацию через переменные окружения в GitLab CI.

## 5. Аутентификация Terraform в GitLab из CI

Для HTTP‑backend Terraform может использовать следующие переменные окружения:

- `TF_HTTP_USERNAME`
- `TF_HTTP_PASSWORD`

Рекомендованный паттерн для GitLab CI:

- `TF_HTTP_USERNAME = "gitlab-ci-token"`
- `TF_HTTP_PASSWORD = "$CI_JOB_TOKEN"`

GitLab проверяет пару `gitlab-ci-token` + `CI_JOB_TOKEN` и разрешает доступ к state этого проекта.
Эти переменные необходимо задать в `.gitlab-ci.yml` в разделе `variables`.

### Пример `.gitlab-ci.yml` с блокировкой state

Ниже минимальный пример пайплайна с тремя стадиями:

- `validate` — проверка синтаксиса;
- `plan` — расчет плана;
- `apply` — применение (ручное, чтобы не применять автоматически каждый push).

```yaml path=null start=null
stages:
  - validate
  - plan
  - apply

# Общие переменные
variables:
  TF_ROOT: "."                               # путь к Terraform-каталогу
  TF_HTTP_USERNAME: "gitlab-ci-token"
  TF_HTTP_PASSWORD: "$CI_JOB_TOKEN"
  TF_IN_AUTOMATION: "true"
  TF_INPUT: "false"
  TF_PLAN_FILE: "tfplan.out"

terraform:validate:
  stage: validate
  image: hashicorp/terraform:1.9.0
  script:
    - cd "$TF_ROOT"
    - terraform init -input=false
    - terraform validate
  only:
    - merge_requests
    - main
    - master

terraform:plan:
  stage: plan
  image: hashicorp/terraform:1.9.0
  script:
    - cd "$TF_ROOT"
    - terraform init -input=false
    - terraform plan -out="$TF_PLAN_FILE"
  artifacts:
    paths:
      - "$TF_ROOT/$TF_PLAN_FILE"
    expire_in: 1 day
  only:
    - merge_requests
    - main
    - master

terraform:apply:
  stage: apply
  image: hashicorp/terraform:1.9.0
  needs:
    - job: terraform:plan
      artifacts: true
  script:
    - cd "$TF_ROOT"
    - terraform init -input=false
    - terraform apply -input=false "$TF_PLAN_FILE"
  only:
    - main
    - master
  when: manual           # применение только вручную
  allow_failure: false
```

Как работает блокировка:

1. Каждый job выполняет `terraform init` и подключается к GitLab state.
2. Terraform запрашивает lock (HTTP `POST` на `/lock`).
3. Если lock получен — читает/пишет state.
4. По завершении снимает lock (HTTP `DELETE` на `/lock`).
Результат: только один job изменяет state одновременно.

## 6. Использование разных state для разных окружений

Способы разделения:

- Отдельный state для каждого окружения — `dev`, `stage`, `prod`.
- State по ветке. 

Рассмотрим варианты реализации. 

### 6.1. Разные backend‑файлы / каталоги

Например:

- `envs/dev/backend.tf` → `…/state/dev`
- `envs/prod/backend.tf` → `…/state/prod`

В `.gitlab-ci.yml` необходимо указать `TF_ROOT` в зависимости от job’а или pipeline‑переменной.

### 6.2. Динамическое имя state (по ветке)

Более продвинутый вариант — формировать `STATE_NAME` динамически, но стандартный `backend "http"` не подставляет переменные окружения в `address`. Для простоты лучше явно указать один state (`dev` или `prod`).

## 7. Проверка работы блокировки

Для проверки, что GitLab действительно блокирует state:

1. Подготовка:
   a. `backend "http"` настроен на GitLab.
   b. Пайплайн успешно прошел хотя бы один раз (`terraform init` выполнился, state создан).
2. Тест параллельности:
   a. Запустите одно и то же `terraform:apply` два раза почти одновременно. Например, дождитесь, пока первый `apply` начнет выполняться (и будет ждать подтверждения или долго применять ресурсы).
   b. Запустите второй `terraform:apply` job вручную.
3. Ожидаемый результат:
   a. Первый job получит lock и выполнится.
   b. Второй job:
      - либо будет ожидать (в соответствии с `retry_wait_min`),
      - либо упадет с ошибкой `Error acquiring the state lock`.

Так вы убедитесь, что GitLab‑backend реально предотвращает одновременную запись в один state.

## 8. Безопасность и хранение токенов

В примере выше использовался `CI_JOB_TOKEN` — он автоматически создается GitLab для каждого job’а и имеет ограниченные права.

Если по каким‑то причинам вы хотите использовать PAT:

1. Создайте PAT с минимально возможными правами;
2. Добавьте его в **CI/CD Variables** проекта/группы (например, `TF_GITLAB_PAT`, protected + masked).
3. Используйте в `.gitlab-ci.yml`:

    ```yaml path=null start=null
    variables:
      TF_HTTP_USERNAME: "oauth2"
      TF_HTTP_PASSWORD: "$TF_GITLAB_PAT"
    ```

Храните токены только в CI/CD Variables, не в репозитории.