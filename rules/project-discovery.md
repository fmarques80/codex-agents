# Regras Globais de Descoberta de Projeto

## Objetivo

Definir como os agentes devem analisar aplicações existentes, descobrir contexto relevante e evitar interpretações incorretas da arquitetura do projeto.

---

## Regra Principal

Nenhum agente deve assumir arquitetura, stack, padrões ou regras de negócio sem analisar o contexto real da aplicação.

Toda análise deve começar por reconhecimento estruturado do projeto.

---

## Ordem Obrigatória de Descoberta

Os agentes devem analisar na seguinte ordem:

1. AGENTS.md local
2. documentação em `/docs`
3. README principal
4. package.json
5. estrutura de diretórios
6. arquivos de configuração
7. scripts de build/deploy
8. dependências principais
9. infraestrutura
10. código relevante para a tarefa

---

## Arquivos Prioritários

Priorizar leitura de:

```text
AGENTS.md
README.md
package.json
pnpm-workspace.yaml
turbo.json
docker-compose.yml
Dockerfile
.env.example
tsconfig.json
next.config.*
nest-cli.json
eslint.config.*
.prettierrc*
```

Infraestrutura:

```text
.github/workflows/
infra/
terraform/
k8s/
docker/
nginx/
scripts/
```

Documentação:

```text
docs/
```

---

## Descoberta de Stack

Os agentes devem identificar:

- frontend utilizado
- backend utilizado
- banco de dados
- infraestrutura
- cloud provider
- CI/CD
- observabilidade
- ferramentas de IA
- monorepo ou multirepo
- containers
- orquestração
- ferramentas de build

---

## Descoberta Arquitetural

Os agentes devem identificar:

- módulos principais
- boundaries
- serviços
- APIs
- integrações externas
- autenticação
- autorização
- fluxo de dados
- pontos críticos
- acoplamentos
- gargalos aparentes

---

## Descoberta de Regras de Negócio

Os agentes devem procurar:

- documentação funcional
- workflows
- contratos de API
- validações importantes
- regras críticas
- permissões
- comportamento esperado

Nunca assumir regra de negócio sem evidência.

---

## Contexto Relevante

Os agentes devem carregar apenas:

- arquivos relevantes
- módulos relacionados
- documentação relacionada
- configurações relacionadas

Evitar:

- contexto excessivo
- diretórios irrelevantes
- arquivos não relacionados
- histórico desnecessário

---

## Monorepo

Em monorepos os agentes devem:

- identificar apps
- identificar packages
- identificar dependências internas
- identificar boundaries
- limitar análise ao domínio relevante

---

## Infraestrutura

Os agentes devem identificar:

- tipo de deploy
- Docker
- Kubernetes
- Terraform
- servidores Linux
- pipelines
- cloud provider
- observabilidade
- secrets management

---

## Documentação Local

Quando necessário, os agentes podem propor:

- criação de AGENTS.md local
- organização de `/docs`
- documentação de APIs
- documentação de arquitetura
- documentação de regras de negócio
- ADRs
- troubleshooting

---

## Proibições

Evitar:

- assumir stack sem verificar
- assumir arquitetura sem evidência
- assumir regra de negócio
- carregar contexto excessivo
- analisar projeto inteiro sem necessidade
- modificar arquivos não relacionados
- criar documentação duplicada

---

## Escalonamento

Quando houver incerteza relevante:

- envolver CTO Agent
- envolver especialista adequado
- pedir validação antes de mudança estrutural

---

## Limites de Contexto

Seguir obrigatoriamente:

- ~/.codex/rules/context-boundaries.md

## Resultado Esperado

Antes de iniciar mudanças relevantes, os agentes devem possuir entendimento suficiente sobre:

- arquitetura
- stack
- domínio afetado
- infraestrutura
- riscos
- impacto operacional
- documentação existente
