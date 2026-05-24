# Relatorio - Art Pass 01

Data: 2026-05-24

## Objetivo

Melhorar o visual inicial do prototipo, reduzindo aspecto de formas basicas sem estilo.

## Melhorias aplicadas

- Direcao visual da fase de teste com:
  - gradiente de ceu em 3 tons;
  - sol com glow;
  - camadas de montanhas (profundidade);
  - nuvens com movimento lento (script dedicado);
  - piso com faixa superior e highlight.

- Jogador com visual estilizado:
  - silhueta mais organica;
  - detalhes de roupa/rosto;
  - contorno e sombra;
  - feedback dinamico (squash/stretch, inclinacao e movimento da pupila).

- Props de gameplay com melhor leitura:
  - bloco destrutivel com inset, rachaduras e outline;
  - objeto arremessavel com nucleo e outline.

- HUD mais legivel:
  - painel com estilo e borda;
  - titulo de cena e texto de controles com melhor contraste.

## Arquivos alterados

- scenes/test/test_level.tscn
- scenes/player/player.tscn
- scenes/environment/destructible_block.tscn
- scenes/environment/throwable_object.tscn
- scripts/player/player.gd
- scripts/environment/cloud_layer.gd

## Validacao

- Boot headless do projeto: APROVADO
- Suite automatica: APROVADO
