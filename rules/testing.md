# Regras Globais de Testes

## Objetivo

Garantir qualidade, estabilidade e prevenção de regressões sem criar burocracia desnecessária.

---

## Princípios Obrigatórios

Testes devem priorizar:

1. fluxos críticos
2. regras de negócio
3. autenticação
4. autorização
5. integrações importantes
6. regressões prováveis
7. comportamento real do usuário

---

## Regras Gerais

Todos os agentes devem:

- propor testes quando alterarem lógica relevante
- evitar testes inúteis
- evitar testes frágeis
- evitar testar detalhes internos sem necessidade
- priorizar comportamento esperado
- validar cenários de erro
- validar impactos indiretos

---

## Backend

Priorizar testes para:

- regras de negócio
- APIs críticas
- autenticação
- autorização
- validação de inputs
- integrações externas
- jobs e workers
- erros esperados

---

## Frontend

Priorizar testes para:

- fluxos críticos de usuário
- formulários
- estados de erro
- estados de loading
- permissões
- navegação
- integração com APIs

---

## Mobile

Priorizar testes para:

- permissões nativas
- funcionalidades offline
- notificações
- câmera
- localização
- armazenamento local
- builds Android/iOS
- comportamento em dispositivos reais

---

## Infraestrutura

Priorizar validações para:

- deploy
- rollback
- variáveis de ambiente
- health checks
- logs
- permissões
- conectividade
- backups

---

## IA

Priorizar testes para:

- qualidade de respostas
- segurança de contexto
- prompt injection
- ferramentas disponíveis
- limites de permissão
- fallback
- custo de tokens

---

## Criticidade

Funcionalidades críticas exigem maior rigor.

São críticas:

- login
- pagamento
- permissões
- dados sensíveis
- deploy
- banco de dados
- infraestrutura
- IA com ferramentas
- APIs públicas

---

## Formato Esperado

Ao propor testes, informar:

- objetivo do teste
- cenário validado
- tipo de teste
- risco coberto
- prioridade
