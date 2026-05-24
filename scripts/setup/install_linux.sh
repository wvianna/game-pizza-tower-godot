#!/usr/bin/env bash

set -euo pipefail

METHOD="auto"
DRY_RUN=false

usage() {
  cat <<'EOF'
Uso:
  ./scripts/setup/install_linux.sh [--method auto|snap|flatpak|pacman|manual] [--dry-run]

Exemplos:
  ./scripts/setup/install_linux.sh --dry-run
  ./scripts/setup/install_linux.sh --method snap
  ./scripts/setup/install_linux.sh --method manual

Notas:
- Este script prioriza Godot 4.
- Nao usa apt por padrao para evitar instalar Godot 3 em distros que nao possuem pacote godot4.
EOF
}

log() {
  printf '[setup] %s\n' "$1"
}

run_cmd() {
  if [[ "$DRY_RUN" == true ]]; then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi

  "$@"
}

run_as_root() {
  if [[ "$(id -u)" -eq 0 ]]; then
    run_cmd "$@"
    return
  fi

  if command -v sudo >/dev/null 2>&1; then
    run_cmd sudo "$@"
    return
  fi

  log "Erro: sudo nao encontrado e o script nao esta em modo root."
  exit 1
}

is_godot_installed() {
  command -v godot4 >/dev/null 2>&1 || command -v godot >/dev/null 2>&1
}

install_snap() {
  if ! command -v snap >/dev/null 2>&1; then
    log "snap nao encontrado."
    return 1
  fi

  log "Instalando Godot 4 via Snap..."
  run_as_root snap install godot4 --classic
  return 0
}

install_flatpak() {
  if ! command -v flatpak >/dev/null 2>&1; then
    log "flatpak nao encontrado."
    return 1
  fi

  log "Instalando Godot via Flatpak..."
  if ! flatpak remotes --columns=name | grep -qx 'flathub'; then
    run_cmd flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  fi

  run_cmd flatpak install -y flathub org.godotengine.Godot
  return 0
}

install_pacman() {
  if ! command -v pacman >/dev/null 2>&1; then
    log "pacman nao encontrado."
    return 1
  fi

  log "Instalando Godot via pacman..."
  run_as_root pacman -S --noconfirm godot
  return 0
}

manual_instructions() {
  cat <<'EOF'
Instalacao manual (Linux):
1. Acesse: https://godotengine.org/download/linux/
2. Baixe o binario oficial do Godot 4.
3. Extraia o arquivo.
4. Dê permissao de execucao ao binario.
5. Execute o binario e importe o projeto.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --method)
      METHOD="${2:-}"
      shift 2
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      log "Argumento invalido: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ -z "$METHOD" ]]; then
  log "Metodo invalido."
  usage
  exit 1
fi

if is_godot_installed; then
  log "Godot ja instalado em: $(command -v godot4 || command -v godot)"
  exit 0
fi

case "$METHOD" in
  snap)
    install_snap || exit 1
    ;;
  flatpak)
    install_flatpak || exit 1
    ;;
  pacman)
    install_pacman || exit 1
    ;;
  manual)
    manual_instructions
    exit 0
    ;;
  auto)
    install_snap || install_flatpak || install_pacman || {
      log "Nao foi possivel instalar automaticamente neste ambiente."
      manual_instructions
      exit 1
    }
    ;;
  *)
    log "Metodo invalido: $METHOD"
    usage
    exit 1
    ;;
esac

if is_godot_installed; then
  log "Instalacao concluida."
  log "Binario detectado em: $(command -v godot4 || command -v godot)"
  exit 0
fi

log "Instalacao executada, mas o binario nao foi detectado no PATH atual."
log "Abra um novo terminal e execute: godot4 --version"
exit 0
