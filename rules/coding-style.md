# Regras Globais de Código

## Objetivo

Garantir código limpo, consistente, legível e sustentável em todos os projetos.

---

## Princípios Obrigatórios

Todo código deve priorizar:

1. legibilidade
2. simplicidade
3. manutenção
4. previsibilidade
5. baixo acoplamento
6. facilidade de evolução

---

## Idioma

Código deve utilizar inglês para:

- variáveis
- funções
- classes
- interfaces
- tipos
- arquivos
- commits
- estruturas técnicas

Conteúdo exibido ao usuário deve estar em Português do Brasil.

---

## Regras Gerais

Todos os agentes devem:

- evitar complexidade desnecessária
- evitar funções gigantes
- evitar arquivos gigantes
- evitar duplicação
- evitar comentários redundantes
- evitar lógica escondida
- evitar efeitos colaterais inesperados
- escrever código explícito
- priorizar clareza

---

## Nomeação

Priorizar nomes:

- claros
- previsíveis
- consistentes
- sem abreviações desnecessárias

Evitar:
- nomes genéricos
- nomes ambíguos
- siglas obscuras

---

## Estrutura

Priorizar:

- separação clara de responsabilidades
- organização por domínio
- baixo acoplamento
- componentes reutilizáveis
- módulos pequenos

---

## TypeScript

Priorizar:

- tipagem explícita
- evitar any
- tipos reutilizáveis
- validação adequada
- interfaces claras

Evitar:
- tipagem fraca
- casts desnecessários
- tipos excessivamente complexos

---

## Backend

Priorizar:

- tratamento adequado de erros
- validação de inputs
- serviços desacoplados
- APIs previsíveis
- logs úteis
- observabilidade

---

## Frontend

Priorizar:

- componentes pequenos
- reutilização consciente
- renderização eficiente
- UX clara
- acessibilidade
- responsividade

---

## React / Next.js

Evitar:

- prop drilling excessivo
- estado global desnecessário
- re-renderizações desnecessárias
- hooks complexos sem necessidade

Priorizar:

- composição simples
- server components quando fizer sentido
- cache inteligente
- separação entre UI e lógica

---

## Banco de Dados

Priorizar:

- queries simples
- índices adequados
- paginação
- baixo acoplamento ao banco

Evitar:
- queries pesadas desnecessárias
- duplicação sem controle
- operações perigosas sem validação

---

## Logs

Logs devem ser:

- úteis
- objetivos
- rastreáveis

Nunca expor:
- secrets
- tokens
- dados sensíveis

---

## Comentários

Comentários devem existir apenas quando:

- a regra não for óbvia
- houver decisão arquitetural relevante
- houver comportamento complexo inevitável

Código limpo deve reduzir necessidade de comentários.

---

## Performance

Evitar:

- otimização prematura
- complexidade por micro performance

Otimizar apenas:
- gargalos reais
- problemas medidos
- impactos relevantes

---

## Testes

Priorizar testes para:

- fluxos críticos
- regras de negócio
- autenticação
- permissões
- integrações importantes

Evitar testes redundantes sem valor real.

---

## Refatoração

Refatorações devem:

- reduzir complexidade
- melhorar legibilidade
- preservar comportamento
- minimizar risco

Evitar reescritas sem necessidade real.
