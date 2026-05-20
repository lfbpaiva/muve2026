# Muve App — Design Spec Visual (9 Telas)

## 🎨 Identidade Visual Global

- **Nome do app:** Muve — "Seu movimento começa aqui"
- **Paleta principal:**
  - Roxo/violeta primário: `#7B4FD9` (aprox.)
  - Gradiente de fundo (tela de login): roxo escuro → rosa/magenta no canto inferior
  - Branco/cinza claro para fundos internos: `#F5F5F7`
  - Texto escuro: `#1A1A1A`
  - Verde de status: `#22C55E`
  - Vermelho de ação destrutiva: `#EF4444`
- **Tipografia:** Sans-serif moderna, peso variado (bold para títulos, regular para corpo)
- **Ícones:** Estilo outline fino, com preenchimento apenas no item ativo da navegação
- **Border radius:** Arredondado generoso (~12–16px nos cards, ~8px nos inputs)
- **Bottom navigation:** 3 itens — Eventos · Home · Perfil — ícone ativo em roxo com fundo destacado

---

## Tela 1 — Login (`/login`)

**Fundo:** Gradiente diagonal de roxo escuro (`#3B1F8C`) para magenta/rosa (`#C850C0`) — cobre toda a tela.

**Conteúdo:**
- Topo: ícone de onda + logo "Muve" em branco, subtitle "Seu movimento começa aqui" em branco suave
- Card branco centralizado com cantos arredondados (~20px), padding generoso
  - Título: **"Bem-vindo de volta"** (bold, ~22px)
  - Subtítulo: "Faça login para continuar" (cinza médio, ~14px)
  - Input **Email** com ícone de envelope à esquerda, fundo cinza claro, borda sutil
  - Input **Senha** com ícone de cadeado à esquerda + ícone de olho à direita (toggle visibilidade)
  - Link **"Esqueceu a senha?"** alinhado à direita, em roxo
  - Botão primário **"Entrar"** — roxo sólido, largura total, texto branco, border-radius ~10px
  - Divisor **"ou continue com"** com linhas horizontais
  - Botão **"Entrar com Google"** — branco com borda, ícone Google colorido à esquerda
  - Botão **"Entrar com Instagram"** — branco com borda, ícone Instagram à esquerda
  - Rodapé: "Ainda não tenho cadastro" + link roxo **"Criar conta"**
- Footer fixo: texto de Termos de Uso e Política de Privacidade, pequeno, centralizado

---

## Tela 2 — Cadastro (`/register`)

**Fundo:** Branco/cinza clarissimo. Topo com logo "Muve" em roxo + ícone de nota musical, subtitle "Crie sua conta e comece a se conectar".

**Formulário (sem card, layout direto na tela):**
- Campo **Nome Completo** — ícone de pessoa, placeholder cinza
- Campo **Email** — ícone de envelope
- Campo **Senha** — ícone de cadeado + toggle de visibilidade
- Campo **Nome de usuário** — ícone `@`, placeholder `ex: felippe_paiva`

**Seção "Como você quer usar o Muve?"** (texto menor abaixo: "Você poderá alterar isso depois")

Três opções de seleção em formato de **cards verticais com borda**:
| Opção | Ícone | Descrição | Estado |
|---|---|---|---|
| Somente Artista | 🎤 roxo | Mostre seu talento e seja encontrado | **Selecionado** (bullet roxo à direita) |
| Somente Contratante | 💼 cinza | Encontre artistas para seus eventos | Não selecionado |
| Artista e Contratante | 🎭 cinza | Perfil híbrido com acesso completo | Não selecionado |

- Botão **"Cadastrar →"** — roxo sólido, largura total
- Link no rodapé: "Já tem conta? **Fazer login**" (roxo)

---

## Tela 3 — Home (`/home`)

**Header:**
- Saudação: **"Olá, João! 🎵"** (bold)
- Subtítulo: "Encontre músicos e eventos perto de você"
- Ícone de sino (notificação) com badge no canto superior direito

**Busca:**
- Barra de busca com placeholder "Buscar @user, cidade ou estilo..." + ícone de filtro (sliders) à direita, fundo cinza arredondado

**Filtros de gênero (chips/pills horizontais scrolláveis):**
- `Todos` — selecionado (roxo sólido, texto branco)
- `Sertanejo` · `Rock` · `Pagode` — não selecionados (fundo transparente, borda sutil)

**Banner de Novidade (carrossel):**
- Card com imagem de fundo de show ao vivo (tons escuros/azulados)
- Badge **"NOVIDADE"** em roxo no canto superior esquerdo
- Texto: **"Festival Muve 2025"** (bold branco), "Inscreva-se e toque nos melhores palcos!"
- Botão **"Saiba mais"** (roxo, pequeno)
- Indicador de paginação (dots) abaixo

**Seção "Eventos Patrocinados":**
- Label `AD` pequeno + link **"Ver todos"** em roxo à direita
- Card de evento: foto de bar/show, badges de gênero (`Sertanejo`) e status (`Vagas abertas` em verde)
  - Título: **"Noite Sertaneja"**
  - Local: 📍 Bar do Zé – Cascavel/PR
  - Data: 📅 15 Jun 2025
  - Cachê: R$ 500

**Seção "Artistas Relevantes":**
- Link **"Ver todos"** em roxo
- Cards circulares de artistas (foto redonda com borda roxa para quem está online)
  - Nome + @usuario + Gênero + 📍 Cidade

**Bottom Navigation:**
- Eventos · **Home** (ativo, ícone roxo) · Perfil

---

## Tela 4 — Meu Perfil (`/profile`)

**Header:** Título **"Meu Perfil"** + ícone de engrenagem (configurações) à direita

**Foto de perfil:** Circular, grande (~80px), com botão de câmera (roxo) no canto inferior direito para editar

**Informações principais:**
- Nome: **Lucas Mendes** (bold, ~20px)
- Bio: "Cantor sertanejo em Cascavel/PR, disponível para bares e casamentos" (cinza, ~14px)

**Seção "Estilos Musicais":**
- Chips/tags: `Sertanejo` (roxo sólido) · `Acústico` (borda cinza) · `Pop` (borda cinza)

**Seção "Meus Links":**
Três linhas com ícone da plataforma + nome + URL (ou "Adicionar link") + ícone de link externo:
- 🔴 YouTube — `youtube.com/lucasmendes`
- 🟢 Spotify — "Adicionar link"
- 🟡 SoundCloud — "Adicionar link"

**Seção "Sobre mim":**
- Caixa de texto com fundo cinza claro, borda sutil, texto descritivo longo do artista

**Botão:** `✏️ Editar Perfil` — roxo sólido, largura total

**Bottom Navigation:** Eventos · Home · **Perfil** (ativo)

---

## Tela 5 — Configurações (`/settings`)

**Fundo:** Escuro/preto (`#0F0F0F` aprox.) — tema dark

**Header:** `← Configurações` (seta de voltar + título centralizado, branco)

**Seções agrupadas com label em caixa-alta cinza:**

**CONTA**
- `👤 Editar Perfil` →
- `🔒 Alterar Senha` →
- `🔔 Notificações` — toggle ativo (roxo)

**PREFERÊNCIAS**
- `🎵 Estilos Musicais Preferidos` →
- `📍 Região de Busca` →
- `🎨 Tema` — valor atual: "Escuro" à direita

**SOBRE**
- `📄 Termos de Uso` →
- `🛡️ Política de Privacidade` →
- `ℹ️ Versão do App` — valor: `v1.0.0`

**Botão de ação destrutiva:**
- `[→ Sair da Conta]` — fundo vermelho (`#EF4444`), texto branco, largura total, fixado na parte inferior

---

## Tela 6 — Lista de Eventos (`/events`)

**Header:** Título **"Eventos"** (sem seta de voltar — tela principal)

**Busca:**
- Barra com placeholder "Buscar por cidade, bairro ou região..."

**Filtros de gênero (chips horizontais):**
- `Todos` (roxo) · `Sertanejo` · `Rock` · `Pagode`

**Cards de evento (lista vertical, sem scroll horizontal):**

Cada card contém:
- Foto de capa do evento (formato 16:9 ou similar, largura total)
- Badge de gênero no canto superior esquerdo da imagem (ex: `Sertanejo` em roxo, `Pagode` em laranja, `Rock` em verde-água)
- Abaixo da foto:
  - Título do evento (bold)
  - 📍 Local — Cidade/Estado
  - 📅 Dia, data e horário
  - Badge de status: `✅ Aceitando músicos` (verde) ou `⊘ Vagas preenchidas` (cinza)
  - Botão **"Ver detalhes"** (roxo, pequeno, alinhado à direita)

**Exemplos de eventos:**
1. **Festival de Verão** — Praça Central, Cascavel/PR · Sáb 21 Jun 2025 · 20h · ✅ Aceitando músicos
2. **Noite do Pagode** — Bar do Zé, Londrina/PR · Sex 27 Jun 2025 · 21h · ✅ Aceitando músicos
3. **Rock in Rio Branco** — Arena Show, Rio Branco/AC · Sáb 05 Jul 2025 · 19h · ⊘ Vagas preenchidas

---

## Tela 7 — Aplicar para Evento (`/events/:id/apply`)

**Fundo:** Escuro (dark mode)

**Header:** `← Aplicar para Evento` (centralizado)

**Seção do evento:**
- Imagem de capa do evento (largura total, ~160px altura)
- Título: **Festival de Verão** (bold branco)
- 📍 Praça Central – Cascavel/PR
- 📅 Sáb, 21 Jun 2025 · 20h
- Chip de gênero: `Sertanejo` (roxo)
- Texto de descrição: detalhes do evento, público estimado, cachê

**Seção "Seu Perfil":**
- Card arredondado com fundo cinza escuro
  - Foto circular pequena + **Lucas Mendes**
  - Tags de gênero: `Sertanejo` · `Pop` · `Acústico`
  - Ícones de instrumento/fone
  - Texto: "Este perfil será enviado ao contratante"
  - Toggle: **"Confirmar envio do perfil"** — ativo (roxo)

**Seção "Sua Mensagem":**
- Textarea com placeholder: "Escreva uma mensagem para o contratante... Apresente-se, fale da sua experiência e por que você é ideal para este evento."

**Botão:**
- `📨 Aplicar para este Evento` — roxo sólido, largura total

**Feedback de sucesso (toast/banner no rodapé):**
- `✅ Aplicação enviada com sucesso!` — verde, com texto "O contratante receberá seu perfil e..."

---

## Tela 8 — Criar Evento (`/events/create`)

**Fundo:** Claro (light mode)

**Header:** `← Criar Evento`

**Campos do formulário:**

- **Upload de foto:** Área retangular com borda dashed, ícone de câmera centralizado, texto "Adicionar foto do evento / Toque para fazer upload"
- **Nome do evento** — input com placeholder `Ex: Festival de Verão`
- **Localização** — input com ícone 📍, placeholder `Cidade, bairro ou endereço`
- **Data** (metade da largura) — ícone de calendário, placeholder `Selecionar`
- **Horário** (metade da largura) — ícone de relógio, placeholder `Selecionar`
- **Estilo musical** — chips selecionáveis em grid:
  - `Sertanejo` (selecionado, roxo) · `Rock` · `Pagode` · `Eletrônico` · `MPB` · `Jazz` · `Forró`
- **Precisa de músicos?** — toggle (ativo, roxo) com label e descrição "Ative para receber candidaturas"
- **Vagas disponíveis** — stepper: `— 3 +`
- **Descrição (opcional)** — textarea com placeholder descritivo

**Botão:**
- `+ Criar Evento` — roxo sólido, largura total

---

## Tela 9 — Candidatura Recebida (`/applications/:id`)

**Fundo:** Claro (light mode)

**Header:** `← Candidatura Recebida`

**Card do Evento:**
- Foto de capa (show de jazz, iluminação vermelha/palco)
- Título: **Festival de Jazz – Noite Especial**
- 📅 24 de Janeiro, 2025 · 20:00 – 23:00
- 📍 Casa de Shows Aurora, São Paulo – SP
- 💵 Cachê oferecido: R$ 1.500,00

**Seção "Perfil do Candidato"** (label em roxo com ícone de pessoa):
- Foto circular + **Lucas Mendes** · Saxofonista & Multi-instrumentalista
- ⭐⭐⭐⭐⭐ **5.0** (47 avaliações)

**Sobre:** texto descritivo do músico

**Gêneros Musicais:** `Jazz` · `Bossa Nova` · `MPB` · `Blues`

**Tabela de Detalhes da Candidatura:**
| Campo | Valor |
|---|---|
| Cachê solicitado | R$ 1.200,00 |
| Equipamento próprio | **Sim** (verde) |
| Disponibilidade | **Confirmada** (verde) |

**Mensagem do Candidato:**
- Caixa com fundo cinza claro, texto em aspas da mensagem enviada pelo músico

---

## 📐 Padrões de Componentes Recorrentes

| Componente | Especificação |
|---|---|
| Inputs | Fundo cinza claro `#F3F4F6`, sem borda visível no rest, borda roxa no focus, border-radius 10px, altura ~48px |
| Botão primário | Fundo `#7B4FD9`, texto branco, border-radius 10px, altura 48–52px, font-weight 600 |
| Chips/Tags | Border-radius 20px (pill), roxo sólido = selecionado, borda cinza = inativo |
| Cards de evento | Border-radius 12px, sombra suave `box-shadow: 0 2px 8px rgba(0,0,0,0.08)` |
| Bottom nav | Fundo branco, 3 ítens, ícone ativo em roxo com fundo roxo translúcido arredondado |
| Dark screens | Fundo `#0F0F0F` ou `#111827`, texto branco, elementos em `#1F2937` |
| Toggles | Roxo quando ativo (`#7B4FD9`), cinza quando inativo |
| Badges de status | Verde `#22C55E` para positivo, cinza para neutro/cheio |
