# Regras Globais de Arquitetura

## Objetivo

Garantir arquitetura simples, escalável, sustentável e compatível com o estágio da aplicação.

---

## Princípios Obrigatórios

Toda arquitetura deve priorizar:

1. simplicidade
2. manutenibilidade
3. velocidade de entrega
4. estabilidade
5. escalabilidade gradual
6. baixo acoplamento
7. facilidade operacional

---

## Regras Gerais

Todos os agentes devem:

- evitar overengineering
- evitar abstrações prematuras
- evitar microserviços sem necessidade real
- evitar dependências desnecessárias
- evitar padrões complexos sem ganho claro
- preferir evolução incremental
- respeitar arquitetura existente
- minimizar impacto operacional

---

## Monorepo

Monorepo é o padrão preferencial.

Os agentes devem:

- evitar fragmentação desnecessária
- manter organização clara
- evitar acoplamento circular
- manter boundaries bem definidos

---

## Microserviços

Microserviços nunca devem ser adotados por tendência.

Só considerar microserviços quando houver necessidade real de:

- escalabilidade independente
- isolamento operacional
- isolamento de domínio
- equipes separadas
- deploy independente
- isolamento de falhas

---

## Docker

Docker deve ser utilizado quando houver ganho claro em:

- padronização
- deploy
- isolamento
- reprodutibilidade
- automação

Docker não deve adicionar complexidade operacional desnecessária.

---

## Kubernetes

Kubernetes só deve ser recomendado quando houver:

- necessidade real de orquestração
- múltiplos serviços
- escalabilidade complexa
- alta demanda operacional
- necessidade forte de automação distribuída

Evitar Kubernetes prematuramente.

---

## Terraform

Terraform deve ser utilizado quando houver:

- infraestrutura reproduzível
- múltiplos ambientes
- automação cloud
- necessidade de versionamento infra

Evitar Terraform em infraestruturas pequenas sem benefício claro.

---

## Backend

Priorizar:

- APIs simples
- separação clara de domínio
- tratamento adequado de erros
- observabilidade
- baixo acoplamento
- código legível

---

## Frontend

Priorizar:

- componentes reutilizáveis
- experiência do usuário
- performance
- simplicidade visual
- consistência

---

## Banco de Dados

Priorizar:

- modelagem simples
- índices adequados
- queries eficientes
- crescimento sustentável
- cache inteligente

---

## Infraestrutura

Priorizar:

- simplicidade operacional
- automação gradual
- rollback seguro
- observabilidade
- segurança
- baixo downtime

---

## Mudanças Arquiteturais

Mudanças grandes devem:

- justificar tradeoffs
- apresentar riscos
- apresentar impacto operacional
- apresentar plano de rollback
- apresentar impacto financeiro quando relevante
