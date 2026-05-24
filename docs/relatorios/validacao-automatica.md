# Relatorio de Validacao Automatica

Data: 2026-05-24 12:47:18

## Teste 1 - Controles de teclado (smoke)

Status: APROVADO

Comando:

```bash
./scripts/tests/keyboard_controls_smoke_test.sh
```

Saida:

```
== Validando mapeamento de teclado em input_bootstrap.gd ==
[OK] Mover esquerda (A/Seta Esquerda)
[OK] Mover direita (D/Seta Direita)
[OK] Mover cima (W/Seta Cima)
[OK] Mover baixo (S/Seta Baixo)
[OK] Pulo (Space/Z)
[OK] Dash (Shift/X)
[OK] Agarrar/Arremessar (J/C)
[OK] Taunt/Parry (K/V)
[OK] Agachar (Ctrl/S/Seta Baixo)
[OK] Export de telemetria (F8)
== Teste finalizado com sucesso ==
```

## Teste 2 - Boot headless do projeto

Status: APROVADO

Comando:

```bash
godot4 --headless --path . --quit
```

Saida:

```
Godot Engine v4.5.stable.official.876b29033 - https://godotengine.org
```

## Resultado geral

- Resultado: APROVADO
