# Bibliotech - Sistema de Livraria

Sistema web para gerenciamento de livraria com Spring Boot.

## Tecnologias
- Java 21 | Spring Boot 3.5.6 | PostgreSQL | Thymeleaf | Spring Security | Lombok

## Executar

```bash
# 1. Criar banco: livraria_db no PostgreSQL
# 2. Ajustar credenciais em application.properties se necessário
# 3. Executar:
.\mvnw.cmd spring-boot:run
```

Acesse: http://localhost:8080

## Login
- **Admin:** admin@bibliotech.com / admin123
- **User:** joao@email.com / user123

## Estrutura
- **model/** - Entidades JPA (Livro, Autor, Categoria, Usuario, Emprestimo)
- **repository/** - Repositories Spring Data
- **service/** - Lógica de negócio
- **controller/** - Controllers web
- **config/** - Configurações (Security, JPA, DataInitializer)
- **templates/** - Views Thymeleaf

## Status
✅ Autenticação e autorização  
⏳ CRUDs completos (próxima etapa)
