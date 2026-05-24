param(
  [ValidateSet("auto", "winget", "choco", "manual")]
  [string]$Method = "auto",
  [switch]$DryRun
)

$ErrorActionPreference = "Stop"

function Write-Step {
  param([string]$Message)
  Write-Host "[setup] $Message"
}

function Test-GodotInstalled {
  return (Get-Command godot4 -ErrorAction SilentlyContinue) -or (Get-Command godot -ErrorAction SilentlyContinue)
}

function Invoke-SetupCommand {
  param([string]$Command)

  if ($DryRun) {
    Write-Host "[dry-run] $Command"
    return $true
  }

  try {
    & powershell -NoProfile -ExecutionPolicy Bypass -Command $Command
    return ($LASTEXITCODE -eq 0)
  }
  catch {
    return $false
  }
}

function Install-WithWinget {
  if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Step "winget nao encontrado."
    return $false
  }

  $candidateIds = @(
    "GodotEngine.GodotEngine",
    "GodotEngine.Godot"
  )

  foreach ($id in $candidateIds) {
    Write-Step "Tentando instalar via winget (id: $id)..."
    $ok = Invoke-SetupCommand "winget install --id $id -e --accept-package-agreements --accept-source-agreements"
    if ($ok) {
      return $true
    }
  }

  Write-Step "winget nao conseguiu instalar usando IDs conhecidos."
  return $false
}

function Install-WithChoco {
  if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Step "Chocolatey nao encontrado."
    return $false
  }

  Write-Step "Tentando instalar via Chocolatey..."
  return (Invoke-SetupCommand "choco install godot --yes")
}

function Show-ManualInstructions {
  Write-Host "Instalacao manual (Windows):"
  Write-Host "1. Acesse: https://godotengine.org/download/windows/"
  Write-Host "2. Baixe o binario oficial do Godot 4."
  Write-Host "3. Extraia o arquivo ZIP."
  Write-Host "4. Execute o binario e importe project.godot."
}

if (Test-GodotInstalled) {
  Write-Step "Godot ja instalado neste ambiente."
  exit 0
}

switch ($Method) {
  "winget" {
    if (-not (Install-WithWinget)) { exit 1 }
  }
  "choco" {
    if (-not (Install-WithChoco)) { exit 1 }
  }
  "manual" {
    Show-ManualInstructions
    exit 0
  }
  "auto" {
    if (-not (Install-WithWinget)) {
      if (-not (Install-WithChoco)) {
        Show-ManualInstructions
        exit 1
      }
    }
  }
}

if (Test-GodotInstalled) {
  Write-Step "Instalacao concluida."
  exit 0
}

Write-Step "Instalacao executada, mas o comando godot/godot4 nao foi detectado no PATH atual."
Write-Step "Feche e abra um novo terminal e execute: godot4 --version"
exit 0
