![Banner](imag/banner_troca_comigo.png)

# Troca Comigo (SkillSwap Hub) 🚀
![Status do Deploy](https://img.shields.io/badge/deploy-Render-brightgreen)
![License](https://img.shields.io/badge/license-MIT-blue)

### 👥 Integrantes
- **Guilherme Felipe da Silva Souza**: RM558282
- **Pablo Lopes Doria de Andrade**: RM556834
- **Vinicius Leopoldino de Oliveira**: RM557047

### Deploy
- **Projeto na Azure:** [https://dev.azure.com/RM556834/Troca%20Comigo](https://dev.azure.com/RM556834/Troca%20Comigo)
- **Render:** [https://troca-comigo-global-2-2025-n89g.onrender.com](https://troca-comigo-global-2-2025-n89g.onrender.com)
- **Video:** [https://www.youtube.com/watch?v=PQ_NMhAXyAs](https://www.youtube.com/watch?v=PQ_NMhAXyAs)
- **Deploy na Azure:** [https://webapp-troca-comigo-global.azurewebsites.net/](https://webapp-troca-comigo-global.azurewebsites.net/)
> [!WARNING]
> Muito provavelmente que o link de **deploy na Azure não ira funcionar apos a gravação do video** deviado a consumo total dos creditos na plataforma

Backend completo de uma plataforma de troca de habilidades (skill-swap), desenvolvida para a Global Solution - FIAP 2025. O projeto permite que usuários se cadastrem, 
ofereçam suas habilidades em troca de "créditos de tempo" e usem esses créditos para aprender novas habilidades com outros membros da comunidade.

A aplicação é construída em **Java 17** com **Spring Boot** e utiliza uma arquitetura moderna baseada em micro-serviços, incluindo autenticação JWT, mensageria assíncrona com RabbitMQ, 
persistência de dados com PostgreSQL e integração com IA Generativa DeepSeek para criação de perfis.

---

## ✨ Principais Funcionalidades

* **Autenticação JWT:** Sistema completo de registro (`/auth/register`) e login (`/auth/login`) usando Spring Security e JSON Web Tokens (JWT).
* **Gerenciamento de Usuários e Perfis:** Usuários podem visualizar e atualizar seus próprios perfis.
* **Cadastro de Habilidades:** API para usuários criarem, listarem e excluírem as habilidades que desejam ensinar ou aprender.
* **Sistema de Agendamento de Sessões:** Lógica de negócio completa para agendar, cancelar e completar sessões de mentoria.
* **Extrato de "Créditos de Tempo":** Endpoint que funciona como um extrato bancário, mostrando todas as transações de créditos (bônus inicial, pagamentos de sessão, recebimentos).
* **Sistema de Avaliação:** Usuários podem avaliar sessões concluídas, e a nota média do mentor é recalculada automaticamente.
* **IA Generativa (Geração de Bio):** Endpoint (`/api/ia/gerar-bio`) que usa Spring AI e a API da DeepSeek para gerar uma biografia de perfil profissional com base em palavras-chave.
* **Mensageria Assíncrona:** Envio de e-mails de boas-vindas é feito de forma assíncrona usando **RabbitMQ**, garantindo que o registro do usuário seja instantâneo.

---

## 🛠️ Tecnologias Utilizadas

* **Backend:** Java 17, Spring Boot 3
* **Persistência de Dados:** Spring Data JPA, Hibernate
* **Banco de Dados:** PostgreSQL (Produção/Render) & H2 (Testes/Dev Local)
* **Segurança:** Spring Security 6, Autenticação JWT
* **Mensageria:** Spring AMQP, RabbitMQ
* **IA Generativa:** Spring AI (com DeepSeek)
* **Cache:** Spring Boot Starter Cache (com Caffeine)
* **Validação:** Spring Boot Starter Validation
* **Testes:** JUnit 5, Mockito
* **Deploy:** Docker, Render

---

## 🚀 Rodando o Projeto Localmente

Para rodar a aplicação localmente, você precisará ter o **JDK 17** (ou superior), o **Maven** e o **Docker** instalados.

**1. Clone o Repositório**
```bash
git clone https://github.com/GuiFelSS/Troca_Comigo_Global_2_2025.git
```

**2. Inicie as Dependências (RabbitMQ)**  
O projeto precisa de uma instância do RabbitMQ. Nós usamos o docker-compose.yml para subir uma facilmente:
```bash
docker-compose up -d
```
Isso iniciará um container do RabbitMQ em localhost:5672.

**3. Configure as Variáveis de Ambiente**  
A aplicação usa o arquivo ```src/main/resources/application.properties``` para configuração. Para rodar localmente (com o banco H2 em memória), 
você precisa fornecer as seguintes variáveis de ambiente na sua IDE (IntelliJ, VSCode, etc.) para que o envio de email e a IA funcionem:
```bash
# Credenciais do seu Gmail (necessário App Password)
MAIL_USER=seu-email-real@gmail.com
MAIL_PASS=sua-senha-de-app-de-16-letras

# Chave da API da DeepSeek
DEEPSEEK_API_KEY=sk-sua-chave-secreta-da-deepseek
```
(As chaves do banco de dados e do RabbitMQ usarão os padrões ```h2:mem``` e ```localhost``` definidos no ```.properties```)

**4. Rode a Aplicação**  
Inicie a aplicação diretamente pela sua IDE ou usando o Maven:
```bash
mvn spring-boot:run
```

**5. Acesse a Aplicação**  
- Página Inicial: http://localhost:8080/
- Console do Banco H2: http://localhost:8080/h2-console
  - JDBC URL: jdbc:h2:mem:skillswapdb
  -  User Name: sa
  -  Password: (deixe em branco)

## 🗺️ Principais Endpoints da API
**Autenticação (Auth)**
- ```POST /auth/register``` - Registra um novo usuário.
- ```POST /auth/login``` - Autentica um usuário e retorna um token JWT.

**Usuários (Users) - 🔒 Protegido**
- ```GET /api/users``` - Lista todos os usuários (mentores) com paginação.
- ```GET /api/users/me``` - Retorna o perfil completo do usuário autenticado.
- ```PUT /api/users/me``` - Atualiza o perfil do usuário autenticado.
- ```GET /api/users/{id}``` - Retorna o perfil público de um usuário específico.
- ```DELETE /api/users/me``` - Deleta a conta.

**Habilidades (Habilidades) - 🔒 Protegido**
- ```POST /api/habilidades``` - Cria uma nova habilidade para o usuário logado.
- ```GET /api/habilidades/me``` - Lista as habilidades do usuário logado.
- ```PUT /api/habilidades/{id}``` - Atualiza habilidade.
- ```DELETE /api/habilidades/{id}``` - Deleta uma habilidade do usuário logado.

**Sessões (Sessoes) - 🔒 Protegido**
- ```POST /api/sessoes``` - Agenda uma nova sessão com um mentor.
- ```GET /api/sessoes/me``` - Lista todas as sessões (como mentor e mentorado) do usuário logado.
- ```PATCH /api/sessoes/{id}/cancelar``` - Cancela uma sessão (mentor ou mentorado).
- ```PATCH /api/sessoes/{id}/completar``` - Completa uma sessão (apenas mentor).

**Transações (Transferencias) - 🔒 Protegido**
- ```GET /api/transferencias/me``` - Retorna o extrato de transações de créditos do usuário logado.

**Avaliações (Avaliacoes) - 🔒 Protegido**
- ```POST /api/avaliacoes``` - Cria uma nova avaliação para uma sessão concluída.
- ```GET /api/avaliacoes/user/{usuarioId}``` - Lista todas as avaliações recebidas por um usuário.

**Inteligência Artificial (IA) - 🔒 Protegido**
- ```POST /api/ia/gerar-bio``` - Gera uma biografia de perfil usando IA.

## 🧪 Guia de Testes Manuais (Postman / Insomnia)

Para validar o funcionamento da API, recomenda-se o uso do **Postman** ou **Insomnia**. Abaixo está um roteiro de teste para simular o fluxo completo de uso da plataforma.

**URL Base (Produção):** `https://troca-comigo-global-2-2025-n89g.onrender.com`

### 1. Autenticação e Perfil/Usuario

**1.1 Registrar Usuário (Mentor)**
* **Método:** `POST`
* **URL:** `/auth/register`
* **Body (JSON):**
  ```json
  {
    "fullName": "Mentor Java",
    "email": "mentor@teste.com",
    "password": "senha123"
  }
  ```
* **Status Esperado:** `200 OK`

**1.2 Login (Gerar Token)**
* **Método:** `POST`
**URL:** `/auth/login`
**Body (JSON):**
  ```json
  {
  "email": "mentor@teste.com",
  "password": "senha123"
  }
  ```
* **Status Esperado:** `200 OK`
* **⚠️ Importante:** Copie o `token` retornado. Você precisará dele no cabeçalho Authorization (Bearer Token) para todas as requisições abaixo.

**1.3 Ler Perfil**
* **Método:** `GET`
* **URL:** `/api/users/me`
* **Auth:** Bearer Token
* **Status Esperado:** `200 OK`

**1.4 Atualizar Perfil**
* **Método:** `PUT`
* **URL:** `/api/users/me`
* **Auth:** Bearer Token
* **Body (JSON):**
  ```json
  {
    "fullName": "Usuario CRUD Atualizado",
    "bio": "Testando update na nuvem",
    "linkedinUrl": "https://linkedin.com/in/teste"
  }
  ```
* **Status Esperado:** `200 OK`

**1.5 Deletar Perfil**
* **Método:** `DEL`
* **URL:** `/api/users/me`
* **Auth:** Bearer Token
* **Status Esperado:** `204 OK`

### 2. Habilidades

**2.1 Criar Habilidades**
* **Método:** `POST`
* **URL:** `/api/habilidades`
* **Auth:** Bearer Token
* **Body (JSON):**
  ```json
  {
  "name": "Mentoria Spring Boot",
  "category": "TECNOLOGIA",
  "description": "Aulas avançadas de Java e Microservices",
  "level": "ESPECIALISTA",
  "isOffering": true,
  "isSeeking": false,
  "hourlyRate": 1.0
  }
  ```
* **Status Esperado:** `201 Created` (Copie o `id` da habilidade criada)

**2.2 Ler Habilidades**
* **Método:** `GET`
* **URL:** `/api/habilidades/me`
* **Auth:** Bearer Token
* **Status Esperado:** `200 Created`

**2.3 Atualizar Habilidades**
* **Método:** `PUT`
* **URL:** `/api/habilidades/{ID da Habilidade}`
* **Auth:** Bearer Token
* **Body (JSON):**
  ```json
  {
  "name": "Java Avançado",
  "category": "TECNOLOGIA",
  "description": "Curso completo de Java e Cloud",
  "level": "AVANCADO",
  "isOffering": true,
  "isSeeking": false,
  "hourlyRate": 50.0
  }
  ```
* **Status Esperado:** `200 Created`

**2.4 Deletar Habilidades**
* **Método:** `DEL`
* **URL:** `/api/habilidades/{ID da Habilidade}`
* **Auth:** Bearer Token
* **Status Esperado:** `204 Created`

### 3. Sessões de Mentoria

**3.1 Agendar Sessão (Como Aluno)** (Dica: Crie um segundo usuário "Aluno" seguindo o passo 1 para testar este fluxo realisticamente)
* **Método:** `POST`
* **URL:** `/api/sessoes`
* **Auth:** Bearer Token (do Aluno)
* **Body (JSON):**
 ```json
  {
  "habilidadeId": "ID_DA_HABILIDADE_CRIADA",
  "mentorId": "ID_DO_MENTOR",
  "scheduledDate": "2025-12-20T15:00:00",
  "notes": "Gostaria de aprender sobre Spring Security."
  }
  ```
* **Status Esperado:** `201 Created`

**3.2 Completar Sessão (Como Mentor)**
* **Método:** `PATCH`
* **URL:** `/api/sessoes/{id_da_sessao}/completar`
* **Auth:** Bearer Token (do Mentor)
* **Status Esperado:** `200 OK`

### 4. Avaliações e Extrato
**4.1 Avaliar a Sessão**

* **Método:** `POST`
* **URL:** `/api/avaliacoes`
* **Auth:** Bearer Token
* **Body (JSON):**
 ```json
  {
    "sessaoId": "ID_DA_SESSAO_CONCLUIDA",
    "rating": 5,
    "comment": "Excelente mentoria!"
  }
  ```
* **Status Esperado:** `201 Created`

**4.2 Ver Extrato de Créditos**
* **Método:** `GET`
* **URL:** `/api/transferencias/me`
* **Auth:** Bearer Token
* **Status Esperado:** `200 OK` (Deve mostrar o débito/crédito da sessão)

### 5. Inteligência Artificial
**5.1 Gerar Bio Profissional**
* **Método:** `POST`
* **URL:** `/api/ia/gerar-bio`
* **Auth:** Bearer Token
* **Body (JSON):**
  ```json
  {
    "promptKeywords": "Java, Spring Boot, AWS, Liderança Técnica"
  }
  ```
* **Status Esperado:** `200 OK` (Retorna um texto gerado pela IA)

## Estrutura do projeto
```
Troca_Comigo-main/
├── scripts/
│   └── script-bd.sql
├── src/
│   ├── main/
│   │   ├── java/br/com/fiap/globalSolution/
│   │   │   ├── Controller/         # Endpoints da API (REST)
│   │   │   │   ├── SecurityController/
│   │   │   │   │   └── AuthController.java
│   │   │   │   ├── AvaliacaoController.java
│   │   │   │   ├── HabilidadeContorller.java
│   │   │   │   ├── IaController.java
│   │   │   │   ├── SessoesController.java
│   │   │   │   ├── TransferenciasController.java
│   │   │   │   └── UsuarioController.java
│   │   │   ├── Dto/                # Objetos de Transferência de Dados
│   │   │   ├── Entity/             # Entidades JPA (Mapeamento do Banco)
│   │   │   │   ├── UsuarioEntity.java
│   │   │   │   ├── HabilidadeEntity.java
│   │   │   │   └── ...
│   │   │   ├── Enum/               # Enums (Role, Status, Categoria)
│   │   │   ├── Rabbit/             # Módulo de Mensageria
│   │   │   │   ├── Config/
│   │   │   │   ├── Consumers/      # Consumidor de E-mails
│   │   │   │   ├── Dto/
│   │   │   │   ├── Entity/
│   │   │   │   └── Service/
│   │   │   ├── Repository/         # Interfaces de acesso a dados
│   │   │   ├── Security/           # Configurações de Segurança e JWT
│   │   │   │   ├── JwtAuthFilter.java
│   │   │   │   ├── SecurityConfig.java
│   │   │   │   └── ...
│   │   │   ├── Service/            # Regras de Negócio
│   │   │   │   ├── AuthService.java
│   │   │   │   ├── IaService.java  # Integração com IA Generativa
│   │   │   │   └── ...
│   │   │   └── GlobalSolutionApplication.java
│   │   └── resources/
│   │       ├── templates/
│   │       │   └── index.html      # Página inicial simples
│   │       ├── application.properties  # Configurações (Azure, Rabbit, JWT, IA)
│   │       └── messages_pt_BR.properties # Mensagens do sistema (Unicode)
│   └── test/                       # Testes Unitários e de Integração
│       ├── java/br/com/fiap/globalSolution/
│       │   ├── Security/
│       │   │   └── AuthServiceTest.java
│       │   ├── Service/
│       │   │   ├── AvaliacaoServiceTest.java
│       │   │   └── SessoesServiceTest.java
│       │   └── GlobalSolutionApplicationTests.java
│       └── resources/
│           └── application-test.properties # <== CONFIGURAÇÃO DE TESTES (H2 e Mocks)
├── docker-compose.yml              # Orquestração local (RabbitMQ)
├── Dockerfile                      # Build da Imagem para Deploy (Render/Azure)
├── pom.xml                         # Gerenciamento de Dependências (Maven)
└── README.md                       # Documentação do Projeto
```
## Diagrama de arquitetura do projeto

![Banner](imag/diagrama_global.png)
