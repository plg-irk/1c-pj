# 1C Project Workspace

Проект настроен для разработки на платформе 1С:Предприятие 8.3.27.

## Project Profile

- Type: configuration + extensions + external processors/reports.
- Infobase: file infobase.
- Connection string: `File="C:\Users\user\Documents\1C\PJ"`.
- Main configuration source: `src/`.
- Extensions source: `ext/`.
- External processors: `external/epf/`.
- External reports: `external/erf/`.
- Build artifacts: `dist/`.

## 1C Development Rules

- Prefer existing 1C skills and DSL generators before editing XML manually.
- For BSL code, use Russian identifiers and platform terminology where appropriate.
- Use tabs for indentation in `.bsl` files.
- Do not guess 1C platform APIs. If MCP documentation is unavailable, state that explicitly and use the local project sources as the next best context.
- After writing BSL, validate syntax when `1c-syntax-checker`, EDT, BSL LS, or Designer validation is available.
- Treat base configuration changes and extension changes separately. Put extension-only work under `ext/`.
- Do not commit local credentials, infobase dumps, or generated temp files.

## MCP Policy

- MCP servers are configured in `.opencode/opencode.json`.
- Local/free servers are prepared but disabled until installed and started, except Playwright which can be enabled through `npx`.
- Paid/external 1C MCP servers are placeholders and must remain disabled until real URLs are provided.
- If an MCP server is disabled or unreachable, do not pretend it was used.

## Workflow

- For small changes, edit directly and verify with available local tools.
- For larger changes, write an OpenSpec proposal under `openspec/changes/` before implementation.
- Store source XML in `src/` after export from Designer or EDT.
- Store extension XML in `ext/<ExtensionName>/`.
- Store distributable binaries only in `dist/`.
