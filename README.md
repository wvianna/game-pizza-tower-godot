# Game Like Pizza Tower (Protótipo)

Jogo 2D de plataforma em alta velocidade, inspirado em Pizza Tower, com foco em dash, combo e fuga de fase. Goto é o motor de jogo utilizado para desenvolvimento. Gotod 4.5+ é recomendado para melhor compatibilidade.

## Requisitos

- Sistema operacional:
  - Windows 10/11
  - Linux (Ubuntu, Debian, Arch ou similar)
- Godot Engine 4.3+ (recomendado: 4.3.x ou 4.4.x)

## Instalação

Instalacao rapida por script (recomendado):

- Linux: [scripts/setup/install_linux.sh](scripts/setup/install_linux.sh)
- Windows: [scripts/setup/install_windows.ps1](scripts/setup/install_windows.ps1)

## Instalacao rapida (Linux)

```bash
chmod +x ./scripts/setup/install_linux.sh
./scripts/setup/install_linux.sh --dry-run
./scripts/setup/install_linux.sh --method auto
```

Metodos disponiveis no Linux:

- auto
- snap
- flatpak
- pacman
- manual

## Instalacao rapida (Windows PowerShell)

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\setup\install_windows.ps1 -DryRun
.\scripts\setup\install_windows.ps1 -Method auto
```

Metodos disponiveis no Windows:

- auto
- winget
- choco
- manual

## Windows

1. Baixe o Godot 4 em [godotengine.org/download/windows](https://godotengine.org/download/windows/).
2. Extraia o arquivo ZIP em uma pasta local.
3. Abra o executável do Godot.

## Linux

Opção recomendada (binário oficial):

1. Baixe o Godot 4 em [godotengine.org/download/linux](https://godotengine.org/download/linux/).
2. Extraia o arquivo e dê permissão de execução.
3. Execute o binário.

Opção via Snap:

1. Execute: sudo snap install godot4 --classic

Observação: em algumas distros, o pacote apt chamado godot3 instala a versão 3.x, que não é compatível com este projeto.

## Inicialização do projeto

1. Abra o Godot.
2. Clique em Import.
3. Selecione o arquivo [project.godot](project.godot).
4. Clique em Import & Edit.
5. Rode o jogo com F5.

Cena inicial atual: [scenes/levels/level_01.tscn](scenes/levels/level_01.tscn)

## Progressao atual do game

O prototipo agora possui 3 fases conectadas:

1. [level_01.tscn](scenes/levels/level_01.tscn)
2. [level_02.tscn](scenes/levels/level_02.tscn)
3. [level_03.tscn](scenes/levels/level_03.tscn)

Fluxo de cada fase:

1. Explore e colete toppings.
2. Destrua o Pillar John (com dash).
3. Pizza Time: volte para a area de saida antes do tempo acabar.
4. Avance para a proxima fase.

Ao concluir a terceira fase, o jogo vai para [victory_screen.tscn](scenes/game/victory_screen.tscn).

## Novidades desta iteracao

- Quadro flutuante de controles no canto superior direito em todas as fases da campanha.
- Player com sprite baseado em imagem da pasta [imagens](imagens) e animacao simples por estado (idle/corrida/dash/ar).
- Inimigos ativos (patrulha, contato com player, interacao com dash e arremesso) nas fases 1, 2 e 3.
- Combo continuo com timeout, multiplicador progressivo e pontuacao integrada no HUD.
- Audio sintetico em runtime com:
  - musica de fundo;
  - sons do player (pulo, dash, taunt, dano, aterrissagem, arremesso);
  - sons de inimigo (alerta, derrota);
  - sons de colisao/impacto e quebra.

## Handoff para proximo agente

Documentacao de continuidade (estado atual, arquitetura, status por issue, pendencias e plano de execucao):

- [docs/handoff-proximo-agente.md](docs/handoff-proximo-agente.md)

## Controles (Teclado PC)

- Mover esquerda: A ou Seta Esquerda
- Mover direita: D ou Seta Direita
- Mover cima: W ou Seta Cima
- Mover baixo: S ou Seta Baixo
- Pular: Espaço ou Z
- Dash: Shift ou X
- Agarrar/Arremessar: J ou C
- Taunt/Parry: K ou V
- Agachar/Deslizar: Ctrl ou S ou Seta Baixo
- Exportar telemetria: F8

Mapeamento implementado em [scripts/core/input_bootstrap.gd](scripts/core/input_bootstrap.gd).

## Controles (Gamepad)

- Analógico esquerdo / D-Pad: mover
- A: pular
- B / RT: dash
- X / RB: agarrar/arremessar
- Y: taunt/parry
- LT: agachar

## Testes

## Validação automática (recomendado)

Linux/macOS (bash):

```bash
./scripts/tests/run_validation_suite.sh
```

Esse comando:

1. roda o smoke test de controles de teclado;
2. tenta executar boot headless do projeto (se Godot estiver instalado no ambiente);
3. gera relatório em [docs/relatorios/validacao-automatica.md](docs/relatorios/validacao-automatica.md).

## 1) Teste de smoke dos controles de teclado

Linux/macOS (bash):

```bash
./scripts/tests/keyboard_controls_smoke_test.sh
```

O script valida se os atalhos de teclado principais estão definidos em [scripts/core/input_bootstrap.gd](scripts/core/input_bootstrap.gd).

## 2) Teste de boot do projeto (quando Godot estiver instalado)

Linux:

```bash
godot4 --headless --path . --quit
```

Windows (PowerShell):

```powershell
./Godot_v4.x-stable_win64.exe --headless --path . --quit
```

## Estrutura atual

- Código principal do player: [scripts/player/player.gd](scripts/player/player.gd)
- Componentes: [scripts/components](scripts/components)
- Cenas de teste: [scenes/test](scenes/test)
- Relatórios de execução do agente: [docs/relatorios](docs/relatorios)
