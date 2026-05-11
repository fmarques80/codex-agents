# Regras Globais de Capacidades dos Agentes

## Objetivo

Definir o que os agentes podem fazer, como devem atuar e quais limites devem respeitar ao trabalhar em projetos reais.

---

## Capacidades Gerais

Os agentes podem:

- analisar código existente
- modificar arquivos relacionados à tarefa
- criar arquivos necessários
- atualizar documentação
- criar documentação local da aplicação
- propor melhorias arquiteturais
- sugerir refatorações
- criar testes
- revisar segurança
- revisar performance
- revisar infraestrutura
- analisar impacto técnico

---

## Limites Gerais

Os agentes não devem:

- modificar arquivos não relacionados
- criar complexidade sem necessidade
- alterar múltiplos domínios sem justificativa
- assumir contexto sem verificar
- ignorar documentação existente
- remover código sem análise
- realizar mudanças destrutivas sem confirmação

---

## Projetos Grandes

Em projetos grandes, os agentes devem:

- limitar escopo
- analisar apenas módulos relevantes
- identificar boundaries
- evitar carregar contexto excessivo
- preservar padrões existentes
- documentar decisões importantes

---

## Monorepos

Em monorepos, os agentes devem:

- identificar apps e packages
- respeitar dependências internas
- evitar impacto cruzado desnecessário
- validar scripts afetados
- documentar boundaries quando necessário

---

## Documentação

Os agentes podem criar ou alterar documentação quando:

- houver mudança arquitetural
- houver regra de negócio relevante
- houver API nova ou alterada
- houver mudança de infraestrutura
- houver fluxo crítico
- houver comportamento não óbvio

Devem seguir:

- ~/.codex/rules/documentation.md
- ~/.codex/rules/orchestration.md

---

## APIs

Ao trabalhar com APIs, os agentes devem:

- identificar rotas existentes
- preservar contratos quando possível
- documentar paths relevantes
- validar autenticação
- validar autorização
- validar payloads
- tratar erros com segurança
- considerar versionamento quando necessário

---

## Banco de Dados

Ao trabalhar com banco, os agentes devem:

- avaliar impacto em dados existentes
- considerar índices
- considerar volume
- evitar mudanças destrutivas sem confirmação
- documentar migrations quando necessário
- prever rollback quando aplicável

---

## Infraestrutura

Ao trabalhar com infraestrutura, os agentes devem:

- avaliar impacto operacional
- avaliar downtime
- validar segurança
- preservar rollback
- documentar comandos críticos
- evitar mudanças irreversíveis
- considerar custo

---

## IA

Ao trabalhar com IA, os agentes devem:

- limitar contexto
- reduzir custo de tokens
- evitar agentes desnecessários
- proteger dados sensíveis
- evitar ferramentas perigosas
- documentar fluxos relevantes
- validar riscos de prompt injection

---

## Testes

Os agentes podem criar testes quando houver:

- regra de negócio
- fluxo crítico
- API
- autenticação
- autorização
- integração externa
- comportamento de risco

Evitar testes redundantes ou frágeis.

---

## Operações Perigosas

Exigem confirmação explícita:

- apagar arquivos relevantes
- alterar banco de dados em produção
- alterar autenticação
- alterar permissões
- alterar infraestrutura crítica
- alterar CI/CD crítico
- executar comandos destrutivos
- migrar arquitetura
- remover dependências importantes

---

## Resultado Esperado

Os agentes devem atuar de forma:

- contextual
- organizada
- segura
- incremental
- documentada
- proporcional à complexidade da aplicação
