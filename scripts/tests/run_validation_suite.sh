#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
REPORT_DIR="$ROOT_DIR/docs/relatorios"
REPORT_FILE="$REPORT_DIR/validacao-automatica.md"

mkdir -p "$REPORT_DIR"

timestamp="$(date '+%Y-%m-%d %H:%M:%S')"
keyboard_status="APROVADO"
keyboard_output=""
boot_status="BLOQUEADO"
boot_output=""
godot_bin=""

run_and_capture() {
  local cmd="$1"
  set +e
  local output
  output="$(eval "$cmd" 2>&1)"
  local exit_code=$?
  set -e
  echo "$output"
  return "$exit_code"
}

keyboard_cmd="$ROOT_DIR/scripts/tests/keyboard_controls_smoke_test.sh"
set +e
keyboard_output="$($keyboard_cmd 2>&1)"
keyboard_exit=$?
set -e

if [[ $keyboard_exit -ne 0 ]]; then
  keyboard_status="FALHOU"
fi

if command -v godot4 >/dev/null 2>&1; then
  godot_bin="godot4"
elif command -v godot >/dev/null 2>&1; then
  godot_bin="godot"
fi

if [[ -n "$godot_bin" ]]; then
  set +e
  boot_output="$($godot_bin --headless --path "$ROOT_DIR" --quit 2>&1)"
  boot_exit=$?
  set -e

  if [[ $boot_exit -eq 0 ]]; then
    boot_status="APROVADO"
  else
    boot_status="FALHOU"
  fi
else
  boot_output="Binario Godot nao encontrado no ambiente (godot4/godot)."
fi

cat > "$REPORT_FILE" <<EOF
# Relatorio de Validacao Automatica

Data: $timestamp

## Teste 1 - Controles de teclado (smoke)

Status: $keyboard_status

Comando:

\`\`\`bash
./scripts/tests/keyboard_controls_smoke_test.sh
\`\`\`

Saida:

\`\`\`
$keyboard_output
\`\`\`

## Teste 2 - Boot headless do projeto

Status: $boot_status

Comando:

\`\`\`bash
${godot_bin:-godot4} --headless --path . --quit
\`\`\`

Saida:

\`\`\`
$boot_output
\`\`\`

## Resultado geral

EOF

if [[ "$keyboard_status" == "FALHOU" || "$boot_status" == "FALHOU" ]]; then
  echo "- Resultado: FALHA" >> "$REPORT_FILE"
elif [[ "$boot_status" == "BLOQUEADO" ]]; then
  echo "- Resultado: PARCIAL (smoke aprovado, boot bloqueado por dependencia externa)" >> "$REPORT_FILE"
else
  echo "- Resultado: APROVADO" >> "$REPORT_FILE"
fi

echo "Relatorio gerado em: $REPORT_FILE"

if [[ "$keyboard_status" == "FALHOU" ]]; then
  exit 1
fi

exit 0
