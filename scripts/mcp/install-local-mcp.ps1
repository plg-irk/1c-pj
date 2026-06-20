param(
    [string]$InstallRoot = "tools\mcp"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ProjectRoot = Resolve-Path (Join-Path $PSScriptRoot "..\..")
$TargetRoot = Join-Path $ProjectRoot $InstallRoot

function Assert-Command {
    param([string]$Name)
    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Required command not found: $Name"
    }
}

function Ensure-Repo {
    param(
        [string]$Name,
        [string]$Url
    )

    $Path = Join-Path $TargetRoot $Name
    if (Test-Path -LiteralPath $Path) {
        Write-Output "[INFO] Updating $Name"
        git -C $Path pull --ff-only
        return
    }

    Write-Output "[INFO] Cloning $Name"
    git clone $Url $Path
}

Assert-Command "git"

if (-not (Test-Path -LiteralPath $TargetRoot)) {
    New-Item -ItemType Directory -Path $TargetRoot | Out-Null
}

Ensure-Repo "mcp-bsl-lsp-bridge" "https://github.com/SteelMorgan/mcp-bsl-lsp-bridge.git"
Ensure-Repo "rlm-toolkit" "https://github.com/dmitrii-labintsev/rlm-toolkit.git"

$BslPath = Join-Path $TargetRoot "mcp-bsl-lsp-bridge"
if (Get-Command npm -ErrorAction SilentlyContinue) {
    Write-Output "[INFO] Installing npm dependencies for mcp-bsl-lsp-bridge"
    npm install --prefix $BslPath
}
else {
    Write-Output "[WARN] npm not found. Install Node.js before running bsl-lsp-bridge."
}

$RlmPath = Join-Path $TargetRoot "rlm-toolkit"
$Requirements = Join-Path $RlmPath "requirements.txt"
if ((Test-Path -LiteralPath $Requirements) -and (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Output "[INFO] Installing Python dependencies for rlm-toolkit"
    python -m pip install -r $Requirements
}
elseif (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Output "[WARN] python not found. Install Python before running rlm-toolkit."
}

Write-Output "[OK] Local MCP sources prepared in $TargetRoot"
Write-Output "[INFO] Start servers with scripts/mcp/start-local-mcp.ps1"
