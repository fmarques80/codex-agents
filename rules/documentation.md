# Regras Globais de Documentação

## Objetivo

Garantir documentação útil, objetiva, organizada e sustentável.

---

## Princípios Obrigatórios

Toda documentação deve priorizar:

1. clareza
2. objetividade
3. organização
4. facilidade de manutenção
5. utilidade prática

---

## Regras Gerais

Todos os agentes devem:

- documentar apenas o necessário
- evitar documentação redundante
- evitar documentação desatualizada
- evitar excesso de teoria
- evitar textos longos sem necessidade
- organizar conteúdo por contexto
- manter navegação simples

---

## O Que Deve Ser Documentado

Documentar obrigatoriamente quando houver:

- mudança arquitetural
- infraestrutura nova
- integração externa
- setup complexo
- fluxo crítico
- regra operacional importante
- comportamento não óbvio
- dependência importante
- automação relevante

---

## O Que Evitar

Evitar:

- documentação automática sem revisão
- markdown excessivo
- documentação duplicada
- documentação sem contexto
- documentação genérica
- documentação irrelevante
- comentários redundantes no código

---

## READMEs

READMEs devem conter:

- objetivo do projeto
- setup básico
- comandos principais
- estrutura relevante
- variáveis importantes
- fluxo de execução
- troubleshooting quando necessário

---

## APIs

Documentar:

- endpoints
- autenticação
- payloads
- respostas
- erros importantes
- limites relevantes

---

## Infraestrutura

Documentar:

- deploy
- rollback
- variáveis importantes
- dependências
- pipelines
- backups
- observabilidade

---

## IA

Documentar:

- agentes
- responsabilidades
- fluxos
- ferramentas
- permissões
- contexto utilizado
- limitações importantes

---

## Organização

Priorizar:

- documentação por domínio
- exemplos reais
- passo a passo objetivo
- comandos reproduzíveis
- troubleshooting simples

---

## Atualização

Documentação deve ser atualizada quando:

- arquitetura mudar
- fluxo mudar
- infraestrutura mudar
- comportamento importante mudar

---

## Proibição

Evitar:

- documentação desatualizada
- documentação ornamental
- excesso de documentação
- duplicação de informação
- múltiplas fontes conflitantes

---

---

## Estrutura Preferencial de Documentação

A documentação deve preferencialmente seguir a estrutura:

```text
docs/
├── architecture/
├── backend/
├── frontend/
├── mobile/
├── infra/
├── ai/
├── api/
├── workflows/
├── decisions/
└── troubleshooting/
```

---

## Organização Obrigatória

Todos os agentes devem:

- centralizar documentação em `/docs`
- evitar markdowns soltos na raiz
- evitar múltiplos READMEs redundantes
- verificar documentação existente antes de criar nova
- atualizar documentação relacionada ao invés de duplicar
- manter separação clara entre:
  - arquitetura
  - operação
  - troubleshooting
  - APIs
  - workflows

---

## ADRs

Decisões arquiteturais importantes devem ser registradas em:

```text
/docs/decisions
```

As ADRs devem incluir:

- contexto
- decisão
- tradeoffs
- impacto
- riscos
- motivo da escolha

---

## Troubleshooting

Problemas operacionais recorrentes devem ser documentados em:

```text
/docs/troubleshooting
```

Priorizar:

- problemas reais
- soluções reproduzíveis
- comandos úteis
- diagnóstico objetivo
