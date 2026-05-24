# Handoff para Proximo Agente

Data de referencia: 2026-05-24

## 1. Objetivo deste handoff

Este documento resume o estado real do projeto para permitir continuidade imediata sem retrabalho.

## 2. Fontes de verdade

Prioridade de decisao:

1. [backlog-execucao.md](backlog-execucao.md)
2. [plano-desenvolvimento.md](plano-desenvolvimento.md)
3. [requisitos.txt](requisitos.txt)
4. [controles.txt](controles.txt)

Regras do agente:

- [../.github/copilot-instructions.md](../.github/copilot-instructions.md)
- [agente-ia-implementacao.md](agente-ia-implementacao.md)

## 3. Estado atual do jogo

Main scene atual:

- [../project.godot](../project.godot) -> [../scenes/levels/level_01.tscn](../scenes/levels/level_01.tscn)

Fluxo implementado:

1. Nivel 1 -> Nivel 2 -> Nivel 3
2. Em cada nivel: explorar, coletar toppings, destruir Pillar John, iniciar fuga com cronometro, voltar para area de saida.
3. Conclusao do nivel 3 abre tela final.

Arquivos principais deste fluxo:

- Controlador de fase: [../scripts/game/level_controller.gd](../scripts/game/level_controller.gd)
- Pilar objetivo: [../scripts/environment/pillar_john.gd](../scripts/environment/pillar_john.gd)
- Coletavel: [../scripts/environment/collectible_topping.gd](../scripts/environment/collectible_topping.gd)
- Tela final: [../scripts/game/victory_screen.gd](../scripts/game/victory_screen.gd)
- Cenas de campanha:
  - [../scenes/levels/level_01.tscn](../scenes/levels/level_01.tscn)
  - [../scenes/levels/level_02.tscn](../scenes/levels/level_02.tscn)
  - [../scenes/levels/level_03.tscn](../scenes/levels/level_03.tscn)
  - [../scenes/game/victory_screen.tscn](../scenes/game/victory_screen.tscn)

## 4. Arquitetura atual (resumo)

Player por composicao:

- [../scripts/player/player.gd](../scripts/player/player.gd)
- Componentes em [../scripts/components](../scripts/components)

Componentes ja implementados:

- Movimento base: [../scripts/components/move_component.gd](../scripts/components/move_component.gd)
- Pulo/Super Jump/Body Slam: [../scripts/components/jump_component.gd](../scripts/components/jump_component.gd)
- Dash tiers: [../scripts/components/dash_component.gd](../scripts/components/dash_component.gd)
- State machine base: [../scripts/components/state_machine_component.gd](../scripts/components/state_machine_component.gd)
- Grab/Throw: [../scripts/components/grab_throw_component.gd](../scripts/components/grab_throw_component.gd)
- Parry/Taunt: [../scripts/components/parry_taunt_component.gd](../scripts/components/parry_taunt_component.gd)
- Telemetria local: [../scripts/components/telemetry_component.gd](../scripts/components/telemetry_component.gd)

Visual/fase:

- Art pass inicial registrado em [relatorios/art-pass-01.md](relatorios/art-pass-01.md)

## 5. Status por issue (consolidado)

### 5.1 Concluido ou funcionalmente entregue

- GZ-001, GZ-002, GZ-003, GZ-004, GZ-005
- GZ-006, GZ-007, GZ-008, GZ-009, GZ-010
- GZ-011, GZ-012, GZ-013
- GZ-015 (HUD funcional de objetivo/tempo/coletaveis)
- GZ-016 (coletaveis por fase)
- GZ-019 (fase 2 implementada)
- GZ-021 (fase 3 implementada)

### 5.2 Parcial (requer completar criterio original do backlog)

- GZ-014: existe score basico por coletavel, mas ainda falta ComboSystem + Ranking D..P completo.
- GZ-023: existe progressao linear por troca de cena, mas nao ha desbloqueio por coletaveis globais.

### 5.3 Nao iniciado

- GZ-017, GZ-018, GZ-020
- GZ-022, GZ-024, GZ-025
- GZ-026 em diante

## 6. Pendencias tecnicas importantes

1. Combo e ranking oficial ainda ausentes.
2. Nao existe boss (sprints 6+ nao iniciadas).
3. Nao existe save global de campanha/coletaveis.
4. Nao existe CI de export Windows/Linux.
5. Segredos/jaulas/Lap2 ainda nao implementados.
6. Testes atuais sao smoke + boot, sem testes unitarios de gameplay.

## 7. Plano recomendado para continuidade imediata

Ordem sugerida (sem quebrar dependencias):

1. Fechar GZ-014 (ComboSystem + Ranking).
2. Fechar GZ-017 e GZ-018 (segredos + jaulas).
3. Fechar GZ-023 corretamente (desbloqueio por coletaveis globais).
4. Fechar GZ-024 e GZ-025 (telemetria ampliada + balance).
5. Iniciar GZ-026 a GZ-028 (boss).

## 8. Como rodar e validar

Setup:

- Linux: [../scripts/setup/install_linux.sh](../scripts/setup/install_linux.sh)
- Windows: [../scripts/setup/install_windows.ps1](../scripts/setup/install_windows.ps1)

Comandos de validacao:

1. [../scripts/tests/run_validation_suite.sh](../scripts/tests/run_validation_suite.sh)
2. Relatorio gerado em [relatorios/validacao-automatica.md](relatorios/validacao-automatica.md)

Comando manual de boot:

- `godot4 --headless --path . --quit`

## 9. Critérios para fechar uma issue daqui pra frente

So marcar como Done quando:

1. Criterio de aceite da issue estiver cumprido integralmente.
2. Build/boot do projeto estiver ok.
3. Validacao runtime estiver feita no Godot.
4. Documentacao minima estiver atualizada.
5. Evidencia adicionada em [relatorios](relatorios).

## 10. Relatorios uteis para contexto rapido

- [relatorios/phase-expansion-01.md](relatorios/phase-expansion-01.md)
- [relatorios/art-pass-01.md](relatorios/art-pass-01.md)
- [relatorios/validacao-automatica.md](relatorios/validacao-automatica.md)
- [relatorios/testes-setup-scripts.md](relatorios/testes-setup-scripts.md)
- [relatorios/testes-controles-teclado.md](relatorios/testes-controles-teclado.md)
