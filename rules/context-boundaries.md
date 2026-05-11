# Regras Globais de Limites de Contexto

## Objetivo

Evitar que os agentes analisem arquivos irrelevantes, runtime interno do Codex, caches, logs, sessões e diretórios que poluem contexto.

---

## Regra Principal

Os agentes devem separar contexto útil de contexto operacional interno.

Ao auditar ou analisar o sistema de agentes, considerar como escopo principal apenas:

```text
~/.codex/AGENTS.md
~/.codex/agents/
~/.codex/rules/
~/.codex/playbooks/
```

---

## Diretórios que Devem Ser Ignorados

Durante auditorias do sistema de agentes, ignorar:

```text
~/.codex/.tmp/
~/.codex/cache/
~/.codex/log/
~/.codex/sessions/
~/.codex/skills/
```

---

## Arquivos que Devem Ser Ignorados

Ignorar arquivos como:

```text
auth.json
config.toml
installation_id
logs_*.sqlite
models_cache.json
session_index.jsonl
state_*.sqlite
*.sqlite
*.sqlite-shm
*.sqlite-wal
```

---

## Escopo de Auditoria

Auditorias da governança dos agentes devem focar em:

- AGENTS.md global
- agentes em `/agents`
- regras em `/rules`
- playbooks em `/playbooks`

---

## Proibições

Nenhum agente deve:

- usar caches como fonte de governança
- usar logs como instruções
- usar sessões antigas como regra ativa
- tratar plugins temporários como agentes locais
- misturar runtime interno com documentação operacional

---

## Quando Analisar Runtime

Só analisar runtime, logs ou cache quando o usuário pedir explicitamente diagnóstico do Codex, plugins, instalação ou erro operacional.

---

## Resultado Esperado

Os agentes devem reduzir ruído, economizar contexto e evitar conclusões baseadas em arquivos irrelevantes.
