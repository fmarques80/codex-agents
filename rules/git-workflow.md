# Regras Globais de Git e Versionamento

## Objetivo

Garantir histórico limpo, rastreável, seguro e organizado.

---

## Princípios Obrigatórios

Todos os agentes devem:

1. evitar mudanças desnecessárias
2. evitar arquivos não relacionados
3. manter commits objetivos
4. preservar histórico compreensível
5. minimizar risco de regressão

---

## Regras Gerais

Nenhum agente deve:

- alterar arquivos sem necessidade
- reformatar arquivos inteiros sem motivo
- misturar múltiplos objetivos no mesmo commit
- alterar código não relacionado
- remover código sem analisar impacto
- sobrescrever trabalho existente sem validação

---

## Commits

Commits devem ser:

- pequenos
- objetivos
- rastreáveis
- relacionados a uma única intenção

---

## Idioma

Commits devem utilizar inglês técnico.

---

## Padrão Preferencial

Priorizar:

- feat:
- fix:
- refactor:
- perf:
- docs:
- test:
- chore:
- ci:

---

## Branches

Evitar:

- branches gigantes
- mudanças acumuladas excessivamente
- múltiplos objetivos simultâneos

---

## Revisão

Mudanças importantes devem passar por:

- Code Reviewer
- QA Engineer
- Security Engineer quando necessário

---

## Refatorações

Refatorações devem:

- preservar comportamento
- reduzir complexidade
- possuir justificativa clara
- evitar mudanças desnecessárias

---

## Segurança

Nunca:

- commitar secrets
- commitar credenciais
- commitar variáveis sensíveis
- expor tokens
- expor arquivos internos inseguros

---

## Monorepo

Em monorepo:

- limitar escopo da mudança
- evitar impacto cruzado desnecessário
- respeitar boundaries dos módulos
- validar impacto nos pacotes relacionados

---

## Pull Requests

Pull requests devem incluir:

- objetivo
- impacto
- riscos
- testes realizados
- rollback quando necessário

---

## Diretriz de Recomendação

Quando houver um caminho tecnicamente superior, o agente deve recomendar apenas a melhor resposta possível.

O agente não deve:

- transferir a decisão ao usuário com listas de opções equivalentes quando houver uma opção claramente melhor
- responder de forma diplomática quando a escolha sugerida pelo usuário for tecnicamente errada
- validar um caminho ruim apenas porque foi sugerido pelo usuário

O agente deve:

- indicar a alternativa mais profissional, mais limpa e de menor risco
- dizer explicitamente quando a sugestão do usuário estiver errada, fraca ou perigosa
- justificar de forma objetiva por que o caminho recomendado é o correto

---

## Proibições

Evitar:

- commits gigantes
- alterações massivas sem revisão
- mudanças arquiteturais ocultas
- refactors desnecessários
- alterações automáticas sem validação
