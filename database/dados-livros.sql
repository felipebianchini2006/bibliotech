-- Script para popular a base de dados com livros, autores e categorias
-- Execute após a criação automática das tabelas pelo Hibernate

-- ============================================
-- CATEGORIAS
-- ============================================
INSERT INTO categorias (nome, descricao) VALUES
('Ficção Científica', 'Livros de ficção científica e futurismo'),
('Romance', 'Romances literários e contemporâneos'),
('Suspense', 'Thrillers e mistérios'),
('Fantasia', 'Aventuras fantásticas e mundos imaginários'),
('Biografia', 'Histórias de vida reais'),
('Tecnologia', 'Livros sobre programação, computação e tecnologia'),
('Filosofia', 'Obras filosóficas e pensamento crítico'),
('História', 'Livros históricos e documentários'),
('Autoajuda', 'Desenvolvimento pessoal e motivacional'),
('Clássicos', 'Literatura clássica universal');

-- ============================================
-- AUTORES
-- ============================================
INSERT INTO autores (nome, biografia, data_nascimento, nacionalidade) VALUES
('George Orwell', 'Escritor britânico conhecido por suas obras distópicas.', '1903-06-25', 'Britânico'),
('J.K. Rowling', 'Autora britânica da série Harry Potter.', '1965-07-31', 'Britânica'),
('Isaac Asimov', 'Escritor russo-americano de ficção científica e divulgação científica.', '1920-01-02', 'Americano'),
('Machado de Assis', 'Maior escritor brasileiro, autor de Dom Casmurro.', '1839-06-21', 'Brasileiro'),
('Clarice Lispector', 'Escritora ucraniana naturalizada brasileira.', '1920-12-10', 'Brasileira'),
('Gabriel García Márquez', 'Escritor colombiano, Prêmio Nobel de Literatura.', '1927-03-06', 'Colombiano'),
('Stephen King', 'Mestre do terror e suspense americano.', '1947-09-21', 'Americano'),
('Agatha Christie', 'Rainha do crime, autora de romances policiais.', '1890-09-15', 'Britânica'),
('J.R.R. Tolkien', 'Criador da Terra Média e autor de O Senhor dos Anéis.', '1892-01-03', 'Britânico'),
('Jane Austen', 'Escritora inglesa de romances clássicos.', '1775-12-16', 'Britânica'),
('Franz Kafka', 'Escritor tcheco de contos e romances existencialistas.', '1883-07-03', 'Tcheco'),
('Virginia Woolf', 'Escritora modernista britânica.', '1882-01-25', 'Britânica'),
('Ernest Hemingway', 'Escritor e jornalista americano, Prêmio Nobel.', '1899-07-21', 'Americano'),
('Paulo Coelho', 'Escritor brasileiro autor de O Alquimista.', '1947-08-24', 'Brasileiro'),
('Dan Brown', 'Autor americano de thrillers de suspense.', '1964-06-22', 'Americano');

-- ============================================
-- LIVROS
-- ============================================
INSERT INTO livros (titulo, isbn, descricao, data_publicacao, quantidade_total, quantidade_disponivel, categoria_id) VALUES
-- Ficção Científica (categoria_id = 1)
('1984', '9780451524935', 'Distopia sobre vigilância totalitária e controle do pensamento.', '1949-06-08', 5, 5, 1),
('Fundação', '9780553293357', 'Épico da ficção científica sobre o futuro da humanidade.', '1951-06-01', 3, 3, 1),
('Eu, Robô', '9780553382563', 'Coletânea de contos sobre robótica e inteligência artificial.', '1950-12-02', 4, 4, 1),

-- Romance (categoria_id = 2)
('Orgulho e Preconceito', '9780141439518', 'Romance clássico sobre Elizabeth Bennet e Mr. Darcy.', '1813-01-28', 6, 6, 2),
('Cem Anos de Solidão', '9780060883287', 'Obra-prima do realismo mágico sobre a família Buendía.', '1967-05-30', 4, 4, 2),
('Dom Casmurro', '9788535911664', 'Romance clássico brasileiro sobre amor e traição.', '1899-01-01', 5, 5, 2),

-- Suspense (categoria_id = 3)
('O Código Da Vinci', '9780307474278', 'Thriller sobre símbolos, arte e conspiração religiosa.', '2003-03-18', 7, 7, 3),
('O Iluminado', '9780307743657', 'Terror psicológico sobre um hotel mal-assombrado.', '1977-01-28', 5, 5, 3),
('Assassinato no Expresso do Oriente', '9780062693662', 'Clássico policial de Hercule Poirot.', '1934-01-01', 4, 4, 3),
('E Não Sobrou Nenhum', '9780062073488', 'Suspense sobre dez pessoas presas em uma ilha.', '1939-11-06', 5, 5, 3),

-- Fantasia (categoria_id = 4)
('Harry Potter e a Pedra Filosofal', '9788532530788', 'Primeiro livro da saga do bruxo Harry Potter.', '1997-06-26', 10, 10, 4),
('O Senhor dos Anéis: A Sociedade do Anel', '9780544003415', 'Épico de fantasia sobre a jornada para destruir o Anel.', '1954-07-29', 6, 6, 4),
('O Hobbit', '9780547928227', 'Aventura de Bilbo Bolseiro na Terra Média.', '1937-09-21', 5, 5, 4),

-- Biografia (categoria_id = 5)
('Steve Jobs', '9781451648539', 'Biografia autorizada do cofundador da Apple.', '2011-10-24', 3, 3, 5),

-- Tecnologia (categoria_id = 6)
('Código Limpo', '9788576082675', 'Guia sobre como escrever código de qualidade.', '2008-08-01', 8, 8, 6),
('O Programador Pragmático', '9788577807017', 'Boas práticas de desenvolvimento de software.', '1999-10-30', 6, 6, 6),

-- Filosofia (categoria_id = 7)
('A Metamorfose', '9788535911794', 'Novela existencialista sobre transformação e alienação.', '1915-10-01', 4, 4, 7),
('Assim Falou Zaratustra', '9788535911800', 'Obra filosófica de Nietzsche sobre o super-homem.', '1883-01-01', 3, 3, 7),

-- História (categoria_id = 8)
('Sapiens', '9780062316097', 'História da humanidade desde a Idade da Pedra.', '2011-01-01', 7, 7, 8),

-- Autoajuda (categoria_id = 9)
('O Alquimista', '9788576657682', 'Fábula sobre seguir seus sonhos e lenda pessoal.', '1988-01-01', 10, 10, 9),
('Como Fazer Amigos e Influenciar Pessoas', '9788504018189', 'Clássico sobre relacionamentos e influência.', '1936-10-01', 5, 5, 9),

-- Clássicos (categoria_id = 10)
('Mrs. Dalloway', '9780156628709', 'Romance modernista sobre um dia na vida de Clarissa.', '1925-05-14', 3, 3, 10),
('O Velho e o Mar', '9780684801223', 'Novela sobre um pescador e sua luta com um marlim.', '1952-09-01', 4, 4, 10),
('A Hora da Estrela', '9788520925683', 'Romance sobre Macabéa e sua vida humilde.', '1977-10-25', 4, 4, 10);

-- ============================================
-- RELACIONAMENTO LIVRO-AUTOR
-- ============================================
INSERT INTO livro_autor (livro_id, autor_id) VALUES
-- 1984 - George Orwell
(1, 1),
-- Fundação - Isaac Asimov
(2, 3),
-- Eu, Robô - Isaac Asimov
(3, 3),
-- Orgulho e Preconceito - Jane Austen
(4, 10),
-- Cem Anos de Solidão - Gabriel García Márquez
(5, 6),
-- Dom Casmurro - Machado de Assis
(6, 4),
-- O Código Da Vinci - Dan Brown
(7, 15),
-- O Iluminado - Stephen King
(8, 7),
-- Assassinato no Expresso do Oriente - Agatha Christie
(9, 8),
-- E Não Sobrou Nenhum - Agatha Christie
(10, 8),
-- Harry Potter e a Pedra Filosofal - J.K. Rowling
(11, 2),
-- O Senhor dos Anéis - J.R.R. Tolkien
(12, 9),
-- O Hobbit - J.R.R. Tolkien
(13, 9),
-- A Metamorfose - Franz Kafka
(16, 11),
-- Mrs. Dalloway - Virginia Woolf
(20, 12),
-- O Velho e o Mar - Ernest Hemingway
(21, 13),
-- A Hora da Estrela - Clarice Lispector
(22, 5),
-- O Alquimista - Paulo Coelho
(18, 14);

-- ============================================
-- VERIFICAÇÃO
-- ============================================
SELECT 'Categorias inseridas:', COUNT(*) FROM categorias;
SELECT 'Autores inseridos:', COUNT(*) FROM autores;
SELECT 'Livros inseridos:', COUNT(*) FROM livros;
SELECT 'Relacionamentos livro-autor:', COUNT(*) FROM livro_autor;

-- ============================================
-- CONSULTA DE EXEMPLO
-- ============================================
-- Listar todos os livros com autores e categorias
SELECT 
    l.titulo,
    l.isbn,
    c.nome AS categoria,
    STRING_AGG(a.nome, ', ') AS autores,
    l.quantidade_disponivel
FROM livros l
LEFT JOIN categorias c ON l.categoria_id = c.id
LEFT JOIN livro_autor la ON l.id = la.livro_id
LEFT JOIN autores a ON la.autor_id = a.id
GROUP BY l.id, l.titulo, l.isbn, c.nome, l.quantidade_disponivel
ORDER BY l.titulo;
