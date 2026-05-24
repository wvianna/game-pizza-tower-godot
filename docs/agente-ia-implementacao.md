# Guia de Implementacao por Agente de IA

Este guia define como um agente de IA deve implementar o projeto de forma controlada e rastreavel.

## 1. Objetivo de execucao
Implementar o jogo em ciclos curtos, seguindo as issues de docs/backlog-execucao.md, com prioridade em P0 e mantendo compatibilidade com Windows e Linux.

## 2. Protocolo obrigatorio do agente
1. Ler contexto inicial:
   - docs/plano-desenvolvimento.md
   - docs/backlog-execucao.md
   - docs/requisitos.txt
   - docs/controles.txt
2. Selecionar a primeira issue aberta sem dependencias pendentes.
3. Implementar somente 1 issue por vez.
4. Validar criterio de aceite da issue.
5. Atualizar status da issue no backlog (Todo -> Doing -> Review -> QA -> Done).
6. Registrar resumo tecnico em docs/relatorios/.

## 3. Politica de prioridade
- Sempre esgotar P0 da sprint antes de iniciar P1.
- Nao iniciar tarefa de fase nova com bug P0 de locomocao aberto.
- Se performance cair abaixo de 60 FPS medio, priorizar correcoes de desempenho.

## 4. Formato de relatorio por issue
Arquivo: docs/relatorios/GZ-XXX.md

Modelo:
- Issue: GZ-XXX
- Objetivo:
- Arquivos alterados:
- Validacao do criterio de aceite:
- Resultado:
- Riscos remanescentes:

## 5. Criterios de bloqueio
Parar e escalar para decisao humana quando:
- requisito estiver ambiguo e impactar arquitetura;
- dependencia tecnica externa impedir progresso;
- houver regressao critica sem alternativa segura.

## 6. Politica de qualidade
- Mudancas pequenas e incrementais.
- Evitar refatoracao ampla junto de nova funcionalidade.
- Preservar padrao de codigo estabelecido no repositorio.
- Atualizar documentacao quando regra de jogo mudar.

## 7. Execucao sugerida (inicio imediato)
Sprint 1:
- GZ-001 -> GZ-002 -> GZ-003 -> GZ-004 -> GZ-005

Ao finalizar Sprint 1:
- iniciar Sprint 2 apenas com validacao minima de estabilidade.
