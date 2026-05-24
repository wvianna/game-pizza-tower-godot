# Relatorio de Testes - Controles de Teclado

Data: 2026-05-24

## Escopo

- Validar implementacao de controles de teclado no projeto.
- Validar script de smoke para mapeamentos principais.

## Teste 1 - Smoke de mapeamento

Comando executado:

```bash
./scripts/tests/keyboard_controls_smoke_test.sh
```

Resultado:

- [OK] Mover esquerda (A/Seta Esquerda)
- [OK] Mover direita (D/Seta Direita)
- [OK] Mover cima (W/Seta Cima)
- [OK] Mover baixo (S/Seta Baixo)
- [OK] Pulo (Space/Z)
- [OK] Dash (Shift/X)
- [OK] Agarrar/Arremessar (J/C)
- [OK] Taunt/Parry (K/V)
- [OK] Agachar (Ctrl/S/Seta Baixo)
- [OK] Export de telemetria (F8)

Status: Aprovado

## Teste 2 - Boot headless (dependente de engine instalada)

Comando tentado:

```bash
godot4 --headless --quit
```

Resultado:

- Ambiente sem binario godot/godot4 disponivel.
- Teste de boot nao executado neste ambiente.

Status: Bloqueado por dependencia externa

## Evidencias de implementacao

- Mapeamento de input: [scripts/core/input_bootstrap.gd](../../scripts/core/input_bootstrap.gd)
- Script de teste: [scripts/tests/keyboard_controls_smoke_test.sh](../../scripts/tests/keyboard_controls_smoke_test.sh)
- Manual de setup: [README.md](../../README.md)
