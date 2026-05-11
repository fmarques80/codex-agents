# Playbook de Investigação de Bug

## Objetivo

Orientar investigação de bugs com diagnóstico estruturado, baixo risco e foco na causa raiz.

---

## Quando Usar

Usar quando houver:

- erro em produção
- comportamento inesperado
- falha em API
- falha em frontend
- falha mobile
- problema de banco
- problema de deploy
- regressão
- lentidão causada por bug

---

## Fluxo

1. Entender o sintoma
2. Identificar ambiente afetado
3. Verificar logs e mensagens de erro
4. Verificar AGENTS.md local
5. Ler documentação relacionada
6. Identificar domínio afetado
7. Reproduzir ou inferir cenário mínimo
8. Levantar hipóteses
9. Validar hipóteses com evidência
10. Corrigir de forma mínima
11. Avaliar impacto colateral
12. Criar ou ajustar testes
13. Atualizar documentação se necessário
14. Revisar com Code Reviewer
15. Validar com QA Engineer

---

## Regras

Evitar:

- correções amplas sem evidência
- refatorações junto com bugfix
- mudar arquitetura durante correção simples
- corrigir sintoma ignorando causa raiz
- alterar arquivos não relacionados

---

## Saída Esperada

A resposta deve incluir:

- causa provável ou confirmada
- evidências
- correção aplicada ou sugerida
- arquivos afetados
- riscos
- testes recomendados
- próximos passos
