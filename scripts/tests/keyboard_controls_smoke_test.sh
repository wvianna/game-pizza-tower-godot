#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INPUT_FILE="$ROOT_DIR/scripts/core/input_bootstrap.gd"

if [[ ! -f "$INPUT_FILE" ]]; then
  echo "[ERRO] Arquivo nao encontrado: $INPUT_FILE"
  exit 1
fi

assert_contains() {
  local label="$1"
  local needle="$2"

  if grep -Fq "$needle" "$INPUT_FILE"; then
    echo "[OK] $label"
  else
    echo "[FALHA] $label"
    echo "  esperado conter: $needle"
    exit 1
  fi
}

echo "== Validando mapeamento de teclado em input_bootstrap.gd =="

assert_contains "Mover esquerda (A/Seta Esquerda)" "_ensure_action(\"move_left\", [_key(KEY_A), _key(KEY_LEFT)"
assert_contains "Mover direita (D/Seta Direita)" "_ensure_action(\"move_right\", [_key(KEY_D), _key(KEY_RIGHT)"
assert_contains "Mover cima (W/Seta Cima)" "_ensure_action(\"move_up\", [_key(KEY_W), _key(KEY_UP)"
assert_contains "Mover baixo (S/Seta Baixo)" "_ensure_action(\"move_down\", [_key(KEY_S), _key(KEY_DOWN)"
assert_contains "Pulo (Space/Z)" "_ensure_action(\"jump\", [_key(KEY_SPACE), _key(KEY_Z)"
assert_contains "Dash (Shift/X)" "_ensure_action(\"dash\", [_key(KEY_SHIFT), _key(KEY_X)"
assert_contains "Agarrar/Arremessar (J/C)" "_ensure_action(\"grab_throw\", [_key(KEY_J), _key(KEY_C)"
assert_contains "Taunt/Parry (K/V)" "_ensure_action(\"taunt_parry\", [_key(KEY_K), _key(KEY_V)"
assert_contains "Agachar (Ctrl/S/Seta Baixo)" "_ensure_action(\"crouch\", [_key(KEY_CTRL), _key(KEY_S), _key(KEY_DOWN)"
assert_contains "Export de telemetria (F8)" "_ensure_action(\"telemetry_export\", [_key(KEY_F8)])"

echo "== Teste finalizado com sucesso =="
