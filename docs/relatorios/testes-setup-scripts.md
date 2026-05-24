# Relatorio de Testes - Scripts de Setup

Data: 2026-05-24

## Escopo

- Validar script de instalacao Linux.
- Validar caminho seguro do script de instalacao Windows.
- Confirmar regressao zero na suite automatica.

## Teste 1 - Linux setup script (sintaxe + help + manual)

Comando executado:

```bash
chmod +x scripts/setup/install_linux.sh && \
bash -n scripts/setup/install_linux.sh && \
./scripts/setup/install_linux.sh --help && \
./scripts/setup/install_linux.sh --method manual
```

Resultado:

- Script valido em sintaxe bash.
- Help exibido corretamente.
- Execucao manual funcionando.
- Ambiente detectou Godot instalado em /snap/bin/godot4.

Status: Aprovado

## Teste 2 - Windows setup script (execucao local)

Comando executado:

```bash
command -v pwsh >/dev/null 2>&1 && \
pwsh -NoProfile -ExecutionPolicy Bypass -File scripts/setup/install_windows.ps1 -Method manual -DryRun || \
echo PWSH_MISSING
```

Resultado:

- Saida: PWSH_MISSING

Status: Bloqueado por dependencia externa (PowerShell nao disponivel neste ambiente Linux).

## Teste 3 - Suite automatica completa

Comando executado:

```bash
./scripts/tests/run_validation_suite.sh
```

Resultado:

- Smoke de teclado: APROVADO
- Boot headless Godot: APROVADO
- Relatorio gerado: [validacao-automatica.md](validacao-automatica.md)

Status: Aprovado
