# Local MCP Setup

This project prepares MCP configuration in `.opencode/opencode.json`, but all MCP servers are disabled by default.

## Free Local MCP Servers

- `playwright`: can be enabled directly in `.opencode/opencode.json`; OpenCode will run `npx -y @playwright/mcp`.
- `bsl-lsp-bridge`: install with `scripts/mcp/install-local-mcp.ps1`, then start with `scripts/mcp/start-local-mcp.ps1 -Server bsl-lsp-bridge`.
- `rlm-toolkit`: install with `scripts/mcp/install-local-mcp.ps1`, then start with `scripts/mcp/start-local-mcp.ps1 -Server rlm-toolkit`.

## Paid Or External MCP Servers

The following servers are placeholders and remain disabled until real URLs are available:

- `1c-help`
- `1c-ssl`
- `1c-templates`
- `1c-syntax-checker`
- `1c-code-checker`
- `1c-forms`
- `edt-mcp`

After a server is installed and started, change its `enabled` field in `.opencode/opencode.json` from `false` to `true`, then restart OpenCode.
