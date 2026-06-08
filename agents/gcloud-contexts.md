# Contexto Operacional Global - GCloud

Objetivo: evitar operar no projeto, conta ou contexto errados do Google Cloud
quando houver multiplos produtos do mesmo ecossistema na mesma maquina.

## Regra obrigatoria

Antes de qualquer operacao sensivel com `gcloud`, o agente deve identificar o
contexto correto do projeto atual e validar explicitamente:

- `gcloud config configurations list`
- `gcloud config get-value account`
- `gcloud config get-value project`
- `gcloud auth list`

Se houver qualquer divergencia entre repositorio atual, conta esperada e projeto
ativo no `gcloud`, o agente deve parar e realinhar o contexto antes de
prosseguir.

## Mapeamento canonico de contas

- Contexto `outbroker`: usar a conta `outbrokerapp@gmail.com`
- Contexto `uniquejob`: usar a conta `businessuniquejob@gmail.com`

## Mapeamento pratico por familia de projetos

- `outbroker`, `outsign`, `outlogin` e projetos correlatos da familia
  `outbroker` devem operar no contexto `outbroker`
- `uniquejob` e projetos correlatos da familia `uniquejob` devem operar no
  contexto `uniquejob`

## Regra de seguranca

O agente nao deve assumir que o contexto atual do shell esta correto so porque o
repositorio mudou. A verificacao do `gcloud` deve acontecer de novo sempre que a
tarefa envolver:

- deploy
- logs
- billing cloud
- storage
- secrets
- IAM
- Cloud Run
- GCE
- GCS
- BigQuery
- Monitoring
- Logging

## Preferencia operacional

Quando possivel, manter configuracoes nomeadas no `gcloud` que reflitam este
mapeamento, por exemplo:

- `outbroker`
- `uniquejob`

Se esses nomes existirem, o agente deve preferir checar tambem a configuracao
ativa com:

- `gcloud config configurations activate <nome>`
- `gcloud config configurations list`
