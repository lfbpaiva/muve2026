# 🛠️ Prompt de Correções — App Muve

> Você é um designer/desenvolvedor revisando o app **Muve**, uma plataforma de conexão entre artistas e contratantes. Analise cada tela cuidadosamente, aplique as correções listadas abaixo e, ao final, faça uma **revisão geral** em busca de outros problemas não listados.

---

## Correções Identificadas

### 🖼️ Tela: Meu Perfil (Imagens 1 e 5)

- Adicione um botão de **editar perfil** com ícone de lápis (✏️) no **topo da tela**, próximo ao avatar ou nome — seguindo o padrão do Twitter/X
- O ícone de **engrenagem (⚙️)** no canto superior direito deve levar **exclusivamente** para a tela de Configurações (tema, notificações etc.)
- O botão **"Editar Perfil"** que estava na parte inferior da tela deve ser **removido de lá** e reposicionado no topo
- O botão **"Sair da conta"** deve ser **removido do perfil** e movido para dentro da tela de **Configurações**

---

### 🖼️ Tela: Mensagens (Imagem 3)

- O fundo roxo escuro está **inconsistente** com o restante do app, que usa fundo claro
- Corrija para fundo **branco/claro** com texto escuro, mantendo a identidade roxa apenas em elementos de destaque (avatares, badges, ícones)

---

### 🖼️ Tela: Eventos (Imagem 4)

- Corrija o **erro de overflow** nos botões inferiores (`BOTTOM OVERFLOWED BY 2.0 PIXELS`) — ajuste padding, margin ou tamanho dos componentes para que não ultrapassem os limites da tela
- **Remova o botão flutuante "Muve"** centralizado na barra de navegação inferior — ele é redundante pois a aba "Eventos" já existe na navegação, causando confusão de UX

---

### 🖼️ Tela: Configurações (Imagem 2)

- Mova os campos de edição de perfil (nome, bio, cidade, telefone) para uma tela dedicada **"Editar Perfil"**, acessível pelo botão de lápis na tela de Perfil
- Em Configurações, mantenha apenas: notificações, tema (escuro/claro), cachê e estilos musicais
- Adicione o botão **"Sair da conta"** ao final desta tela

---

### 🖼️ Tela: Login (Imagem 6)

- **Remova** o botão **"Entrar com Instagram"**
- Mantenha apenas login por e-mail/senha e **"Entrar com Google"**
- Reajuste o layout para que os elementos fiquem bem distribuídos após a remoção

---

### 🖼️ Tela: Cadastro (Imagem 7)

- Adicione campo de **CPF** para perfis do tipo "Somente Artista" e "Artista e Contratante"
- Adicione campo de **CNPJ** para perfis do tipo "Somente Contratante" e "Artista e Contratante"
- Aplique **máscara de formatação** nos campos:
  - CPF: `000.000.000-00`
  - CNPJ: `00.000.000/0000-00`
- Os campos devem aparecer **dinamicamente** conforme o tipo de conta selecionado

---

## 🔍 Revisão Geral

Após aplicar as correções acima, revise **todas as telas** em busca de outros problemas, verificando:

1. **Consistência de tema** — há outras telas com fundo escuro misturado com telas claras?
2. **Overflow ou clipping** — algum texto ou botão ultrapassa os limites do container?
3. **Navegação inferior** — os ícones e labels estão corretos e sem redundâncias em todas as telas?
4. **Hierarquia visual** — botões primários, secundários e destrutivos (como "Sair") seguem um padrão de cores consistente?
5. **Acessibilidade básica** — contraste adequado, fontes legíveis e áreas de toque suficientes?
6. **Fluxo de cadastro** — os campos de CPF/CNPJ validam o formato antes de avançar?
7. **Estados vazios (empty states)** — telas como Mensagens e Eventos possuem um estado vazio bem desenhado?

**Liste todos os problemas adicionais encontrados e aplique as correções necessárias.**
