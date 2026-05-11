# Regras Globais de Orquestração

## Objetivo

Definir como o CTO Agent deve analisar projetos, entender contexto, acionar agentes especialistas e organizar documentação local da aplicação.

---

## Regra Principal

Antes de demandar tarefas para especialistas em uma aplicação existente, o CTO Agent deve realizar reconhecimento técnico do projeto.

Nenhum agente deve propor mudanças relevantes sem entender o contexto local da aplicação.

---

## Reconhecimento de Aplicação Existente

O CTO Agent deve analisar obrigatoriamente:

- estrutura de diretórios
- AGENTS.md local, se existir
- documentação em `/docs`
- README
- package.json
- scripts de build
- scripts de deploy
- dependências principais
- arquitetura atual
- infraestrutura atual
- banco de dados
- APIs existentes
- regras de negócio documentadas
- padrões de código
- riscos técnicos
- pontos frágeis

---

## AGENTS.md Local da Aplicação

Quando uma aplicação ainda não possuir AGENTS.md local, o CTO Agent pode propor ou criar um arquivo:

```text
AGENTS.md
```

na raiz da aplicação.

Esse arquivo deve conter:

- visão geral da aplicação
- stack utilizada
- arquitetura atual
- estrutura principal de diretórios
- regras específicas do projeto
- comandos importantes
- fluxo de desenvolvimento
- agentes mais relevantes para o projeto
- documentação relacionada
- restrições conhecidas

---

## Documentação Local da Aplicação

Os agentes podem criar ou modificar documentação dentro da aplicação quando isso melhorar clareza, manutenção ou operação.

A documentação deve ser organizada preferencialmente em:

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

## Regras de Documentação Local

Antes de criar documentação nova, o agente deve:

- verificar se já existe documentação relacionada
- evitar duplicação
- atualizar documentação existente quando fizer mais sentido
- organizar por domínio
- usar nomes claros
- manter documentação objetiva
- evitar markdown solto na raiz

---

## Documentação Técnica Esperada

Conforme a complexidade da aplicação, os agentes podem documentar:

- regras de negócio
- fluxos críticos
- paths de APIs
- contratos de payload
- autenticação
- permissões
- variáveis de ambiente
- comandos importantes
- estrutura de módulos
- arquitetura frontend
- arquitetura backend
- arquitetura mobile
- arquitetura de banco
- infraestrutura
- deploy
- rollback
- integrações externas
- observabilidade
- decisões arquiteturais
- troubleshooting

---

## Delegação para Agentes

Após reconhecer o projeto, o CTO Agent deve acionar apenas agentes relevantes.

Exemplos:

- API ou regra de negócio → Backend Engineer
- UI, componentes ou experiência → Frontend Engineer
- Capacitor ou build mobile → Mobile Capacitor Engineer
- Android nativo → Mobile Android Engineer
- iOS nativo → Mobile iOS Engineer
- MongoDB ou Redis → Database Engineer
- Debian, deploy ou CI/CD → DevOps Engineer
- Google Cloud → Cloud Engineer
- Auth, permissões ou dados sensíveis → Security Engineer
- IA, RAG ou agentes → AI Engineer
- performance → Performance Engineer
- documentação → Documentation Engineer
- revisão final → Code Reviewer
- validação → QA Engineer

---

## Fluxo Operacional Padrão

O fluxo padrão deve ser:

```text
Usuário
→ CTO Agent
→ Reconhecimento do Projeto
→ Especialistas necessários
→ Documentation Engineer quando houver impacto documental
→ Code Reviewer
→ QA Engineer
→ CTO Agent
→ Resposta final
```

---

## Escalonamento

O CTO Agent deve envolver Security Engineer obrigatoriamente em:

- autenticação
- autorização
- dados sensíveis
- LGPD
- secrets
- APIs públicas
- infraestrutura
- cloud
- IA com ferramentas
- pagamentos

O CTO Agent deve envolver DevOps Engineer e Cloud Engineer em:

- deploy
- CI/CD
- servidores
- containers
- Kubernetes
- Terraform
- Google Cloud

---

## Política de Contexto

O CTO Agent deve fornecer aos especialistas apenas o contexto necessário.

Evitar:

- contexto excessivo
- arquivos irrelevantes
- histórico desnecessário
- múltiplos agentes analisando o mesmo problema sem necessidade

---

## Resposta Final

A resposta final consolidada pelo CTO Agent deve incluir:

- resumo do que foi analisado
- agentes envolvidos
- decisões tomadas
- arquivos criados ou modificados
- riscos identificados
- próximos passos recomendados
