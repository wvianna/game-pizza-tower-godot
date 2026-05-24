# Relatorio - Expansao de Fases 01

Data: 2026-05-24

## Objetivo

Criar mais fases jogaveis e evoluir o loop principal do game.

## Entregas

- Campanha com 3 fases sequenciais:
  - [level_01.tscn](../../scenes/levels/level_01.tscn)
  - [level_02.tscn](../../scenes/levels/level_02.tscn)
  - [level_03.tscn](../../scenes/levels/level_03.tscn)
- Pilar de objetivo com trigger por dash:
  - [pillar_john.gd](../../scripts/environment/pillar_john.gd)
  - [pillar_john.tscn](../../scenes/environment/pillar_john.tscn)
- Sistema de coletaveis com pontuacao:
  - [collectible_topping.gd](../../scripts/environment/collectible_topping.gd)
  - [collectible_topping.tscn](../../scenes/environment/collectible_topping.tscn)
- Controlador de fase com Pizza Time simplificado e troca de cena:
  - [level_controller.gd](../../scripts/game/level_controller.gd)
- Tela final de vitoria:
  - [victory_screen.tscn](../../scenes/game/victory_screen.tscn)
  - [victory_screen.gd](../../scripts/game/victory_screen.gd)

## Evolucao de gameplay

- Objetivo claro por fase (destruir pilar).
- Fase de fuga com cronometro apos o pilar.
- Abertura de atalho na fuga (remocao de bloqueio de retorno).
- Coletaveis com bonus no score e no tempo de fuga.
- Progressao entre niveis ate tela de fim.

## Validacao

- Boot headless Godot: APROVADO
- Suite automatica: APROVADO
