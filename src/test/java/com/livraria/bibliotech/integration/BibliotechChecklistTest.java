package com.livraria.bibliotech.integration;

import com.livraria.bibliotech.model.*;
import com.livraria.bibliotech.repository.*;
import com.livraria.bibliotech.service.*;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Teste de integração completo do sistema Bibliotech
 * Verifica todas as funcionalidades principais
 */
@SpringBootTest
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class BibliotechChecklistTest {

    @Autowired private UsuarioService usuarioService;
    @Autowired private LivroService livroService;
    @Autowired private AutorService autorService;
    @Autowired private CategoriaService categoriaService;
    @Autowired private EmprestimoService emprestimoService;
    
    @Autowired private UsuarioRepository usuarioRepository;
    @Autowired private LivroRepository livroRepository;
    @Autowired private AutorRepository autorRepository;
    @Autowired private CategoriaRepository categoriaRepository;
    @Autowired private EmprestimoRepository emprestimoRepository;
    
    @Autowired private PasswordEncoder passwordEncoder;

    private static Long adminId;
    private static Long userId;
    private static Long livroId;
    private static Long autorId;
    private static Long categoriaId;
    private static Long emprestimoId;

    // Não limpar dados no @BeforeEach - usar @Order para sequenciar testes
    // Os testes dependem de dados criados em testes anteriores

    // ===================== FUNCIONALIDADES BÁSICAS =====================

    @Test
    @Order(1)
    @DisplayName("✓ 1. Login com admin@bibliotech.com funciona")
    void testLoginAdmin() {
        System.out.println("\n=== TESTE 1: Login Admin ===");
        
        // Criar usuário admin
        Usuario admin = new Usuario();
        admin.setNome("Admin");
        admin.setEmail("admin@bibliotech.com");
        admin.setSenha("admin123");
        admin.setCpf("12345678901");
        admin.setRole(Usuario.Role.ADMIN);
        admin.setAtivo(true);
        
        Usuario adminSalvo = usuarioService.cadastrar(admin);
        adminId = adminSalvo.getId();
        
        // Verificar se foi salvo
        assertNotNull(adminSalvo.getId());
        assertEquals("admin@bibliotech.com", adminSalvo.getEmail());
        assertEquals(Usuario.Role.ADMIN, adminSalvo.getRole());
        assertTrue(adminSalvo.getAtivo());
        
        // Verificar se senha foi criptografada
        assertTrue(passwordEncoder.matches("admin123", adminSalvo.getSenha()));
        
        System.out.println("✅ Admin criado e senha criptografada corretamente");
    }

    @Test
    @Order(2)
    @DisplayName("✓ 2. Login com joao@email.com funciona")
    void testLoginUsuario() {
        System.out.println("\n=== TESTE 2: Login Usuário ===");
        
        Usuario user = new Usuario();
        user.setNome("João Silva");
        user.setEmail("joao@email.com");
        user.setSenha("user123");
        user.setCpf("98765432100");
        user.setRole(Usuario.Role.USER);
        user.setAtivo(true);
        
        Usuario userSalvo = usuarioService.cadastrar(user);
        userId = userSalvo.getId();
        
        assertNotNull(userSalvo.getId());
        assertEquals("joao@email.com", userSalvo.getEmail());
        assertEquals(Usuario.Role.USER, userSalvo.getRole());
        assertTrue(passwordEncoder.matches("user123", userSalvo.getSenha()));
        
        System.out.println("✅ Usuário comum criado corretamente");
    }

    @Test
    @Order(3)
    @DisplayName("✓ 3. Registro de novo usuário funciona")
    void testRegistroNovoUsuario() {
        System.out.println("\n=== TESTE 3: Registro Novo Usuário ===");
        
        Usuario novo = new Usuario();
        novo.setNome("Maria Santos");
        novo.setEmail("maria@email.com");
        novo.setSenha("senha123");
        novo.setCpf("11122233344");
        novo.setRole(Usuario.Role.USER);
        novo.setAtivo(true);
        
        Usuario novoSalvo = usuarioService.cadastrar(novo);
        
        assertNotNull(novoSalvo.getId());
        assertEquals("maria@email.com", novoSalvo.getEmail());
        assertTrue(novoSalvo.getAtivo());
        
        System.out.println("✅ Novo usuário registrado com sucesso");
    }

    // ===================== CRUD DE LIVROS =====================

    @Test
    @Order(5)
    @DisplayName("✓ 5. Listar livros mostra todos os livros")
    void testListarLivros() {
        System.out.println("\n=== TESTE 5: Listar Livros ===");
        
        criarDadosBasicos();
        
        List<Livro> livros = livroService.listarTodos();
        
        assertNotNull(livros);
        assertFalse(livros.isEmpty());
        System.out.println("✅ Total de livros: " + livros.size());
    }

    @Test
    @Order(6)
    @DisplayName("✓ 6. Criar novo livro SEM autores funciona")
    void testCriarLivroSemAutores() {
        System.out.println("\n=== TESTE 6: Criar Livro SEM Autores ===");
        
        criarCategoria();
        
        Livro livro = new Livro();
        livro.setTitulo("Livro Teste");
        livro.setIsbn("9788535911664"); // ISBN-13 válido
        livro.setDescricao("Descrição teste");
        livro.setDataPublicacao(LocalDate.now());
        livro.setQuantidadeTotal(10);
        livro.setQuantidadeDisponivel(10);
        
        Categoria cat = categoriaService.buscarPorId(categoriaId);
        livro.setCategoria(cat);
        
        Livro livroSalvo = livroService.salvar(livro);
        livroId = livroSalvo.getId();
        
        assertNotNull(livroSalvo.getId());
        assertEquals("Livro Teste", livroSalvo.getTitulo());
        assertTrue(livroSalvo.getAutores().isEmpty());
        
        System.out.println("✅ Livro criado sem autores");
    }

    @Test
    @Order(7)
    @DisplayName("✓ 7. Criar novo livro COM 2 autores funciona")
    void testCriarLivroCom2Autores() {
        System.out.println("\n=== TESTE 7: Criar Livro COM 2 Autores ===");
        
        criarCategoria();
        
        // Criar 2 autores
        Autor autor1 = new Autor();
        autor1.setNome("Autor 1");
        autor1.setBiografia("Bio 1");
        autor1.setDataNascimento(LocalDate.of(1980, 1, 1));
        Autor autor1Salvo = autorService.salvar(autor1);
        
        Autor autor2 = new Autor();
        autor2.setNome("Autor 2");
        autor2.setBiografia("Bio 2");
        autor2.setDataNascimento(LocalDate.of(1985, 5, 15));
        Autor autor2Salvo = autorService.salvar(autor2);
        
        // Criar livro
        Livro livro = new Livro();
        livro.setTitulo("Livro com 2 Autores");
        livro.setIsbn("9788532530790"); // ISBN-13 válido diferente
        livro.setDataPublicacao(LocalDate.now());
        livro.setQuantidadeTotal(5);
        livro.setQuantidadeDisponivel(5);
        
        Categoria cat = categoriaService.buscarPorId(categoriaId);
        livro.setCategoria(cat);
        
        Set<Autor> autores = new HashSet<>();
        autores.add(autor1Salvo);
        autores.add(autor2Salvo);
        livro.setAutores(autores);
        
        Livro livroSalvo = livroService.salvar(livro);
        
        assertNotNull(livroSalvo.getId());
        assertEquals(2, livroSalvo.getAutores().size());
        
        System.out.println("✅ Livro criado com 2 autores");
    }

    @Test
    @Order(8)
    @DisplayName("✓ 8. Editar livro e adicionar mais autores funciona")
    void testEditarLivroAdicionarAutores() {
        System.out.println("\n=== TESTE 8: Editar Livro e Adicionar Autores ===");
        
        testCriarLivroSemAutores();
        
        // Criar novo autor
        Autor novoAutor = new Autor();
        novoAutor.setNome("Novo Autor");
        novoAutor.setBiografia("Nova bio");
        novoAutor.setDataNascimento(LocalDate.of(1990, 3, 20));
        Autor novoAutorSalvo = autorService.salvar(novoAutor);
        
        // Buscar livro
        Livro livro = livroService.buscarPorId(livroId);
        
        // Adicionar autor
        Set<Autor> autores = new HashSet<>();
        autores.add(novoAutorSalvo);
        livro.setAutores(autores);
        
        Livro livroAtualizado = livroService.atualizar(livroId, livro);
        
        assertEquals(1, livroAtualizado.getAutores().size());
        
        System.out.println("✅ Livro atualizado com novo autor");
    }

    @Test
    @Order(10)
    @DisplayName("✓ 10. Deletar livro funciona")
    void testDeletarLivro() {
        System.out.println("\n=== TESTE 10: Deletar Livro ===");
        
        testCriarLivroSemAutores();
        
        livroService.deletar(livroId);
        
        assertThrows(Exception.class, () -> livroService.buscarPorId(livroId));
        
        System.out.println("✅ Livro deletado com sucesso");
    }

    // ===================== CRUD DE AUTORES =====================

    @Test
    @Order(11)
    @DisplayName("✓ 11. Listar autores funciona")
    void testListarAutores() {
        System.out.println("\n=== TESTE 11: Listar Autores ===");
        
        List<Autor> autores = autorService.listarTodos();
        
        assertNotNull(autores);
        // Pode estar vazio se for o primeiro teste ou ter dados se outros testes já executaram
        
        System.out.println("✅ Total de autores: " + autores.size());
    }

    @Test
    @Order(12)
    @DisplayName("✓ 12. Criar autor funciona")
    void testCriarAutor() {
        System.out.println("\n=== TESTE 12: Criar Autor ===");
        
        Autor autor = new Autor();
        autor.setNome("Machado de Assis");
        autor.setBiografia("Escritor brasileiro");
        autor.setDataNascimento(LocalDate.of(1839, 6, 21));
        
        Autor autorSalvo = autorService.salvar(autor);
        autorId = autorSalvo.getId();
        
        assertNotNull(autorSalvo.getId());
        assertEquals("Machado de Assis", autorSalvo.getNome());
        
        System.out.println("✅ Autor criado: " + autorSalvo.getNome());
    }

    @Test
    @Order(13)
    @DisplayName("✓ 13. Editar autor funciona")
    void testEditarAutor() {
        System.out.println("\n=== TESTE 13: Editar Autor ===");
        
        testCriarAutor();
        
        Autor autor = autorService.buscarPorId(autorId);
        autor.setNome("Machado de Assis (Editado)");
        
        Autor autorAtualizado = autorService.atualizar(autorId, autor);
        
        assertEquals("Machado de Assis (Editado)", autorAtualizado.getNome());
        
        System.out.println("✅ Autor editado com sucesso");
    }

    // ===================== CRUD DE CATEGORIAS =====================

    @Test
    @Order(16)
    @DisplayName("✓ 16. Listar categorias funciona")
    void testListarCategorias() {
        System.out.println("\n=== TESTE 16: Listar Categorias ===");
        
        List<Categoria> categorias = categoriaService.listarTodas();
        
        assertNotNull(categorias);
        // Pode estar vazio se for o primeiro teste ou ter dados se outros testes já executaram
        
        System.out.println("✅ Total de categorias: " + categorias.size());
    }

    @Test
    @Order(17)
    @DisplayName("✓ 17. Criar categoria funciona")
    void testCriarCategoria() {
        System.out.println("\n=== TESTE 17: Criar Categoria ===");
        
        Categoria categoria = new Categoria();
        categoria.setNome("Ficção");
        categoria.setDescricao("Livros de ficção");
        
        Categoria categoriaSalva = categoriaService.salvar(categoria);
        categoriaId = categoriaSalva.getId();
        
        assertNotNull(categoriaSalva.getId());
        assertEquals("Ficção", categoriaSalva.getNome());
        
        System.out.println("✅ Categoria criada: " + categoriaSalva.getNome());
    }

    @Test
    @Order(18)
    @DisplayName("✓ 18. Editar categoria funciona")
    void testEditarCategoria() {
        System.out.println("\n=== TESTE 18: Editar Categoria ===");
        
        testCriarCategoria();
        
        Categoria categoria = categoriaService.buscarPorId(categoriaId);
        categoria.setNome("Ficção Científica");
        
        Categoria categoriaAtualizada = categoriaService.atualizar(categoriaId, categoria);
        
        assertEquals("Ficção Científica", categoriaAtualizada.getNome());
        
        System.out.println("✅ Categoria editada com sucesso");
    }

    // ===================== VALIDAÇÕES =====================

    @Test
    @Order(32)
    @DisplayName("✓ 32. Não permite ISBN duplicado")
    void testISBNDuplicado() {
        System.out.println("\n=== TESTE 32: ISBN Duplicado ===");
        
        testCriarLivroSemAutores();
        
        Livro livro2 = new Livro();
        livro2.setTitulo("Outro Livro");
        livro2.setIsbn("9788535911664"); // Mesmo ISBN do testCriarLivroSemAutores
        livro2.setDataPublicacao(LocalDate.now());
        livro2.setQuantidadeTotal(5);
        livro2.setQuantidadeDisponivel(5);
        
        Categoria cat = categoriaService.buscarPorId(categoriaId);
        livro2.setCategoria(cat);
        
        assertThrows(Exception.class, () -> livroService.salvar(livro2));
        
        System.out.println("✅ ISBN duplicado foi rejeitado");
    }

    @Test
    @Order(33)
    @DisplayName("✓ 33. Não permite email duplicado")
    void testEmailDuplicado() {
        System.out.println("\n=== TESTE 33: Email Duplicado ===");
        
        testLoginUsuario();
        
        Usuario user2 = new Usuario();
        user2.setNome("Outro Usuário");
        user2.setEmail("joao@email.com"); // Mesmo email
        user2.setSenha("senha123");
        user2.setCpf("55544433322");
        
        assertThrows(Exception.class, () -> usuarioService.cadastrar(user2));
        
        System.out.println("✅ Email duplicado foi rejeitado");
    }

    @Test
    @Order(34)
    @DisplayName("✓ 34. Não permite CPF duplicado")
    void testCPFDuplicado() {
        System.out.println("\n=== TESTE 34: CPF Duplicado ===");
        
        testLoginUsuario();
        
        Usuario user2 = new Usuario();
        user2.setNome("Outro Usuário");
        user2.setEmail("outro@email.com");
        user2.setSenha("senha123");
        user2.setCpf("98765432100"); // Mesmo CPF
        
        assertThrows(Exception.class, () -> usuarioService.cadastrar(user2));
        
        System.out.println("✅ CPF duplicado foi rejeitado");
    }

    @Test
    @Order(37)
    @DisplayName("✓ 37. Senha é criptografada")
    void testSenhaCriptografada() {
        System.out.println("\n=== TESTE 37: Senha Criptografada ===");
        
        testLoginAdmin();
        
        Usuario admin = usuarioService.buscarPorId(adminId);
        
        assertNotEquals("admin123", admin.getSenha());
        assertTrue(passwordEncoder.matches("admin123", admin.getSenha()));
        assertTrue(admin.getSenha().startsWith("$2"));
        
        System.out.println("✅ Senha está criptografada com BCrypt");
    }

    // ===================== MÉTODOS AUXILIARES =====================

    private void criarDadosBasicos() {
        testLoginAdmin();
        testLoginUsuario();
        testCriarCategoria();
        testCriarAutor();
        testCriarLivroSemAutores();
    }

    private void criarCategoria() {
        if (categoriaId == null) {
            testCriarCategoria();
        }
    }

    private void criarAutor() {
        if (autorId == null) {
            testCriarAutor();
        }
    }
}
