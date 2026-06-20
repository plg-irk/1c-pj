param(
    [ValidateSet("bsl-lsp-bridge", "rlm-toolkit", "all")]
    [string]$Server = "all",
    [string]$InstallRoot = "tools\mcp"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$TargetRoot = Join-Path $ProjectRoot $InstallRoot

function Start-BslLspBridge {
    $Path = Join-Path $TargetRoot "mcp-bsl-lsp-bridge"
    $ServerJs = Join-Path $Path "server.js"
    if (-not (Test-Path -LiteralPath $ServerJs)) {
        throw "server.js not found. Run scripts/mcp/install-local-mcp.ps1 first."
    }
    Write-Output "[INFO] Starting bsl-lsp-bridge on http://localhost:5007/mcp"
    Start-Process -FilePath "node" -ArgumentList "server.js" -WorkingDirectory $Path
}

function Start-RlmToolkit {
    $Path = Join-Path $TargetRoot "rlm-toolkit"
    $ServerPy = Join-Path $Path "server.py"
    if (-not (Test-Path -LiteralPath $ServerPy)) {
        throw "server.py not found. Run scripts/mcp/install-local-mcp.ps1 first."
    }
    Write-Output "[INFO] Starting rlm-toolkit on http://localhost:8200/mcp"
    Start-Process -FilePath "python" -ArgumentList "server.py" -WorkingDirectory $Path
}

if (($Server -eq "bsl-lsp-bridge") -or ($Server -eq "all")) {
    Start-BslLspBridge
}

if (($Server -eq "rlm-toolkit") -or ($Server -eq "all")) {
    Start-RlmToolkit
}

Write-Output "[OK] Requested MCP server start commands were issued."
