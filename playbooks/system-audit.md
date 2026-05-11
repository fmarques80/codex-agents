# Playbook de Auditoria do Sistema de Agentes

## Objetivo

Auditar a estrutura global de agentes, regras e playbooks para garantir coerência, organização e ausência de conflitos.

---

## Quando Usar

Usar quando houver:

- criação de novos agentes
- criação de novas rules
- criação de novos playbooks
- alterações grandes no sistema global
- comportamento inconsistente dos agentes
- suspeita de duplicação ou conflito

---

## Escopo da Auditoria

Analisar:

- ~/.codex/AGENTS.md
- ~/.codex/agents/
- ~/.codex/rules/
- ~/.codex/playbooks/

---

## Fluxo

1. Verificar se o AGENTS.md global lista todos os agentes relevantes
2. Verificar se o AGENTS.md global lista todas as rules relevantes
3. Verificar se o AGENTS.md global lista todos os playbooks relevantes
4. Verificar se cada agente possui `## Regras Obrigatórias`
5. Verificar duplicações de regras
6. Verificar referências quebradas
7. Verificar conflitos entre rules
8. Verificar sobreposição excessiva entre agentes
9. Verificar ausência de agentes necessários
10. Verificar excesso de complexidade
11. Propor correções incrementais

---

## Comandos Úteis

```bash
find ~/.codex -type f | sort

grep -R "## Regras Obrigatórias" ~/.codex/agents/*.md

grep -R "~/.codex/rules" ~/.codex/agents/*.md

grep -R "~/.codex/playbooks" ~/.codex/AGENTS.md
```

---

## Limites de Contexto

Seguir obrigatoriamente:

- ~/.codex/rules/context-boundaries.md

## Saída Esperada

A auditoria deve entregar:

- problemas encontrados
- arquivos afetados
- duplicações
- conflitos
- referências faltantes
- correções recomendadas
- prioridade das correções
