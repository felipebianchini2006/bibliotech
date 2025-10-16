-- Script SIMPLIFICADO para popular base de dados
-- Execute linha por linha ou em blocos separados

-- ============================================
-- 1. LIMPAR DADOS (execute primeiro se necessário)
-- ============================================
DELETE FROM livro_autor;
DELETE FROM emprestimos WHERE livro_id IS NOT NULL;
DELETE FROM livros;
DELETE FROM autores;
DELETE FROM categorias;

-- Resetar sequences
ALTER SEQUENCE categorias_id_seq RESTART WITH 1;
ALTER SEQUENCE autores_id_seq RESTART WITH 1;
ALTER SEQUENCE livros_id_seq RESTART WITH 1;

-- ============================================
-- 2. CATEGORIAS (execute segundo)
-- ============================================
INSERT INTO categorias (nome, descricao) VALUES
('Ficção Científica', 'Livros de ficção científica e futurismo'),
('Romance', 'Romances literários e contemporâneos'),
('Suspense', 'Thrillers e mistérios'),
('Fantasia', 'Aventuras fantásticas e mundos imaginários'),
('Tecnologia', 'Livros sobre programação e tecnologia');

-- ============================================
-- 3. AUTORES (execute terceiro)
-- ============================================
INSERT INTO autores (nome, biografia, nacionalidade) VALUES
('George Orwell', 'Escritor britânico conhecido por 1984 e A Revolução dos Bichos', 'Britânico'),
('J.K. Rowling', 'Autora da série Harry Potter', 'Britânica'),
('Isaac Asimov', 'Escritor de ficção científica', 'Americano'),
('Machado de Assis', 'Maior escritor brasileiro', 'Brasileiro'),
('Stephen King', 'Mestre do terror e suspense', 'Americano');

-- ============================================
-- 4. LIVROS - Ficção Científica (execute quarto - BLOCO 1)
-- ============================================
INSERT INTO livros (titulo, isbn, descricao, data_publicacao, quantidade_total, quantidade_disponivel, categoria_id)
SELECT 
    '1984' as titulo,
    '9780451524935' as isbn,
    'Distopia sobre vigilância totalitária' as descricao,
    '1949-06-08'::date as data_publicacao,
    5 as quantidade_total,
    5 as quantidade_disponivel,
    c.id as categoria_id
FROM categorias c
WHERE c.nome = 'Ficção Científica';

INSERT INTO livros (titulo, isbn, descricao, data_publicacao, quantidade_total, quantidade_disponivel, categoria_id)
SELECT 
    'Fundação',
    '9780553293357',
    'Épico da ficção científica sobre o futuro da humanidade',
    '1951-06-01'::date,
    3, 3,
    c.id
FROM categorias c
WHERE c.nome = 'Ficção Científica';

INSERT INTO livros (titulo, isbn, descricao, data_publicacao, quantidade_total, quantidade_disponivel, categoria_id)
SELECT 
    'Eu, Robô',
    '9780553382563',
    'Coletânea de contos sobre robótica e IA',
    '1950-12-02'::date,
    4, 4,
    c.id
FROM categorias c
WHERE c.nome = 'Ficção Científica';

-- ============================================
-- 5. LIVROS - Romance (BLOCO 2)
-- ============================================
INSERT INTO livros (titulo, isbn, descricao, data_publicacao, quantidade_total, quantidade_disponivel, categoria_id)
SELECT 
    'Dom Casmurro',
    '9788535911664',
    'Romance clássico brasileiro sobre amor e ciúme',
    '1899-01-01'::date,
    5, 5,
    c.id
FROM categorias c
WHERE c.nome = 'Romance';

-- ============================================
-- 6. LIVROS - Suspense (BLOCO 3)
-- ============================================
INSERT INTO livros (titulo, isbn, descricao, data_publicacao, quantidade_total, quantidade_disponivel, categoria_id)
SELECT 
    'O Iluminado',
    '9780307743657',
    'Terror psicológico sobre um hotel mal-assombrado',
    '1977-01-28'::date,
    5, 5,
    c.id
FROM categorias c
WHERE c.nome = 'Suspense';

-- ============================================
-- 7. LIVROS - Fantasia (BLOCO 4)
-- ============================================
INSERT INTO livros (titulo, isbn, descricao, data_publicacao, quantidade_total, quantidade_disponivel, categoria_id)
SELECT 
    'Harry Potter e a Pedra Filosofal',
    '9788532530788',
    'Primeiro livro da saga do bruxo Harry Potter',
    '1997-06-26'::date,
    10, 10,
    c.id
FROM categorias c
WHERE c.nome = 'Fantasia';

-- ============================================
-- 8. LIVROS - Tecnologia (BLOCO 5)
-- ============================================
INSERT INTO livros (titulo, isbn, descricao, data_publicacao, quantidade_total, quantidade_disponivel, categoria_id)
SELECT 
    'Código Limpo',
    '9788576082675',
    'Guia sobre como escrever código de qualidade',
    '2008-08-01'::date,
    8, 8,
    c.id
FROM categorias c
WHERE c.nome = 'Tecnologia';

-- ============================================
-- 9. RELACIONAMENTOS (execute por último)
-- ============================================
-- 1984 - George Orwell
INSERT INTO livro_autor (livro_id, autor_id)
SELECT l.id, a.id 
FROM livros l, autores a
WHERE l.isbn = '9780451524935' AND a.nome = 'George Orwell';

-- Fundação - Isaac Asimov
INSERT INTO livro_autor (livro_id, autor_id)
SELECT l.id, a.id 
FROM livros l, autores a
WHERE l.isbn = '9780553293357' AND a.nome = 'Isaac Asimov';

-- Eu, Robô - Isaac Asimov
INSERT INTO livro_autor (livro_id, autor_id)
SELECT l.id, a.id 
FROM livros l, autores a
WHERE l.isbn = '9780553382563' AND a.nome = 'Isaac Asimov';

-- Dom Casmurro - Machado de Assis
INSERT INTO livro_autor (livro_id, autor_id)
SELECT l.id, a.id 
FROM livros l, autores a
WHERE l.isbn = '9788535911664' AND a.nome = 'Machado de Assis';

-- O Iluminado - Stephen King
INSERT INTO livro_autor (livro_id, autor_id)
SELECT l.id, a.id 
FROM livros l, autores a
WHERE l.isbn = '9780307743657' AND a.nome = 'Stephen King';

-- Harry Potter - J.K. Rowling
INSERT INTO livro_autor (livro_id, autor_id)
SELECT l.id, a.id 
FROM livros l, autores a
WHERE l.isbn = '9788532530788' AND a.nome = 'J.K. Rowling';

-- ============================================
-- 10. VERIFICAÇÃO
-- ============================================
SELECT 'Categorias:', COUNT(*) FROM categorias;
SELECT 'Autores:', COUNT(*) FROM autores;
SELECT 'Livros:', COUNT(*) FROM livros;
SELECT 'Relacionamentos:', COUNT(*) FROM livro_autor;

-- Listar livros com categorias e autores
SELECT 
    l.titulo,
    c.nome as categoria,
    STRING_AGG(a.nome, ', ') as autores
FROM livros l
LEFT JOIN categorias c ON l.categoria_id = c.id
LEFT JOIN livro_autor la ON l.id = la.livro_id
LEFT JOIN autores a ON la.autor_id = a.id
GROUP BY l.id, l.titulo, c.nome
ORDER BY l.titulo;
