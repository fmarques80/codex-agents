# Infraestrutura Atual da Outbroker

Este documento registra a infraestrutura atualmente confirmada da `outbroker`
fora do repositório da aplicação, para reutilização por futuras IAs sem
versionar esse contexto no Git do projeto.

## Status

- Fonte principal: validação direta via `gcloud` em `2026-06-04`
- Escopo: infraestrutura atualmente visível para a conta
  `outbrokerapp@gmail.com`
- Objetivo: evitar respostas por inferência quando o tema for produção, VM,
  deploy, storage, rede e riscos operacionais

## Projeto GCP da VM

- Projeto: `project-c70e3d96-205a-42c4-b6c`
- Nome do projeto: `MAQUINA VIRTUAL`
- Cloud: Google Cloud

Observação:

- Os projetos `outbroker` e `outbroker-prod` existem, mas não são o projeto da
  VM principal confirmada nesta checagem
- `outbroker`, `outsign`, `outlogin` e `outbroker-feed-bot` compartilham hoje a
  mesma VM deste projeto
- os DNS públicos dessas quatro aplicações apontam para o mesmo IP público da
  VM

## Instância principal

- Nome: `outbroker-prod`
- Status: `RUNNING`
- Região/zona: `southamerica-east1-b`
- Tipo de máquina: `e2-standard-2`
- Hostname: `outbroker.app`
- CPU platform: `Intel Broadwell`
- Provisioning model: `STANDARD`
- Restart automático: habilitado
- Host maintenance: `MIGRATE`

## Sistema operacional

- Imagem/licença do disco de boot: `debian-13-trixie`
- Conclusão operacional: a VM de produção roda em Debian 13

## Rede

- Network: `default`
- Subnetwork: `default` em `southamerica-east1`
- IP interno: `10.158.0.2`
- IP externo atual: `35.199.94.141`
- Network tier: `PREMIUM`
- Tags da instância:
  - `http-server`
  - `https-server`

## Regras de firewall confirmadas

- `default-allow-http`: abre `tcp:80` para `0.0.0.0/0`
- `default-allow-https`: abre `tcp:443` para `0.0.0.0/0`
- `default-allow-ssh`: abre `tcp:22` para `0.0.0.0/0`
- `allow-ssh`: abre `tcp:32800` para `0.0.0.0/0`
- `default-allow-internal`: tráfego interno amplo para a faixa privada

## Discos

### Disco de boot

- Nome: `outbroker-prod`
- Tamanho: `50 GB`
- Tipo: `pd-balanced`
- Auto delete: `true`

### Disco adicional de dados

- Nome: `outbrokerapp-disk`
- Tamanho: `100 GB`
- Tipo: `pd-balanced`
- Auto delete: `false`

Leitura operacional:

- existe separação entre disco de sistema e disco de dados
- o disco extra sugere persistência operacional fora do boot disk

## Snapshots

- Existem snapshots recorrentes dos dois discos
- Foram confirmados snapshots diários recentes de:
  - `outbroker-prod`
  - `outbrokerapp-disk`

Exemplo confirmado em `2026-06-04`:

- snapshots de `2026-06-03`
- snapshots de `2026-06-02`
- snapshots de `2026-06-01`

## Serviços GCP habilitados relevantes

- `compute.googleapis.com`
- `logging.googleapis.com`
- `monitoring.googleapis.com`
- `cloudtrace.googleapis.com`
- `osconfig.googleapis.com`
- `oslogin.googleapis.com`
- `storage.googleapis.com`

Observação:

- também há várias APIs de Maps/Places habilitadas no projeto

## Padrão de deploy e runtime da aplicação

Esse ponto vem do checkout da aplicação e da operação recente:

- `outbroker` em `Next.js`
- `outsign` em `Next.js`
- `outlogin` em `Next.js`
- `outbroker-feed-bot` em `Node.js`
- deploy por `GitHub Actions`
- produção em `/home/outbroker/prod`
- produção de `outsign` em `/home/outsign/prod`
- produção de `outlogin` em `/home/outlogin/prod`
- modelo release-based com `releases/` + symlink `current`
- processo principal gerido por `PM2`
- persistência do PM2 via `systemd`
- storage persistente da aplicação em `Cloudflare R2`
- MongoDB como banco principal
- Redis suportado pelo código como cache opcional

## Topologia operacional atual

### Infraestrutura compartilhada

- uma única VM do projeto `MAQUINA VIRTUAL` hospeda todas as aplicações do
  ecossistema validado nesta sessão
- essa VM atende:
  - `outbroker`
  - `outsign`
  - `outlogin`
  - `outbroker-feed-bot`
- os DNS públicos dessas aplicações convergem para o mesmo IP público

### Organização operacional por usuário na VM

Informação operacional fornecida pelo Filipe e tratada como referência local
válida para futuras IAs:

- há acesso SSH disponível pela entrada `ssh outbroker`
- dentro da VM, as aplicações estão distribuídas por usuário do sistema
- cada usuário tende a listar sua própria aplicação, com a exceção de
  `outbroker`, que também concentra waitlist e bot

Mapa atual informado:

- usuário `outbroker`
  - `outbroker`
  - `outbot` (`outbroker-feed-bot`)
  - `outbroker.com.br` (waitlist)
- usuário `outsign`
  - `outsign`
- usuário `outlogin`
  - `outlogin`
- usuário `outlabel`
  - `outlabel`

Regra operacional derivada:

- ao auditar a VM por SSH, não assumir que um único usuário revela todas as
  aplicações
- começar por `outbroker`, mas lembrar que `outsign`, `outlogin` e `outlabel`
  têm contextos separados de runtime
- a entrada `ssh outbroker` conecta como usuário `filipe` na VM
- o contexto do usuário `outbroker` pode ser acessado via `sudo -iu outbroker`
- o usuário `filipe` está no `sudoers` e concentra a elevação de privilégio da
  VM
- para trocar de contexto entre apps/usuários, o fluxo correto é partir de
  `filipe`; não assumir que é possível sair de `outbroker` direto para
  `outsign`, `outlogin` ou `outlabel`

### Leitura arquitetural

- a organização atual do Google Cloud não segue o modelo "um projeto por app"
- o projeto `MAQUINA VIRTUAL` concentra a infraestrutura de runtime
- outros projetos GCP aparentam cumprir papéis auxiliares de integração,
  autenticação, push ou legado

## Inventário inicial de projetos GCP visíveis

### Projeto de infraestrutura principal

- `project-c70e3d96-205a-42c4-b6c`
  - nome: `MAQUINA VIRTUAL`
  - função real hoje: hospedar a VM única onde todas as quatro aplicações rodam
  - evidência:
    - `compute.googleapis.com` habilitado
    - instância `outbroker-prod` em `RUNNING`
    - IP público em uso
  - dependência:
    - `outbroker`
    - `outsign`
    - `outlogin`
    - `outbroker-feed-bot`

### Projetos auxiliares ou candidatos a legado

- `outbroker`
  - nome original auditado: `AUTENTICACAO`
  - nome atual confirmado: `Outbroker Waitlist`
  - função real hoje: projeto associado primariamente ao
    `outbroker-waitlist`, com possível legado secundário de auth/identidade
  - evidência:
    - nome original sugeria auth
    - rename aplicado para refletir waitlist
    - sem `compute.googleapis.com`
    - service account `waitlist@outbroker.iam.gserviceaccount.com`
    - serviços básicos de observabilidade e storage habilitados
  - dependência provável:
    - `outbroker-waitlist`
    - possivelmente algum legado de auth/identidade

- `outbroker-push-notification`
  - nome: `Outbroker Push Notification`
  - função real hoje: provável projeto auxiliar de push/Firebase
  - evidência:
    - `firebase.googleapis.com` habilitado
    - service account
      `firebase-adminsdk-fbsvc@outbroker-push-notification.iam.gserviceaccount.com`
    - API keys auto criadas pelo Firebase
    - sem Compute
  - dependência provável:
    - `outbroker`
    - possivelmente app mobile ou backend de push

- `outbroker-prod`
  - nome: `outbroker sem vm`
  - função real hoje: indefinida
  - evidência:
    - sem Compute
    - nome sugere projeto criado para produção sem uso atual de VM
  - leitura atual:
    - forte candidato a nome residual, projeto vazio operacionalmente ou uso
      parcial/temporário

- `gen-lang-client-0485197507`
  - nome: `Outsign AI Experimental`
  - função real hoje: indefinida
  - evidência:
    - rename aplicado para refletir vínculo provável com `outsign`
    - API key `Outbroker Trae`
    - sem footprint operacional confirmado nesta checagem
  - leitura atual:
    - forte candidato a experimento, resíduo ou projeto criado por integração
      assistida

- `geocoding-496221`
  - nome: `GEOCODING`
  - função real hoje: provável projeto auxiliar/experimental ligado a geocoding
  - evidência:
    - sem Compute
    - nome específico de domínio
    - API key `Maps Platform API Key`
  - observação:
    - o projeto da VM principal é quem mostrou APIs de Maps/Places habilitadas,
      então este projeto pode estar subutilizado ou legado

## Vínculos externos auditados até agora

### Service accounts confirmadas

- `outbroker`
  - `waitlist@outbroker.iam.gserviceaccount.com`
- `outbroker-push-notification`
  - `firebase-adminsdk-fbsvc@outbroker-push-notification.iam.gserviceaccount.com`
- `project-c70e3d96-205a-42c4-b6c`
  - `440811566251-compute@developer.gserviceaccount.com`

Leitura:

- `outbroker` não está vazio; há ao menos uma service account específica
- `outbroker-push-notification` tem uma service account típica de Firebase Admin
- `MAQUINA VIRTUAL` usa a service account default do Compute Engine

### API keys confirmadas

- `project-c70e3d96-205a-42c4-b6c`
  - `Maps Platform API Key`
- `geocoding-496221`
  - `Maps Platform API Key`
- `outbroker-push-notification`
  - `Android key (auto created by Firebase)`
  - `Browser key (auto created by Firebase)`
- `gen-lang-client-0485197507`
  - `Outbroker Trae`

Leitura:

- existem pelo menos duas chaves distintas de Maps no ecossistema
- existe footprint claro de Firebase no projeto de push
- existe ao menos uma chave de ferramenta ou integração assistida no projeto
  `gen-lang-client-0485197507`

### OAuth / brands via GCP

Não houve evidência útil de brands ou clients geridos por IAP nos projetos
auditados.

Leitura:

- o fluxo OAuth do ecossistema provavelmente não é gerido por IAP
- no caso do `outlogin`, os clientes OAuth aparentam ser parte da própria
  aplicação e do seu banco, não um recurso GCP desta trilha

### Firebase

- `outbroker-push-notification` mostrou `firebase.googleapis.com` habilitado
- o código local do `outbroker` confirma uso de:
  - `google-services.json` no Android
  - `FIREBASE_PROJECT_ID`
  - `GOOGLE_APPLICATION_CREDENTIALS`
  - FCM HTTP v1 por service account

Leitura:

- `outbroker-push-notification` é hoje o candidato mais forte a projeto real de
  push/mobile do ecossistema
- isso foi confirmado também na VM:
  - `GOOGLE_APPLICATION_CREDENTIALS` do `outbroker` aponta para
    `/opt/outbroker/secrets/firebase-service-account.json`
  - esse JSON tem:
    - `project_id=outbroker-push-notification`
    - `client_email=firebase-adminsdk-fbsvc@outbroker-push-notification.iam.gserviceaccount.com`
  - o `android/app/google-services.json` de produção do `outbroker` também usa:
    - `project_id=outbroker-push-notification`
    - `project_number=309069443605`

### Maps / Geocoding

O código local do `outbroker` usa:

- `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY`
- `maps.googleapis.com`
- geocoding por `maps/api/geocode/json`

No GCP, foram encontradas chaves de Maps em:

- `project-c70e3d96-205a-42c4-b6c`
- `geocoding-496221`

Leitura:

- a chave usada pelo `outbroker` em produção foi comparada sem expor segredo e
  corresponde ao projeto `MAQUINA VIRTUAL`
- a chave de `geocoding-496221` não corresponde ao valor presente em
  `/home/outbroker/prod/.env`
- isso reduz fortemente a chance de `geocoding-496221` ser parte do runtime
  atual do `outbroker`

## Cruzamento com os repositórios locais

### outbroker

- usa Firebase/FCM no app Android e no backend
- usa `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY`
- usa `GOOGLE_APPLICATION_CREDENTIALS`
- depende de `OUTLOGIN_CLIENT_ID` e `OUTLOGIN_CLIENT_SECRET`

Conclusão parcial:

- depende com alta probabilidade de:
  - `outbroker-push-notification` para push/Firebase
  - `project-c70e3d96-205a-42c4-b6c` ou `geocoding-496221` para Maps/Geocoding
  - `outlogin` para OAuth do ecossistema
- na VM, o vínculo com `outbroker-push-notification` já ficou comprovado
- na VM, a chave de Maps em produção também já ficou comprovada como pertencente
  ao projeto `MAQUINA VIRTUAL`

### outbroker-waitlist

- repo local: `~/projetos/outbroker-waitlist`
- branch observada: `main`
- deploy próprio para `/home/outbroker/outbroker.com.br`
- processo PM2: `outbroker-waitlist`
- usa MongoDB com coleção `waitlist`
- usa credenciais Google para consultar GA4
  - `GA4_CLIENT_EMAIL`
  - `GA4_PRIVATE_KEY`
  - `GA4_SERVICE_ACCOUNT_JSON`
  - `GOOGLE_CLIENT_EMAIL`
  - `GOOGLE_SERVICE_ACCOUNT_EMAIL`

Conclusão parcial:

- o projeto GCP `outbroker` está ligado com alta probabilidade ao
  `outbroker-waitlist`
- evidência principal:
  - service account `waitlist@outbroker.iam.gserviceaccount.com`
    com display name `Waitlist`
  - semântica do repo local, da coleção Mongo e do nome da service account
- isso não elimina vínculo conceitual com auth/identidade, mas hoje o vínculo
  operacional comprovado mais forte é com `outbroker-waitlist`
- o projeto foi renomeado no GCP de `AUTENTICACAO` para `Outbroker Waitlist`
  após a confirmação operacional desse vínculo
- na VM, isso foi reforçado porque `outbroker.com.br/.env.production` contém:
  - `GA4_CLIENT_EMAIL=waitlist@outbroker.iam.gserviceaccount.com`
  - `GA4_PROPERTY_ID` presente
- até prova em contrário, tratar `outbroker` como projeto associado ao app
  `outbroker-waitlist`, com hipótese secundária de também carregar algum legado
  ou responsabilidade ligada a auth/identidade
- decisão mais recente do Filipe:
  - a waitlist não fará mais parte do ecossistema ativo
  - isso torna o projeto `Outbroker Waitlist` candidato a exclusão controlada
    após checagem final do app e do uso de GA4

### outsign

- integra com `outlogin` por `OUTLOGIN_CLIENT_ID` e `OUTLOGIN_CLIENT_SECRET`
- não mostrou vínculo GCP explícito além de dependências gerais
- o código local tem fallback de IA por Gemini:
  - `src/lib/server/scan-ocr.ts`
  - `@google/genai`
  - `GEMINI_API_KEY` / `GOOGLE_API_KEY`

Conclusão parcial:

- não há hoje evidência de projeto GCP dedicado para `outsign`
- a aplicação pode simplesmente consumir a VM compartilhada e integrações
  comuns do ecossistema
- existe um projeto experimental renomeado para `Outsign AI Experimental`, com
  vínculo provável ao `outsign`, mas sem prova de uso em produção hoje

### outlabel

- repo local: `~/projetos/outlabel`
- repo remoto: `git@github.com:outbrokerapp/outlabel.git`
- branch observada: `main`
- stack local:
  - `Next.js 16`
  - `React 19`
  - `TypeScript`
- PM2 local previsto:
  - app `outlabel-app`
  - `cwd=/home/outlabel/outlabel-app`
  - `next start -p 1339`

Conclusão parcial:

- `outlabel` existe como aplicação própria no workspace local e já possui
  configuração de runtime/PM2
- no host auditado via `filipe`, não apareceu processo ativo do usuário
  `outlabel`
- também não surgiram arquivos acessíveis em `/home/outlabel` nem referências
  de Nginx para `outlabel`
- não apareceu projeto GCP com nome `outlabel` no inventário atual
- até prova em contrário, tratar `outlabel` como app preparada para deploy, mas
  sem evidência operacional atual no host

### outlogin

- expõe OAuth do ecossistema dentro da própria aplicação
- usa MongoDB
- fala com `outbroker` e `outsign`
- usa Google OAuth por variáveis locais:
  - `GOOGLE_CLIENT_ID`
  - `GOOGLE_CLIENT_SECRET`
  - `GOOGLE_ANDROID_CLIENT_ID`
  - `GOOGLE_IOS_CLIENT_ID`
- registra clientes OAuth no próprio banco via coleção/modelo
  `IdentityOAuthClient`
- o script `create-oauth-client.mjs` grava clients no Mongo do próprio
  `outlogin`, não em recurso GCP dedicado

Conclusão parcial:

- até aqui não apareceu um recurso GCP específico provando que um projeto
  separado é "o projeto do outlogin"
- o nome antigo `AUTENTICACAO` era conceitualmente compatível com `outlogin`, mas
  a auditoria técnica aponta que o OAuth real do `outlogin` vive:
  - nas variáveis de ambiente da app
  - no banco Mongo da própria app
- por enquanto, não há evidência suficiente para dizer que o projeto GCP
  `outbroker` seja operacionalmente "o projeto do outlogin"

## Auditoria focada do outlogin

### O que foi confirmado no código

- `outlogin` é um serviço próprio de identidade/OAuth do ecossistema
- expõe:
  - `/oauth/authorize`
  - `/oauth/token`
  - `/oauth/userinfo`
- mantém clientes OAuth no próprio banco
- aceita `app: outbroker|outsign` ao provisionar clientes OAuth
- usa secrets/IDs Google via `.env`, não via IAP nem via recurso GCP específico

### O que não apareceu

- nenhuma service account específica de `outlogin` no GCP auditado
- nenhuma API key claramente atribuída ao `outlogin`
- nenhuma brand/client útil de OAuth via IAP
- nenhum projeto GCP com footprint inequívoco de "este é o projeto do
  outlogin"

### Leitura operacional

- `outlogin` depende da VM compartilhada para runtime
- depende do próprio Mongo para identidade, OAuth clients e fluxo de auth
- depende de credenciais Google configuradas localmente no ambiente da app
- hoje ele não justifica, com a evidência disponível, um projeto GCP dedicado já
  confirmado nesta auditoria

### outbroker-feed-bot

- usa `OUTBROKER_URL`, MongoDB e R2
- não mostrou vínculo GCP específico

Conclusão parcial:

- não há evidência, por ora, de projeto GCP dedicado ao bot

## Matriz de reorganização inicial

### 1. `project-c70e3d96-205a-42c4-b6c`

- função real hoje: infraestrutura principal compartilhada
- aplicações que dependem dele:
  - `outbroker`
  - `outsign`
  - `outlogin`
  - `outbroker-feed-bot`
- evidência:
  - VM ativa
  - discos
  - snapshots
  - firewall
  - IP público compartilhado
- ação sugerida:
  - manter
  - renomear no GCP para um nome sem ambiguidade
- sugestão de nome:
  - `Outbroker Shared Runtime`
  - ou `Outbroker Production Runtime`
- risco de mexer:
  - alto se a mudança for além de rename/descritivo
  - baixo para ajuste apenas nominal/documental
- classificação revisada:
  - `confirmado e crítico`

### 2. `outbroker`

- função real hoje: projeto associado com alta probabilidade ao
  `outbroker-waitlist`, com possível legado secundário de auth/identidade
- aplicações que dependem dele:
  - `outbroker-waitlist` confirmado com alta probabilidade
  - `outlogin` apenas como hipótese conceitual, não comprovada
- evidência:
  - nome original do projeto `AUTENTICACAO`
  - rename já aplicado para `Outbroker Waitlist`
  - ausência de Compute
  - presença da service account `waitlist`
  - waitlist em produção usa `GA4_CLIENT_EMAIL=waitlist@outbroker.iam.gserviceaccount.com`
- ação sugerida:
  - tratar como projeto em fase final de descontinuação
  - validar se a waitlist pode ser desligada de vez
  - checar se o uso de GA4 ainda precisa ser preservado/exportado
  - após isso, preparar exclusão
- sugestão de nome:
  - `Outbroker Waitlist`
  - ou `Outbroker Waitlist and Auth Legacy`
- risco de mexer:
  - médio
  - o maior risco agora é quebrar waitlist/GA4, não `outlogin`
- classificação revisada:
  - `candidato a exclusão controlada`

### 3. `outbroker-push-notification`

- função real hoje: projeto auxiliar de push/Firebase
- aplicações que dependem dele:
  - provavelmente `outbroker`
- evidência:
  - `firebase.googleapis.com` habilitado
  - nome específico e coerente
  - service account Firebase Admin
  - API keys Firebase auto criadas
  - produção do `outbroker` usa service account e `google-services.json` desse
    projeto
- ação sugerida:
  - manter
  - padronizar nomenclatura se necessário
- sugestão de nome:
  - `Outbroker Push`
  - ou `Outbroker Firebase Push`
- risco de mexer:
  - médio
  - exige checagem de FCM, `google-services.json`, service account e backend
- classificação revisada:
  - `confirmado e vivo`

## Evidências validadas diretamente na VM

### outbroker

- PM2 no usuário `outbroker` mostra:
  - `outbroker-devel`
  - `outbroker-prod`
  - `outbroker-feed-bot`
  - `outbroker-waitlist`
- o backend de produção usa:
  - `GOOGLE_APPLICATION_CREDENTIALS=/opt/outbroker/secrets/firebase-service-account.json`
- esse arquivo de credenciais resolve para:
  - projeto `outbroker-push-notification`
  - service account Firebase Admin do projeto de push
- a variável `NEXT_PUBLIC_GOOGLE_MAPS_API_KEY` da produção foi comparada com as
  chaves ativas do GCP e corresponde ao projeto `MAQUINA VIRTUAL`

### waitlist

- a aplicação `outbroker-waitlist` roda em
  `/home/outbroker/outbroker.com.br`
- o ambiente de produção contém:
  - `GA4_CLIENT_EMAIL=waitlist@outbroker.iam.gserviceaccount.com`
  - `GA4_PROPERTY_ID` presente

Leitura:

- o vínculo do projeto GCP `outbroker` com a waitlist deixou de ser apenas
  hipótese forte e passou a ser evidência operacional concreta

### 4. `outbroker-prod`

- função real hoje: indefinida
- aplicações que dependem dele:
  - não confirmadas
- evidência:
  - sem Compute
  - sem service accounts
  - sem API keys
  - sem buckets
  - sem Cloud SQL
  - sem Secret Manager
  - sem Pub/Sub
  - sem Scheduler
  - sem Cloud Functions
  - sem Cloud Run
  - billing desabilitado
  - IAM efetivo observado:
    - `roles/owner -> user:outbrokerapp@gmail.com`
  - nome inconsistente com a topologia atual
- ação sugerida:
  - tratava-se de candidato muito forte a desuso
  - exclusão solicitada em `2026-06-04T10:09:49-03:00`
  - estado observado após a solicitação:
    - `LIFECYCLE_STATE=DELETE_REQUESTED`
  - só resta reverter com `gcloud projects undelete outbroker-prod` se houver
    motivo administrativo
- sugestão de destino:
  - remover se vazio operacionalmente
  - ou renomear se for identificado papel real
- risco de mexer:
  - médio enquanto não houver auditoria de credenciais e APIs
- classificação revisada:
  - `em remoção`

### 5. `gen-lang-client-0485197507`

- função real hoje: indefinida
- aplicações que dependem dele:
  - não confirmadas
- evidência:
  - nome atual no GCP: `Outsign AI Experimental`
  - chave `Outbroker Trae`
  - API habilitada `generativelanguage.googleapis.com`
  - billing desabilitado
  - owner observado:
    - `user:outbrokerapp@gmail.com`
  - sem service accounts
  - sem buckets
  - sem Cloud SQL
  - sem Compute
  - sem Artifact Registry
  - sem Secret Manager
  - sem Pub/Sub
  - sem Cloud Run
  - no código local, o candidato mais plausível de consumo é o `outsign`, que
    usa `@google/genai` e lê `GEMINI_API_KEY`/`GOOGLE_API_KEY`
  - no host de produção, a árvore `/home/outsign/prod` é legível pelo usuário
    `filipe` e mostrou:
    - `.env` sem `GEMINI_API_KEY` e sem `GOOGLE_API_KEY`
    - `package.json` com `@google/genai` e `google-auth-library`
    - nenhum uso textual de `GEMINI_API_KEY`, `GOOGLE_API_KEY`,
      `GoogleGenAI`, `@google/genai` ou `generativelanguage` fora de
      `node_modules`
- ação sugerida:
  - tratar como projeto experimental de IA
  - provável relação com testes/ferramentas de Gemini
  - considerar que, hoje, não há prova de uso em produção do `outsign`
  - antes de excluir, ainda vale checar se existe chave injetada por outro meio
    fora do `.env` visível
- risco de mexer:
  - baixo/médio, porque ainda existe uma chave ativa no projeto
  - o risco principal é quebrar algum fallback de IA ainda não ativado ou algum
    uso experimental fora do `outsign` de produção
- classificação revisada:
  - `experimental de IA com vínculo provável ao outsign, sem prova de uso em produção`

### 6. `geocoding-496221`

- função real hoje: provável projeto auxiliar ou experimental de geocoding
- aplicações que dependem dele:
  - não confirmadas
- evidência:
  - nome específico
  - sem runtime
  - possui chave própria de Maps
  - `geocoding-backend.googleapis.com` habilitado
  - billing habilitado
  - IAM efetivo observado:
    - `roles/owner -> user:outbrokerapp@gmail.com`
  - sem service accounts
  - sem buckets
  - sem Cloud SQL
  - sem Compute
  - sem Artifact Registry
  - sem Secret Manager
  - sem Pub/Sub
  - sem Cloud Run
  - billing habilitado na conta:
    - `billingAccounts/011DFB-1DE71C-9CC210`
  - a chave `Maps Platform API Key` está restrita por `apiTargets`, cobrindo a
    família ampla do Google Maps Platform:
    - `maps-backend.googleapis.com`
    - `geocoding-backend.googleapis.com`
    - `places-backend.googleapis.com`
    - `routes.googleapis.com`
    - e vários outros serviços da mesma família
  - o projeto tem várias APIs habilitadas além de geocoding, incluindo:
    - BigQuery
    - Dataplex
    - Dataform
    - Datastore
    - Storage
  - a chave de produção do `outbroker` não vem deste projeto; o runtime atual do
    `outbroker` usa a chave do projeto `MAQUINA VIRTUAL`
- ação sugerida:
  - classificar como candidato a exclusão, não como projeto a ser adotado pelo
    `outbroker` atual
  - não migrar o `outbroker` para usar este projeto agora, porque isso só
    aumentaria a dispersão do ecossistema sem resolver um problema real
  - antes de excluir, fazer uma checagem final humana sobre a origem da chave e
    sobre o motivo de BigQuery/Dataform/Dataplex ainda estarem habilitados
- risco de mexer:
  - baixo para o runtime atual do `outbroker`
  - médio para experimentos, scripts ou painéis antigos que possam ter usado a
    mesma chave ou as APIs analíticas habilitadas
- classificação revisada:
  - `candidato a exclusão com chave ativa e billing ligado`

## Matriz revisada em uma linha

- `project-c70e3d96-205a-42c4-b6c`
  - status: manter
  - classe: confirmado e crítico
- `outbroker`
  - status: preparar exclusão controlada
  - classe: candidato a exclusão controlada
- `outbroker-push-notification`
  - status: manter
  - classe: confirmado e vivo
- `outbroker-prod`
  - status: exclusão solicitada
  - classe: em remoção
- `gen-lang-client-0485197507`
  - status: manter em auditoria
  - classe: experimental de IA com vínculo provável ao outsign, sem prova de uso em produção
- `geocoding-496221`
  - status: preparar exclusão após checagem final humana
  - classe: candidato a exclusão com chave ativa e billing ligado

## Ordem sugerida para reorganização

### Etapa 1. Confirmar vínculos externos antes de qualquer remoção

- OAuth consent screen
- clientes OAuth
- Firebase/FCM
- service accounts
- API keys de Maps/Places/Geocoding
- secrets dos workflows
- `.env` e arquivos de credenciais nos hosts

### Etapa 2. Renomear projetos que permanecerem

- começar pelos projetos com função claramente conhecida
- manter um mapa explícito entre nome atual e nome novo

### Etapa 3. Marcar candidatos a legado

- `outbroker-prod`
- `gen-lang-client-0485197507`
- `geocoding-496221` se não houver consumo atual

### Etapa 4. Remover apenas após prova negativa

- nenhum segredo ativo
- nenhuma API key ativa
- nenhum cliente OAuth ativo

## Recomendação de organização do ecossistema GCP

### Princípio recomendado

Para este ecossistema, a organização mais saudável tende a ser:

- projeto principal por aplicação quando a aplicação possui runtime próprio,
  credenciais próprias e ciclo de vida próprio
- projetos separados por função apenas quando a função é realmente
  compartilhada, sensível ou merece governança isolada

Em termos práticos, evitar:

- um projeto separado para cada serviço pequeno sem necessidade real
- nomes genéricos ou ambíguos que escondem a função real do projeto

### Modelo sugerido para este ecossistema

#### 1. Projeto de runtime compartilhado

Enquanto todas as aplicações continuarem na mesma VM, faz sentido manter um
projeto de infraestrutura compartilhada para o host principal.

Exemplo de papel:

- VM
- discos
- snapshots
- firewall
- APIs de Maps realmente usadas pela aplicação hospedada ali

Projeto atual correspondente:

- `project-c70e3d96-205a-42c4-b6c`

#### 2. Projetos por aplicação quando houver integração própria relevante

Quando uma aplicação tiver integração própria clara, especialmente com billing,
push, OAuth, analytics ou segredo sensível, o projeto pode ser identificado pela
aplicação.

Exemplos do que faz sentido:

- `Outbroker Waitlist`
- `Outbroker Push`

#### 3. Projetos auxiliares compartilhados só quando a fronteira for real

Criar projeto separado por serviço só faz sentido quando o serviço é realmente:

- compartilhado por várias aplicações
- sensível do ponto de vista de credenciais
- sujeito a billing/quotas próprios
- operado por outra pessoa/time

Exemplos clássicos:

- Firebase compartilhado entre vários apps móveis
- billing/finops segregado
- ambiente de IA/experimentos separado do runtime principal

### Aplicação prática ao seu caso

Hoje, eu seguiria esta lógica:

- manter um projeto de runtime compartilhado para a VM principal
- manter projetos específicos quando a função real já está clara
  - `Outbroker Waitlist`
  - `Outbroker Push`
- evitar criar agora um projeto separado só para `geocoding` se a aplicação
  principal já usa Maps a partir do projeto da VM
- evitar multiplicar projetos por "cada serviço Google" se esse serviço só é
  consumido por uma aplicação única

### Regra de decisão simples

Usar projeto por aplicação como padrão.

Abrir exceção para projeto por serviço apenas quando pelo menos uma destas
condições for verdadeira:

- o serviço é compartilhado por várias aplicações
- o serviço tem billing/quotas que precisam de isolamento
- o serviço tem risco/credenciais sensíveis que merecem separação
- o serviço é claramente experimental e não deve se misturar ao runtime

### Leitura estratégica para os candidatos atuais

- `Outbroker Waitlist`
  - faz sentido como projeto de aplicação
- `Outbroker Push`
  - faz sentido como projeto funcional dedicado porque envolve Firebase/mobile
- `MAQUINA VIRTUAL`
  - faz sentido como projeto de infraestrutura compartilhada enquanto houver VM
    única
- `geocoding-496221`
  - não parece um bom projeto dedicado neste momento, a menos que você queira
    transformar Maps/Geocoding em uma capacidade compartilhada de várias apps
- `gen-lang-client-0485197507`
  - faz sentido como projeto experimental separado de IA, se esse for de fato o
    propósito
- decisão mais recente do Filipe:
  - `geocoding-496221` entra em fila de exclusão

## Matriz final consolidada

### Fica

- `project-c70e3d96-205a-42c4-b6c`
  - nome atual: `MAQUINA VIRTUAL`
  - papel: infraestrutura compartilhada e runtime atual de todo o ecossistema
  - decisão: manter
  - observação: candidato futuro a rename para algo como `Outbroker Shared Runtime`

- `outbroker-push-notification`
  - papel: Firebase/push real do `outbroker`
  - decisão: manter
  - observação: é um projeto funcional dedicado válido no estado-alvo

- `gen-lang-client-0485197507`
  - nome atual: `Outsign AI Experimental`
  - papel: projeto experimental de IA com vínculo provável ao `outsign`
  - decisão: manter em auditoria
  - observação: não há prova de uso em produção hoje, mas o rename já deixa a
    função muito mais clara

### Exclui

- `outbroker`
  - nome atual: `Outbroker Waitlist`
  - papel: projeto associado à waitlist
  - decisão: excluir de forma controlada
  - estado observado: `DELETE_REQUESTED`
  - motivo: a waitlist não fará mais parte do ecossistema ativo

- `outbroker-prod`
  - nome auditado antes da exclusão: `outbroker sem vm`
  - papel: projeto vazio ou residual
  - decisão: exclusão já solicitada
  - estado observado: `DELETE_REQUESTED`

- `geocoding-496221`
  - nome atual: `GEOCODING`
  - papel: projeto auxiliar/legado com chave própria de Maps
  - decisão: excluir
  - estado observado: `DELETE_REQUESTED`
  - motivo: o runtime atual do `outbroker` não usa a chave deste projeto

- `gen-lang-client-0289831592`
  - nome atual: `Default Gemini Project`
  - papel: projeto Gemini genérico sem evidência de uso no ecossistema
  - decisão: excluir
  - estado observado: `DELETE_REQUESTED`
  - motivo: sem billing, sem chaves, sem service accounts e sem referência no workspace

- `argon-retina-469422-q0`
  - nome atual: `My First Project`
  - papel: projeto genérico sem uso confirmado
  - decisão: excluir
  - estado observado: `DELETE_REQUESTED`
  - motivo: sem billing útil, sem chaves, sem service accounts e sem referência no workspace

- `extreme-arch-469522-b1`
  - nome atual: `My First Project`
  - papel: projeto genérico sem uso confirmado
  - decisão: excluir
  - estado observado: `DELETE_REQUESTED`
  - motivo: sem chaves, sem service accounts, sem buckets e sem SQL

- `leafy-clone-469522-i8`
  - nome atual: `My First Project`
  - papel: projeto genérico sem uso confirmado
  - decisão: excluir
  - estado observado: `DELETE_REQUESTED`
  - motivo: sem billing útil, sem chaves, sem service accounts e sem referência no workspace

- `poised-ceiling-469522-c2`
  - nome atual: `My First Project`
  - papel: projeto genérico sem uso confirmado
  - decisão: excluir
  - estado observado: `DELETE_REQUESTED`
  - motivo: sem billing útil, sem chaves, sem service accounts e sem referência no workspace

- `round-cacao-469522-c0`
  - nome atual: `My First Project`
  - papel: projeto genérico sem uso confirmado
  - decisão: excluir
  - estado observado: `DELETE_REQUESTED`
  - motivo: sem billing útil, sem chaves, sem service accounts e sem referência no workspace

- `sacred-vault-469422-f6`
  - nome atual: `My First Project`
  - papel: projeto genérico sem uso confirmado
  - decisão: excluir
  - estado observado: `DELETE_REQUESTED`
  - motivo: sem billing útil, sem chaves, sem service accounts e sem referência no workspace

### Sem evidência operacional atual

- `outlabel`
  - repo e configuração local existem
  - não apareceu projeto GCP com nome correspondente
  - não apareceu evidência operacional atual no host
  - decisão: manter fora da matriz de projetos GCP atuais até surgir runtime ou
    projeto dedicado

### Estado-alvo futuro

- projeto por aplicação como padrão
- exceções apenas para:
  - infraestrutura compartilhada
  - push/mobile
  - experimentos de IA
- desmembramento futuro sugerido:
  - `outbroker` com runtime próprio
  - `outsign` com runtime próprio
  - `outlogin` com runtime próprio
  - `outbot` com runtime próprio
  - worker de build compartilhado
  - worker de upload/normalização/storage compartilhado

## Lote final de projetos genéricos auditados

- `gen-lang-client-0289831592`
  - `ACTIVE`
  - `billingEnabled: false`
  - owner: `user:outbrokerapp@gmail.com`
  - APIs habilitadas:
    - `generativelanguage.googleapis.com`
    - `telemetry.googleapis.com`
  - sem API keys
  - sem service accounts
  - sem buckets
  - sem Cloud SQL
  - sem referência encontrada no workspace

- `argon-retina-469422-q0`
  - `ACTIVE`
  - `billingEnabled: false`
  - owner: `user:outbrokerapp@gmail.com`
  - pacote genérico de APIs de dados/observabilidade habilitado
  - sem API keys
  - sem service accounts
  - sem buckets
  - sem Cloud SQL
  - sem referência encontrada no workspace

- `extreme-arch-469522-b1`
  - `ACTIVE`
  - `billingEnabled: false`
  - billing account ainda associada:
    - `billingAccounts/014BD0-21B322-AF9E4C`
  - owner: `user:outbrokerapp@gmail.com`
  - pacote genérico de APIs de dados/observabilidade habilitado
  - sem API keys
  - sem service accounts
  - sem buckets
  - sem Cloud SQL
  - sem referência encontrada no workspace

- `leafy-clone-469522-i8`
  - `ACTIVE`
  - `billingEnabled: false`
  - owner: `user:outbrokerapp@gmail.com`
  - pacote genérico de APIs de dados/observabilidade habilitado
  - sem API keys
  - sem service accounts
  - sem buckets
  - sem Cloud SQL
  - sem referência encontrada no workspace

- `poised-ceiling-469522-c2`
  - `ACTIVE`
  - `billingEnabled: false`
  - owner: `user:outbrokerapp@gmail.com`
  - pacote genérico de APIs de dados/observabilidade habilitado
  - sem API keys
  - sem service accounts
  - sem buckets
  - sem Cloud SQL
  - sem referência encontrada no workspace

- `round-cacao-469522-c0`
  - `ACTIVE`
  - `billingEnabled: false`
  - owner: `user:outbrokerapp@gmail.com`
  - pacote genérico de APIs de dados/observabilidade habilitado
  - sem API keys
  - sem service accounts
  - sem buckets
  - sem Cloud SQL
  - sem referência encontrada no workspace

- `sacred-vault-469422-f6`
  - `ACTIVE`
  - `billingEnabled: false`
  - owner: `user:outbrokerapp@gmail.com`
  - pacote genérico de APIs de dados/observabilidade habilitado
  - sem API keys
  - sem service accounts
  - sem buckets
  - sem Cloud SQL
  - sem referência encontrada no workspace
- nenhum workflow/release apontando para o projeto
- nenhum billing ou recurso residual relevante

## O que está confirmado

- a Outbroker usa hoje uma VM do Google Cloud
- a produção está em uma instância única `Compute Engine`
- a VM principal roda em `southamerica-east1-b`
- a aplicação usa IP público direto na VM
- há disco extra anexado para dados
- há snapshots recorrentes dos discos

## Pontos de atenção

### 1. IP externo aparenta não estar reservado como estático

Na checagem feita em `compute addresses`, não apareceu nenhum endereço estático
reservado no projeto, apesar da VM estar acessível via `35.199.94.141`.

Risco:

- se esse IP for ephemeral de fato, uma recriação mais agressiva da VM ou certas
  mudanças operacionais podem causar troca de IP
- isso pode quebrar DNS, webhooks, allowlists, integrações e troubleshooting

### 2. Exposição direta de SSH

As regras abertas mostram:

- `tcp:22` para `0.0.0.0/0`
- `tcp:32800` para `0.0.0.0/0`

Risco:

- superfície pública de ataque maior do que o necessário
- necessidade de revisar se a porta custom realmente substitui ou apenas soma ao
  SSH padrão

## Como futuras IAs devem usar este documento

- tratar este arquivo como referência prioritária quando o assunto for infra da
  `outbroker`
- distinguir sempre:
  - o que foi confirmado no GCP
  - o que vem do repositório da aplicação
  - o que ainda exige validação dentro do host
- não afirmar load balancer, IP estático, Cloud SQL, Redis gerenciado, GKE,
  Secret Manager operacional ou Nginx ativo sem nova verificação
- ao discutir reorganização de projetos GCP, tratar `MAQUINA VIRTUAL` como
  infraestrutura compartilhada das quatro aplicações até prova em contrário

## Estado-alvo proposto

### Princípio estrutural

- usar `um projeto GCP por aplicação` como padrão
- manter projetos separados por função apenas quando a função for realmente
  compartilhada, sensível ou experimental
- reduzir ao máximo nomes genéricos, projetos duplicados e chaves espalhadas

### Regras operacionais globais definidas

- região/zona padrão do ecossistema:
  - `southamerica-east1-b`
- cada projeto/runtime novo deve ter `usuário operacional próprio`
- exemplo:
  - `outbot` para `Outbot Runtime`
  - futuros runtimes devem seguir a mesma lógica por aplicação

### Projetos que devem existir no estado-alvo

- `Outbroker Runtime`
  - papel: runtime dedicado do `outbroker`
  - conteúdo esperado:
    - VM própria ou runtime próprio equivalente
    - discos, snapshots, firewall e observabilidade do `outbroker`
    - APIs Google realmente usadas pelo `outbroker`
    - Maps/Geocoding usados pela própria aplicação

- `Outsign Runtime`
  - papel: runtime dedicado do `outsign`
  - conteúdo esperado:
    - VM própria ou runtime próprio equivalente
    - observabilidade, deploy e credenciais próprias
    - eventual consumo de IA/Gemini ligado ao próprio domínio da app

- `Outlogin Runtime`
  - papel: runtime dedicado do `outlogin`
  - conteúdo esperado:
    - VM própria ou runtime próprio equivalente
    - credenciais Google OAuth e observabilidade próprias
    - tudo que sustenta o auth server do ecossistema

- `Outbot Runtime`
  - papel: runtime dedicado do `outbroker-feed-bot`
  - conteúdo esperado:
    - worker ou VM própria
    - credenciais, logs e monitoramento próprios

- `Outbroker Push`
  - papel: projeto funcional dedicado para Firebase/push/mobile
  - conteúdo esperado:
    - Firebase
    - service accounts de push
    - chaves e integrações mobile

- `Outsign AI Experimental`
  - papel: projeto experimental de IA
  - conteúdo esperado:
    - chaves e APIs de Gemini/Generative Language isoladas
    - zero dependência crítica de produção enquanto estiver em modo experimental

- `Build Worker`
  - papel: projeto de automação compartilhada para build, se a esteira for
    realmente centralizada
  - conteúdo esperado:
    - runners, workers ou automações de build
    - sem mistura com runtime de aplicação

- `Media Worker`
  - papel: projeto compartilhado para upload, normalização de arquivos e envio
    para storage remoto
  - conteúdo esperado:
    - processamento de imagem/vídeo/documento
    - filas e jobs de mídia
    - integração com storage remoto

### Projetos que não devem existir no estado-alvo

- projetos genéricos do tipo `My First Project`
- projetos duplicados sem runtime
- projetos criados por experimento antigo sem owner claro
- projetos por serviço pequeno quando o consumo é exclusivo de uma única app

## Ordem de desmembramento recomendada

### Fase 1. Consolidar a limpeza

- aguardar a propagação das exclusões já pedidas
- validar periodicamente os `DELETE_REQUESTED`
- renomear `MAQUINA VIRTUAL` para um nome operacional claro quando a janela for
  adequada

### Fase 2. Preparar fronteiras por aplicação

- mapear por aplicação:
  - domínio
  - porta
  - processo PM2
  - diretório de deploy
  - banco e coleções principais
  - secrets e credenciais Google
  - storage e integrações externas
- objetivo: tornar cada app migrável sem ambiguidade

### Fase 3. Separar primeiro as aplicações menos acopladas

- `outbot`
  - tende a ser o melhor candidato inicial para sair da VM compartilhada
- `outsign`
  - boa candidata para runtime próprio
- `outlogin`
  - separar com cuidado por ser a base de identidade do ecossistema

### Fase 4. Separar o `outbroker`

- deixar o `outbroker` por último entre as apps principais
- motivo:
  - é a aplicação mais central
  - concentra mais integrações
  - hoje compartilha mais responsabilidades operacionais

### Fase 5. Extrair capacidades compartilhadas

- `Build Worker`
  - extrair depois que as esteiras das apps estiverem mais padronizadas
- `Media Worker`
  - extrair depois que os fluxos de upload/storage estiverem bem mapeados

## Ordem prática sugerida

1. fechar a limpeza dos projetos já em `DELETE_REQUESTED`
2. renomear `MAQUINA VIRTUAL` para algo como `Outbroker Shared Runtime`
3. inventariar secrets e credenciais por aplicação
4. inventariar DNS, portas, PM2 e deploys por aplicação
5. desenhar a migração de `outbot`
6. desenhar a migração de `outsign`
7. desenhar a migração de `outlogin`
8. desenhar a migração do `outbroker`
9. só então criar `Build Worker` e `Media Worker` se a necessidade continuar

## Riscos que devem orientar a execução

- não fazer big bang
- não migrar duas aplicações críticas ao mesmo tempo
- não separar um serviço compartilhado antes de entender quem realmente o consome
- não espalhar Maps, OAuth, push e IA em projetos novos sem dono claro
- não usar o projeto experimental de IA como dependência crítica de produção sem
  antes promover esse projeto a um papel operacional explícito

## Inventário operacional por aplicação

### outbroker

- repo local: `~/projetos/outbroker`
- remoto: `git@github.com:outbrokerapp/outbroker.git`
- branch local observada: `develop`
- stack:
  - `Next.js`
  - `React`
  - `TypeScript`
- deploy/runtime no host:
  - produção em `/home/outbroker/prod`
  - release-based em `/home/outbroker/prod/releases/<run_id>-<sha>`
  - PM2:
    - `outbroker-prod`
    - `outbroker-devel`
    - crons auxiliares de ciclo de vida e retenção de anexos
- portas observadas:
  - `1336` produção
  - `1337` homologação/desenvolvimento
- integrações/infra conhecidas:
  - MongoDB
  - Cloudflare R2
  - Firebase/FCM via `outbroker-push-notification`
  - Google Maps/Geocoding via projeto `MAQUINA VIRTUAL`
  - auth via `outlogin`

### outbroker-feed-bot

- repo local: `~/projetos/outbroker-feed-bot`
- remoto: `git@github.com:outbrokerapp/outbroker-feed-bot.git`
- branch local observada: `main`
- stack:
  - `Node.js`
  - `TypeScript`
  - `tsx`
- deploy/runtime no host:
  - diretório `/home/outbroker/outbot`
  - PM2:
    - `outbroker-feed-bot`
- porta observada:
  - não expõe porta HTTP dedicada visível na auditoria
- integrações/infra conhecidas:
  - MongoDB
  - depende do ecossistema `outbroker`

### outbroker-waitlist

- repo local: `~/projetos/outbroker-waitlist`
- remoto: `git@github.com:outbrokerapp/outbroker-waitlist.git`
- branch local observada: `main`
- stack:
  - `Next.js`
  - `React`
  - `TypeScript`
- deploy/runtime no host:
  - diretório `/home/outbroker/outbroker.com.br`
  - PM2:
    - `outbroker-waitlist`
- porta observada:
  - `1338`
- domínio confirmado por runtime:
  - `https://outbroker.com.br`
- integrações/infra conhecidas:
  - MongoDB
  - GA4 por service account do projeto `Outbroker Waitlist`
- observação:
  - aplicação ainda está viva no host, mesmo com o projeto GCP já em
    `DELETE_REQUESTED`

### outsign

- repo local: `~/projetos/outsign`
- remoto: `git@github.com:outbrokerapp/contrato-digital-f-cil.git`
- branch local observada: `main`
- stack:
  - `Next.js`
  - `React`
  - `TypeScript`
- deploy/runtime no host:
  - diretório `/home/outsign/prod`
  - porta prevista em `ecosystem.config.cjs`:
    - `1340`
- porta observada no host:
  - `1340`
- integrações/infra conhecidas:
  - auth com `outlogin`
  - código local com fallback Gemini por `@google/genai`
  - vínculo provável com `Outsign AI Experimental`, ainda sem prova de uso em
    produção

### outlogin

- repo local: `~/projetos/outlogin`
- remoto: `git@github.com:outbrokerapp/outlogin.git`
- branch local observada:
  - `dev/filipe/outlogin-user-delete-fanout`
- stack:
  - `Next.js`
  - `React`
  - `TypeScript`
- deploy/runtime no host:
  - produção em `/home/outlogin/prod`
  - porta prevista em `ecosystem.config.cjs`:
    - `1341`
- porta observada no host:
  - `1341`
- integrações/infra conhecidas:
  - MongoDB
  - Google OAuth por variáveis da própria app
  - clients OAuth no próprio banco
  - integra `outbroker` e `outsign`

### outlabel

- repo local: `~/projetos/outlabel`
- remoto: `git@github.com:outbrokerapp/outlabel.git`
- branch local observada: `main`
- stack:
  - `Next.js 16`
  - `React 19`
  - `TypeScript`
- runtime previsto localmente:
  - `outlabel-app`
  - `cwd=/home/outlabel/outlabel-app`
  - porta `1339`
- estado operacional observado:
  - `1339` não apareceu escutando no host
  - não surgiu processo PM2 ativo do usuário `outlabel`
  - não apareceram refs úteis de Nginx no host
- leitura atual:
  - app preparada para runtime, mas sem evidência operacional atual na VM

## Portas operacionais observadas na VM

- `1336`
  - `outbroker-prod`
- `1337`
  - `outbroker-devel`
- `1338`
  - `outbroker-waitlist`
- `1340`
  - `outsign`
- `1341`
  - `outlogin`
- `1339`
  - prevista para `outlabel`, mas não observada em execução

## Leitura consolidada desta etapa

- o ecossistema atual ainda está fortemente centralizado na VM compartilhada
- `outbroker`, `outsign` e `outlogin` já têm fronteiras técnicas mínimas
  identificáveis por diretório e porta
- `outbot` já aparece como worker/processo separado e tende a ser o melhor
  candidato inicial para desmembramento
- `outlabel` ainda não entrou de fato no mapa operacional vivo da VM

## Ordem de migração por aplicação

### Critério geral

- priorizar primeiro o que é menos acoplado
- evitar mexer cedo em identidade e no runtime mais central
- migrar uma aplicação por vez até estabilizar operação, logs, deploy e rollback
- só extrair serviços compartilhados depois que as apps tiverem fronteiras bem
  consolidadas

### Fase 0. Preparação comum

- objetivo:
  - preparar base para qualquer migração sem mexer ainda em produção
- tarefas:
  - mapear secrets por aplicação
  - mapear Mongo e coleções principais por aplicação
  - mapear domínios/DNS por aplicação
  - mapear rotina de deploy e rollback por aplicação
  - definir padrão mínimo de observabilidade por projeto novo
- critério de saída:
  - cada app com ficha operacional própria e dependências explícitas

### Fase 1. Migrar `outbroker-feed-bot`

- prioridade: `mais alta`
- risco: `baixo`
- por que vem primeiro:
  - é o componente menos acoplado ao tráfego web principal
  - já roda como worker/processo separado
  - não depende de porta pública dedicada no desenho atual
- alvo:
  - `Outbot Runtime`
- pré-requisitos:
  - confirmar todas as envs do bot
  - confirmar origem dos dados no Mongo
  - confirmar rotina de restart e logs
- critério de saída:
  - bot executando em runtime próprio
  - deploy e rollback independentes
  - zero dependência operacional da VM compartilhada

### Fase 2. Migrar `outsign`

- prioridade: `alta`
- risco: `baixo/médio`
- por que vem cedo:
  - já tem porta própria (`1340`)
  - já tem diretório de deploy bem delimitado
  - é menos crítico que `outlogin` e `outbroker`
- alvo:
  - `Outsign Runtime`
- pré-requisitos:
  - fechar se o fallback Gemini ficará ativo ou não
  - consolidar secrets do `outsign`
  - definir domínio, TLS e rotina de deploy
- critério de saída:
  - `outsign` rodando em runtime próprio
  - integração com `outlogin` revalidada
  - OCR/IA ou desativado explicitamente, ou migrado com segurança

### Fase 3. Migrar `outlogin`

- prioridade: `alta`
- risco: `médio/alto`
- por que fica depois do `outsign`:
  - é o auth server do ecossistema
  - qualquer erro nele afeta múltiplas aplicações
- alvo:
  - `Outlogin Runtime`
- pré-requisitos:
  - inventário completo de clients OAuth
  - inventário completo de envs Google OAuth
  - inventário de integrações com `outbroker` e `outsign`
  - plano de rollback validado antes da migração
- critério de saída:
  - `outlogin` rodando em runtime próprio
  - login/OAuth funcionando para apps consumidoras
  - callbacks e tokens revalidados ponta a ponta

### Fase 4. Migrar `outbroker`

- prioridade: `média`, mas `complexidade mais alta`
- risco: `alto`
- por que fica por último entre as apps centrais:
  - é a aplicação mais extensa
  - concentra mais integrações
  - hoje ainda carrega a maior parte da operação prática do ecossistema
- alvo:
  - `Outbroker Runtime`
- pré-requisitos:
  - separar completamente waitlist já desativada
  - revisar push/Firebase
  - revisar Maps/Geocoding
  - revisar storage/R2
  - revisar billing/Mercado Pago
  - revisar workers/crons associados
- critério de saída:
  - `outbroker` rodando em runtime próprio
  - deploy release-based preservado ou substituído por fluxo equivalente
  - Firebase, Maps, storage, auth e billing revalidados em produção

### Fase 5. Decidir `outlabel`

- prioridade: `condicional`
- risco: `baixo`
- por que não entra antes:
  - ainda não há evidência operacional viva no host
  - primeiro é preciso decidir se a app entra mesmo no ecossistema ativo
- alvo:
  - `Outlabel Runtime`, se a app for promovida
- pré-requisitos:
  - confirmar se `outlabel` será ativada
  - definir domínio, deploy, secrets e dados
- critério de saída:
  - ou a app entra oficialmente no plano de runtime
  - ou sai do escopo de migração por enquanto

### Fase 6. Extrair `Build Worker`

- prioridade: `posterior`
- risco: `médio`
- por que vem depois:
  - antes disso, as esteiras das aplicações ainda estarão mudando
  - extrair cedo demais pode cristalizar um pipeline ruim
- alvo:
  - `Build Worker`
- pré-requisitos:
  - deploys das apps com padrão minimamente consistente
  - convenção comum de build e artefato
- critério de saída:
  - builds centralizados sem acoplar runtime e CI

### Fase 7. Extrair `Media Worker`

- prioridade: `posterior`
- risco: `médio`
- por que vem por último:
  - depende de entender com clareza todos os fluxos de upload, normalização e
    storage
  - vale mais a pena extrair quando o ecossistema já estiver estabilizado
- alvo:
  - `Media Worker`
- pré-requisitos:
  - inventário real dos fluxos de mídia
  - contratos claros entre apps e worker
  - definição de filas, retry e observabilidade
- critério de saída:
  - mídia processada de forma compartilhada e desacoplada dos runtimes

## Ordem resumida recomendada

1. `outbroker-feed-bot`
2. `outsign`
3. `outlogin`
4. `outbroker`
5. `outlabel` se entrar no ecossistema ativo
6. `Build Worker`
7. `Media Worker`

## Regra de segurança da execução

- não iniciar a próxima migração antes da anterior estar estabilizada
- cada fase precisa terminar com:
  - runtime novo validado
  - deploy validado
  - rollback validado
  - observabilidade mínima validada

## Fase 0 detalhada - outbroker-feed-bot

### Papel do componente

- sincronizador de feeds XML para importação automática de imóveis
- roda como worker contínuo, sem superfície HTTP pública principal
- agenda ciclos de sincronização via `node-cron`

### Stack

- `Node.js`
- `TypeScript`
- `tsx`
- `mongoose`
- `axios`
- `node-cron`
- `@aws-sdk/client-s3`
- `xml-stream`

### Repositório e branch

- repo local: `~/projetos/outbroker-feed-bot`
- remoto: `git@github.com:outbrokerapp/outbroker-feed-bot.git`
- branch observada: `main`

### Runtime atual no host

- usuário: `outbroker`
- diretório: `/home/outbroker/outbot`
- PM2:
  - app `outbroker-feed-bot`
  - `fork_mode`
  - script `./node_modules/.bin/tsx`
  - args `src/index.ts`
- estado observado:
  - `online`
  - uptime observado na auditoria: ~`40h`
  - restart count observado: `9`

### Deploy atual

- workflow próprio em GitHub Actions
- trigger:
  - push em `main`
  - `workflow_dispatch`
- transporte:
  - `scp` do script de deploy
  - `ssh` para execução remota
- host:
  - segredo `DEPLOY_HOST`
  - usuário `outbroker`
  - porta `32800`
- diretório de destino:
  - `DEPLOY_DIR=/home/outbroker/outbot`
- estratégia:
  - `git fetch`
  - `git checkout main`
  - `git pull --ff-only`
  - `npm ci --include=dev`
  - `pm2 reload` ou `pm2 start`
  - `pm2 save`

### Dependências de configuração

- variáveis confirmadas no código:
  - `MONGODB_URI`
  - `OUTBROKER_URL`
  - `R2_ACCOUNT_ID`
  - `R2_ACCESS_KEY_ID`
  - `R2_SECRET_ACCESS_KEY`
  - `R2_PUBLIC_BUCKET`
  - `FEED_BOT_RUN_ON_STARTUP`
  - `FEED_BOT_DEBUG_PARSERS`
- observação:
  - o `.env` local observado contém Mongo de desenvolvimento
  - a migração deve usar inventário de secrets de produção sem reaproveitar
    cegamente o `.env` local

### Banco e persistência

- banco:
  - MongoDB
- conexão:
  - feita por `mongoose.connect(MONGODB_URI)`
- modelos principais observados:
  - `Ad`
  - `BrokerFeed`
  - `FeedLog`
  - `BotRuntimeStatus`
- função operacional:
  - lê feeds configurados
  - sincroniza anúncios
  - registra logs e status de runtime
  - usa lock de ciclo para evitar concorrência entre execuções

### Storage e mídia

- usa Cloudflare R2 via SDK S3 compatível
- responsabilidades observadas:
  - download de imagens do feed
  - naming determinístico por hash da URL
  - upload no bucket público
  - remoção de objetos obsoletos por anúncio

### Agendamento e execução

- scheduler embutido via `node-cron`
- expressão cron vinda de configuração do sistema:
  - `settings?.botCronExpression`
  - fallback: `0 * * * *`
- suporta:
  - modo contínuo
  - `--run-once`
  - execução imediata opcional por `FEED_BOT_RUN_ON_STARTUP`

### Observabilidade atual

- logs por PM2:
  - out log e error log dedicados
- persistência de estado no banco:
  - `BotRuntimeStatus`
- sinais de diagnóstico no processo:
  - tratamento de `SIGINT`
  - tratamento de `SIGTERM`
  - `uncaughtException`
  - `unhandledRejection`
  - registro de restart/shutdown

### Dependências externas

- MongoDB
- Cloudflare R2
- aplicação `outbroker` via `OUTBROKER_URL`
- parceiros/CRMs que entregam feeds XML

### Riscos e pontos de atenção para a migração

- garantir que o novo runtime tenha acesso a:
  - Mongo correto
  - R2 correto
  - URL correta do `outbroker`
- garantir que apenas uma instância produtiva do bot fique ativa por vez
- preservar o comportamento de cron e lock distribuído antes de cortar a VM atual
- validar se o bot depende implicitamente de algum estado local em
  `/home/outbroker/outbot`

### Critério de saída da Fase 0 do bot

- secrets de produção inventariados de forma sanitizada
- deploy e rollback descritos
- dependências externas descritas
- estratégia de single-runner definida
- pronto para desenho do `Outbot Runtime`

## Fase 0 detalhada - outsign

### Papel do componente

- aplicação web de contratos digitais
- possui autenticação própria e integração SSO com `outlogin`
- concentra upload, documentos, assinatura, scanner/OCR e suporte

### Stack

- `Next.js 16`
- `React`
- `TypeScript`
- `MongoDB` via `mongoose`
- `JWT`
- integrações Google OAuth
- fallback de IA/Gemini para OCR
- storage híbrido:
  - local
  - GridFS
  - S3 compatível

### Repositório e branch

- repo local: `~/projetos/outsign`
- remoto: `git@github.com:outbrokerapp/contrato-digital-f-cil.git`
- branch observada: `main`

### Runtime atual no host

- usuário: `outsign`
- diretório: `/home/outsign/prod`
- PM2:
  - daemon próprio do usuário `outsign`
  - app `outsign-prod`
- porta observada:
  - `1340`
- processo observado:
  - `npm start`
  - `next start`
  - `next-server (v16.2.3)`

### Deploy atual

- workflow próprio em GitHub Actions
- trigger:
  - push em `main`
- host:
  - `DEPLOY_HOST`
  - `DEPLOY_USER`
  - `DEPLOY_PORT`
  - `DEPLOY_SSH_KEY`
- diretório de destino:
  - `/home/outsign/prod`
- estratégia:
  - `git fetch`
  - `git reset --hard origin/main`
  - `git clean -fd`
  - `npm ci`
  - `npm run build`
  - `pm2 reload` ou `pm2 start`

### Dependências de configuração observadas

- confirmadas no runtime atual:
  - `MONGODB_URI`
  - `JWT_SECRET`
  - `JWT_EXPIRES_IN`
  - `JWT_REFRESH_SECRET`
  - `JWT_REFRESH_EXPIRES_IN`
  - `JWT_TEMP_SECRET`
  - `OUTLOGIN_URL`
  - `NEXT_PUBLIC_OUTLOGIN_URL`
  - `OUTLOGIN_CLIENT_ID`
  - `OUTLOGIN_CLIENT_SECRET`
  - `OUTLOGIN_INTERNAL_PROVISIONING_TOKEN`
- confirmadas no código:
  - `GOOGLE_CLIENT_ID`
  - `GOOGLE_CLIENT_SECRET`
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - `AWS_REGION`
  - `AWS_S3_BUCKET`
  - `SMTP_*`
  - `APP_URL`
  - `FRONTEND_URL`
  - `CORS_ORIGINS`
  - `WEBAUTHN_RP_NAME`
  - `WEBAUTHN_RP_ID`
  - `WEBAUTHN_ORIGIN`
  - `UPLOAD_DIR`
  - `PDF_SIGNING_CERT_PATH`
  - `PDF_SIGNING_CERT_PASSWORD`
  - `PDF_SIGNING_*`
  - `GEMINI_API_KEY`
  - `GOOGLE_API_KEY`
  - `GOOGLE_GENERATIVE_AI_API_KEY`
  - `WEBAUTHN_*`
  - `CONTENT_ENCRYPTION_KEY`
  - `TWO_FACTOR_ENCRYPTION_KEY`
  - `EVIDENCE_SEAL_SECRET`

### Banco e persistência

- banco:
  - MongoDB
- runtime atual aponta para:
  - `outsign-dev`
- observação crítica:
  - antes da migração, validar se esse nome representa de fato produção lógica
    ou apenas nomenclatura herdada
- storage identificado no código:
  - GridFS
  - local
  - S3 compatível
- indícios operacionais atuais:
  - `.env` visível não contém `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` nem
    `AWS_S3_BUCKET`
  - existe diretório local de uploads no host:
    - `/home/outsign/prod/uploads`
  - subdiretórios observados:
    - `documents`
    - `signatures`
    - `avatars`
    - `scans`
    - `.ocr-cache`
  - uso observado:
    - `18M`
  - leitura atual:
    - produção parece operar principalmente com storage local
    - S3 permanece como capacidade suportada pelo código, não comprovada como
      ativa no runtime atual

### Domínio, origem e callbacks

- domínio/base URL confirmados no runtime:
  - `https://outsign.app`
- origens CORS confirmadas:
  - `https://outsign.app`
- WebAuthn confirmado:
  - `rpId=outsign.app`
  - `origin=https://outsign.app`
- integração com `outlogin` confirmada:
  - `OUTLOGIN_URL=https://outlogin.app`
  - callback Google do fluxo SSO é derivado de:
    - `https://outsign.app/auth/callback/google`

### Certificados e e-mail

- SMTP confirmado no runtime:
  - `mail.outsign.app`
  - porta `465`
  - `SMTP_SECURE=true`
- certificado PFX confirmado no host:
  - `/home/outsign/prod/certs/outbroker-ltda-11022027.pfx`
- leitura atual:
  - assinatura digital e e-mail transacional são dependências reais e ativas

### IA / OCR

- código suporta fallback Gemini/Generative AI
- dependências presentes no runtime publicado:
  - `@google/genai`
  - `google-auth-library`
- `.env` visível não mostrou:
  - `GEMINI_API_KEY`
  - `GOOGLE_API_KEY`
  - `GOOGLE_GENERATIVE_AI_API_KEY`
- leitura atual:
  - OCR local está ativo
  - fallback Gemini não está comprovado como ativo em produção
  - isso mantém o projeto `Outsign AI Experimental` como auxiliar provável, não
    como dependência produtiva confirmada

### Dependências externas

- `outlogin` como provedor de identidade do ecossistema
- Google OAuth
- SMTP
- S3 compatível
- certificados/assinatura digital
- fallback Gemini/IA para OCR

### Riscos e pontos de atenção para migração

- maior sensibilidade que o bot, por ser aplicação web de usuários finais
- depende de `outlogin`
- depende de storage com múltiplos modos
- depende de secrets criptográficos e de assinatura digital
- depende de mailer e fluxos de autenticação
- precisa de validação mais forte de domínio, cookies, callbacks e upload

### Critério de saída da Fase 0 do outsign

- inventário completo de secrets de produção
- confirmação do storage realmente em uso
- confirmação do papel do projeto `Outsign AI Experimental`
- ficha completa de domínio/TLS/deploy/rollback
- pronto para desenho do `Outsign Runtime`

### Estado atual da auditoria do outsign

- storage operacional provável:
  - local em disco
- GridFS:
  - suportado e usado em alguns fluxos do código
- S3:
  - suportado no código, não comprovado como ativo no runtime
- domínio e WebAuthn:
  - confirmados
- `outlogin`:
  - dependência ativa e crítica
- PDF signing:
  - ativo e dependente de artefato local
- Gemini/IA:
  - suportado no código, sem prova de chave ativa no runtime

### Decisão operacional do Filipe

- a primeira migração do `outsign` deve preservar `storage local`
- não migrar storage para Cloudflare/R2 nesta fase
- primeiro objetivo:
  - tirar o runtime da VM compartilhada mantendo o comportamento atual
- evolução futura:
  - revisar storage remoto depois da separação do runtime

## Desenho alvo - Outsign Runtime

### Objetivo

- retirar o `outsign` da VM compartilhada
- manter o comportamento atual com o mínimo de mudança funcional
- preservar autenticação, assinatura, upload e domínio sem reescrever storage

### Decisão arquitetural

- usar `um projeto GCP próprio`
- usar `uma VM dedicada`
- manter `storage local` nesta primeira migração
- não usar Kubernetes
- não introduzir R2/Cloudflare no `outsign` agora

### Nome sugerido

- projeto GCP:
  - `outsign-runtime`
  - nome amigável: `Outsign Runtime`
- VM:
  - `outsign-prod`

### Runtime sugerido

- `Compute Engine`
- Debian 13
- tipo inicial sugerido:
  - `e2-standard-2`
- disco de boot:
  - `pd-balanced`
  - `40 GB`

### Por que esse desenho faz sentido

- o `outsign` já roda bem em `Next.js + PM2`
- a dependência mais crítica não é CPU; é previsibilidade operacional
- storage local, certificado local e SMTP pedem uma migração conservadora
- manter o comportamento atual reduz muito o risco do primeiro corte

### Processo e supervisor

- manter `PM2`
- app:
  - `outsign-prod`
- porta:
  - `1340`
- processo:
  - `npm start`

### Rede e exposição

- a VM precisa servir tráfego web público
- domínio esperado:
  - `outsign.app`
- recomendação:
  - manter reverse proxy simples na própria VM ou em camada dedicada futura
- para a primeira migração:
  - o mais importante é preservar domínio, TLS e callbacks

### Segredos mínimos confirmados

- `MONGODB_URI`
- `JWT_SECRET`
- `JWT_EXPIRES_IN`
- `JWT_REFRESH_SECRET`
- `JWT_REFRESH_EXPIRES_IN`
- `JWT_TEMP_SECRET`
- `TWO_FACTOR_ENCRYPTION_KEY`
- `OUTLOGIN_URL`
- `NEXT_PUBLIC_OUTLOGIN_URL`
- `OUTLOGIN_CLIENT_ID`
- `OUTLOGIN_CLIENT_SECRET`
- `OUTLOGIN_INTERNAL_PROVISIONING_TOKEN`
- `APP_URL`
- `FRONTEND_URL`
- `CORS_ORIGINS`
- `UPLOAD_DIR`
- `WEBAUTHN_RP_NAME`
- `WEBAUTHN_RP_ID`
- `WEBAUTHN_ORIGIN`
- `SMTP_HOST`
- `SMTP_PORT`
- `SMTP_SECURE`
- `SMTP_USER`
- `SMTP_PASS`
- `SMTP_FROM_EMAIL`
- `SMTP_FROM_NAME`
- `PDF_SIGNING_CERT_PATH`
- `PDF_SIGNING_CERT_PASSWORD`

### Artefatos locais críticos

- diretório de uploads
  - `./uploads`
- subpastas observadas:
  - `documents`
  - `signatures`
  - `avatars`
  - `scans`
  - `.ocr-cache`
- certificado PFX:
  - `./certs/outbroker-ltda-11022027.pfx`

### Política de storage nesta fase

- manter `uploadDir=./uploads`
- copiar o conteúdo atual de `uploads/` para a nova VM
- copiar o diretório `certs/` para a nova VM
- não alterar código de storage nesta migração

### Dependências externas críticas

- `outlogin`
- SMTP
- MongoDB
- WebAuthn
- artefato PFX de assinatura digital

### Dependências opcionais ou não comprovadas

- Google OAuth
- fallback Gemini
- S3 compatível

### Deploy alvo

- manter GitHub Actions
- mesmo modelo atual:
  - `git reset --hard origin/main`
  - `git clean -fd`
  - `npm ci`
  - `npm run build`
  - `pm2 reload/start`

### Rollback alvo

- rollback simples por host:
  - recolocar DNS/proxy no host antigo se necessário
  - religar o processo antigo
- por ser app web, o rollback precisa preservar:
  - domínio
  - TLS
  - callbacks
  - uploads recentes

### Observabilidade mínima

- logs do PM2
- monitoramento da VM
- checagens de:
  - login
  - integração com `outlogin`
  - upload
  - assinatura digital
  - envio de e-mail

### Estratégia de corte sugerida

- criar projeto `Outsign Runtime`
- criar VM `outsign-prod`
- provisionar Node/PM2/usuário `outsign`
- clonar repo
- copiar `.env`
- copiar `uploads/`
- copiar `certs/`
- validar build
- validar rotas críticas sem trocar tráfego
- só então fazer o corte de domínio/proxy

### Critério de pronto para migração

- projeto criado
- VM criada
- repo provisionado
- `.env` validado
- `uploads/` migrado
- `certs/` migrado
- build validado
- autenticação com `outlogin` validada
- upload validado
- assinatura digital validada
- SMTP validado

## Checklist de criação - Outsign Runtime

### Projeto GCP

- criar projeto:
  - `outsign-runtime`
- nome amigável:
  - `Outsign Runtime`
- habilitar somente o necessário no começo:
  - `compute.googleapis.com`
  - `logging.googleapis.com`
  - `monitoring.googleapis.com`

### VM

- nome:
  - `outsign-prod`
- região:
  - `southamerica-east1`
- zona:
  - `southamerica-east1-b`
- tipo:
  - `e2-standard-2`
- sistema:
  - `Debian 13`
- disco:
  - `pd-balanced`
  - `40 GB`
- IP:
  - reservar IP estático antes do corte do tráfego

### Firewall

- abrir somente o necessário
- SSH:
  - restringir por faixa administrativa ou pelo padrão mais seguro disponível
- web pública:
  - `80`
  - `443`
- não expor `1340` publicamente
  - o `Next.js` deve continuar atrás de reverse proxy local

### Usuário e acesso

- criar usuário operacional dedicado:
  - `outsign`
- instalar chave SSH de deploy específica
- manter separação entre:
  - acesso GitHub do usuário da aplicação
  - acesso SSH do GitHub Actions ao host

## Checklist de provisionamento do host - Outsign Runtime

### Base do sistema

- atualizar pacotes
- instalar:
  - `git`
  - `curl`
  - `build-essential`
  - `ca-certificates`
  - `nginx`
- instalar Node na versão padrão do projeto
- instalar `pm2`

### Estrutura de diretórios

- criar diretório de app:
  - `/home/outsign/prod`
- clonar repo:
  - `outsign`
- criar `.env`
- criar diretórios:
  - `uploads/`
  - `certs/`

### Migração de dados locais

- copiar do host antigo:
  - `/home/outsign/prod/uploads`
  - `/home/outsign/prod/certs`
- preservar permissões do usuário `outsign`
- validar presença mínima de:
  - `uploads/documents`
  - `uploads/signatures`
  - `uploads/avatars`
  - `uploads/scans`
  - `uploads/.ocr-cache`
  - `certs/outbroker-ltda-11022027.pfx`

### Processo

- rodar:
  - `npm ci`
  - `npm run build`
- iniciar:
  - `pm2 start ecosystem.config.js --only outsign-prod --update-env`
- persistir:
  - `pm2 save`
- configurar persistência no boot:
  - `pm2 startup systemd`

### Proxy e TLS

- configurar `nginx` para:
  - `server_name outsign.app`
  - proxy para `127.0.0.1:1340`
- instalar certificado TLS antes do corte final
- preservar callbacks e origens atuais:
  - `https://outsign.app`

### Logs

- instalar/configurar `pm2-logrotate`
- validar logs do `nginx`
- validar logs da aplicação

## Checklist de validação - Outsign Runtime

### Antes do corte

- validar `.env`
- validar build e subida local na nova VM
- validar conexão com Mongo
- validar homepage e rotas protegidas
- validar autenticação com `outlogin`
- validar upload de documento
- validar leitura/escrita em `./uploads`
- validar assinatura PDF com o arquivo PFX
- validar envio de e-mail via SMTP
- validar WebAuthn com:
  - `WEBAUTHN_RP_ID=outsign.app`
  - `WEBAUTHN_ORIGIN=https://outsign.app`

### Corte

- apontar `nginx` e TLS no novo host
- atualizar DNS ou proxy externo para o IP novo
- subir `outsign-prod` na nova VM
- parar `outsign-prod` na VM compartilhada
- validar login, upload, assinatura e e-mail em produção real

### Rollback

- recolocar DNS ou proxy no host antigo
- religar `outsign-prod` na VM compartilhada
- preservar a VM nova para análise
- não descartar `uploads/` novos sem reconciliação

## Runbook prático - criação do Outsign Runtime

### Variáveis sugeridas

```bash
export OUTSIGN_PROJECT_ID="outsign-runtime"
export OUTSIGN_PROJECT_NAME="Outsign Runtime"
export OUTSIGN_REGION="southamerica-east1"
export OUTSIGN_ZONE="southamerica-east1-b"
export OUTSIGN_VM_NAME="outsign-prod"
export OUTSIGN_MACHINE_TYPE="e2-standard-2"
export OUTSIGN_DISK_SIZE="40GB"
export OUTSIGN_SYSTEM_USER="outsign"
```

### 1. Criar projeto

```bash
gcloud projects create "$OUTSIGN_PROJECT_ID" --name="$OUTSIGN_PROJECT_NAME"
```

### 2. Vincular billing

Observação:
- usar a mesma billing account operacional do ecossistema principal

Descobrir billing account disponível:

```bash
gcloud beta billing accounts list
```

Vincular:

```bash
export OUTSIGN_BILLING_ACCOUNT="SEU_BILLING_ACCOUNT_ID"
gcloud beta billing projects link "$OUTSIGN_PROJECT_ID" \
  --billing-account="$OUTSIGN_BILLING_ACCOUNT"
```

### 3. Definir projeto ativo

```bash
gcloud config set project "$OUTSIGN_PROJECT_ID"
```

### 4. Habilitar APIs mínimas

```bash
gcloud services enable \
  compute.googleapis.com \
  logging.googleapis.com \
  monitoring.googleapis.com
```

### 5. Reservar IP estático

```bash
gcloud compute addresses create outsign-prod-ip \
  --region="$OUTSIGN_REGION"
```

### 6. Criar VM

```bash
export OUTSIGN_STATIC_IP="$(gcloud compute addresses describe outsign-prod-ip \
  --region="$OUTSIGN_REGION" \
  --format='value(address)')"

gcloud compute instances create "$OUTSIGN_VM_NAME" \
  --zone="$OUTSIGN_ZONE" \
  --machine-type="$OUTSIGN_MACHINE_TYPE" \
  --image-family=debian-13 \
  --image-project=debian-cloud \
  --boot-disk-type=pd-balanced \
  --boot-disk-size="$OUTSIGN_DISK_SIZE" \
  --address="$OUTSIGN_STATIC_IP" \
  --tags=http-server,https-server,outsign-prod
```

### 7. Acessar a VM

```bash
gcloud compute ssh "$OUTSIGN_VM_NAME" --zone="$OUTSIGN_ZONE"
```

### 8. Bootstrap base do host

```bash
sudo apt-get update
sudo apt-get install -y git curl build-essential ca-certificates nginx

sudo useradd -m -s /bin/bash "$OUTSIGN_SYSTEM_USER" || true
sudo usermod -aG sudo "$OUTSIGN_SYSTEM_USER"
```

### 9. Instalar Node e PM2 para o usuário da aplicação

```bash
sudo -iu "$OUTSIGN_SYSTEM_USER" bash <<'EOF'
set -e
export NVM_DIR="$HOME/.nvm"
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
. "$NVM_DIR/nvm.sh"
nvm install 20
nvm alias default 20
npm install -g pm2
EOF
```

### 10. Clonar repo e instalar dependências

```bash
sudo -iu "$OUTSIGN_SYSTEM_USER" bash <<'EOF'
set -e
cd "$HOME"
git clone git@github.com:outbrokerapp/contrato-digital-f-cil.git prod
cd prod
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"
nvm use 20
npm ci
EOF
```

### 11. Copiar `.env`, `uploads/` e `certs/` do host antigo

Observação:
- copiar a partir do host atual compartilhado usando `rsync -a`
- esse passo deve acontecer antes do build final de validação

Itens a copiar:

- `/home/outsign/prod/.env`
- `/home/outsign/prod/uploads/`
- `/home/outsign/prod/certs/`

### 12. Build e subida inicial

```bash
sudo -iu "$OUTSIGN_SYSTEM_USER" bash <<'EOF'
set -e
cd "$HOME/prod"
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"
nvm use 20
npm run build
pm2 start ecosystem.config.js --only outsign-prod --update-env
pm2 save
EOF
```

### 13. Configurar PM2 no boot

```bash
sudo env PATH="/home/$OUTSIGN_SYSTEM_USER/.nvm/versions/node/$(sudo -iu "$OUTSIGN_SYSTEM_USER" bash -lc 'node -v')/bin:$PATH" \
  pm2 startup systemd -u "$OUTSIGN_SYSTEM_USER" --hp "/home/$OUTSIGN_SYSTEM_USER"
sudo -iu "$OUTSIGN_SYSTEM_USER" pm2 save
```

### 14. Configurar `nginx`

Configuração mínima esperada:

- `server_name outsign.app`
- `proxy_pass http://127.0.0.1:1340`
- headers de proxy padrão
- TLS ativo antes do corte

### 15. Validar antes do corte

- abrir `https://outsign.app` apontando ainda para o host antigo
- validar a nova VM por IP, túnel SSH ou host temporário
- confirmar:
  - login via `outlogin`
  - upload
  - assinatura
  - e-mail
  - WebAuthn

### 16. Fazer o corte

- atualizar DNS ou proxy para o IP estático novo
- acompanhar logs do `nginx` e PM2
- parar o `outsign-prod` no host antigo somente depois da validação inicial

### 17. Rollback

- reverter DNS ou proxy para o host antigo
- religar `outsign-prod` na VM compartilhada
- congelar uploads no host novo até reconciliar diferenças se houver escrita após o corte

## Estado atual do Outsign Runtime

### Projeto GCP

- `projectId`:
  - `outsign-runtime`
- nome:
  - `Outsign Runtime`
- billing:
  - `billingAccounts/011DFB-1DE71C-9CC210`

### APIs mínimas habilitadas

- `compute.googleapis.com`
- `logging.googleapis.com`
- `monitoring.googleapis.com`

### IP estático

- nome da reserva:
  - `outsign-prod-ip`
- IP:
  - `34.39.157.241`

### VM

- nome:
  - `outsign-prod`
- status atual:
  - `STAGING`
- zona:
  - `southamerica-east1-b`
- tipo:
  - `e2-standard-2`
- IP interno:
  - `10.158.0.2`
- IP externo:
  - `34.39.157.241`
- tags:
  - `http-server`
  - `https-server`
  - `outsign-prod`

### Próximo passo

- provisionar a VM
- criar usuário operacional `outsign`
- instalar Node e PM2
- preparar acesso Git
- copiar `.env`, `uploads/` e `certs`

## Provisionamento atual do host - Outsign Runtime

### Acesso e bootstrap

- acesso SSH funcional na VM `outsign-prod`
- bootstrap base concluído
- pacotes instalados:
  - `git`
  - `curl`
  - `build-essential`
  - `ca-certificates`
  - `nginx`

### Usuário operacional

- usuário criado:
  - `outsign`
- shell:
  - `/bin/bash`
- home:
  - `/home/outsign`

### Node e PM2

- `nvm` instalado para o usuário `outsign`
- Node:
  - `v20.20.2`
- npm:
  - `10.8.2`
- PM2:
  - `7.0.1`

### Disco

- root filesystem expandido corretamente
- estado observado:
  - `/dev/sda1 40G`
  - `2.7G` usados
  - `35G` livres

### Próximo passo operacional

- gerar chave SSH do usuário `outsign`
- cadastrar a chave pública no GitHub como `Deploy key`
- clonar o repositório do `outsign`
- copiar `.env`, `uploads/` e `certs`

## Estado atual da aplicação no novo Outsign Runtime

### Acesso Git

- chave SSH exclusiva do usuário `outsign` criada
- deploy key cadastrada no GitHub
- clone do repositório concluído em:
  - `/home/outsign/prod`

### Código e dependências

- branch:
  - `main`
- commit validado no host novo:
  - `499005d`
- `npm ci` executado com sucesso

### Node real alinhado ao projeto

- ajuste feito de `Node 20` para `Node 24.14.1`
- versão final em uso:
  - `Node v24.14.1`
  - `npm 11.11.0`
- motivo:
  - o `package.json` da `Outsign` exige `>=24.14.1 <25`

### Migração de artefatos locais

- `.env` copiado do runtime atual
- `uploads/` copiado do runtime atual
- `certs/` copiado do runtime atual
- tamanhos observados no host novo:
  - `uploads`: `18M`
  - `certs`: `16K`

### Build e runtime

- `npm run build` executado com sucesso
- observação:
  - houve warning de tracing do Turbopack relacionado a `next.config.ts` e `src/lib/server/storage.ts`
  - não bloqueou o build
- processo iniciado com:
  - `pm2 start ecosystem.config.cjs --only outsign-prod --update-env`
- status atual:
  - `outsign-prod` `online`
- resposta HTTP local validada:
  - `HTTP/1.1 307 Temporary Redirect`
  - `location: /login`

### Persistência no boot

- `pm2 startup systemd` configurado para o usuário `outsign`
- unit criada:
  - `pm2-outsign.service`
- `pm2 save` executado com sucesso

### Situação da migração

- a `Outsign` já está funcional na VM nova
- o corte de tráfego ainda não foi feito
- falta principalmente:
  - configurar `nginx` final para `outsign.app`
  - ajustar TLS
  - validar fluxos funcionais mais sensíveis antes do corte

## Estado atual da borda HTTP/TLS - Outsign Runtime

### Nginx na VM nova

- estrutura alinhada ao padrão do servidor atual:
  - `/etc/nginx/vhosts/outsign.app.conf`
  - `/etc/nginx/includes/upstreams.conf`
  - `/etc/nginx/includes/cloudflare.conf`
- upstream configurado:
  - `outsign-app -> 127.0.0.1:1340`

### Comportamento validado

- `http://127.0.0.1` com `Host: outsign.app`
  - responde `301`
  - redireciona para `https://outsign.app/`
- `https://127.0.0.1` com `Host: outsign.app`
  - responde `307`
  - `location: /login`
  - `server: nginx`
  - `x-powered-by: Next.js`

### Situação do certificado

- a origem antiga usa `Cloudflare Origin Certificate`
- na VM nova o certificado definitivo já foi instalado em:
  - `/etc/nginx/ssl/outsign.app/server.crt`
  - `/etc/nginx/ssl/outsign.app/server.key`
- validação confirmada na origem nova:
  - issuer `CloudFlare Origin SSL Certificate Authority`
  - subject `CloudFlare Origin Certificate`
  - `notBefore=2026-06-04 19:20:00 GMT`
  - `notAfter=2041-05-31 19:20:00 GMT`

### Conclusão desta fase

- a `Outsign` já está funcional como aplicação
- a borda `nginx` já está funcional na VM nova
- o certificado de origem definitivo já está ativo
- a pendência crítica restante para corte seguro é a validação funcional final

## Validação funcional automática pré-corte - Outsign Runtime

### Aplicação e borda

- `GET /api/health` na origem nova:
  - `HTTP 200`
  - `{"success":true,"data":{"status":"ok"...}}`
- `GET /login` na origem nova:
  - `HTTP 200`
- redirect raiz na origem nova:
  - `307 -> /login`

### Dependências e configuração

- `OUTLOGIN_URL=https://outlogin.app`
- `NEXT_PUBLIC_OUTLOGIN_URL=https://outlogin.app`
- `SMTP_HOST=mail.outsign.app`
- `SMTP_PORT=465`
- `UPLOAD_DIR=./uploads`
- `WEBAUTHN_RP_ID=outsign.app`
- `WEBAUTHN_ORIGIN=https://outsign.app`
- `PDF_SIGNING_CERT_PATH=./certs/outbroker-ltda-11022027.pfx`

### Outlogin

- `https://outlogin.app` respondeu `HTTP 200`
- `https://outlogin.app/oauth/authorize` respondeu `HTTP 400`
- leitura operacional:
  - a rota OAuth está viva
  - o `400` sem parâmetros é esperado para uma chamada incompleta

### SMTP

- teste de conectividade TCP:
  - `mail.outsign.app:465`
  - resultado: `SMTP_TCP_OK`

### Arquivos locais críticos

- `PFX_OK`
- diretórios confirmados:
  - `uploads/`
  - `uploads/documents`
  - `uploads/signatures`
  - `uploads/scans`
  - `uploads/avatars`
  - `uploads/.ocr-cache`

### O que ainda não foi provado ponta a ponta

- login real com credenciais de usuário
- upload autenticado de documento
- assinatura PDF real
- envio de e-mail real
- WebAuthn real

### Leitura prática

- a infraestrutura, a origem HTTP/TLS, os artefatos locais e as dependências externas principais estão coerentes
- antes do corte, ainda é recomendado um teste assistido com conta real para os fluxos autenticados e de assinatura

## Deploy da Outsign na VM nova

### Secrets operacionais confirmados

- `DEPLOY_HOST=34.39.157.241`
- `DEPLOY_USER=outsign`
- `DEPLOY_PORT=22`
- `DEPLOY_SSH_KEY` atualizado para a chave do runtime novo

### Ajuste complementar necessário

- a chave pública do runtime `outsign` foi adicionada em:
  - `/home/outsign/.ssh/authorized_keys`
- isso foi necessário porque a chave inicialmente criada para o clone do GitHub ainda não estava autorizada para login SSH vindo do GitHub Actions

### Validação do pipeline

- workflow:
  - `Deploy Outsign Prod`
- execução validada:
  - `run_id=26923090894`
- resultado:
  - `success`
- duração observada:
  - `3m17s`

### Leitura operacional

- a `Outsign` já está não só migrada como também publicando pela VM nova via GitHub Actions
- o fluxo de deploy ficou ponta a ponta funcional no novo runtime

## Fase 0 - Outlogin

### Repositório local

- path:
  - `/home/filimm/projetos/outlogin`
- remoto:
  - `git@github.com:outbrokerapp/outlogin.git`
- branch local atual observada:
  - `dev/filipe/outlogin-user-delete-fanout`
- branch publicada:
  - `origin/dev/filipe/outlogin-user-delete-fanout`
- `main` local observada:
  - `97bc611`

### Deploy atual

- workflow:
  - `Deploy Outlogin Prod`
- trigger:
  - `push` em `main`
- diretório de produção:
  - `/home/outlogin/prod`
- PM2:
  - `outlogin-prod`
- versão alvo de Node no deploy:
  - `24.14.1`
- secrets esperados no GitHub:
  - `DEPLOY_KEY`
  - `DEPLOY_HOST`
  - `DEPLOY_PORT`
  - `DEPLOY_USER`

### Runtime atual na VM compartilhada

- usuário operacional:
  - `outlogin`
- home:
  - `/home/outlogin`
- permissões observadas:
  - `/home/outlogin` com `700`
- processo ativo:
  - `PM2 v6.0.14`
  - `npm start`
  - `next start`
  - `next-server (v16.2.5)`
- porta observada:
  - `1341`

### Stack e integração

- `APP_URL`
- `MONGODB_URI`
- `JWT_SECRET`
- `JWT_REFRESH_SECRET`
- `JWT_ACCESS_EXPIRES_IN`
- `JWT_REFRESH_EXPIRES_IN`
- `GOOGLE_CLIENT_ID`
- `GOOGLE_CLIENT_SECRET`
- `GOOGLE_ANDROID_CLIENT_ID`
- `GOOGLE_IOS_CLIENT_ID`
- `GOOGLE_ALLOWED_RETURN_ORIGINS`
- `GOOGLE_NATIVE_ALLOWED_CLIENT_IDS`
- `OUTBROKER_MONGODB_URI`
- `OUTBROKER_EVENT_WEBHOOK_URL`
- `OUTBROKER_EVENT_WEBHOOK_SECRET`
- `OUTSIGN_MONGODB_URI`

### Papel no ecossistema

- servidor de identidade/auth do ecossistema
- rotas-chave:
  - `/oauth/authorize`
  - `/oauth/token`
  - `/oauth/userinfo`
- integra diretamente com:
  - `outbroker`
  - `outsign`

### Sensibilidades da futura migração

- o `outlogin` é mais crítico que `outsign`
- ele carrega:
  - OAuth do ecossistema
  - Google OAuth
  - JWT/sessões
  - fanout e integrações entre apps
- a migração vai exigir cuidado extra com:
  - segredos reais
  - callbacks OAuth
  - domínio público
  - compatibilidade de clientes OAuth já provisionados

### Próximo passo recomendado

- continuar a auditoria do `outlogin` no host atual
- identificar:
  - domínio público efetivo
  - configuração de `nginx`
  - segredos reais de produção
  - certificados/TLS
  - dependências externas ativas

### Auditoria pública e de borda do `outlogin`

- domínio público confirmado:
  - `https://outlogin.app`
- comportamento público confirmado:
  - `GET /` responde `HTTP 200`
  - `GET /oauth/authorize` sem parâmetros responde `HTTP 400`
  - `POST /oauth/token` com corpo vazio responde `HTTP 400`
  - `GET /oauth/userinfo` sem bearer responde `HTTP 401`
  - `GET /api/auth/google/url` responde `HTTP 200`
- origem antiga na VM compartilhada confirmada:
  - `80 -> 301 https`
  - `443 -> nginx -> upstream outlogin-app`
- vhost atual identificado em:
  - `/etc/nginx/vhosts/outlogin.app.conf`
- upstream atual identificado em:
  - `/etc/nginx/includes/upstreams.conf`
  - `outlogin-app -> 127.0.0.1:1341`
- certificado atual na origem antiga:
  - `/etc/nginx/ssl/outlogin.app/server.crt`
  - `/etc/nginx/ssl/outlogin.app/server.key`
- observação de segurança:
  - na VM compartilhada, `server.key` apareceu com permissão legível além de root
  - isso merece correção quando a migração do `outlogin` acontecer

### Descoberta crítica - Google OAuth do `outlogin`

- a rota pública `GET /api/auth/google/url` revelou um `client_id` ativo:
  - `647816570459-5qjdnjg7vnhbqgfvakhemrgjokfmok4e.apps.googleusercontent.com`
- o prefixo `647816570459` bate exatamente com o `projectNumber` do projeto GCP:
  - `outbroker`
  - nome: `Outbroker Waitlist`
  - estado observado: `DELETE_REQUESTED`
- conclusão operacional:
  - o Google OAuth atual do `outlogin` ainda depende do projeto antigo da waitlist
  - portanto, a exclusão definitiva desse projeto deve ser tratada como `bloqueada`
  - antes da remoção final, será necessário:
    - criar um novo projeto/runtime apropriado para o `outlogin`
    - provisionar novos OAuth clients Google
    - atualizar `GOOGLE_CLIENT_ID` e `GOOGLE_CLIENT_SECRET`
    - validar callback `https://outlogin.app/api/auth/google/callback`
    - só então concluir a remoção do projeto antigo

### Limite atual da auditoria

- o host compartilhado confirma o runtime, o `nginx` e a borda do `outlogin`
- mas o `.env` real de produção ainda não foi lido
- motivo:
  - `filipe` no host só tem `NOPASSWD` para o usuário `outbroker`
  - a troca para `outlogin`/root exige senha
- então, por ora, os segredos do `outlogin` seguem auditados por:
  - contrato de código
  - comportamento público
  - workflow de deploy

### Segredos e runtime reais de produção

- o acesso `sudo -iu outlogin` foi liberado depois e permitiu ler o runtime real
- `.env` de produção confirmado em `/home/outlogin/prod/.env`
- variáveis confirmadas em produção:
  - `APP_URL=https://outlogin.app`
  - `PORT=1341`
  - `MONGODB_URI` apontando para `outlogin_prod`
  - `JWT_SECRET`
  - `JWT_REFRESH_SECRET`
  - `OUTBROKER_EVENT_WEBHOOK_URL=https://outbroker.app/api/internal/outlogin/account-purge`
  - `OUTBROKER_EVENT_WEBHOOK_SECRET`
  - `IDENTITY_DELETION_WORKER_INTERVAL_MS=60000`
  - `IDENTITY_DELETION_WORKER_BATCH_LIMIT=25`
  - `GOOGLE_CLIENT_ID`
  - `GOOGLE_CLIENT_SECRET`
  - `GOOGLE_ANDROID_CLIENT_ID`
  - `GOOGLE_IOS_CLIENT_ID`
  - `GOOGLE_NATIVE_ALLOWED_CLIENT_IDS`
  - `GOOGLE_ALLOWED_RETURN_ORIGINS=https://outbroker.app,https://devel.outbroker.app`
  - `INTERNAL_PROVISIONING_TOKEN`
  - `OUTBROKER_MONGODB_URI` apontando para `outbroker_prod`
  - `OUTSIGN_MONGODB_URI` apontando para `outsign-dev`
- observação importante:
  - o valor de `OUTSIGN_MONGODB_URI` em produção está apontando para `outsign-dev`
  - isso foi validado pelo Filipe como intencional no estado atual
  - a nomenclatura é confusa e deve entrar na fila de padronização futura
  - por ora, a migração do `outlogin` deve preservar esse valor exatamente como está

### PM2 e processos reais

- `ecosystem.config.cjs` de produção define:
  - `outlogin-prod`
  - `outlogin-identity-deletion-cron`
- estado observado no PM2:
  - `outlogin-prod` online
- o cron de deleção de identidade existe no ecosystem, mas não apareceu online no momento da auditoria
- implicação:
  - na migração do `outlogin`, será preciso decidir se o worker de deleção sobe:
    - junto com a app no mesmo runtime
    - ou em processo separado mais controlado

### Artefatos locais do runtime

- não há `uploads/` nem `certs/` no runtime do `outlogin`
- isso simplifica a migração em relação à `Outsign`
- o runtime atual é essencialmente:
  - app Next.js
  - Mongo
  - JWT
  - Google OAuth
  - webhook para `outbroker`

## Desenho alvo - Outlogin Runtime

### Objetivo

- retirar o `outlogin` da VM compartilhada
- dar a ele um runtime próprio e isolado
- migrar o Google OAuth para um projeto GCP novo e correto
- preservar compatibilidade com:
  - `outbroker`
  - `outsign`
  - apps móveis
  - clientes OAuth já provisionados no banco

### Decisão arquitetural

- usar `um projeto GCP próprio` para o `outlogin`
- usar `uma VM dedicada` simples
- não usar Kubernetes
- manter `PM2`
- manter `nginx` na borda
- manter uma app web principal e decidir explicitamente o destino do worker de deleção

### Nome sugerido

- projeto:
  - `outlogin-runtime`
- nome amigável:
  - `Outlogin Runtime`
- VM:
  - `outlogin-prod`
- usuário operacional:
  - `outlogin`
- zona padrão:
  - `southamerica-east1-b`

### Sizing sugerido

- tipo:
  - `e2-standard-2`
- disco:
  - `pd-balanced 30 GB`
- SO:
  - `Debian 13`

### Dependências críticas

- `MongoDB`
  - banco principal `outlogin_prod`
- `Google OAuth`
  - web client
  - Android client
  - iOS client
- `outbroker`
  - purge webhook
  - `OUTBROKER_MONGODB_URI`
- `outsign`
  - `OUTSIGN_MONGODB_URI`
- `JWT_SECRET`
- `JWT_REFRESH_SECRET`
- `INTERNAL_PROVISIONING_TOKEN`

### Decisão sobre o projeto GCP antigo

- o projeto `Outbroker Waitlist` não pode ser removido definitivamente antes da migração do Google OAuth
- nova classificação operacional:
  - `DELETE_REQUESTED`, mas com dependência viva do `outlogin`
  - precisa ser recuperado logicamente como referência até a troca dos OAuth clients
- regra:
  - só concluir a remoção final depois que o `outlogin` novo estiver usando clients do projeto `outlogin-runtime`

### Plano de migração do Google OAuth

#### Fase 1. Criar o novo projeto/runtimes

- criar projeto `outlogin-runtime`
- vincular billing
- habilitar:
  - `compute.googleapis.com`
  - `logging.googleapis.com`
  - `monitoring.googleapis.com`
- criar VM `outlogin-prod`
- provisionar:
  - usuário `outlogin`
  - `Node 24.14.1`
  - `PM2`
  - `nginx`

#### Fase 2. Criar os novos OAuth clients Google

- no projeto `outlogin-runtime`, criar:
  - OAuth client Web
  - OAuth client Android
  - OAuth client iOS
- o client Web precisa incluir ao menos:
  - JavaScript origin:
    - `https://outlogin.app`
  - redirect URI:
    - `https://outlogin.app/api/auth/google/callback`
- os clients móveis devem refletir exatamente os pacotes/apps que hoje dependem dos IDs antigos

#### Fase 3. Preparar o runtime novo

- clonar o repo em `/home/outlogin/prod`
- copiar `.env`
- ajustar no `.env` novo:
  - `GOOGLE_CLIENT_ID`
  - `GOOGLE_CLIENT_SECRET`
  - `GOOGLE_ANDROID_CLIENT_ID`
  - `GOOGLE_IOS_CLIENT_ID`
- preservar sem mudança:
  - `APP_URL`
  - `MONGODB_URI`
  - `JWT_SECRET`
  - `JWT_REFRESH_SECRET`
  - `OUTBROKER_EVENT_WEBHOOK_URL`
  - `OUTBROKER_EVENT_WEBHOOK_SECRET`
  - `OUTBROKER_MONGODB_URI`
  - `OUTSIGN_MONGODB_URI`
  - `GOOGLE_ALLOWED_RETURN_ORIGINS`
  - `GOOGLE_NATIVE_ALLOWED_CLIENT_IDS` ajustado para a nova família de IDs
- buildar e subir a app no PM2

#### Fase 4. Validar antes do corte

- validar:
  - `GET /`
  - `GET /oauth/authorize`
  - `POST /oauth/token`
  - `GET /oauth/userinfo`
  - `GET /api/auth/google/url`
- conferir que o `client_id` devolvido pela origem nova já pertence ao projeto `outlogin-runtime`
- validar callback:
  - `https://outlogin.app/api/auth/google/callback`
- validar login real via Google
- validar fluxo de OAuth para app cliente real

#### Fase 5. Corte

- configurar `nginx` e TLS na VM nova
- apontar Cloudflare para a origem nova
- validar a borda pública
- acompanhar logs de:
  - login
  - callback Google
  - purge webhook
  - token exchange

#### Fase 6. Fechamento

- atualizar GitHub Actions do `outlogin`
- validar deploy ponta a ponta
- só depois disso:
  - remover dependência do projeto `Outbroker Waitlist`
  - concluir a exclusão definitiva do projeto antigo

### Riscos principais

- trocar o `client_id` web sem cadastrar callback/origin corretamente
- esquecer algum client Android/iOS ainda em uso
- mudar `GOOGLE_NATIVE_ALLOWED_CLIENT_IDS` de forma incompleta
- quebrar o purge webhook do `outbroker`
- assumir que o cron de deleção já está operacional quando ele pode estar dormente

### Próximo passo recomendado

- criar o projeto `outlogin-runtime`
- e, em seguida, provisionar a VM
- só depois criar os novos OAuth clients Google, para já os atrelar ao projeto final correto

## Criação do Outlogin Runtime

### Projeto GCP

- projeto criado:
  - `outlogin-runtime`
- nome amigável:
  - `Outlogin Runtime`
- `projectNumber`:
  - `603113878956`
- estado:
  - `ACTIVE`
- billing vinculado:
  - `billingAccounts/011DFB-1DE71C-9CC210`

### APIs mínimas habilitadas

- `compute.googleapis.com`
- `logging.googleapis.com`
- `monitoring.googleapis.com`

### VM criada

- nome:
  - `outlogin-prod`
- zona:
  - `southamerica-east1-b`
- tipo:
  - `e2-medium`
- disco:
  - `pd-balanced 20 GB`
- IP interno:
  - `10.158.0.2`
- IP externo:
  - `35.198.8.159`
- status:
  - `RUNNING`

### Observação operacional

- o GCP emitiu apenas o aviso padrão de disco maior que a imagem base
- isso deve ser confirmado no provisionamento, como já fizemos nos demais runtimes

## Provisionamento da VM `outlogin-prod`

### Host base

- acesso SSH funcional
- pacotes base instalados:
  - `git`
  - `curl`
  - `build-essential`
  - `ca-certificates`
  - `nginx`
- versão do `nginx` observada:
  - `1.26.3`

### Usuário operacional

- usuário criado:
  - `outlogin`
- home:
  - `/home/outlogin`
- `.ssh` preparado:
  - `/home/outlogin/.ssh`

### Runtime Node

- `nvm` instalado para o usuário `outlogin`
- `Node` instalado:
  - `v24.14.1`
- `npm` instalado:
  - `11.11.0`
- `PM2` instalado:
  - `7.0.1`

### Disco

- root confirmado com resize funcional:
  - `20 GB`
- uso observado após bootstrap:
  - `2.7G` usados
  - `16G` livres

### Limpeza

- script temporário de bootstrap removido do host

## Base do runtime novo do `outlogin`

### Repositório

- repo clonado em:
  - `/home/outlogin/prod`
- branch:
  - `main`
- commit observado na VM nova:
  - `e5d6cfe`

### Configuração copiada

- `.env` replicado do runtime atual
- `ecosystem.config.cjs` replicado do runtime atual

### Build

- `npm ci` executado com sucesso
- `npm run build` executado com sucesso
- warning observado:
  - tracing amplo envolvendo `next.config.ts`
  - warning não bloqueante, semelhante ao padrão já visto em outros runtimes

### Próximo bloqueio real

- a migração do `Google OAuth` do `outlogin` não está disponível por `gcloud` comum
- o caminho disponível por CLI no ambiente local é apenas de `IAP OAuth`, que:
  - é específico de IAP
  - está depreciado
  - não serve como API genérica para os clients OAuth do `outlogin`
- portanto, a próxima etapa prática depende de criação manual no Google Cloud Console:
  - OAuth client Web
  - OAuth client Android
  - OAuth client iOS

### Aplicação dos novos clients web

- `GOOGLE_CLIENT_ID` novo aplicado no runtime novo:
  - `603113878956-3e86sl3sjgdus4c70sfo7ccujqp5mvqj.apps.googleusercontent.com`
- `GOOGLE_CLIENT_SECRET` novo aplicado no runtime novo
- estratégia mantida:
  - `GOOGLE_CLIENT_ID/SECRET` novos do projeto `outlogin-runtime`
  - `GOOGLE_ANDROID_CLIENT_ID` antigo mantido temporariamente
  - `GOOGLE_IOS_CLIENT_ID` antigo mantido temporariamente
  - `GOOGLE_NATIVE_ALLOWED_CLIENT_IDS` ajustado para:
    - web novo
    - android antigo
    - ios antigo

### Validação da origem nova

- `outlogin-prod` reiniciado no PM2 com `--update-env`
- `GET /api/auth/google/url` na origem nova passou a devolver:
  - `client_id=603113878956-3e86sl3sjgdus4c70sfo7ccujqp5mvqj.apps.googleusercontent.com`
- conclusão:
  - o Google OAuth web já está migrado corretamente no runtime novo

## Borda do `outlogin` na VM nova

### Nginx

- estrutura criada na VM nova:
  - `/etc/nginx/vhosts/outlogin.app.conf`
  - `/etc/nginx/includes/cloudflare.conf`
  - `/etc/nginx/includes/listen-http.conf`
  - `/etc/nginx/includes/listen-https.conf`
  - `/etc/nginx/includes/upstreams.conf`
- `nginx.conf` do Debian novo não incluía `vhosts/*.conf` por padrão
- solução aplicada:
  - `include /etc/nginx/vhosts/*.conf;` via `/etc/nginx/conf.d/vhosts.conf`
  - upstream `outlogin-app` também exposto em `/etc/nginx/conf.d/upstreams.conf`

### Certificado

- certificado de origem replicado da origem antiga:
  - `/etc/nginx/ssl/outlogin.app/server.crt`
  - `/etc/nginx/ssl/outlogin.app/server.key`
- certificado servido na origem nova validado:
  - issuer `CloudFlare Origin SSL Certificate Authority`
  - notBefore `May 6 22:46:00 2026 GMT`
  - notAfter `May 2 22:46:00 2041 GMT`

### Validação local da origem nova

- `http://127.0.0.1` com `Host: outlogin.app`:
  - `301` para `https://outlogin.app/`
- `https://127.0.0.1` com `Host: outlogin.app`:
  - `200`
  - `server: nginx`
  - `x-powered-by: Next.js`
- `GET /api/auth/google/url` via HTTPS local:
  - `success: true`
  - `client_id` web novo do projeto `outlogin-runtime`

### Firewall e validação por IP público

- regras de firewall criadas no projeto `outlogin-runtime`:
  - `default-allow-http`
  - `default-allow-https`
- validação por IP público da origem nova:
  - IP:
    - `35.198.8.159`
  - `http://35.198.8.159` com `Host: outlogin.app`:
    - `301` para `https://outlogin.app/`
  - `https://35.198.8.159` com `Host: outlogin.app`:
    - `200`
  - `GET /api/auth/google/url` via IP público + `Host`:
    - `success: true`
    - `client_id` web novo do projeto `outlogin-runtime`

## Deploy e corte final do `outlogin`

### Deploy

- secrets do GitHub Actions atualizados para a VM nova:
  - `DEPLOY_HOST=35.198.8.159`
  - `DEPLOY_USER=outlogin`
  - `DEPLOY_PORT=22`
  - `DEPLOY_KEY` atualizado com a chave do runtime novo
- chave pública do runtime novo autorizada em:
  - `/home/outlogin/.ssh/authorized_keys`
- validação SSH direta com a chave do deploy:
  - `SSH_OK`
  - host `outlogin-prod`
  - usuário `outlogin`
- workflow `Deploy Outlogin Prod` rerodado:
  - run `26734395625`
  - conclusão `success`
  - duração aproximada `1m4s`

### Corte operacional

- processo antigo na VM compartilhada:
  - `outlogin-prod`
  - status final `stopped`
- domínio público após o corte:
  - `https://outlogin.app/api/auth/google/url`
  - continua respondendo com o `client_id` novo:
    - `603113878956-3e86sl3sjgdus4c70sfo7ccujqp5mvqj.apps.googleusercontent.com`
- origem antiga continua respondendo diretamente por IP com o `client_id` antigo
- conclusão:
  - o tráfego público do `outlogin` está efetivamente na VM nova
  - a VM antiga não serve mais produção pública para `outlogin`

## Desenho alvo - Outbot Runtime

### Objetivo

- retirar o `outbroker-feed-bot` da VM compartilhada
- dar ao bot um runtime próprio, pequeno e barato
- preservar deploy simples, rollback rápido e operação previsível

### Decisão arquitetural

- usar `um projeto GCP próprio` para o bot
- usar `uma VM simples dedicada` no curto prazo
- não usar Kubernetes
- não usar cluster distribuído
- manter `um único runner ativo` do bot
- não criar ambiente de homologação para o bot
- operar o bot com `apenas produção`

### Nome sugerido

- projeto GCP:
  - `outbot-runtime`
  - nome amigável: `Outbot Runtime`
- VM:
  - `outbot-prod`

### Runtime sugerido

- `Compute Engine`
- Debian 13
- tamanho inicial sugerido:
  - `e2-standard-2`
- disco:
  - `pd-balanced`
  - `30 GB`

### Por que VM simples é a melhor escolha aqui

- o bot já roda bem como processo único
- o deploy atual já está adaptado a diretório e PM2
- não há benefício real em adicionar orquestração complexa agora
- troubleshooting fica muito mais simples em uma VM dedicada
- não existe necessidade operacional de homologação para esse worker

### Processo e supervisor

- manter `PM2` no primeiro desenho
- app única:
  - `outbroker-feed-bot`
- modo:
  - `fork_mode`
- regra operacional:
  - uma única instância produtiva por ambiente

### Rede e exposição

- a VM do bot não precisa exposição HTTP pública principal para servir usuários
- liberar SSH administrativo apenas no padrão que você decidir para o ecossistema
- não abrir portas desnecessárias
- se houver necessidade de endpoint de healthcheck no futuro, isso pode entrar
  depois, mas não é obrigatório no primeiro corte

### Segredos mínimos

- `MONGODB_URI`
- `OUTBROKER_URL`
- `R2_ACCOUNT_ID`
- `R2_ACCESS_KEY_ID`
- `R2_SECRET_ACCESS_KEY`
- `R2_PUBLIC_BUCKET`
- opcionais conforme uso:
  - `FEED_BOT_RUN_ON_STARTUP`
  - `FEED_BOT_DEBUG_PARSERS`

### Política de segredos recomendada

- não depender de `.env` commitado
- manter `.env` apenas no host ou em mecanismo de secret escolhido depois
- no curto prazo, um `.env` de produção no host dedicado é suficiente
- no médio prazo, migrar para uma estratégia centralizada por aplicação

### Deploy alvo

- manter GitHub Actions
- ajustar o workflow para apontar para:
  - novo `DEPLOY_HOST`
  - novo projeto/VM do bot
- manter estratégia simples:
  - `git fetch`
  - `git checkout`
  - `git pull --ff-only`
  - `npm ci --include=dev`
  - `pm2 reload/start`
  - `pm2 save`

### Rollback alvo

- rollback manual simples no primeiro momento
- opções aceitáveis:
  - `git checkout <sha_anterior>` + `npm ci` + `pm2 reload`
  - ou evoluir depois para release dirs, se o bot justificar
- não vejo necessidade de release-based mais sofisticado logo no primeiro corte

### Observabilidade mínima

- logs do PM2
- `pm2-logrotate`
- monitoramento básico da VM:
  - CPU
  - memória
  - disco
- status funcional:
  - continuar usando `BotRuntimeStatus` no Mongo
- alvos mínimos de checagem:
  - último ciclo executado
  - último ciclo com sucesso
  - restart inesperado

### Backups e persistência

- o bot não parece depender de storage local durável como fonte de verdade
- por isso:
  - snapshot da VM é útil
  - mas o core da persistência continua sendo Mongo + R2
- isso reduz risco da migração

### Dependências que precisam ser validadas antes do corte

- o `OUTBROKER_URL` do novo bot deve apontar para o ambiente correto
- o acesso ao Mongo deve sair do novo IP/novo host sem bloqueio
- o acesso ao R2 deve funcionar com as mesmas credenciais ou credenciais novas
- o lock operacional deve continuar impedindo ciclos concorrentes

### Estratégia de corte

- subir a nova VM
- provisionar Node, PM2, repo e `.env`
- fazer um `run-once` controlado no novo runtime
- validar:
  - conexão com Mongo
  - conexão com R2
  - leitura dos feeds
  - escrita de logs/status
- se passar:
  - parar o processo antigo na VM compartilhada
  - subir o processo contínuo na VM nova
- observar pelo menos um ciclo completo

### Estratégia de rollback

- se houver qualquer inconsistência:
  - parar o bot novo
  - religar o bot antigo na VM compartilhada
  - manter a VM nova só para análise
- o rollback é simples justamente porque o bot é runner único

### Critério de pronto para migração

- projeto `Outbot Runtime` criado
- VM `outbot-prod` criada
- acesso SSH e usuário operacional definidos
- `.env` de produção validado
- workflow de deploy apontando para o novo host
- execução `--run-once` validada
- procedimento de rollback testado

## Checklist de criação - Outbot Runtime

### Projeto GCP

- criar projeto:
  - `outbot-runtime`
- nome amigável:
  - `Outbot Runtime`
- habilitar somente o necessário no começo:
  - `compute.googleapis.com`
  - `logging.googleapis.com`
  - `monitoring.googleapis.com`

### VM

- nome:
  - `outbot-prod`
- região:
  - preferencialmente a mesma região operacional atual do ecossistema no início
- zona:
  - escolher uma zona estável da região alvo
- tipo:
  - `e2-standard-2`
- sistema:
  - `Debian 13`
- disco:
  - `pd-balanced`
  - `30 GB`
- IP:
  - reservar IP estático se houver necessidade de allowlist externa futura

### Firewall

- abrir somente o necessário
- SSH:
  - restringir por faixa administrativa ou pelo padrão mais seguro disponível
- não abrir portas públicas do bot se ele não precisar servir tráfego externo

### Usuário e acesso

- criar usuário operacional dedicado
- instalar chave SSH de deploy
- definir se o deploy continuará como usuário da aplicação ou por usuário
  administrativo com `sudo`

## Checklist de provisionamento do host

### Base do sistema

- atualizar pacotes
- instalar:
  - `git`
  - `curl`
  - `build-essential`
  - `ca-certificates`
- instalar Node na versão padrão do projeto
- instalar `pm2`

### Estrutura de diretórios

- criar diretório de app:
  - `/home/<usuario>/outbot`
- clonar repo:
  - `outbroker-feed-bot`
- criar `.env` de produção

### Processo

- rodar:
  - `npm ci --include=dev`
- iniciar:
  - `pm2 start ecosystem.config.cjs --only outbroker-feed-bot --update-env`
- persistir:
  - `pm2 save`
- configurar persistência no boot:
  - `pm2 startup systemd`

### Logs

- instalar/configurar `pm2-logrotate`
- validar caminhos de log

## Checklist de corte

### Antes do corte

- validar `.env`
- testar conectividade com Mongo
- testar conectividade com R2
- executar `sync:once` ou `--run-once`
- validar `BotRuntimeStatus`
- validar se não houve concorrência com o runner antigo

### Corte

- parar o `outbroker-feed-bot` na VM compartilhada
- subir o `outbroker-feed-bot` na VM nova
- acompanhar um ciclo completo
- validar logs, status e resultados no Mongo

### Rollback

- parar o bot novo
- religar o bot antigo
- preservar a VM nova para análise

## Runbook prático - criação do Outbot Runtime

### Variáveis sugeridas

```bash
export OUTBOT_PROJECT_ID="outbot-runtime"
export OUTBOT_PROJECT_NAME="Outbot Runtime"
export OUTBOT_REGION="southamerica-east1"
export OUTBOT_ZONE="southamerica-east1-b"
export OUTBOT_VM_NAME="outbot-prod"
export OUTBOT_MACHINE_TYPE="e2-standard-2"
export OUTBOT_DISK_SIZE="30GB"
export OUTBOT_SYSTEM_USER="outbot"
```

### 1. Criar projeto

```bash
gcloud projects create "$OUTBOT_PROJECT_ID" --name="$OUTBOT_PROJECT_NAME"
```

### 2. Vincular billing

Observação:
- usar a mesma billing account operacional do ecossistema principal

Descobrir billing account disponível:

```bash
gcloud beta billing accounts list
```

Vincular:

```bash
export OUTBOT_BILLING_ACCOUNT="SEU_BILLING_ACCOUNT_ID"
gcloud beta billing projects link "$OUTBOT_PROJECT_ID" \
  --billing-account="$OUTBOT_BILLING_ACCOUNT"
```

### 3. Definir projeto ativo

```bash
gcloud config set project "$OUTBOT_PROJECT_ID"
```

### 4. Habilitar APIs mínimas

```bash
gcloud services enable \
  compute.googleapis.com \
  logging.googleapis.com \
  monitoring.googleapis.com
```

### 5. Criar VM

```bash
gcloud compute instances create "$OUTBOT_VM_NAME" \
  --zone="$OUTBOT_ZONE" \
  --machine-type="$OUTBOT_MACHINE_TYPE" \
  --image-family=debian-13 \
  --image-project=debian-cloud \
  --boot-disk-type=pd-balanced \
  --boot-disk-size="$OUTBOT_DISK_SIZE" \
  --tags=outbot-prod
```

### 6. Regra de firewall

Se o bot não precisar servir tráfego externo, não abrir portas públicas extras.
No mínimo, revisar o padrão de SSH antes de expor para `0.0.0.0/0`.

### 7. Descobrir IP da VM

```bash
gcloud compute instances describe "$OUTBOT_VM_NAME" \
  --zone="$OUTBOT_ZONE" \
  --format='get(networkInterfaces[0].accessConfigs[0].natIP)'
```

### 8. Acesso inicial por SSH

```bash
gcloud compute ssh "$OUTBOT_VM_NAME" --zone="$OUTBOT_ZONE"
```

### 9. Bootstrap inicial do host

```bash
sudo apt update
sudo apt install -y git curl build-essential ca-certificates
sudo adduser --disabled-password --gecos "" "$OUTBOT_SYSTEM_USER"
sudo usermod -aG sudo "$OUTBOT_SYSTEM_USER"
```

### 10. Instalar Node via nvm

```bash
sudo -iu "$OUTBOT_SYSTEM_USER"
curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.nvm/nvm.sh
nvm install 20
nvm use 20
npm install -g pm2
```

### 11. Clonar o bot

```bash
git clone git@github.com:outbrokerapp/outbroker-feed-bot.git ~/outbot
cd ~/outbot
git checkout main
npm ci --include=dev
```

### 12. Criar `.env` de produção

Criar manualmente com:
- `MONGODB_URI`
- `OUTBROKER_URL`
- `R2_ACCOUNT_ID`
- `R2_ACCESS_KEY_ID`
- `R2_SECRET_ACCESS_KEY`
- `R2_PUBLIC_BUCKET`
- opcionais do bot

### 13. Teste controlado antes do PM2

```bash
cd ~/outbot
npx tsx src/index.ts --run-once
```

### 14. Subir no PM2

```bash
cd ~/outbot
pm2 start ecosystem.config.cjs --only outbroker-feed-bot --update-env
pm2 save
pm2 startup systemd
```

### 15. Validar logs

```bash
pm2 describe outbroker-feed-bot
pm2 logs outbroker-feed-bot --lines 100
```

### 16. Corte

Na VM antiga:

```bash
sudo -iu outbroker pm2 stop outbroker-feed-bot
```

Na VM nova:

```bash
pm2 restart outbroker-feed-bot --update-env
pm2 logs outbroker-feed-bot --lines 100
```

### 17. Rollback

Na VM nova:

```bash
pm2 stop outbroker-feed-bot
```

Na VM antiga:

```bash
sudo -iu outbroker pm2 restart outbroker-feed-bot --update-env
```

## Estado atual do Outbot Runtime

### Projeto

- `projectId`: `outbot-runtime`
- nome: `Outbot Runtime`
- `lifecycleState`: `ACTIVE`
- billing vinculado:
  - `billingAccounts/011DFB-1DE71C-9CC210`

### APIs habilitadas mínimas

- `compute.googleapis.com`
- `logging.googleapis.com`
- `monitoring.googleapis.com`

### VM criada

- nome: `outbot-prod`
- zona: `southamerica-east1-b`
- tipo: `e2-standard-2`
- disco:
  - `pd-balanced`
  - `30 GB`
- IP interno:
  - `10.158.0.2`
- IP externo:
  - `34.95.138.190`
- status:
  - `RUNNING`

### Próximo passo operacional

- provisionar o host
- criar o usuário `outbot`
- instalar Node + PM2
- clonar o repo do bot
- criar `.env` de produção
- validar `--run-once`

### Estado após provisionamento inicial

- usuário `outbot` criado
- `Node v20.20.2` instalado via `nvm`
- `PM2 7.0.1` instalado
- repo clonado em:
  - `/home/outbot/outbot`
- commit validado no host:
  - `80e1fcc`
- `npm ci --include=dev` executado com sucesso
- `npm run lint` executado com sucesso
- `.env` de produção copiado a partir do runtime atual
- `npm run sync:once` executado com sucesso (`exit 0`)

### Evidências da validação `run-once`

- conexão com Mongo validada
- lock de ciclo validado
- leitura do feed validada
- processamento real de centenas de itens validado
- o processo terminou com `exit 0`

### Próximo passo real

- configurar persistência do PM2 no boot do runtime novo
- subir o processo contínuo no novo host somente no momento do corte
- parar o runner antigo e transferir a operação para `outbot-prod`

### Estado após o corte

- `outbroker-feed-bot` antigo na VM compartilhada:
  - `stopped`
- `outbroker-feed-bot` no `outbot-prod`:
  - `online`
  - aguardando cron
- logs do novo runner mostram:
  - inicialização normal
  - conexão com Mongo validada
  - agendamento configurado com cron `0 * * * *`
  - modo de espera operacional ativo

### Resultado da migração do bot

- o primeiro desmembramento do ecossistema foi concluído
- o `outbroker-feed-bot` saiu da VM compartilhada e passou a rodar em runtime
  próprio
- o novo runtime foi validado por:
  - `lint`
  - `run-once`
  - subida contínua em `PM2`
  - corte do runner antigo

### Chave SSH do runtime

- chave pública gerada para o usuário `outlogin` na VM nova:
  - `ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIbzXTUYU+NMhGEo60Es1BBpYohrSG0Pb7Z4FhnF/oEu outlogin-runtime`
- fingerprint:
  - `SHA256:Rf0Pb9iJ/cKnq53Gk7BlSlTGjLuxafxB/ICwgwDXUgw`
- próximo passo:
  - cadastrar essa chave como `Deploy key` no repositório do `outlogin`

### Migração Google OAuth web do outlogin

- novos valores recebidos e aplicados no runtime novo:
  - `GOOGLE_CLIENT_ID=603113878956-3e86sl3sjgdus4c70sfo7ccujqp5mvqj.apps.googleusercontent.com`
  - `GOOGLE_CLIENT_SECRET` novo aplicado
- estratégia atual:
  - `GOOGLE_CLIENT_ID/SECRET` novos do projeto `outlogin-runtime`
  - `GOOGLE_ANDROID_CLIENT_ID` antigo mantido temporariamente
  - `GOOGLE_IOS_CLIENT_ID` antigo mantido temporariamente

## Desenho alvo - Outbroker Devel Runtime

### Objetivo

- retirar o `develop` da VM compartilhada atual
- isolar o ambiente `devel` do `prod`
- trocar o banco do `devel` para `outbroker_dev`
- manter o mesmo domínio funcional de homologação:
  - `devel.outbroker.app`
- impedir que builds de `develop` consumam CPU/RAM do runtime

### Decisão arquitetural

- criar um projeto GCP próprio para o runtime de desenvolvimento da `outbroker`
- manter `develop -> devel`
- manter `main -> prod`
- não buildar na VM de runtime
- runtime recebe artefato pronto
- manter `nginx + PM2`
- manter o app web e os workers de `devel` separados dos de produção

### Nome sugerido

- projeto:
  - `outbroker-devel-runtime`
- nome amigável:
  - `Outbroker Devel Runtime`
- VM:
  - `outbroker-devel`
- usuário operacional:
  - `outbroker`
- zona:
  - `southamerica-east1-b`

### Sizing inicial sugerido

- VM:
  - `e2-standard-2`
- disco:
  - `pd-balanced 40 GB`
- SO:
  - `Debian 13`

### Justificativa do sizing

- o `outbroker-devel` atual já roda um Next.js grande
- a app usa mobile shell, auth, R2, pagamentos, WebRTC e upload/mídia
- o runtime do `prod` atual consome bastante memória
- mesmo sem build local, o `devel` precisa folga razoável
- `e2-medium` tende a ficar apertado para Next.js desse porte
- `e2-standard-2` é o melhor ponto de partida de custo-benefício

### Banco de dados

- criar base nova:
  - `outbroker_dev`
- fazer clone inicial de `outbroker_prod -> outbroker_dev`
- trocar `.env` do `devel` para `outbroker_dev`
- não manter replicação contínua de `prod -> dev`

### Storage

- decisão temporária validada:
  - `devel` manterá o mesmo bucket R2 da produção por enquanto
- justificativa:
  - facilitar testes com imagens já sincronizadas do banco produtivo
- risco aceito temporariamente:
  - ambiente `devel` escrevendo em bucket produtivo
- dívida técnica futura:
  - separar buckets por ambiente

### Integrações de ambiente

- `outlogin`
  - `devel` deve apontar para o runtime correto de identidade quando existir
- `Mercado Pago`
  - `devel` deve usar credenciais/sandbox de homologação
- `WebRTC/TURN`
  - avaliar se `devel` usa as mesmas credenciais ou credenciais separadas
- `Firebase/push`
  - avaliar convivência de `devel` com o projeto atual de push

### Regras operacionais novas

- `develop` nunca mais roda no mesmo runtime do `prod`
- `main` nunca mais compartilha build host com `develop`
- builds não rodam nas VMs de runtime
- deploy passa a ser por artefato

## Desenho alvo - Build Runner Compartilhado

### Objetivo

- centralizar builds das aplicações web
- centralizar builds de workers
- centralizar geração do app Android via Capacitor
- tirar carga de CPU/RAM das VMs de runtime

### Decisão arquitetural

- criar `1 build-runner compartilhado` no curto prazo
- runner self-hosted para GitHub Actions
- gerar artefatos de deploy para web
- gerar `APK` e `AAB` para Android
- não rodar app em produção nesse host

### Nome sugerido

- projeto:
  - `shared-build-runner`
- nome amigável:
  - `Shared Build Runner`
- VM:
  - `build-runner-prod`
- usuário operacional:
  - `builder`
- zona:
  - `southamerica-east1-b`

### Sizing inicial sugerido

- VM:
  - `e2-standard-4`
- disco:
  - `pd-balanced 100 GB`
- SO:
  - `Debian 13`

### Ferramentas necessárias

- Node.js
- npm
- JDK
- Android SDK
- Gradle
- Capacitor toolchain
- GitHub Actions runner

### Pipeline alvo para web

1. GitHub Actions dispara no runner
2. `npm ci`
3. `npm run build`
4. empacota artefato imutável
5. envia artefato para a VM de runtime
6. runtime apenas extrai e recarrega PM2

### Pipeline alvo para Android

1. GitHub Actions dispara no runner
2. build web da `outbroker`
3. sincroniza Capacitor
4. gera `APK` para distribuição rápida
5. gera `AAB` para Play Console
6. publica artefatos

## Canal oficial de testes Android

### Estratégia recomendada

Usar dois canais oficiais em paralelo:

- `Internal App Sharing`
  - para compartilhar builds rapidamente com link
- `Internal testing`
  - para validar o fluxo oficial de release na Play

### Internal App Sharing

Melhor para:

- QA rápido
- distribuição imediata
- testes antes de release formal

Características importantes:

- aceita `APK` ou `AAB`
- gera link direto de instalação
- bom para time interno e stakeholders
- links expiram
- Google re-assina o artefato para esse canal

### Internal Testing

Melhor para:

- processo de release real
- validação de versão e rollout
- preparação para publicação futura

Características importantes:

- usa track oficial da Play
- exige configuração de testers
- ideal para o fluxo contínuo da empresa

### Política recomendada

- `APK`:
  - distribuição rápida de teste
  - canal auxiliar HTTP opcional
- `AAB`:
  - artefato oficial para Play
  - publicar em `Internal testing` ou `Internal App Sharing`

### Regra operacional

- link HTTP público não substitui o canal oficial da Play
- o principal canal de testes Android deve ser a Play Console
- o link HTTP pode existir como apoio tático

### Publicação futura

- primeiro publicar manualmente pela Play Console
- depois automatizar com `Google Play Developer API`
- não automatizar a publicação antes de estabilizar:
  - build runner
  - geração de AAB
  - versionamento Android
  - trilha de testes

### Próximos passos recomendados

1. desenhar e criar o `Outbroker Devel Runtime`
2. clonar `outbroker_prod -> outbroker_dev`
3. criar o `Shared Build Runner`
4. mudar o deploy do `develop` para artefato + VM própria
5. montar o fluxo de `APK` + `AAB`
6. configurar `Internal App Sharing`
7. configurar `Internal testing`

## Execução - Outbroker Devel Runtime

### Projeto GCP criado

- `projectId`: `outbroker-devel-runtime`
- nome: `Outbroker Devel Runtime`
- `projectNumber`: `555187828060`
- billing vinculado em `billingAccounts/011DFB-1DE71C-9CC210`

### APIs mínimas habilitadas

- `compute.googleapis.com`
- `logging.googleapis.com`
- `monitoring.googleapis.com`

### VM criada

- nome: `outbroker-devel`
- zona: `southamerica-east1-b`
- tipo: `e2-standard-2`
- disco: `pd-balanced 40 GB`
- IP interno: `10.158.0.2`
- IP externo: `35.198.60.131`
- status: `RUNNING`

### Observação operacional

- o GCP repetiu o aviso padrão de que o disco `40 GB` é maior que a imagem base `10 GB`
- no provisionamento será necessário confirmar o resize do root, como já foi feito nas outras VMs

### Próximos passos imediatos

1. provisionar a VM `outbroker-devel`
2. clonar `outbroker_prod -> outbroker_dev`
3. ajustar o `.env` do `devel` para `outbroker_dev`
4. preparar o corte do `develop` para a VM nova

### IP público

- IP atual do `outbroker-devel`: `35.198.60.131`
- o IP foi imediatamente reservado como estático:
  - recurso: `outbroker-devel-ip`
  - região: `southamerica-east1`

### Provisionamento do host

- SSH funcional via GCE
- usuário operacional criado:
  - `outbroker`
- pacotes base instalados:
  - `git`
  - `curl`
  - `build-essential`
  - `ca-certificates`
  - `nginx`
- `nginx` ativo no boot
- disco root confirmado com resize correto:
  - `40 GB`
  - cerca de `35 GB` livres

### Node e process manager

- `Node v24.14.1`
- `npm 11.11.0`
- `PM2 7.0.1`

Observação importante:

- no `outbroker-devel`, o `PM2` falhou quando a daemonização foi testada via `sudo -u outbroker`, acusando `EACCES` no binário do `node`
- o problema não ocorreu em login SSH real como `outbroker`
- com SSH direto do usuário operacional, o `PM2` daemonizou normalmente
- conclusão prática:
  - o runtime deve ser validado e operado por login direto do usuário `outbroker`
  - não confiar no teste de daemonização feito via `sudo -u` neste host

### Banco de desenvolvimento

- clone concluído:
  - `outbroker_prod -> outbroker_dev`
- estratégia usada:
  - `mongodump --archive --gzip`
  - `mongorestore --archive --gzip`
  - remapeando namespace de `outbroker_prod.*` para `outbroker_dev.*`
- resultado final:
  - `29485 document(s) restored successfully`
  - `0 document(s) failed to restore`

### `.env` do devel atual

- o `/home/outbroker/devel/.env` foi alterado para trocar:
  - `MONGODB_URI` de `outbroker_prod` para `outbroker_dev`
- backup criado antes da alteração:
  - `/home/outbroker/devel/.env.backup-before-outbroker-dev-20260604214324`
- depois da alteração:
  - `outbroker-devel` foi reiniciado no PM2 da VM compartilhada
- objetivo desta etapa:
  - remover imediatamente o risco do `develop` continuar escrevendo no banco de produção

### Chave Git do runtime novo

- chave pública gerada no usuário `outbroker` da VM nova:

```text
ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ8DH7MoCVz8o5p8PpwgRee9Q/sPSbPfphg81CcKp4Wi outbroker-devel-runtime
```

- fingerprint:

```text
SHA256:sGvRJg1mC9Pc+gqR2gZas/1N/e1PZOx54w7Zv3MfPAo
```

### Próximo bloqueio

- cadastrar a chave pública acima como `Deploy key` do repositório da `outbroker`
- depois disso:
  1. clonar a app na VM nova
  2. copiar o `.env` do `devel`
  3. subir o runtime novo
  4. preparar `nginx`, TLS e DNS de `devel.outbroker.app`

### Aplicação clonada no host novo

- caminho novo:
  - `/home/outbroker/outbroker-devel-app`
- repositório clonado com a chave dedicada do runtime
- branch:
  - `develop`
- commit no host novo:
  - `b16eaa08`

### Estratégia de subida sem build local

- como o novo padrão proíbe build em runtime, a VM nova não compilou a app
- em vez disso, o artefato já pronto do `devel` antigo foi transferido do host compartilhado para a VM nova
- a cópia preservou principalmente:
  - `.next`
  - `node_modules`
  - `.env`
  - arquivos de runtime já presentes no `devel`

Estado validado após a semeadura:

- `.next`: `224 MB`
- `node_modules`: `1.1 GB`
- `public`: `592 KB`
- `.env`: presente

### Runtime novo do devel

- processo iniciado no host novo:
  - `outbroker-devel`
- porta:
  - `1337`
- process manager:
  - `PM2`
- validação local:
  - `GET http://127.0.0.1:1337` respondeu `HTTP 200`
- memória observada logo após o boot:
  - cerca de `355 MB`

### Borda do devel

- o vhost do host antigo foi inspecionado e o bloco relevante para `devel.outbroker.app` foi mapeado
- upstream esperado:
  - `outbroker-dev -> 127.0.0.1:1337`
- `cloudflare.conf` também já foi extraído

### TLS e nginx concluídos

- novo `Cloudflare Origin Certificate` fornecido para `*.outbroker.app`
- certificado instalado em:
  - `/etc/nginx/ssl/outbroker.app/server.crt`
  - `/etc/nginx/ssl/outbroker.app/server.key`
- includes e vhost instalados:
  - `/etc/nginx/includes/cloudflare.conf`
  - `/etc/nginx/includes/upstreams.conf`
  - `/etc/nginx/vhosts/devel.outbroker.app.conf`
  - `/etc/nginx/conf.d/outbroker-vhosts.conf`

Validações locais concluídas:

- `nginx -t` => ok
- `http://127.0.0.1` com `Host: devel.outbroker.app` => `301` para `https`
- `https://127.0.0.1` com `Host: devel.outbroker.app` => `200`
- certificado servido localmente:
  - `issuer = CloudFlare Origin SSL Certificate Authority`
  - `subject = CloudFlare Origin Certificate`
  - `notBefore = Jun 5 00:55:00 2026 GMT`
  - `notAfter = Jun 1 00:55:00 2041 GMT`

### Firewall público

- regras criadas no projeto `outbroker-devel-runtime`:
  - `default-allow-http`
  - `default-allow-https`
- portas liberadas:
  - `80/tcp`
  - `443/tcp`

### Próximo passo

1. apontar o registro DNS de `devel.outbroker.app` para `35.198.60.131`
2. validar a borda pública
3. atualizar o workflow de deploy da branch `develop` para a VM nova

### DNS e borda pública

- `devel.outbroker.app` foi apontado para `35.198.60.131`
- validação pública concluída:
  - `GET https://devel.outbroker.app` => `HTTP 200`
  - borda servindo por Cloudflare normalmente

### Validação do login via Outlogin e Google

Validação pública do início do fluxo OAuth:

- `GET https://devel.outbroker.app/api/auth/outlogin/google/start` => `HTTP 307`
- redirecionamento foi para `https://accounts.google.com/o/oauth2/v2/auth`
- o `client_id` usado no redirect é o novo client web do projeto `outlogin-runtime`:
  - `603113878956-3e86sl3sjgdus4c70sfo7ccujqp5mvqj.apps.googleusercontent.com`
- o `redirect_uri` usado pelo Google continua correto:
  - `https://outlogin.app/api/auth/google/callback`
- o `state.returnTo` inclui retorno para o callback web do devel:
  - `https://devel.outbroker.app/auth/callback/outlogin`

Configuração de base confirmada:

- no `devel` novo:
  - `APP_URL=https://devel.outbroker.app`
  - `NEXTAUTH_URL=https://devel.outbroker.app`
  - `OUTLOGIN_URL=https://outlogin.app`
- no `outlogin` novo:
  - `APP_URL=https://outlogin.app`
  - `GOOGLE_ALLOWED_RETURN_ORIGINS=https://outbroker.app,https://devel.outbroker.app`

Leitura prática:

- o login web do `devel` via `outlogin` e Google está corretamente amarrado no nível de redirect e whitelist
- ainda vale uma validação manual final em navegador com conta real, mas a parte crítica de configuração já ficou provada

### Correção de imagens no devel

Problema observado após o primeiro login no `devel` novo:

- autenticação via conta comum e Google funcionou
- imagens não apareceram na interface

Causa encontrada:

- o `.env` do `devel` novo não tinha o bloco de variáveis de R2 e assinatura de mídia
- o `.env` histórico do `devel` antigo também não tinha essas variáveis
- para o novo `devel`, isso impedia a entrega correta das imagens armazenadas no bucket compartilhado

Correção aplicada:

- o bloco abaixo foi herdado do `.env` de produção para o `devel` novo:
  - `R2_ACCOUNT_ID`
  - `R2_ACCESS_KEY_ID`
  - `R2_SECRET_ACCESS_KEY`
  - `R2_PUBLIC_BUCKET`
  - `R2_PRIVATE_BUCKET`
  - `MEDIA_SIGNING_SECRET`
  - `R2_PUBLIC_BASE_URL`
  - `R2_PRIVATE_BASE_URL`
  - `PRIVATE_MEDIA_DELIVERY_MODE`
- depois disso:
  - `pm2 restart outbroker-devel --update-env`

Validação concluída:

- local na VM nova:
  - `GET http://127.0.0.1:1337/api/media/site/logo/4484f522-b332-4f96-9d81-6f9f4c647a2e.png` => `HTTP 200`
- público:
  - `GET https://devel.outbroker.app/api/media/site/logo/4484f522-b332-4f96-9d81-6f9f4c647a2e.png` => `HTTP 200`

Leitura prática:

- a falha de imagens no novo `devel` foi resolvida por alinhamento de variáveis de R2/mídia com a produção

## Android devel flavor

### Estrutura aplicada no repositório

- `productFlavors` Android criados:
  - `prod`
  - `devel`
- flavor `devel`:
  - `applicationIdSuffix = ".devel"`
  - package final:
    - `app.outbroker.mobile.devel`
  - nome visivel:
    - `OutBroker Devel`
  - alvo web:
    - `https://devel.outbroker.app`
- flavor `prod`:
  - package final:
    - `app.outbroker.mobile`
  - alvo web:
    - `https://outbroker.app`

### Scripts adicionados

- `mobile:sync:android:devel`
- `mobile:sync:android:prod`
- `mobile:apk:devel:debug`
- `mobile:apk:devel:release`
- `mobile:aab:devel:release`
- `mobile:apk:prod:debug`
- `mobile:apk:prod:release`
- `mobile:aab:prod:release`

### Validação técnica do Gradle

- tasks confirmadas:
  - `assembleDevelDebug`
  - `assembleDevelRelease`
  - `bundleDevelRelease`
  - `assembleProdDebug`
  - `assembleProdRelease`
  - `bundleProdRelease`

### Prova operacional do fluxo devel

Comando executado:

```bash
CAPACITOR_SERVER_URL=https://devel.outbroker.app npx cap sync android
./android/gradlew -p android assembleDevelDebug
```

Resultado:

- `cap sync android` => sucesso
- build Android => falhou no passo `processDevelDebugGoogleServices`

Erro real:

```text
No matching client found for package name 'app.outbroker.mobile.devel' in android/app/google-services.json
```

### Conclusão prática

O flavor `devel` já está corretamente preparado no código, mas o build ainda depende de provisionamento externo no Google/Firebase.

Pendências obrigatórias:

1. Firebase / google-services
   - adicionar um app Android com package:
     - `app.outbroker.mobile.devel`
   - baixar `google-services.json` atualizado contendo esse novo client

2. Google login nativo no Android
   - criar um OAuth client Android para:
     - `app.outbroker.mobile.devel`
   - usar o `SHA-1` da chave que vai assinar o APK/AAB do flavor `devel`

### Recomendação arquitetural

- para o flavor `devel`, usar uma chave de assinatura própria e estável
- evitar depender de debug keystore efêmero se a ideia é distribuir o app de teste para terceiros ou usar build runner
- isso facilita:
  - Firebase
  - Google login nativo
  - Internal App Sharing
  - Internal Testing na Play

### 2026-06-04 - Android devel flavor: firebase, oauth e build

- `android/app/google-services.json` foi atualizado para incluir ambos os apps Android do projeto Firebase `outbroker-push-notification`:
  - `app.outbroker.mobile`
  - `app.outbroker.mobile.devel`
- O novo OAuth client Android de devel criado no projeto `outlogin-runtime` foi:
  - `603113878956-edda5ls5h1je9qn0t43bocvt9eobnioh.apps.googleusercontent.com`
- O runtime novo do `outlogin` teve `GOOGLE_NATIVE_ALLOWED_CLIENT_IDS` atualizado para aceitar esse client Android de devel.
- O build Android passou a suportar `signingConfig` dedicada para o flavor `devel` via `android/keystore.devel.properties`.
- Foram adicionados:
  - `android/keystore.devel.properties.example`
  - ignore de `android/keystore.devel.properties`
- O problema inicial de `google-services.json` foi resolvido.
- O próximo erro encontrado foi ausência da dependência `@capacitor/push-notifications`, que foi adicionada ao projeto.
- Após adicionar a dependência, o comando abaixo passou com sucesso:
  - `CAPACITOR_SERVER_URL=https://devel.outbroker.app npx cap sync android`
  - `./android/gradlew -p android assembleDevelDebug`
- Observação importante:
  - o build de debug compila mesmo sem `android/keystore.devel.properties`, mas para o login Google nativo do app `devel` funcionar com o novo client Android e o `SHA-1` novo, o flavor `devel` precisa ser assinado com `android/outbroker-devel.keystore` por meio de `android/keystore.devel.properties`.

### 2026-06-04 - Correção do Google nativo no app devel

- O app Android `devel` falhava com `Google nativo indisponivel: configure NEXT_PUBLIC_GOOGLE_WEB_CLIENT_ID`.
- Causa validada:
  - o runtime web de `https://devel.outbroker.app` estava sem `NEXT_PUBLIC_GOOGLE_WEB_CLIENT_ID` e `NEXT_PUBLIC_GOOGLE_IOS_CLIENT_ID` no `.env` publicado.
  - como `src/lib/google-native-auth.ts` roda no client, isso exige rebuild do bundle web.
- Correção aplicada:
  - `NEXT_PUBLIC_GOOGLE_WEB_CLIENT_ID=603113878956-3e86sl3sjgdus4c70sfo7ccujqp5mvqj.apps.googleusercontent.com`
  - `NEXT_PUBLIC_GOOGLE_IOS_CLIENT_ID=647816570459-ofbatdj28n6g0jniprpnu5n4j13rneh9.apps.googleusercontent.com`
  - rebuild do `outbroker-devel` no host novo como exceção controlada de migração
- Evidência:
  - o bundle publicado passou a conter o novo web client do `outlogin-runtime`
  - grep positivo em `/home/outbroker/outbroker-devel-app/.next/static/chunks/...`
- Observação:
  - o app já instalado antes dessa correção pode manter cache do WebView; se o login Google continuar falhando, limpar dados do app ou reinstalar o APK `devel` antes de retestar.

## Shared Build Runner - estado alvo

### Objetivo

Centralizar builds web e mobile fora das VMs de runtime, evitando que deploys e compilacoes consumam CPU e memoria dos ambientes que servem trafego.

### Escopo inicial

Um unico runner compartilhado para:

- `outbroker` web
- `outbroker` Android via Capacitor
- `outsign`
- `outlogin`
- `outbroker-feed-bot`
- builds auxiliares de workers

### Configuracao recomendada inicial

- projeto GCP proprio: `shared-build-runner`
- VM: `build-runner-01`
- zona: `southamerica-east1-b`
- tipo: `e2-standard-4`
- RAM: `16 GB`
- disco: `pd-balanced 100 GB`
- SO: `Debian 13`
- usuario operacional: `builder`

### Ferramentas base

- `git`
- `curl`
- `build-essential`
- `zip` / `unzip`
- `jq`
- `Node 24.x`
- `npm`
- `pm2` nao e necessario para build
- `OpenJDK 21`
- `Android SDK Command Line Tools`
- `Gradle` (via wrapper dos projetos)
- `gh` opcional para automacoes GitHub

### Segredos esperados no runner

- chave SSH de leitura para cada repo privado usado no build
- `google-services.json` do app Android
- `GoogleService-Info.plist` quando o iOS entrar na fila
- `release-keystore.jks` de producao
- `outbroker-devel.keystore` de homologacao mobile
- respectivos arquivos `.properties` de assinatura
- eventuais credenciais de upload de artefatos

### Politica operacional

- runtime nunca roda `npm run build`
- runtime nunca gera APK/AAB
- GitHub Actions aciona o runner
- runner produz artefato imutavel
- deploy publica artefato no runtime alvo
- mobile publica artefato de download e, depois, track oficial da Play

### Artefatos previstos

#### Outbroker devel
- `.next` ou artefato web equivalente para `devel`
- `app-devel-release.apk`
- depois: `app-devel-release.aab`

#### Outbroker prod
- `.next` ou artefato web equivalente para `prod`
- `app-prod-release.aab`
- opcionalmente `app-prod-release.apk` para distribuicao tecnica controlada

### Distribuicao inicial dos APKs

Curto prazo:
- publicacao HTTP direta de APK em endpoint publico simples
- idealmente via bucket/edge dedicado, nao Google Drive

Medio prazo:
- `Internal App Sharing` e `Internal testing` na Play Console
- automacao de publicacao usando Google Play Developer API

### Ordem recomendada de implementacao

1. criar `shared-build-runner`
2. provisionar VM `build-runner-01`
3. instalar Node + JDK + Android SDK
4. levar segredos mobile para o runner
5. automatizar build do `app-devel-release.apk`
6. publicar APK de devel em URL HTTP direta
7. automatizar deploy web de `develop` para `outbroker-devel`
8. depois repetir o padrao para `main`/producao

### Decisao importante

Mesmo com a excecao controlada feita hoje no `outbroker-devel` para corrigir o bundle web do login Google nativo, a diretriz oficial permanece:

- builds fora do runtime
- VMs de app servem trafego
- VM de build compila

### 2026-06-04 - Tentativa de criacao do Shared Build Runner

- Projeto criado com sucesso:
  - `projectId=shared-build-runner`
  - `projectNumber=786136253211`
  - `name=Shared Build Runner`
  - `lifecycleState=ACTIVE`
- Bloqueio encontrado:
  - falha ao vincular billing em `011DFB-1DE71C-9CC210`
  - erro: `Cloud billing quota exceeded`
- Estado atual do projeto:
  - `billingEnabled=false`
  - nenhuma VM criada ainda
- Consequencia:
  - a criacao da VM `build-runner-01` ficou bloqueada por quota da conta de faturamento, nao por configuracao do projeto.

### 2026-06-05 - Shared Build Runner liberado e provisionado

- Nova conta de faturamento criada:
  - `Outbroker Infra Expansion`
  - `billingAccountId=018A15-2644C4-E90CBD`
- Projeto `shared-build-runner` vinculado com sucesso a nova billing account:
  - `billingEnabled=true`
- APIs minimas habilitadas:
  - `compute.googleapis.com`
  - `logging.googleapis.com`
  - `monitoring.googleapis.com`
- Infra criada:
  - IP estatico `build-runner-01-ip`
  - endereco externo `35.199.83.92`
  - VM `build-runner-01`
  - zona `southamerica-east1-b`
  - maquina `e2-standard-4`
  - disco root `pd-balanced 100 GB`
  - status `RUNNING`
- Provisionamento base concluido:
  - usuario operacional `builder`
  - `Node v24.14.1`
  - `npm 11.11.0`
  - `OpenJDK 21.0.11`
  - Android SDK command-line tools
  - `platform-tools`
  - `platforms;android-35`
  - `build-tools;35.0.0`
- Observacao operacional:
  - o `sdkmanager` responde normalmente quando executado com `HOME=/home/builder` e `PATH` explicito do Android SDK.
  - houve warning de shell tentando resolver `/home/filimm` durante validacoes remotas, mas a instalacao do SDK e a validacao final de `node`, `npm`, `java` e `sdkmanager` passaram.

### 2026-06-05 - Fluxo final de deploy da Outbroker

#### Estado consolidado

- `develop -> devel`:
  - build ocorre no `build-runner`
  - gera runtime artifact `.tgz`
  - deploy publica o artifact na VM `outbroker-devel`
- `main -> prod`:
  - nao roda novo build
  - promove o mesmo artifact aprovado no `devel`
  - deploy publica o artifact na VM `outbroker-prod`

#### Regra oficial

- producao da `outbroker` nao deve rebuildar depois do merge na `main`
- o artifact testado no `devel` e o mesmo artifact promovido para `prod`
- variacoes entre `devel` e `prod` devem ficar restritas a:
  - `.env`
  - destino do deploy
  - detalhes de processo/porta do host

#### Hosts e papeis

- `build-runner`
  - host: `35.199.83.92`
  - usuario: `builder`
  - funcao: build web/mobile e promocao de artifacts
- `outbroker-devel`
  - host: `35.198.60.131`
  - usuario: `outbroker`
  - porta SSH: `22`
  - runtime: `devel.outbroker.app`
  - app dir: `/home/outbroker/outbroker-devel-app`
- `outbroker-prod`
  - host: `35.199.94.141`
  - usuario: `outbroker`
  - porta SSH: `32800`
  - runtime: `outbroker.app`
  - app dir base: `/home/outbroker/prod`

#### Fluxo de develop para devel

- workflow: `.github/workflows/deploy.yml`
- o GitHub Actions entra no `build-runner`
- o `build-runner`:
  - faz checkout do commit alvo
  - copia `.env` de devel de `/opt/outbroker/secrets/outbroker-devel.env`
  - restaura segredos mobile
  - roda `npm ci`
  - roda `npm run build`
  - empacota runtime artifact em `/home/builder/artifacts`
- depois o `build-runner` publica esse artifact na VM `outbroker-devel`

Artifact gerado no padrao:

- `outbroker-devel-runtime-<run_id>-<sha>.tgz`

#### Fluxo de main para prod

- workflow: `.github/workflows/deploy-prod.yml`
- o merge na `main` nao recompila
- o workflow resolve o commit de origem aprovado na `develop`
- o `build-runner` procura o artifact correspondente em:
  - `/home/builder/artifacts/outbroker-devel-runtime-*-<source_sha>.tgz`
- esse artifact e promovido para a VM `outbroker-prod`

#### Scripts relevantes

- deploy de devel:
  - `deploy-devel.sh`
  - `scripts/deploy-from-build-runner.sh`
- promocao para prod:
  - `deploy-prod-runtime.sh`
  - `scripts/promote-from-build-runner.sh`
- empacotamento de runtime:
  - `scripts/package-runtime-artifact.sh`

#### Chaves e saltos SSH

##### GitHub Actions -> build-runner

- secret usado:
  - `BUILD_RUNNER_SSH_KEY`
- usuario:
  - `builder`
- host:
  - `35.199.83.92`
- porta:
  - `22`

##### build-runner -> outbroker-devel

- chave local no runner:
  - `/home/builder/.ssh/outbroker_devel`
- usuario:
  - `outbroker`
- host:
  - `35.198.60.131`
- porta:
  - `22`

##### build-runner -> outbroker-prod

- chave local no runner:
  - `/home/builder/.ssh/outbroker_prod`
- usuario:
  - `outbroker`
- host:
  - `35.199.94.141`
- porta:
  - `32800`

#### Secrets esperados no repositorio da Outbroker

- `BUILD_RUNNER_HOST=35.199.83.92`
- `BUILD_RUNNER_USER=builder`
- `BUILD_RUNNER_PORT=22`
- `BUILD_RUNNER_SSH_KEY=<chave privada do salto GitHub -> build-runner>`
- `PROD_DEPLOY_HOST=35.199.94.141`
- `PROD_DEPLOY_USER=outbroker`
- `PROD_DEPLOY_PORT=32800`

#### Acessos SSH locais do Filipe

Aliases configurados em `~/.ssh/config`:

- `ssh build-runner`
- `ssh outbroker-devel`
- `ssh outbroker-prod`
- `ssh outlogin-prod`
- `ssh outsign-prod`
- `ssh outbot-prod`

#### Validacoes operacionais fechadas

- `develop -> devel` passou ponta a ponta com build fora do runtime
- `main -> prod` passou via promocao manual do artifact aprovado
- o fix final de `deploy-prod-runtime.sh` foi:
  - iniciar o PM2 a partir do diretorio da release
  - isso evitou erro de `Script not found: .../node_modules/next/dist/bin/next`

#### Pendencias restantes

- acompanhar o proximo deploy automatico de `prod` ja usando o script corrigido
- replicar o modelo `build fora do runtime` para:
  - `outsign`
  - `outlogin`
- criar uma VM dedicada para worker de upload e normalizacao de arquivos de imagem e video
  - objetivo: tirar processamento de midia do runtime principal da `outbroker`
  - escopo esperado: uploads, conversoes, normalizacao e eventuais rotinas pesadas de imagem/video
  - recorte oficial definido em `2026-06-05`:
    - escopo v1: `outshorts`, `stories`, `avatars`, `profile-banner`, `posts`, `interests` e `ads`
    - fora da v1: `outbot`, `xml_import`, anexos privados, tickets, docs, reports e uploads administrativos
    - fluxo alvo: app cria `MediaJob`, frontend envia bruto direto para o worker, worker guarda staging efemero local, normaliza e publica apenas o artefato final no Cloudflare R2
    - formatos finais de imagem da v1:
      - `jpeg` como padrao
      - `png` quando houver transparencia real
      - `webp` fora da v1 como variante futura opcional
    - ordem recomendada de migracao:
      - `avatars`
      - `profile-banner`
      - `outshorts`
      - `stories`
      - `posts`
      - `interests`
      - `ads`
  - documento tecnico versionado no repo:
    - `docs/architecture/worker-midias-v1.md`
  - progresso registrado em `2026-06-08`:
    - fundacao de `MediaJob` e rotas da app ja criada na `outbroker`
    - runtime extraido para repo dedicado `/home/filimm/projetos/outbroker-media-worker`
    - repo GitHub criado em `outbrokerapp/outbroker-media-worker`
    - pipeline inicial de imagem no worker ja implementa:
      - ingestao
      - staging local
      - deteccao de tipo real
      - normalizacao para `jpeg` ou `png`
      - publicacao final no R2
      - disparo automatico do processamento apos o `ingest`
    - piloto inicial de `avatars` ja conectado na `outbroker`
    - validacao local ponta a ponta dos pilotos de `avatars` e `profile-banner` concluida em `2026-06-08`
      - `outbroker` em `:3000`
      - `outlogin` em `:3001`
      - worker em `:4304`
      - criacao de job, upload direto, processamento automatico e finalizacao no perfil confirmados
    - validacao local ponta a ponta de `posts` concluida em `2026-06-08`
      - upload direto do navegador para o worker exigiu correcao de `CORS` e `preflight` no `outbroker-media-worker`
      - `MediaJob` de `posts` usa `entityId: \"temp\"`
      - a app promove o arquivo de `users/{brokerId}/posts/temp/...` para `users/{brokerId}/posts/{postId}/...` ao criar o post
      - criacao real de post com `mediaJobIds` confirmada localmente
    - ainda faltam:
      - pipeline de video
      - promocao do piloto para os proximos contextos
- migrar o Google OAuth da producao da `outbroker` para o projeto GCP `Outbroker Prod`
  - objetivo: eliminar a dependencia residual do projeto antigo `Outbroker Waitlist`
  - incluir revisao de client IDs, secrets, origens autorizadas e callbacks da producao
- automatizar publicacao mobile (`APK` / `AAB`) no `build-runner`
- configurar canal oficial de testes Android na Play Console
