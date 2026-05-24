# Projeto: game-pizza-tower

## Objetivo
Implementar um platformer 2D de alta velocidade inspirado em Pizza Tower, com foco em ritmo, combo, fuga com cronometro e ranking.

## Fontes da verdade
1. docs/plano-desenvolvimento.md
2. docs/backlog-execucao.md
3. docs/requisitos.txt
4. docs/controles.txt

Se houver conflito, priorizar nesta ordem:
1. backlog-execucao
2. plano-desenvolvimento
3. requisitos

## Regras de implementacao
- Priorizar tarefas P0 antes de P1 e P2.
- Executar por issue (GZ-XXX), com mudancas pequenas e verificaveis.
- Nao pular dependencias de issue.
- Seguir arquitetura por composicao no player (componentes separados).
- Manter suporte a Windows e Linux desde o inicio.
- Input deve ser por acao (Input Map), nunca por botao fixo hardcoded.

## Regra de fechamento de issue
Uma issue so pode ser marcada como concluida quando:
- criterio de aceite da issue foi atendido;
- build nao foi quebrada;
- documentacao minima foi atualizada;
- comportamento foi validado em runtime (quando aplicavel).

## Entregas por lote
Sempre reportar:
- issue executada;
- arquivos alterados;
- criterio de aceite validado;
- pendencias e riscos.
