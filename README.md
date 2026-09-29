
<img width="946" height="443" alt="image" src="https://github.com/user-attachments/assets/5539602e-d2af-49ae-8b52-6c950f78d349" />


## 📌 Sobre o projeto

O **SIGPE (Sistema Integrado de Gestão de Patrimônio Escolar)** é uma aplicação mobile criada para auxiliar instituições de ensino no gerenciamento de seus bens patrimoniais.

O sistema permite cadastrar, consultar, atribuir, devolver e acompanhar equipamentos utilizados na escola, além de organizar informações relacionadas aos professores e responsáveis pelos bens.

A proposta é tornar o gerenciamento do patrimônio **mais organizado, simples e transparente**, reduzindo controles manuais e facilitando o acompanhamento da utilização dos equipamentos.

---

## 🎯 Objetivo

O SIGPE tem como objetivo centralizar o gerenciamento do patrimônio escolar em uma única aplicação.

Com o sistema, é possível:

- 📦 Cadastrar e gerenciar bens;
- 👨‍🏫 Gerenciar professores e responsáveis;
- 🔄 Registrar atribuições e devoluções;
- 📋 Consultar o histórico dos equipamentos;
- 🔔 Receber notificações importantes;
- 📊 Visualizar informações gerais do patrimônio;
- 🔐 Realizar autenticação de usuários;
- 🗂️ Organizar os bens por categorias e status.

---

## ✨ Funcionalidades

### 🔐 Autenticação

- Login do usuário;
- Cadastro de coordenador;
- Recuperação de senha;
- Verificação por código;
- Alteração de senha;
- Controle de sessão.

### 📊 Dashboard

O painel principal apresenta uma visão geral do patrimônio escolar, incluindo:

- Quantidade total de bens;
- Bens disponíveis;
- Bens em uso;
- Bens em manutenção;
- Categorias de patrimônio;
- Informações resumidas para acompanhamento.

### 📦 Gestão de bens

O sistema permite:

- Cadastrar novos bens;
- Editar informações;
- Consultar bens cadastrados;
- Filtrar por status;
- Filtrar por categoria;
- Visualizar detalhes;
- Atribuir bens a professores;
- Registrar devoluções;
- Consultar histórico de movimentações.

### 👨‍🏫 Gestão de professores

É possível:

- Visualizar professores cadastrados;
- Consultar perfil;
- Visualizar matrícula e departamento;
- Consultar bens atribuídos;
- Editar informações do perfil;
- Acompanhar os equipamentos sob responsabilidade de cada professor.

### 🔔 Notificações

O sistema apresenta notificações relacionadas a:

- Novos bens atribuídos;
- Devoluções;
- Manutenções;
- Novos professores cadastrados;
- Outras movimentações importantes.

---

## 📱 Telas do sistema

O SIGPE possui diferentes telas para cada etapa do gerenciamento:

| Área | Telas |
| --- | --- |
| **Autenticação** | Login, Cadastro, Recuperação de senha, Verificação e Nova senha |
| **Dashboard** | Visão geral do patrimônio e indicadores |
| **Bens** | Lista, Cadastro, Histórico, Atribuição e Devolução |
| **Professores** | Lista, Perfil, Meus Bens e Edição |
| **Gestão** | Bens, Professores, Relatórios, Configurações e Ajuda |
| **Sistema** | Notificações e gerenciamento geral |

---

## 🎨 Identidade visual

A interface foi desenvolvida seguindo uma proposta **elegante, acolhedora e profissional**, utilizando tons inspirados em:

- 🤎 Marrom;
- 🤍 Bege;
- 🟤 Tons terrosos;
- ✨ Tons claros para contraste.

A intenção é fugir de uma aparência excessivamente tecnológica e criar uma interface que transmita **organização, confiança e simplicidade**.

### Tipografia

A interface utiliza a fonte:

**Poppins**

Com diferentes pesos para criar hierarquia visual:

- Regular
- Medium
- SemiBold
- Bold

---

## 🛠️ Tecnologias utilizadas

### Flutter

Framework utilizado para desenvolvimento da aplicação mobile.

### Dart

Linguagem de programação utilizada no desenvolvimento do aplicativo.

### Firebase

Utilizado como parte da infraestrutura de dados e serviços do projeto.

### Provider

Utilizado para gerenciamento de estado da aplicação.

### Shared Preferences

Utilizado para armazenamento local de determinadas informações e preferências.

---

## 🏗️ Estrutura do projeto

Uma possível organização do projeto é:

```
lib/
│
├── core/
│   ├── constants/
│   ├── theme/
│   └── routes/
│
├── data/
│   ├── models/
│   └── services/
│
├── providers/
│
├── screens/
│   ├── auth/
│   ├── home/
│   ├── bens/
│   ├── professores/
│   └── perfil/
│
├── widgets/
│
└── main.dart
```

### Organização

**core/**

Configurações gerais, temas, constantes e rotas.

**data/**

Modelos e serviços responsáveis pelo acesso e organização dos dados.

**providers/**

Gerenciamento dos estados utilizados pela aplicação.

**screens/**

Telas principais do aplicativo.

**widgets/**

Componentes reutilizáveis da interface.

**main.dart**

Ponto de entrada da aplicação.

---

## 🚀 Como executar o projeto

### 1. Pré-requisitos

Antes de iniciar, tenha instalado:

- Flutter SDK;
- Dart SDK;
- Android Studio ou VS Code;
- Emulador Android ou dispositivo físico;
- Git.

Verifique a instalação do Flutter:

```
flutter doctor
```

---

### 2. Clone o repositório

```
git clone https://github.com/seu-usuario/sigpe.git
```

Entre na pasta:

```
cd sigpe
```

---

### 3. Instale as dependências

```
flutter pubget
```

---

### 4. Execute o projeto

```
flutter run
```

---

## 🔄 Fluxo principal

```
              ┌───────────────┐
              │     Login     │
              └───────┬───────┘
                      │
                      ▼
             ┌─────────────────┐
             │    Dashboard    │
             └────────┬────────┘
                      │
          ┌───────────┼───────────┐
          ▼           ▼           ▼
      ┌───────┐  ┌──────────┐  ┌────────────┐
      │  Bens │  │Professores│ │Notificações│
      └───┬───┘  └─────┬────┘  └────────────┘
          │             │
          ▼             ▼
      ┌────────┐    ┌──────────┐
      │Atribuir│    │Meus Bens │
      │  Bem   │    └──────────┘
      └───┬────┘
          │
          ▼
      ┌──────────┐
      │ Devolução│
      └────┬─────┘
           │
           ▼
      ┌───────────┐
      │ Histórico │
      └───────────┘
```

---

## 📦 Status dos bens

Cada patrimônio pode apresentar diferentes estados:

### 🟢 Disponível

O equipamento está disponível para ser utilizado ou atribuído.

### 🟤 Em uso

O equipamento está atualmente sob responsabilidade de um professor ou setor.

### 🟠 Manutenção

O equipamento está temporariamente indisponível para utilização.

---

## 👥 Perfis do sistema

### Coordenador

Responsável pelo gerenciamento geral do patrimônio.

Pode:

- Cadastrar bens;
- Gerenciar professores;
- Atribuir equipamentos;
- Registrar devoluções;
- Consultar históricos;
- Acompanhar o patrimônio.

### Professor

Pode acompanhar os bens atribuídos à sua responsabilidade e consultar suas informações dentro do sistema.

---

## 📸 Screenshots

As principais telas da aplicação estão organizadas na pasta:

```
screenshots/
```

Entre elas:

- Login;
- Cadastro;
- Recuperação de senha;
- Dashboard;
- Lista de bens;
- Cadastro de bens;
- Histórico;
- Atribuição;
- Devolução;
- Professores;
- Perfil;
- Notificações;
- Gestão de patrimônio.

---

## 🔒 Segurança

O projeto possui uma estrutura voltada para controle de acesso e proteção das informações, incluindo:

- Autenticação;
- Controle de sessão;
- Recuperação de senha;
- Verificação de código;
- Organização de permissões por perfil.

---

## 💡 Diferencial do projeto

O SIGPE busca transformar o controle do patrimônio escolar em um processo mais **visual, organizado e acessível**.

Em vez de depender de diferentes planilhas ou controles manuais, a proposta concentra as principais informações em uma aplicação mobile, permitindo acompanhar os equipamentos desde seu cadastro até sua atribuição, manutenção e devolução.

---

## 👩‍💻 Desenvolvimento

Projeto desenvolvido como parte de um projeto acadêmico, utilizando Flutter e Dart.

O sistema foi planejado com foco em:

- Usabilidade;
- Organização;
- Responsividade;
- Facilidade de manutenção;
- Experiência do usuário;
- Gestão eficiente do patrimônio escolar.

---

## 📄 Licença

Este projeto está sob a licença **MIT**.

Consulte o arquivo `LICENSE` para mais informações.

---

<p align="center">

**SIGPE**

*Tecnologia a serviço da educação.*

</p>
