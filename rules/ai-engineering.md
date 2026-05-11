# Regras Globais de Engenharia de IA

## Objetivo

Garantir uso eficiente, seguro, previsível e sustentável de IA, agentes, LLMs e automações inteligentes.

---

## Princípios Obrigatórios

Sistemas de IA devem priorizar:

1. simplicidade
2. previsibilidade
3. baixo custo operacional
4. respostas confiáveis
5. segurança
6. baixo acoplamento
7. observabilidade

---

## Regras Gerais

Todos os agentes devem:

- evitar complexidade artificial
- evitar chains desnecessárias
- evitar agentes excessivos
- evitar múltiplas camadas sem benefício claro
- minimizar uso de contexto
- minimizar latência
- minimizar consumo de tokens
- priorizar arquitetura simples
- priorizar respostas reproduzíveis

---

## Agentes

Agentes devem:

- possuir responsabilidades claras
- evitar sobreposição
- evitar concorrência desnecessária
- possuir contexto limitado
- delegar apenas quando necessário
- evitar loops de delegação
- evitar coordenação excessiva

---

## Orquestração

O CTO Agent deve:

- ativar apenas agentes necessários
- evitar excesso de especialistas simultâneos
- reduzir desperdício de contexto
- consolidar respostas
- evitar duplicação de análise

---

## Contexto

Todos os agentes devem:

- utilizar apenas contexto relevante
- evitar enviar arquivos desnecessários
- evitar histórico excessivo
- resumir quando possível
- priorizar contexto operacional importante

---

## Prompt Engineering

Prompts devem:

- ser objetivos
- possuir responsabilidade clara
- evitar ambiguidades
- evitar instruções conflitantes
- limitar escopo
- possuir comportamento previsível

---

## RAG

Sistemas RAG devem priorizar:

- relevância
- contexto curto e útil
- chunking eficiente
- retrieval preciso
- redução de ruído
- atualização controlada

Evitar:
- contexto excessivo
- embeddings inúteis
- recuperação irrelevante

---

## Tokens e Custos

Todos os agentes devem:

- considerar custo de tokens
- evitar processamento redundante
- evitar contexto inflado
- reutilizar contexto quando possível
- considerar modelos menores quando viável

---

## Segurança de IA

Todos os sistemas com IA devem proteger contra:

- prompt injection
- vazamento de contexto
- exposição de secrets
- uso indevido de ferramentas
- escalonamento indevido de permissões
- execução insegura

---

## Ferramentas

Ferramentas devem:

- possuir escopo limitado
- validar entradas
- limitar ações perigosas
- registrar ações críticas
- respeitar permissões

---

## Observabilidade

Sistemas de IA devem possuir:

- logs relevantes
- rastreabilidade
- métricas de uso
- métricas de custo
- métricas de falha
- métricas de latência

---

## Qualidade

Sistemas de IA devem priorizar:

- respostas consistentes
- respostas úteis
- redução de hallucinations
- previsibilidade
- estabilidade operacional

---

## Proibições

Evitar:

- agentes desnecessários
- arquiteturas excessivamente complexas
- chains infinitas
- automações perigosas sem validação
- contexto ilimitado
- ferramentas sem restrição
- decisões autônomas críticas sem revisão

---

## Evolução Arquitetural

Arquiteturas de IA devem evoluir gradualmente.

Evitar:
- reescritas desnecessárias
- múltiplos frameworks concorrentes
- migrações prematuras
- complexidade sem benefício real
