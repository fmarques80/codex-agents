# Regras Globais para Geração de AGENTS.md Locais

## Objetivo

Definir como os agentes devem criar, atualizar e organizar arquivos AGENTS.md específicos de cada aplicação.

---

## Regra Principal

O AGENTS.md local deve adaptar as regras globais ao contexto real da aplicação.

Ele nunca deve contradizer regras globais críticas de:

- segurança
- limites operacionais
- qualidade mínima
- descoberta de projeto
- proteção de dados

---

## Quando Criar AGENTS.md Local

Criar AGENTS.md local quando:

- a aplicação não possuir instruções locais
- o projeto for complexo
- houver múltiplos módulos
- houver regras de negócio relevantes
- houver stack específica
- houver padrões próprios
- houver infraestrutura própria
- houver documentação local importante

---

## Localização

O arquivo deve ser criado na raiz da aplicação:

```text
AGENTS.md
```

---

## Conteúdo Mínimo

O AGENTS.md local deve conter:

- visão geral da aplicação
- stack real utilizada
- estrutura principal
- comandos importantes
- regras específicas do projeto
- padrões de código locais
- arquitetura resumida
- documentação relacionada
- agentes mais relevantes
- restrições conhecidas

---

## Estrutura Recomendada

```md
# AGENTS.md Local

## Visão Geral

## Stack da Aplicação

## Estrutura Principal

## Comandos Importantes

## Arquitetura

## Regras de Negócio Relevantes

## APIs e Integrações

## Banco de Dados

## Infraestrutura

## Mobile

## IA

## Documentação Relacionada

## Agentes Relevantes

## Restrições e Cuidados
```

---

## Documentação Complementar

Quando necessário, criar documentação em:

```text
docs/
├── architecture/
├── business-rules/
├── api/
├── backend/
├── frontend/
├── mobile/
├── infra/
├── database/
├── ai/
├── workflows/
├── decisions/
└── troubleshooting/
```

---

## Regras para Criação

Antes de criar o AGENTS.md local:

- analisar o projeto
- verificar documentação existente
- evitar duplicação
- identificar stack real
- identificar comandos reais
- identificar padrões reais
- identificar riscos
- identificar domínios importantes

---

## Agentes Locais

O CTO Agent pode definir agentes locais específicos quando o projeto exigir.

Quando o projeto precisar persistir instruções ou arquivos de agentes locais no repositório, a pasta oficial deve ser preferencialmente:

```text
.agents/
```

Justificativa:

- mantém agentes locais fora da estrutura funcional da aplicação
- reduz confusão com código de produto
- deixa claro que se trata de governança auxiliar do repositório

Evitar usar:

```text
agents/
```

como diretório funcional da aplicação, salvo decisão explícita e documentada do projeto.

Exemplos:

- Billing Domain Agent
- Auth Domain Agent
- Notifications Agent
- Marketplace Agent
- Admin Panel Agent
- Payments Agent
- Reporting Agent

Agentes locais devem existir apenas quando houver complexidade real.

---

## Herança de Regras Globais

O AGENTS.md local deve declarar que herda as regras globais de:

```text
~/.codex/AGENTS.md
~/.codex/rules/
```

Regras locais podem complementar as globais, mas não devem enfraquecer regras críticas.

---

## Atualização

Atualizar AGENTS.md local quando houver:

- mudança de stack
- mudança arquitetural
- novo domínio relevante
- nova infraestrutura
- novo fluxo crítico
- nova regra de negócio importante
- mudança significativa de comandos

---

## Proibições

Evitar:

- AGENTS.md genérico demais
- documentação duplicada
- regras locais conflitantes
- excesso de agentes locais
- instruções sem evidência no projeto
- descrever arquitetura que não existe
- inventar regras de negócio
