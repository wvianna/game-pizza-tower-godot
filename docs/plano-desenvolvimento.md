# Plano de Desenvolvimento do Jogo (Windows e Linux)

## 1. Visao do Projeto
Desenvolver um jogo de plataforma 2D de alta velocidade, inspirado em Pizza Tower, com foco em:
- locomocao baseada em momento (inercia, dash progressivo e cadeia de estados);
- exploracao de fase com segredo e coletaveis;
- sistema de fuga com cronometro (Pizza Time);
- score attack com combo continuo e ranking final;
- build e distribuicao para Windows e Linux.

Escopo inicial sugerido: 1 personagem jogavel, 3 fases normais, 1 fase de chefe, 1 loop completo de progressao e ranking.

## 2. Objetivos de Produto e Experiencia
Objetivos principais:
- Entregar gameplay rapido, responsivo e legivel, com sensacao de adrenalina.
- Manter o jogador em estado de flow (desafio x habilidade) com curva de dificuldade crescente.
- Reforcar estados emocionais com audiovisual e feedbacks de pontuacao.

Objetivos mensuraveis de qualidade:
- 60 FPS estavel em hardware alvo de entrada no Windows e Linux.
- Tempo de resposta de input percebido abaixo de 100 ms em acoes criticas.
- 80%+ dos playtesters avaliando manejo e compreensao com nota >= 4 (escala Likert 1-5).

## 3. Base de Requisitos (Consolidado)
### 3.1 Requisitos Funcionais de Gameplay
RF-01: Dash progressivo com tiers de velocidade e quebra de blocos.
RF-02: Ataques verticais, super pulo e esmagamento corporal.
RF-03: Agarrar e arremessar inimigos (uso ofensivo e de mobilidade).
RF-04: Parry e taunt com efeito defensivo e bonus de score.
RF-05: Gatilho de fim de fase por destruicao do pilar.
RF-06: Modo Pizza Time com contagem regressiva e reconfiguracao de caminho.
RF-07: Coletaveis por fase (ingredientes/Toppins, segredos, resgates).
RF-08: Sistema de combo continuo com timeout e multiplicador.
RF-09: Ranking final por desempenho (D ate P).
RF-10: Fase de chefe em arena com multiplos pontos de vida.
RF-11: Suporte a Lap 2 (segunda volta opcional de alta dificuldade).

### 3.2 Requisitos Nao Funcionais (RNF)
RNF-01: Export oficial para Windows e Linux.
RNF-02: Input configuravel para controle e teclado.
RNF-03: Arquitetura modular em composicao (evitar script monolitico de player).
RNF-04: Telemetria local de desempenho (tempo de fase, combo, falhas).
RNF-05: Consistencia audiovisual e clareza de feedback para score e risco.
RNF-06: Pipeline de build reproduzivel com versao fechada de engine.

### 3.3 Mapeamento de Controles (Padrao)
Input base (controle Xbox/generico):
- Analogo esquerdo/D-Pad: mover.
- A: pular/interagir.
- X ou RB: agarrar/arremessar.
- B ou RT: correr (dash).
- Y: provocar (taunt)/parry.
- LT: agachar/deslizar.

Observacao: implementar Input Map com remapeamento por acao, nunca por botao fixo.

## 4. Arquitetura Tecnica Recomendada
Engine recomendada: Godot 4.x (GDScript), visando produtividade e export multiplataforma.

### 4.1 Estrutura de Composicao (Player)
No principal:
- Player (CharacterBody2D): estado global, integracao de movimento e dano.

Nos filhos/componentes:
- MoveComponent: aceleracao, friccao, velocidade por tier.
- JumpComponent: pulo normal, super pulo, quedas.
- DashComponent: ativacao de dash, tiers e colisao destrutiva.
- GrabThrowComponent: captura, transporte, arremesso.
- ParryTauntComponent: janela de parry, taunt e eventos de score.
- HitboxHurtboxComponent: dano e invulnerabilidade.
- StateMachineComponent: Idle, Run, Mach1, Mach2, Mach3, Grab, Throw, SuperJump, Slam, Stun.

Recursos de dados:
- PlayerConfigResource: velocidades, gravidade, friccao, janelas de input.
- LevelResource/SectionResource: metadados de fase, segredos, portas e checkpoints.
- EnemyConfigResource: vida, padrao de IA, resistencia ao dash.

### 4.2 Sistemas Globais
- GameState: exploracao, pizza_time, boss_arena, ranking.
- ComboSystem: contador, timeout, multiplicador, eventos de HUD.
- ScoreSystem: pontuacao de acao, bonus de segredo e ranking final.
- EscapeSystem: cronometro, portas dinamicas e alteracao de obstaculos.
- SaveSystem: progresso de fases, coletaveis e melhores ranks.

### 4.3 Fluxo de Fase
1. Exploracao com objetivos e segredos.
2. Encontro do pilar e acao de destruicao.
3. Ativacao de Pizza Time (timer + rota de retorno).
4. Chegada ao inicio, calculo de score e rank.
5. Opcional: portal de Lap 2 para desafio extra.

## 5. Plano por Fases (Cronograma de 24 Semanas)
## Fase 0 - Pre-producao (Semanas 1-3)
Objetivo: reduzir risco de design e fechar especificacao executavel.
Entregas:
- GDD dinamico (wiki enxuta).
- Especificacao tecnica (RF/RNF + criterios de aceite).
- Documento executavel de jogo (DEJ) com prototipo de movimento.
- Definicao de estilo audiovisual e diretrizes de feedback.

## Fase 1 - Vertical Slice (Semanas 4-9)
Objetivo: validar o loop completo em 1 fase curta.
Entregas:
- Player com dash tiers, pulo, super pulo, slam, grab/throw e parry.
- 1 fase jogavel com pilar, Pizza Time e ranking.
- HUD com combo, score e timer.
- Build interna Windows/Linux para teste de controle e performance.

## Fase 2 - Producao de Conteudo (Semanas 10-17)
Objetivo: escalar conteudo sem perder consistencia.
Entregas:
- Mais 2 fases completas com segredos, coletaveis e fluxo de fuga.
- 1 chefe com arena e fases de ataque.
- Sistema de progressao com desbloqueio por coletaveis.
- Lap 2 opcional com tuning proprio.

## Fase 3 - Polimento e Balanceamento (Semanas 18-22)
Objetivo: ajustar flow, dificuldade e sensacao de controle.
Entregas:
- Balance de fisica por telemetria e playtest.
- Refino de animacao, som e efeitos de impacto.
- Acessibilidade minima (remapeamento, volume separado, shake opcional).
- Otimizacoes para 60 FPS estavel em ambos os SOs.

## Fase 4 - Release Candidate (Semanas 23-24)
Objetivo: congelar escopo e liberar versao 1.0.
Entregas:
- Teste regressivo completo.
- Pacotes finais Windows e Linux.
- Manual curto de controles e onboarding.
- Plano de patch 1.0.1 pos-lancamento.

## 6. Backlog Tecnico por Sprint (Resumo)
Sprint 1:
- Base do projeto Godot, input map e arquitetura de componentes.
- Prototipo de locomocao com dash e pulo.

Sprint 2:
- Grab/throw, parry/taunt e state machine completa do player.
- Testes unitarios de estados criticos.

Sprint 3:
- Sistema de fase (pilar, cronometro, retorno dinamico).
- HUD de score, combo e timer.

Sprint 4:
- Coletaveis, segredos e rank de fim de fase.
- Build interna para Windows/Linux.

Sprint 5:
- Segunda e terceira fases, IA de inimigos e tuning de ritmo.
- Telemetria local para balance.

Sprint 6:
- Arena de chefe e sistema de vida/fases do chefe.
- Ajustes de performance e carregamento.

Sprint 7:
- Lap 2, progressao global e persistencia.
- Revisao de UX e onboarding.

Sprint 8:
- QA final, correcoes criticas, release candidate.

## 7. Estrategia de Build e Distribuicao (Windows/Linux)
- Fixar versao da engine (exemplo: Godot 4.3.x) e documentar hash/build.
- Centralizar configuracoes por ambiente em arquivo de export.
- Automatizar export com CI (GitHub Actions ou equivalente):
  - job windows_export;
  - job linux_export;
  - artefatos versionados por tag.
- Testar em hardware real dos dois SOs antes de cada milestone.
- Preparar distribuicao inicial em Itch.io (depois Steam, se aplicavel).

## 8. Plano de Testes
### 8.1 Testes Tecnicos
- Unitarios: maquina de estados, regras de combo, calculo de rank.
- Integracao: fluxo completo exploracao -> pilar -> pizza_time -> ranking.
- Regressao: controles, colisao, checkpoints, persistencia.
- Performance: frame time, stutter e consumo de memoria em fases densas.

### 8.2 Testes Formativos (UX e Flow)
Escala Likert 1-5 para:
- manejo e compreensao do movimento;
- efetividade do menu de ajuste de variaveis;
- consistencia visual do feedback com os inputs;
- sensacao de adrenalina durante Pizza Time.

Criterio de aprovacao:
- media >= 4 em manejo/compreensao;
- media >= 4 em satisfacao da sequencia de fuga;
- no maximo 1 bug bloqueador por ciclo de release candidate.

## 9. Riscos e Mitigacoes
Risco 1: Movimento sem sensacao de precisao.
Mitigacao: prototipagem rapida + tuning semanal orientado por telemetria.

Risco 2: Escopo excessivo de conteudo.
Mitigacao: manter escopo MVP (3 fases + 1 chefe) ate release 1.0.

Risco 3: Divergencia entre design e implementacao.
Mitigacao: especificacao RF/RNF como fonte da verdade e revisoes quinzenais.

Risco 4: Diferenca de performance entre Windows e Linux.
Mitigacao: testes continuos nos dois SOs desde Sprint 2, nao apenas no fim.

## 10. Entregaveis Finais
- GDD dinamico atualizado.
- Especificacao tecnica rastreavel (RF/RNF + aceite).
- DEJ/vertical slice funcional.
- Versao 1.0 executavel para Windows e Linux.
- Relatorio de testes tecnicos e formativos.

## 11. Proximos Passos Imediatos (Semana 1)
1. Configurar projeto Godot e pipeline inicial de export para Windows/Linux.
2. Criar maquina de estados do player com acoes basicas de movimento.
3. Implementar input map conforme o layout de controles base.
4. Definir metricas de telemetria para combo, tempo de fase e falhas.
5. Construir prototipo DEJ focado apenas em locomocao e feel de dash.

## 12. Backlog Executavel
O detalhamento das tarefas executaveis por sprint (issues com prioridade, estimativa, dependencias e criterio de aceite) esta em [backlog-execucao.md](backlog-execucao.md).
