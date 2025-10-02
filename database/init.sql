-- Script SQL para criar o banco de dados
-- Execute este script no PostgreSQL antes de rodar a aplicação

-- Criar banco de dados (se não existir)
CREATE DATABASE livraria_db
    WITH 
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1;

-- Conectar ao banco de dados
\c livraria_db;

-- As tabelas serão criadas automaticamente pelo Hibernate (spring.jpa.hibernate.ddl-auto=update)
-- Este script é apenas para criar o banco de dados inicial

COMMENT ON DATABASE livraria_db IS 'Banco de dados do sistema de livraria Bibliotech';
