# MUVE

MUVE é uma plataforma voltada para conectar artistas e músicos a contratantes de eventos. O sistema propõe um ambiente digital em que profissionais da música podem divulgar seu perfil e se candidatar a oportunidades, enquanto contratantes podem criar eventos e encontrar artistas adequados para suas demandas.

## Descrição do projeto

O projeto MUVE foi desenvolvido com o objetivo de apoiar a contratação de artistas para eventos, aproximando dois públicos que normalmente dependem de indicações informais, contatos dispersos em redes sociais ou negociações sem centralização de informações.

Para artistas, a aplicação oferece uma forma de apresentar perfil, estilos musicais, disponibilidade, faixa de cachê e inscrições realizadas em eventos. Para contratantes, o sistema permite publicar oportunidades de apresentação e visualizar artistas cadastrados, facilitando a busca por profissionais compatíveis com o tipo de evento.

No contexto acadêmico, o MUVE demonstra uma aplicação prática para o mercado musical e de eventos, com separação entre front-end, back-end e banco de dados, além de integração real entre a interface Flutter e uma API Node.js com persistência em PostgreSQL.

## Funcionalidades principais

- **Cadastro de usuários**: permite criar contas com papéis de artista, contratante ou perfil híbrido, com validações de dados como e-mail, senha, CPF, CNPJ, cidade e UF.
- **Login**: autentica o usuário por e-mail e senha, utilizando senha criptografada no back-end.
- **Perfil do artista**: exibe nome, localização, bio, estilos musicais, faixa de cachê, disponibilidade para contratação, links sociais e eventos inscritos.
- **Perfil do contratante**: o usuário com papel de contratante utiliza o perfil geral da aplicação e pode publicar eventos. Não há, no estado atual do código, um painel administrativo separado apenas para contratantes.
- **Listagem de artistas**: busca artistas cadastrados no banco, com filtros por texto, gênero musical, cidade e disponibilidade.
- **Criação e listagem de eventos**: contratantes autenticados podem criar eventos; a tela de eventos lista oportunidades disponíveis e permite filtros por gênero e status de contratação.
- **Inscrição de artistas em eventos**: artistas autenticados podem se candidatar a eventos que estejam recebendo inscrições.
- **Eventos inscritos no perfil**: artistas conseguem acompanhar, no próprio perfil, os eventos aos quais se candidataram e o status de cada inscrição.
- **Atualização de perfil**: dados de perfil, gêneros, faixa de cachê, links sociais e disponibilidade são atualizados por meio da API.
- **Chat local**: existe uma funcionalidade de conversa entre usuários no front-end, mantida em memória durante a execução da aplicação. No estado atual, as mensagens não são persistidas no banco de dados.
- **Estados de interface**: telas de listagem utilizam estados de carregamento, erro e vazio para evitar que a interface quebre quando a API retorna falha, lista vazia ou dados incompletos.
- **Integração com banco de dados**: usuários, eventos e inscrições são persistidos em PostgreSQL por meio do Prisma.

## Tecnologias utilizadas

### Front-end

- Flutter
- Dart
- Material 3
- `http`
- `intl`
- `google_fonts`
- `animate_do`
- `url_launcher`
- `cupertino_icons`
- `flutter_lints`

### Back-end

- Node.js
- TypeScript
- Express
- Prisma ORM
- PostgreSQL
- `bcryptjs`
- `cors`
- `dotenv`
- `ts-node-dev`

## Estrutura do projeto

```text
muve2026/
|-- muve/                 # Aplicação Flutter
|   |-- lib/
|   |   |-- constants/    # Constantes compartilhadas, como gêneros musicais
|   |   |-- models/       # Modelos usados no front-end
|   |   |-- screens/      # Telas da aplicação
|   |   |-- services/     # Comunicação HTTP e serviços locais
|   |   |-- theme/        # Cores, estilos e tema visual
|   |   `-- widgets/      # Componentes reutilizáveis
|   |-- assets/           # Imagens e recursos visuais
|   |-- test/             # Testes Flutter
|   `-- pubspec.yaml      # Dependências e configuração Flutter
|
|-- muve-backend/         # API Node.js
|   |-- prisma/
|   |   |-- schema.prisma # Modelagem do banco
|   |   `-- migrations/   # Histórico de migrations
|   |-- src/
|   |   |-- index.ts      # Entrada da API e registro das rotas
|   |   |-- login.ts      # Cadastro, login e listagem controlada de usuários
|   |   |-- events_contratante.ts # Eventos e inscrições
|   |   |-- artists.ts    # Listagem de artistas e inscrições do artista
|   |   |-- users.ts      # Atualização do perfil autenticado
|   |   |-- auth_user.ts  # Leitura do usuário autenticado por X-User-Id
|   |   |-- prisma.ts     # Cliente Prisma compartilhado
|   |   `-- api_response.ts # Padronização de erros
|   |-- package.json      # Dependências e scripts da API
|   `-- tsconfig.json     # Configuração TypeScript
|
`-- work/                 # Arquivos auxiliares de trabalho local
```

## Banco de dados

O MUVE utiliza PostgreSQL como banco de dados relacional e Prisma como ORM. O Prisma centraliza a definição dos modelos no arquivo `muve-backend/prisma/schema.prisma` e mantém o histórico de evolução do banco por meio de migrations.

Os principais modelos existentes são:

- **Usuario**: representa os usuários cadastrados na plataforma. Armazena dados de identificação, autenticação, perfil, localização, papéis no sistema, gêneros musicais, links sociais, faixa de cachê e disponibilidade.
- **Evento**: representa eventos criados por contratantes. Inclui título, descrição, local, cidade, estado, data, hora, categoria, cachê estimado, status de contratação e relação com o contratante.
- **EventApplication**: representa a inscrição de um artista em um evento. Relaciona artista e evento, possui status da candidatura e impede inscrições duplicadas do mesmo artista no mesmo evento.

Também existem enums para apoiar as regras do sistema:

- **TipoPessoa**: `PF` ou `PJ`.
- **TipoConta**: `ARTISTA`, `CONTRATANTE` ou `ADMIN`.
- **ApplicationStatus**: `PENDING`, `ACCEPTED`, `REJECTED` ou `CANCELED`.

## Fluxo básico do sistema

1. O usuário acessa a aplicação Flutter.
2. O usuário realiza cadastro informando seus dados e escolhendo seu papel no sistema.
3. O usuário faz login com e-mail e senha.
4. Caso seja contratante, pode criar eventos com informações como título, local, data, hora, categoria musical e cachê estimado.
5. Artistas visualizam os eventos publicados na tela de eventos.
6. Artistas podem se candidatar a eventos disponíveis.
7. O perfil do artista exibe as inscrições realizadas e seus respectivos status.
8. A tela de artistas permite que contratantes encontrem profissionais por busca, gênero, cidade e disponibilidade.
9. A edição de perfil permite atualizar informações relevantes para a apresentação profissional do usuário.

## Como executar o projeto localmente

### Pré-requisitos

- Node.js instalado.
- Flutter SDK instalado.
- PostgreSQL instalado e em execução.
- Um banco PostgreSQL criado para o projeto, por exemplo `MuveDB`.

### Configurar o back-end

Acesse a pasta da API:

```bash
cd muve-backend
```

Instale as dependências:

```bash
npm install
```

Crie um arquivo `.env` com base no `.env.example`. Não utilize credenciais reais em documentação ou arquivos públicos. Um exemplo seguro de formato é:

```env
DATABASE_URL="postgresql://USUARIO:SENHA@localhost:5432/MuveDB?schema=public"
PORT=3000
CORS_ORIGIN=
```

Execute as migrations do Prisma:

```bash
npm run prisma:mig
```

Gere o Prisma Client, se necessário:

```bash
npm run prisma:gen
```

Inicie a API:

```bash
npm run dev
```

Por padrão, a API utiliza a porta `3000`.

### Configurar o front-end

Acesse a pasta Flutter:

```bash
cd muve
```

Instale as dependências:

```bash
flutter pub get
```

Execute no navegador apontando para a API local:

```bash
flutter run -d chrome --dart-define=MUVE_API_BASE_URL=http://localhost:3000
```

Também é possível executar em outros dispositivos suportados pelo Flutter. Em emuladores Android, a configuração do front-end já considera `http://10.0.2.2:3000` como endereço padrão da API.

## Variáveis de ambiente

### Back-end

- `DATABASE_URL`: string de conexão com o PostgreSQL utilizada pelo Prisma.
- `PORT`: porta em que a API será executada. O padrão é `3000`.
- `CORS_ORIGIN`: lista opcional de origens permitidas para CORS, separadas por vírgula. Em desenvolvimento, a API já aceita `localhost`, `127.0.0.1` e `::1`.

### Front-end

- `MUVE_API_BASE_URL`: endereço base da API usado pelo Flutter em tempo de execução. Pode ser informado com `--dart-define`.

## Observações para apresentação acadêmica

O MUVE apresenta pontos relevantes para uma banca de TCC:

- Separação clara entre front-end Flutter e back-end Node.js.
- Uso de banco de dados real com PostgreSQL e Prisma.
- Organização por camadas, com telas, serviços, modelos e componentes reutilizáveis no front-end.
- API com rotas separadas para autenticação, artistas, eventos, inscrições e atualização de perfil.
- Regras de negócio aplicadas no back-end, como autorização por papel, validação de dados e bloqueio de inscrições duplicadas.
- Aplicação voltada a um problema prático do mercado musical e de eventos.
- Interface com estados de carregamento, erro e vazio, melhorando a experiência do usuário e a estabilidade visual para demonstração.
