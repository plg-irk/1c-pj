# 1C PJ Workspace

Рабочее пространство для разработки на платформе 1С:Предприятие 8.3.27 с поддержкой OpenCode, 1C AI Development Kit skills и подготовленной MCP-конфигурацией.

## Назначение

Проект предназначен для разработки:

- основной конфигурации 1С;
- расширений конфигурации;
- внешних обработок `.epf`;
- внешних отчетов `.erf`;
- спецификаций изменений через OpenSpec.

Файловая информационная база:

```text
File="C:\Users\user\Documents\1C\PJ"
```

Установленная платформа:

```text
C:\Program Files\1cv8\8.3.27.1936\bin\1cv8.exe
```

## Структура

```text
.opencode/             OpenCode config, agents, MCP settings
.claude/skills/        1C AI Development Kit skills
.claude/docs/          спецификации XML/DSL и документация toolkit
src/                   выгрузка основной конфигурации 1С
ext/                   расширения конфигурации
external/epf/          исходники внешних обработок
external/erf/          исходники внешних отчетов
dist/                  собранные CF/CFE/EPF/ERF артефакты
openspec/              спецификации и планы изменений
scripts/mcp/           установка и запуск локальных MCP
schemas/               JSON schemas для локальных настроек
```

## Локальные настройки

Основной файл локальных настроек:

```text
.v8-project.json
```

В нем указаны путь к платформе, файловой базе и каталогам исходников. Файл исключен из git, потому что в будущем может содержать локальные логины или пароли.

Шаблон без секретов:

```text
.v8-project.example.json
```

## Запуск OpenCode

Из корня проекта:

```powershell
opencode .
```

После изменения `.opencode/opencode.json`, agents или skills нужно полностью перезапустить OpenCode. Конфигурация не перечитывается на лету.

## OpenCode Agents

В проект добавлены профильные subagents:

- `onec-code-reviewer` — ревью BSL, XML, форм, расширений и внешних обработок.
- `onec-metadata-dev` — разработка объектов метаданных и конфигурации.
- `onec-form-dev` — управляемые формы и `Form.xml`.
- `onec-query-optimizer` — анализ и оптимизация запросов 1С/СКД.
- `onec-db-ops` — операции с локальной файловой базой и Designer.

## Skills

В проект перенесены skills из `1c-ai-development-kit`:

```text
.claude/skills/
```

OpenCode подключает их через `.opencode/opencode.json`:

```json
"skills": {
  "paths": [".claude/skills"]
}
```

Для задач 1С сначала используйте готовые skills и DSL-генераторы, а не ручное редактирование XML.

Типовые направления:

- `meta-compile`, `meta-edit`, `meta-remove` — объекты метаданных.
- `form-compile`, `form-edit`, `form-add` — управляемые формы.
- `epf-expert`, `erf-expert` — внешние обработки и отчеты.
- `cfe-init`, `cfe-borrow`, `cfe-patch-method` — расширения.
- `db-dump-xml`, `db-load-xml`, `db-update`, `db-run` — операции с базой.
- `inspect`, `validate` — анализ и проверка структуры.

## MCP

MCP-серверы описаны в:

```text
.opencode/opencode.json
```

По умолчанию все MCP выключены, чтобы OpenCode запускался без установленных серверов.

Подготовлены подключения:

- `playwright` — веб-клиент и UI-тесты.
- `bsl-lsp-bridge` — анализ BSL через BSL Language Server bridge.
- `rlm-toolkit` — память между сессиями.
- `edt-mcp` — интеграция с EDT, если сервер установлен.
- `1c-help`, `1c-ssl`, `1c-templates`, `1c-syntax-checker`, `1c-code-checker`, `1c-forms` — внешние/платные 1С MCP placeholders.

### Установка локальных MCP

```powershell
powershell.exe -NoProfile -File scripts/mcp/install-local-mcp.ps1
```

Скрипт клонирует локальные бесплатные MCP в `tools/mcp/` и устанавливает доступные зависимости.

### Запуск локальных MCP

```powershell
powershell.exe -NoProfile -File scripts/mcp/start-local-mcp.ps1
```

Запуск отдельного сервера:

```powershell
powershell.exe -NoProfile -File scripts/mcp/start-local-mcp.ps1 -Server bsl-lsp-bridge
powershell.exe -NoProfile -File scripts/mcp/start-local-mcp.ps1 -Server rlm-toolkit
```

После запуска нужного MCP включите его в `.opencode/opencode.json`:

```json
"enabled": true
```

Затем перезапустите OpenCode.

## Работа с конфигурацией

Исходники основной конфигурации хранятся в `src/` после выгрузки из Designer/EDT.

Расширения хранятся отдельно:

```text
ext/<ИмяРасширения>/
```

Внешние обработки и отчеты:

```text
external/epf/
external/erf/
```

Собранные артефакты для передачи пользователям или загрузки в базу складывайте в `dist/`.

## Проверка BSL

После изменения `.bsl` кода нужно выполнить доступную проверку синтаксиса:

- через MCP `1c-syntax-checker`, если он подключен;
- через EDT/BSL Language Server, если доступен;
- через Designer, если требуется проверка конфигурации.

Если инструмент проверки недоступен, это нужно явно указать в отчете по задаче.

## OpenSpec Workflow

Для крупных изменений используйте OpenSpec:

```text
openspec/changes/      активные предложения
openspec/specs/        актуальные спецификации
openspec/archive/      завершенные изменения
openspec/project.md    контекст проекта
```

Рекомендуемый порядок:

1. Описать изменение в `openspec/changes/<change-id>/proposal.md`.
2. Добавить план в `tasks.md`.
3. Реализовать изменение по шагам.
4. Проверить результат.
5. Перенести завершенное изменение в архив.

## Git

Рекомендуется не коммитить:

- `.dt` dumps;
- локальные `.cf/.cfe/.epf/.erf` вне `dist/`;
- пароли, токены, `.env`;
- `.v8-project.json`.

Разрешено хранить distributable artifacts только в `dist/`.

## Быстрый старт

1. Откройте проект в `C:\1C-PJ`.
2. Запустите OpenCode: `opencode .`.
3. При необходимости установите локальные MCP: `powershell.exe -NoProfile -File scripts/mcp/install-local-mcp.ps1`.
4. Запустите нужные MCP и включите их в `.opencode/opencode.json`.
5. Выгрузите конфигурацию в `src/` или начните разработку через skills/DSL.
