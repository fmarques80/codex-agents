# Regras Globais de Performance

## Objetivo

Garantir performance adequada sem aumentar complexidade desnecessariamente.

---

## Princípios Obrigatórios

Toda otimização deve priorizar:

1. gargalos reais
2. simplicidade
3. estabilidade
4. custo-benefício
5. manutenção
6. previsibilidade

---

## Regra Principal

Nenhum agente deve otimizar antes de identificar gargalo real.

Sempre:

- medir antes
- diagnosticar antes
- validar impacto antes
- comparar custo vs benefício

---

## O Que Evitar

Evitar:

- otimização prematura
- cache desnecessário
- paralelismo desnecessário
- abstrações para micro performance
- complexidade excessiva
- arquiteturas superdimensionadas
- múltiplas camadas sem necessidade

---

## Frontend

Priorizar:

- bundle pequeno
- lazy loading quando necessário
- renderização eficiente
- redução de re-renderizações
- carregamento progressivo
- otimização de imagens
- cache inteligente

Evitar:
- estado global desnecessário
- componentes gigantes
- excesso de bibliotecas
- hidratação desnecessária

---

## Backend

Priorizar:

- queries eficientes
- baixo acoplamento
- redução de chamadas redundantes
- cache consciente
- filas quando necessário
- tratamento eficiente de concorrência

Evitar:
- processamento desnecessário
- múltiplas consultas redundantes
- lógica excessiva em tempo de request
- workers desnecessários

---

## Banco de Dados

Priorizar:

- índices corretos
- paginação
- queries simples
- leitura eficiente
- crescimento sustentável

Evitar:
- agregações pesadas desnecessárias
- consultas sem índice
- duplicação excessiva
- shard prematuro

---

## Infraestrutura

Priorizar:

- observabilidade
- monitoramento
- scaling gradual
- uso eficiente de recursos
- automação simples

Evitar:
- Kubernetes prematuro
- microserviços sem necessidade
- autoscaling complexo sem demanda real
- múltiplas camadas infra desnecessárias

---

## IA

Priorizar:

- contexto reduzido
- uso eficiente de tokens
- modelos menores quando possível
- cache quando fizer sentido
- redução de chamadas redundantes

Evitar:
- contexto excessivo
- múltiplos agentes sem necessidade
- chains longas
- processamento redundante

---

## Métricas

Todos os agentes devem considerar:

- latência
- memória
- CPU
- throughput
- custo cloud
- custo de tokens
- tempo de resposta
- consumo de rede

---

## Observabilidade

Toda otimização relevante deve possuir:

- métricas
- logs úteis
- rastreabilidade
- monitoramento básico

---

## Escalabilidade

Escalabilidade deve evoluir gradualmente.

Evitar:
- arquitetura para escala inexistente
- complexidade baseada em hipótese
- overengineering preventivo

---

## Rollback

Mudanças de performance devem considerar:

- impacto operacional
- risco
- reversibilidade
- plano de rollback
