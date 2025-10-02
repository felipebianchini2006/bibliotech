-- Script para inserir dados iniciais de teste

-- Inserir categorias
INSERT INTO categorias (nome, descricao) VALUES
('Ficção', 'Livros de ficção literária'),
('Romance', 'Livros de romance'),
('Suspense', 'Livros de suspense e mistério'),
('Autoajuda', 'Livros de desenvolvimento pessoal'),
('Tecnologia', 'Livros sobre tecnologia e programação'),
('História', 'Livros históricos'),
('Biografia', 'Biografias e memórias'),
('Fantasia', 'Livros de fantasia'),
('Aventura', 'Livros de aventura'),
('Ciência', 'Livros científicos');

-- Inserir autores
INSERT INTO autores (nome, biografia, nacionalidade) VALUES
('Machado de Assis', 'Escritor brasileiro considerado um dos maiores nomes da literatura brasileira', 'Brasileira'),
('Jorge Amado', 'Escritor brasileiro conhecido por obras que retratam a Bahia', 'Brasileira'),
('Clarice Lispector', 'Escritora e jornalista nascida na Ucrânia, naturalizada brasileira', 'Brasileira'),
('Paulo Coelho', 'Escritor brasileiro de grande sucesso internacional', 'Brasileira'),
('J.K. Rowling', 'Autora britânica da série Harry Potter', 'Britânica'),
('George Orwell', 'Escritor e jornalista britânico', 'Britânica'),
('Agatha Christie', 'Escritora britânica conhecida por seus romances policiais', 'Britânica');

-- Inserir usuário administrador padrão
-- Senha: admin123 (você deve implementar hash de senha no código)
INSERT INTO usuarios (nome, email, senha, cpf, role, ativo, data_cadastro) VALUES
('Administrador', 'admin@bibliotech.com', 'admin123', '00000000000', 'ADMIN', true, NOW());

-- Inserir usuário teste
-- Senha: user123 (você deve implementar hash de senha no código)
INSERT INTO usuarios (nome, email, senha, telefone, cpf, role, ativo, data_cadastro) VALUES
('João Silva', 'joao@email.com', 'user123', '11999999999', '12345678900', 'USER', true, NOW());
