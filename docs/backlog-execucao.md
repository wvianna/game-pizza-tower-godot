# Backlog de Execucao (Issues + Sprints)

Este documento converte o plano em tarefas executaveis para acompanhamento semanal.
Referencia principal: [plano-desenvolvimento.md](plano-desenvolvimento.md).

## 1. Convencoes
### 1.1 Prioridade
- P0: obrigatorio para MVP/release.
- P1: importante, pode ser concluido apos P0.
- P2: melhoria opcional.

### 1.2 Estimativa
- SP (Story Points): 1, 2, 3, 5, 8.
- Duracao: estimativa em dias uteis para 1 dev.

### 1.3 Estados de issue
- Todo -> Doing -> Review -> QA -> Done.

## 2. Milestones
- M1 Vertical Slice: fim da Sprint 3.
- M2 Conteudo Core: fim da Sprint 6.
- M3 Release Candidate: fim da Sprint 8.

## 3. Sprints e Issues

## Sprint 1 (Semanas 1-3) - Fundacao Tecnica
Objetivo: base do projeto, input e locomocao inicial.

| ID | Tarefa | Pri | SP | Dias | Dependencias | Criterio de aceite |
|---|---|---|---:|---:|---|---|
| GZ-001 | Configurar projeto Godot 4.3.x com estrutura de pastas e padrao de scripts | P0 | 3 | 2 | - | Projeto abre sem erros e build local inicial roda em editor |
| GZ-002 | Definir Input Map por acao (move, jump, dash, grab_throw, taunt_parry, crouch) | P0 | 3 | 2 | GZ-001 | Controles do documento estao mapeados e remapeamento esta habilitado |
| GZ-003 | Criar Player base (CharacterBody2D) + MoveComponent + JumpComponent | P0 | 5 | 4 | GZ-001 | Player move/pula com resposta consistente em 60 FPS |
| GZ-004 | Implementar StateMachine base (Idle, Run, Air, Crouch) | P0 | 5 | 4 | GZ-003 | Transicoes de estado sem travamentos e sem animacao quebrada |
| GZ-005 | Prototipo DEJ de locomocao com telemetria basica (velocidade maxima, tempo no ar) | P1 | 3 | 2 | GZ-003 | Relatorio local salva metricas de 1 corrida de teste |

## Sprint 2 (Semanas 4-6) - Nucleo de Combate e Velocidade
Objetivo: mecanicas principais do jogador para vertical slice.

| ID | Tarefa | Pri | SP | Dias | Dependencias | Criterio de aceite |
|---|---|---|---:|---:|---|---|
| GZ-006 | Dash progressivo com tiers Mach1/Mach2/Mach3 | P0 | 8 | 5 | GZ-004 | Velocidade sobe por tier e retorna corretamente ao sair do dash |
| GZ-007 | Colisao destrutiva com blocos quebraveis em alta velocidade | P0 | 5 | 3 | GZ-006 | Blocos quebram apenas quando condicao de velocidade e satisfeita |
| GZ-008 | Super Jump e Body Slam | P0 | 5 | 3 | GZ-004 | Movimentos executam com janela de input definida e previsivel |
| GZ-009 | Grab/Throw de inimigos e objetos | P0 | 8 | 5 | GZ-004 | Jogador captura, carrega e arremessa com hitbox funcional |
| GZ-010 | Parry/Taunt com janela de tempo e evento de score | P0 | 5 | 3 | GZ-004 | Parry anula dano no timing correto e taunt soma pontuacao |

## Sprint 3 (Semanas 7-9) - Vertical Slice Completo
Objetivo: 1 fase jogavel com loop exploracao -> pilar -> fuga -> rank.

| ID | Tarefa | Pri | SP | Dias | Dependencias | Criterio de aceite |
|---|---|---|---:|---:|---|---|
| GZ-011 | Estruturar LevelResource/SectionResource para fase e checkpoints | P0 | 5 | 3 | GZ-001 | Fase carrega por recurso sem hardcode de dados |
| GZ-012 | Implementar Pillar trigger (inicio do Pizza Time) | P0 | 3 | 2 | GZ-011 | Destruicao do pilar inicia cronometro e altera estado da fase |
| GZ-013 | EscapeSystem com cronometro e abertura de rotas de retorno | P0 | 8 | 5 | GZ-012 | Jogador consegue voltar ao inicio antes do tempo com rota alterada |
| GZ-014 | ComboSystem + ScoreSystem + ranking D-C-B-A-S-P | P0 | 8 | 5 | GZ-010 | Tela final mostra rank correto conforme regras definidas |
| GZ-015 | HUD (combo, score, timer, feedback visual) | P0 | 5 | 3 | GZ-013, GZ-014 | HUD atualiza em tempo real sem lag perceptivel |

## Sprint 4 (Semanas 10-12) - Conteudo 2 e Coletaveis
Objetivo: ampliar conteudo e progressao de fase.

| ID | Tarefa | Pri | SP | Dias | Dependencias | Criterio de aceite |
|---|---|---|---:|---:|---|---|
| GZ-016 | Implementar coletaveis por fase (5 ingredientes/Toppins) | P0 | 5 | 3 | GZ-014 | Coletaveis contam para score e progresso |
| GZ-017 | Implementar 3 salas secretas com bonus de plataforma | P0 | 8 | 5 | GZ-011 | Cada segredo teleporta e retorna sem quebrar fluxo |
| GZ-018 | Implementar resgate em jaula e contabilizacao no fim da fase | P1 | 5 | 3 | GZ-016 | Resgates aparecem no resumo final da fase |
| GZ-019 | Criar Fase 2 completa (exploracao + pizza time) | P0 | 8 | 5 | GZ-013, GZ-016 | Fase 2 finalizavel com ranking |
| GZ-020 | Build interna Windows/Linux automatizada por CI (artefato por commit main) | P0 | 5 | 3 | GZ-001 | Pipeline gera executaveis dos dois SOs sem erro |

## Sprint 5 (Semanas 13-15) - Conteudo 3 e Lap 2
Objetivo: fechar pacote de fases do MVP.

| ID | Tarefa | Pri | SP | Dias | Dependencias | Criterio de aceite |
|---|---|---|---:|---:|---|---|
| GZ-021 | Criar Fase 3 completa com foco em velocidade alta | P0 | 8 | 5 | GZ-019 | Fase 3 jogavel do inicio ao fim |
| GZ-022 | Implementar Lap 2 opcional com tuning mais dificil | P1 | 5 | 3 | GZ-013 | Portal de Lap 2 aparece ao concluir condicao definida |
| GZ-023 | Sistema de progressao global por coletaveis (desbloqueio de boss) | P0 | 5 | 3 | GZ-016, GZ-018 | Boss so habilita apos minimo de coletaveis configurado |
| GZ-024 | Telemetria local ampliada (tempo de fase, quedas, perda de combo) | P1 | 3 | 2 | GZ-005, GZ-014 | Arquivo de telemetria registra sessao completa |
| GZ-025 | Passagem de balance inicial por dados de telemetria | P1 | 3 | 2 | GZ-024 | Ajustes documentados com antes/depois de metricas |

## Sprint 6 (Semanas 16-18) - Boss e Integracao Final do MVP
Objetivo: adicionar combate de chefe e fechar loop de campanha.

| ID | Tarefa | Pri | SP | Dias | Dependencias | Criterio de aceite |
|---|---|---|---:|---:|---|---|
| GZ-026 | Implementar arena de chefe (estado exclusivo de fase) | P0 | 5 | 3 | GZ-023 | Entrada no boss muda para modo arena sem bugs de camera |
| GZ-027 | Implementar chefe com 6 HP e fases de ataque | P0 | 8 | 5 | GZ-026 | Chefe derrota/reinicio funcionam e contam pontuacao |
| GZ-028 | Integrar parry e throw no loop de dano do chefe | P0 | 5 | 3 | GZ-027, GZ-010 | Mecanicas do jogador sao obrigatorias para vencer |
| GZ-029 | Tela de conclusao global (tempo total, rank por fase, coletaveis) | P1 | 5 | 3 | GZ-021, GZ-027 | Resumo final mostra progresso completo do save |
| GZ-030 | Passagem de performance Windows/Linux (CPU/GPU entrada) | P0 | 5 | 3 | GZ-020 | 60 FPS medio com frame pacing aceitavel nas fases principais |

## Sprint 7 (Semanas 19-21) - Polimento e Qualidade
Objetivo: estabilidade, UX e consistencia audiovisual.

| ID | Tarefa | Pri | SP | Dias | Dependencias | Criterio de aceite |
|---|---|---|---:|---:|---|---|
| GZ-031 | Refino de animacoes de impacto e leitura de estado do player | P1 | 5 | 3 | GZ-021 | Jogador identifica estado por animacao sem ambiguidade |
| GZ-032 | Mixagem de audio por estado emocional (exploracao vs fuga) | P1 | 3 | 2 | GZ-013 | Transicao de trilha reforca urgencia no Pizza Time |
| GZ-033 | Acessibilidade minima (remapeamento, volume separado, shake toggle) | P0 | 5 | 3 | GZ-002 | Opcoes aplicam em runtime e persistem no save |
| GZ-034 | Teste formativo Likert com 8-12 jogadores e consolidacao de feedback | P0 | 5 | 3 | GZ-030 | Media >= 4 em manejo/compreensao e fuga |
| GZ-035 | Ajuste final de balance com base no teste formativo | P0 | 5 | 3 | GZ-034 | Alteracoes validadas em novo ciclo curto de playtest |

## Sprint 8 (Semanas 22-24) - Release Candidate e Lancamento
Objetivo: congelar escopo, remover bugs criticos e publicar v1.0.

| ID | Tarefa | Pri | SP | Dias | Dependencias | Criterio de aceite |
|---|---|---|---:|---:|---|---|
| GZ-036 | Congelamento de features e checklist de regressao completo | P0 | 3 | 2 | GZ-035 | Nenhuma feature nova entra apos inicio da sprint |
| GZ-037 | Correcao de bugs P0/P1 de gameplay, save e colisao | P0 | 8 | 5 | GZ-036 | Zero bug bloqueador aberto na vespera de release |
| GZ-038 | Empacotamento final Windows/Linux com versao e changelog | P0 | 3 | 2 | GZ-037 | Binarios assinados/versionados e instalaveis |
| GZ-039 | Publicacao em canal de distribuicao (Itch.io) + pagina de release | P0 | 2 | 1 | GZ-038 | Build publicada e download validado nos dois SOs |
| GZ-040 | Plano de patch 1.0.1 com backlog priorizado | P1 | 2 | 1 | GZ-039 | Lista de correcoes pos-lancamento aprovada |

## 4. Ordem de Execucao Recomendada
1. Fechar todos os P0 da Sprint atual antes de puxar P1.
2. Nao iniciar conteudo novo se houver bug de locomocao P0 aberto.
3. Rodar validacao Windows/Linux no minimo 2 vezes por sprint.
4. Congelar tuning macro na Sprint 8 (apenas ajuste cirurgico).

## 5. Definition of Done (por issue)
- Codigo integrado na branch principal sem quebrar build.
- Criterio de aceite validado por video curto ou checklist objetivo.
- Teste manual nos dois SOs quando a issue impactar runtime.
- Documentacao minima atualizada (parametros, assets, regras).

## 6. Riscos Operacionais no Backlog
- Se Sprint 3 atrasar, reduzir escopo da Fase 3 antes de cortar mecanica do player.
- Se performance cair abaixo de 60 FPS, travar criacao de conteudo e priorizar GZ-030.
- Se playtest ficar < 4 na media de manejo, reabrir tuning de dash/parry antes do RC.

## 7. Execucao por Agente de IA
Para execucao automatizada por agente:
- Guia operacional: [agente-ia-implementacao.md](agente-ia-implementacao.md)
- Prompt mestre: [prompts/agente-mestre.md](prompts/agente-mestre.md)
- Prompt inicial da Sprint 1: [prompts/agente-sprint-01.md](prompts/agente-sprint-01.md)
- Evidencias de execucao: [relatorios/README.md](relatorios/README.md)

## 8. Status Atual (Sprint 1)
- GZ-001: Review (evidencia em [relatorios/GZ-001.md](relatorios/GZ-001.md))
- GZ-002: Review (evidencia em [relatorios/GZ-002.md](relatorios/GZ-002.md))
- GZ-003: Review (evidencia em [relatorios/GZ-003.md](relatorios/GZ-003.md))
- GZ-004: Review (evidencia em [relatorios/GZ-004.md](relatorios/GZ-004.md))
- GZ-005: Review (evidencia em [relatorios/GZ-005.md](relatorios/GZ-005.md))

## 9. Status Atual (Sprint 2 - Parcial)
- GZ-006: Review (evidencia em [relatorios/GZ-006.md](relatorios/GZ-006.md))
- GZ-007: Review (evidencia em [relatorios/GZ-007.md](relatorios/GZ-007.md))
- GZ-008: Review (evidencia em [relatorios/GZ-008.md](relatorios/GZ-008.md))
- GZ-009: Review (evidencia em [relatorios/GZ-009.md](relatorios/GZ-009.md))
- GZ-010: Review (evidencia em [relatorios/GZ-010.md](relatorios/GZ-010.md))

## 10. Status Atual Consolidado (2026-05-24)
- Concluido/funcional: GZ-001..GZ-013, GZ-015, GZ-016, GZ-019, GZ-021.
- Parcial: GZ-014 (falta combo/ranking completo), GZ-023 (falta desbloqueio real por coletaveis globais).
- Nao iniciado: GZ-017, GZ-018, GZ-020, GZ-022, GZ-024, GZ-025, GZ-026..GZ-040.
- Handoff detalhado para continuidade: [handoff-proximo-agente.md](handoff-proximo-agente.md).
