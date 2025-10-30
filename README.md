# Bibliotech

Sistema de gerenciamento de biblioteca com controle de empréstimos.

## Stack

Java 21 | Spring Boot 3.5.6 | Spring Security | PostgreSQL 16 | JSP + JSTL | Lombok

## Instalação

```bash
# 1. Criar banco
CREATE DATABASE livraria_db;

# 2. Configurar application.properties
spring.datasource.url=jdbc:postgresql://localhost:5432/livraria_db
spring.datasource.username=seu_usuario
spring.datasource.password=sua_senha

# 3. Executar
./mvnw spring-boot:run  # Linux/Mac
mvnw.cmd spring-boot:run  # Windows

# 4. Acessar
http://localhost:8080
```

## Credenciais

**Admin:** admin@bibliotech.com / admin123  
**User:** joao@email.com / user123

## Funcionalidades

- CRUD de livros, autores e categorias
- Sistema de empréstimos com controle de estoque
- Validação de ISBN (10/13 dígitos) e CPF
- Busca multi-campo (título, autor, categoria)
- Cálculo automático de multas (R$ 2,00/dia)
- Renovação de empréstimos (14 dias)
- Limite de 5 empréstimos por usuário
- Autenticação e autorização (BCrypt + CSRF)

## Estrutura

```
src/main/java/com/livraria/bibliotech/
├── config/          Security, JPA, DataInitializer
├── controller/      Controllers MVC
├── model/           Entidades JPA
├── repository/      Spring Data JPA
├── service/         Lógica de negócio
├── exception/       GlobalExceptionHandler
└── validator/       ISBN, CPF

src/main/webapp/WEB-INF/jsp/
├── auth/            Login e registro
├── livros/          Gestão de livros
├── autores/         Gestão de autores
├── categorias/      Gestão de categorias
├── emprestimos/     Gestão de empréstimos
└── usuarios/        Admin de usuários
```

## Regras de Negócio

- Prazo: 14 dias | Multa: R$ 2,00/dia | Limite: 5 empréstimos/usuário
- Status: ATIVO, DEVOLVIDO, ATRASADO, CANCELADO
- Estoque: decrementa no empréstimo, incrementa na devolução

## Comandos

```bash
./mvnw clean package     # Compilar
./mvnw test              # Testar
./mvnw spring-boot:run   # Executar
```

## Licença

MIT - Ver [LICENSE](LICENSE)
