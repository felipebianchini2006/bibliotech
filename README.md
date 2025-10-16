# Bibliotech - Sistema de Gerenciamento de Biblioteca

Sistema web para gerenciamento de biblioteca com controle de empréstimos, usuários, livros, autores e categorias.

## Tecnologias

- Java 21
- Spring Boot 3.5.6
- PostgreSQL
- Spring Security
- Spring Data JPA
- JSP + JSTL
- Lombok

## Instalação

1. Instalar Java 21 e PostgreSQL
2. Criar banco de dados:
```sql
CREATE DATABASE livraria_db;
```

3. Configurar credenciais em `src/main/resources/application.properties`

4. Executar:
```bash
mvnw.cmd spring-boot:run    # Windows
./mvnw spring-boot:run      # Linux/Mac
```

5. Acessar: http://localhost:8080

## Credenciais Padrão

**Administrador:**
- Email: admin@bibliotech.com
- Senha: admin123

**Usuário:**
- Email: joao@email.com
- Senha: user123

## Funcionalidades

- Autenticação e autorização com Spring Security
- CRUD de Livros, Autores e Categorias
- Sistema de Empréstimos com controle de estoque
- Cálculo automático de multas (R$ 2,00/dia)
- Renovação de empréstimos (14 dias)
- Limite de 5 empréstimos simultâneos por usuário
- Administração de usuários
- Histórico de empréstimos
- Busca e filtros

## Estrutura

```
src/main/java/com/livraria/bibliotech/
├── config/          Configurações
├── controller/      Controllers MVC
├── model/           Entidades JPA
├── repository/      Repositories
├── service/         Lógica de negócio
└── BibliotechApplication.java

src/main/webapp/WEB-INF/jsp/
├── auth/            Login e registro
├── livros/          Gestão de livros
├── autores/         Gestão de autores
├── categorias/      Gestão de categorias
├── emprestimos/     Gestão de empréstimos
└── usuarios/        Admin de usuários
```

## Configuração do Banco

```properties
spring.datasource.url=jdbc:postgresql://localhost:5432/livraria_db
spring.datasource.username=postgres
spring.datasource.password=123456
```

## Regras de Negócio

- Prazo padrão de empréstimo: 14 dias
- Multa por atraso: R$ 2,00 por dia
- Limite de empréstimos por usuário: 5
- Renovações ilimitadas (se não estiver atrasado)

## Troubleshooting

**Erro de conexão com banco:**
- Verificar se PostgreSQL está rodando
- Confirmar credenciais em application.properties
- Verificar se o banco livraria_db existe

**Erro 500 em datas:**
- Corrigido: JSPs usam JSTL functions para formatar LocalDateTime
