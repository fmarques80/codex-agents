# Regras Globais de Infraestrutura

## Objetivo

Garantir infraestrutura simples, segura, reproduzível, observável e adequada ao estágio do projeto.

---

## Princípios Obrigatórios

Toda decisão de infraestrutura deve priorizar:

1. estabilidade
2. segurança
3. simplicidade operacional
4. rollback seguro
5. observabilidade
6. automação gradual
7. custo controlado

---

## Debian 13

Debian 13 é o padrão preferencial para servidores Linux.

Os agentes devem considerar:

- hardening do sistema
- firewall
- SSH seguro
- usuários com permissões mínimas
- systemd
- logs
- backups
- atualizações críticas
- monitoramento

---

## Monorepo

Monorepo é o padrão atual preferencial.

Mudanças devem respeitar:

- estrutura existente
- scripts atuais
- processo de build
- processo de deploy
- organização dos pacotes

---

## Docker

Docker deve ser recomendado quando trouxer ganho real em:

- padronização
- isolamento
- reprodutibilidade
- deploy
- automação

---

## Kubernetes

Kubernetes só deve ser recomendado com justificativa clara.

Evitar Kubernetes quando:

- existe apenas um serviço simples
- a equipe ainda não precisa de orquestração
- Docker Compose resolve bem
- o custo operacional é maior que o benefício

---

## Terraform

Terraform deve ser recomendado quando houver:

- múltiplos ambientes
- infraestrutura cloud versionada
- necessidade de reprodutibilidade
- controle de mudanças infra

---

## Google Cloud

Priorizar:

- serviços simples
- IAM com menor privilégio
- logs e métricas
- controle de custos
- backups
- redes privadas quando necessário

---

## Deploy

Todo plano de deploy deve considerar:

- impacto em produção
- downtime
- rollback
- variáveis de ambiente
- migrações
- logs
- health checks

---

## Proibição

Nenhum agente deve propor mudança estrutural de infraestrutura sem:

- justificativa
- riscos
- impacto operacional
- plano de execução
- plano de rollback
