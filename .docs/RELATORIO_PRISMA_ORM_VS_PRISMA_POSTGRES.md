# Relatorio de decisao: Prisma ORM vs Prisma Postgres no MUVE

Data: 2026-06-09

## Resumo executivo

A decisao nao deve ser tratada como "Prisma ORM ou Prisma Postgres", porque eles resolvem camadas diferentes:

- Prisma ORM e a camada de acesso a dados usada no codigo Node.js/TypeScript: schema, migrations, Prisma Client tipado e Prisma Studio.
- Prisma Postgres e um servico gerenciado de banco PostgreSQL, isto e, uma opcao de hospedagem/infraestrutura de banco.

Recomendacao para o MUVE:

1. Manter Prisma ORM como padrao do backend.
2. Nao migrar imediatamente para Prisma Postgres apenas por causa do ORM.
3. Decidir a hospedagem do PostgreSQL separadamente, comparando custo, operacao e ambiente de deploy.
4. Considerar Prisma Postgres se a equipe quiser um PostgreSQL gerenciado com setup rapido, connection pooling, query insights e menor trabalho operacional.
5. Se a equipe ja tem PostgreSQL local/cloud bem definido, continuar com PostgreSQL convencional + Prisma ORM e suficiente para o estado atual do projeto.

Em termos praticos: o MUVE ja esta usando Prisma ORM. Prisma Postgres seria uma troca de onde o banco roda, nao uma troca da camada de codigo.

## Fontes consultadas

- Prisma ORM docs: https://www.prisma.io/docs/orm
- Prisma Postgres docs: https://www.prisma.io/docs/postgres
- Prisma Postgres connection pooling: https://www.prisma.io/docs/postgres/database/connection-pooling
- Prisma pricing: https://www.prisma.io/pricing

## Estado atual do projeto

Estrutura relevante:

- Frontend: Flutter em `muve`.
- Backend: Express + TypeScript em `muve-backend`.
- Banco atual esperado: PostgreSQL local em `localhost:5432`, database `MuveDB`.
- Prisma ORM atual:
  - `prisma`: `6.16.2`
  - `@prisma/client`: `6.16.2`
  - `prisma validate`: OK
  - `prisma migrate status`: 8 migrations encontradas, banco atualizado

Comandos executados:

```bash
npx prisma validate
npx prisma migrate status
npx prisma -v
```

Resultado relevante:

```txt
The schema at prisma\schema.prisma is valid
Database schema is up to date!
```

## O que o Prisma ORM esta fazendo hoje

O arquivo `muve-backend/prisma/schema.prisma` define:

- `Usuario`
- `Evento`
- `EventApplication`
- `TipoPessoa`
- `TipoConta`
- `ApplicationStatus`

As relacoes principais estao coerentes:

- Um contratante pode criar varios eventos.
- Um artista pode se inscrever em varios eventos.
- Um evento pode receber varias inscricoes.
- Um artista nao consegue se inscrever duas vezes no mesmo evento por causa de `@@unique([artistId, eventId])`.

O backend usa o Prisma Client em rotas como:

- cadastro e login de usuarios;
- listagem de artistas;
- listagem/criacao/exclusao de eventos;
- inscricao de artista em evento;
- healthcheck com consulta SQL simples.

Isso significa que o projeto ja esta comprometido tecnicamente com Prisma ORM. Remover Prisma ORM agora exigiria reescrever boa parte do acesso a dados.

## Diferenca real entre as opcoes

| Item | Prisma ORM | Prisma Postgres |
| --- | --- | --- |
| O que e | ORM/toolkit para acesso a banco no backend | Servico gerenciado de PostgreSQL |
| Substitui o PostgreSQL? | Nao | Sim, como provedor/hospedagem de banco |
| Substitui o codigo de rotas? | Nao, ele e usado pelas rotas | Nao |
| Ajuda com type safety? | Sim | Nao diretamente; isso vem do ORM |
| Ajuda com migrations? | Sim | O banco recebe as migrations, mas quem gera/aplica e o Prisma ORM/CLI |
| Ajuda com infraestrutura? | Pouco | Sim |
| Vendor lock-in | Baixo/moderado no codigo Prisma | Maior na infraestrutura e cobranca |
| Custo | Biblioteca open-source; custo vem do banco escolhido | Custo de servico gerenciado/usage-based |

## Opcao A: Prisma ORM + PostgreSQL convencional

Esta e a opcao que o MUVE ja usa.

Pode ser:

- PostgreSQL local em desenvolvimento;
- PostgreSQL em VM;
- PostgreSQL gerenciado por outro provedor;
- PostgreSQL interno da organizacao.

Vantagens:

- Menor mudanca no projeto.
- Mantem controle sobre provedor de banco.
- Evita decisao precoce de infraestrutura.
- Boa previsibilidade se a equipe ja conhece PostgreSQL.
- Prisma ORM ja esta validado e sincronizado com o banco local.

Desvantagens:

- A equipe precisa cuidar de backup, monitoramento, escalabilidade, conexoes e deploy do banco.
- Em ambiente serverless, pode haver preocupacao com conexoes se nao houver pooler.
- Menos recursos integrados de observabilidade se o provedor de banco nao oferecer.

Melhor escolha se:

- O projeto ainda esta em fase de desenvolvimento/local.
- A equipe ainda nao decidiu infraestrutura final.
- Ja existe um banco PostgreSQL confiavel.
- O custo precisa ser previsivel desde cedo.

## Opcao B: Prisma ORM + Prisma Postgres

Esta opcao mantem Prisma ORM no codigo, mas troca a hospedagem do banco para Prisma Postgres.

Segundo a documentacao oficial, Prisma Postgres e um PostgreSQL gerenciado pensado para desenvolvimento moderno, com conexao via Prisma ORM, clientes PostgreSQL e runtime serverless/edge. A propria documentacao lista Prisma ORM como caminho recomendado para migrations e queries tipadas.

Vantagens:

- Banco gerenciado com setup rapido.
- Connection pooling gerenciado.
- Query insights e ferramentas integradas.
- Bom encaixe com apps modernos/serverless.
- Menos trabalho operacional para a equipe.

Desvantagens:

- Cobranca usage-based precisa ser acompanhada.
- Maior dependencia da plataforma Prisma.
- A equipe precisa entender diferenca entre connection string pooled e direct.
- Migrations/admin devem usar conexao direta, enquanto trafego da aplicacao deve usar pool.

Melhor escolha se:

- A equipe quer acelerar deploy sem administrar PostgreSQL.
- O backend sera publicado em ambiente com alta concorrencia ou serverless.
- A equipe quer pooling e observabilidade sem configurar infraestrutura adicional.
- O custo estimado cabe no plano do projeto.

## Ponto critico: pooled vs direct no Prisma Postgres

Se o MUVE usar Prisma Postgres, sera importante separar:

- URL pooled: trafego normal da API.
- URL direct: migrations, introspection, Prisma Studio, dump/restore e tarefas administrativas.

A documentacao da Prisma orienta usar pooled connections para trafego de aplicacao e direct connections para migrations/admin tooling. Isso deve entrar no `.env` e no processo de deploy.

Exemplo conceitual:

```env
DATABASE_URL="postgresql://...pooled..."
DIRECT_URL="postgresql://...direct..."
```

E o schema poderia evoluir para:

```prisma
datasource db {
  provider  = "postgresql"
  url       = env("DATABASE_URL")
  directUrl = env("DIRECT_URL")
}
```

Observacao: isso e uma proposta para caso Prisma Postgres seja adotado. Nao e obrigatorio para o estado local atual.

## Riscos tecnicos atuais antes de producao

Estes pontos valem independentemente de usar PostgreSQL convencional ou Prisma Postgres.

1. Instancias duplicadas de Prisma Client

Hoje varios arquivos criam `new PrismaClient()` diretamente. Em producao, especialmente serverless, o recomendado e centralizar o client em um unico modulo, por exemplo `src/prisma.ts`.

Risco: excesso de conexoes, dificil controle de lifecycle e comportamento inconsistente em hot reload/dev.

Recomendacao:

```ts
// src/prisma.ts
import { PrismaClient } from "@prisma/client";

export const prisma = new PrismaClient();
```

2. `Evento.data` esta como `String`

Hoje a data do evento esta como string no formato `DD/MM/AAAA`.

Vantagem: simples para a UI atual.

Risco: ordenacao, filtros por periodo e queries futuras ficam mais dificeis e menos confiaveis.

Recomendacao futura: considerar `DateTime` para data real e manter `hora` separada ou consolidar em `startsAt DateTime`.

3. Migrations antigas com operacoes destrutivas

Ha migrations antigas que derrubam tabelas para renomear estruturas (`usuario` para `usuarios`, `Evento` para `evento`). No banco atual esta tudo sincronizado, mas em ambientes com dados reais isso exige backup e cuidado.

Recomendacao: antes de aplicar em qualquer banco com dados importantes, rodar backup e revisar migrations.

4. Falta script de producao para migrations

O `package.json` tem:

```json
"prisma:mig": "prisma migrate dev"
```

Para producao, o correto costuma ser um script separado com `prisma migrate deploy`.

Recomendacao:

```json
"prisma:deploy": "prisma migrate deploy"
```

5. Autenticacao ainda simplificada

O backend usa `X-User-Id` em algumas rotas. Isso ajuda no prototipo, mas nao e autenticacao real.

Recomendacao: antes de producao, implementar JWT/sessao e associar as operacoes ao usuario autenticado.

## Matriz de decisao para a equipe

| Criterio | Peso sugerido | Prisma ORM + Postgres convencional | Prisma ORM + Prisma Postgres |
| --- | ---: | --- | --- |
| Menor mudanca agora | Alto | Melhor | Medio |
| Velocidade para publicar MVP | Alto | Boa | Melhor |
| Controle de infraestrutura | Medio | Melhor | Menor |
| Menor operacao de banco | Alto | Menor | Melhor |
| Custo previsivel | Medio | Melhor se infra ja existe | Depende do uso |
| Serverless/alta concorrencia | Medio | Exige pooler/provedor adequado | Melhor encaixe |
| Independencia de fornecedor | Medio | Melhor | Menor |
| Compatibilidade com codigo atual | Alto | Excelente | Excelente, mantendo ORM |

## Recomendacao final

Para o MUVE, a recomendacao tecnica e:

1. Continuar com Prisma ORM.
2. Tratar Prisma Postgres como decisao de hospedagem, nao como substituto do ORM.
3. Neste momento, manter PostgreSQL convencional/local enquanto o produto e o modelo de deploy ainda estao sendo estabilizados.
4. Preparar o backend para producao com:
   - Prisma Client centralizado;
   - script `prisma migrate deploy`;
   - revisao do campo de data de evento;
   - processo de backup antes de migrations;
   - autenticacao real.
5. Reavaliar Prisma Postgres quando a equipe decidir onde o backend sera publicado e tiver uma estimativa minima de trafego/custo.

Conclusao curta para decisao:

> O projeto deve ir de Prisma ORM. Prisma Postgres pode ser adotado depois como banco gerenciado, mas nao substitui o Prisma ORM. Para a fase atual, a escolha mais segura e manter Prisma ORM + PostgreSQL convencional, deixando Prisma Postgres como opcao de infraestrutura para deploy/MVP se a equipe quiser reduzir trabalho operacional.

## Proximo plano recomendado

1. Criar `src/prisma.ts` e substituir `new PrismaClient()` espalhado.
2. Adicionar `prisma:deploy` no `package.json`.
3. Criar checklist de deploy com `.env`, `DATABASE_URL`, migrations e seed.
4. Definir se producao sera:
   - PostgreSQL convencional/ja existente; ou
   - Prisma Postgres com URLs pooled/direct.
5. Antes de producao, decidir se `Evento.data` continua `String` ou vira `DateTime`.

