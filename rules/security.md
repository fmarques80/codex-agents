# Regras Globais de Segurança

## Objetivo

Garantir segurança prática, proporcional ao contexto da aplicação e compatível com velocidade de desenvolvimento de startups.

---

## Princípios Obrigatórios

Todos os agentes devem:

- tratar segurança como responsabilidade obrigatória
- aplicar princípio do menor privilégio
- evitar exposição de dados sensíveis
- validar inputs
- tratar erros com segurança
- proteger secrets
- minimizar superfícies de ataque
- considerar LGPD quando aplicável

---

## Secrets

Nunca:

- expor secrets em código
- commitar secrets
- logar tokens sensíveis
- compartilhar credenciais

Sempre utilizar:
- variáveis de ambiente
- secret managers quando necessário

---

## APIs

Todas as APIs devem:

- validar inputs
- validar autenticação
- validar autorização
- aplicar rate limiting quando necessário
- evitar exposição desnecessária de dados
- tratar erros sem vazar detalhes internos

---

## Autenticação

Priorizar:

- sessões seguras
- expiração adequada
- MFA quando necessário
- gerenciamento seguro de tokens
- proteção contra brute force

---

## Banco de Dados

Todos os agentes devem:

- evitar queries inseguras
- limitar acesso por permissões
- proteger backups
- evitar exposição pública do banco

---

## Infraestrutura

Toda infraestrutura deve:

- minimizar portas expostas
- utilizar firewall
- utilizar SSH seguro
- limitar permissões
- manter atualizações críticas
- proteger acesso administrativo

---

## Docker

Containers devem:

- evitar rodar como root
- minimizar privilégios
- evitar exposição desnecessária
- proteger variáveis sensíveis

---

## Kubernetes

Quando utilizado:

- aplicar RBAC
- limitar permissões
- proteger secrets
- segmentar workloads
- monitorar acessos

---

## Frontend

O frontend nunca deve:

- confiar em validação client-side
- expor secrets
- expor informações internas sensíveis

---

## IA e LLMs

Sistemas com IA devem:

- proteger contexto interno
- evitar vazamento de dados
- validar ferramentas disponíveis
- proteger contra prompt injection
- limitar ações perigosas

---

## Logs

Logs nunca devem conter:

- senhas
- tokens
- credenciais
- secrets
- dados pessoais sensíveis

---

## Dependências

Todos os agentes devem:

- evitar bibliotecas desnecessárias
- evitar bibliotecas abandonadas
- avaliar riscos conhecidos
- manter dependências atualizadas quando possível

---

## Segurança vs Complexidade

Segurança deve ser prática.

Evitar:
- complexidade excessiva
- bloqueios desnecessários
- soluções inviáveis operacionalmente

Sempre equilibrar:
- risco
- impacto
- custo operacional
- velocidade de entrega
