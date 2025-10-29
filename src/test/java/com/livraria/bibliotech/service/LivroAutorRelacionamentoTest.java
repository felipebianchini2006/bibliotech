package com.livraria.bibliotech.service;

import com.livraria.bibliotech.model.Autor;
import com.livraria.bibliotech.model.Categoria;
import com.livraria.bibliotech.model.Livro;
import com.livraria.bibliotech.repository.AutorRepository;
import com.livraria.bibliotech.repository.CategoriaRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@Transactional
@DisplayName("Teste de Relacionamento Livro-Autor")
class LivroAutorRelacionamentoTest {

    @Autowired
    private LivroService livroService;

    @Autowired
    private AutorRepository autorRepository;

    @Autowired
    private CategoriaRepository categoriaRepository;

    private Autor autor1;
    private Autor autor2;
    private Categoria categoria;

    @BeforeEach
    void setUp() {
        System.out.println("\n=== SETUP: Criando dados de teste ===");
        
        // Criar categoria
        categoria = new Categoria();
        categoria.setNome("Ficção Científica");
        categoria.setDescricao("Livros de ficção científica");
        categoria = categoriaRepository.save(categoria);
        System.out.println("✓ Categoria criada - ID: " + categoria.getId() + ", Nome: " + categoria.getNome());

        // Criar primeiro autor
        autor1 = new Autor();
        autor1.setNome("Isaac Asimov");
        autor1.setBiografia("Escritor e bioquímico russo-americano");
        autor1.setDataNascimento(LocalDate.of(1920, 1, 2));
        autor1.setNacionalidade("Russo-Americano");
        autor1 = autorRepository.save(autor1);
        System.out.println("✓ Autor 1 criado - ID: " + autor1.getId() + ", Nome: " + autor1.getNome());

        // Criar segundo autor
        autor2 = new Autor();
        autor2.setNome("Arthur C. Clarke");
        autor2.setBiografia("Escritor e inventor britânico");
        autor2.setDataNascimento(LocalDate.of(1917, 12, 16));
        autor2.setNacionalidade("Britânico");
        autor2 = autorRepository.save(autor2);
        System.out.println("✓ Autor 2 criado - ID: " + autor2.getId() + ", Nome: " + autor2.getNome());
    }

    @Test
    @DisplayName("Deve salvar livro com 2 autores e depois editar removendo 1 autor")
    void deveSalvarLivroComDoisAutoresEDepoisRemoverUm() {
        System.out.println("\n=== TESTE 1: Criando livro com 2 autores ===");

        // 1. Criar livro com 2 autores
        Livro livro = new Livro();
        livro.setTitulo("Fundação");
        livro.setIsbn("9780553293357");
        livro.setDescricao("Primeiro livro da série Fundação");
        livro.setDataPublicacao(LocalDate.of(1951, 5, 1));
        livro.setQuantidadeTotal(10);
        livro.setQuantidadeDisponivel(10);
        livro.setCategoria(categoria);

        // Associar os 2 autores (usando apenas ID para simular o que vem do formulário)
        Set<Autor> autores = new HashSet<>();
        Autor autorTemp1 = new Autor();
        autorTemp1.setId(autor1.getId());
        autores.add(autorTemp1);
        
        Autor autorTemp2 = new Autor();
        autorTemp2.setId(autor2.getId());
        autores.add(autorTemp2);
        
        livro.setAutores(autores);

        System.out.println("Salvando livro com 2 autores (IDs: " + autor1.getId() + ", " + autor2.getId() + ")...");

        // 2. Salvar o livro
        Livro livroSalvo = livroService.salvar(livro);
        assertNotNull(livroSalvo.getId(), "Livro deve ter sido salvo com ID");
        System.out.println("✓ Livro salvo - ID: " + livroSalvo.getId());

        // 3. Buscar o livro do banco com fetch dos autores
        Livro livroBuscado = livroService.buscarPorIdComDetalhes(livroSalvo.getId());
        assertNotNull(livroBuscado, "Livro deve ser encontrado");
        System.out.println("✓ Livro buscado do banco - ID: " + livroBuscado.getId());

        // 4. Verificar se os 2 autores estão associados
        Set<Autor> autoresBuscados = livroBuscado.getAutores();
        assertNotNull(autoresBuscados, "Set de autores não deve ser nulo");
        assertEquals(2, autoresBuscados.size(), "Livro deve ter 2 autores");
        System.out.println("✓ Livro possui 2 autores:");
        autoresBuscados.forEach(a -> System.out.println("  - " + a.getNome() + " (ID: " + a.getId() + ")"));

        // Verificar se são os autores corretos
        boolean temAutor1 = autoresBuscados.stream().anyMatch(a -> a.getId().equals(autor1.getId()));
        boolean temAutor2 = autoresBuscados.stream().anyMatch(a -> a.getId().equals(autor2.getId()));
        assertTrue(temAutor1, "Deve conter o autor 1 (Isaac Asimov)");
        assertTrue(temAutor2, "Deve conter o autor 2 (Arthur C. Clarke)");
        System.out.println("✓ Ambos os autores estão corretamente associados");

        System.out.println("\n=== TESTE 2: Editando livro e removendo 1 autor ===");

        // 5. Editar o livro removendo 1 autor (deixar apenas autor1)
        Set<Autor> autoresAtualizados = new HashSet<>();
        Autor autorTempAtualizado = new Autor();
        autorTempAtualizado.setId(autor1.getId());
        autoresAtualizados.add(autorTempAtualizado);
        
        livroBuscado.setAutores(autoresAtualizados);
        System.out.println("Atualizando livro para ter apenas 1 autor (ID: " + autor1.getId() + ")...");

        Livro livroAtualizado = livroService.atualizar(livroBuscado.getId(), livroBuscado);
        System.out.println("✓ Livro atualizado - ID: " + livroAtualizado.getId());

        // 6. Buscar novamente e verificar se agora só tem 1 autor
        Livro livroFinal = livroService.buscarPorIdComDetalhes(livroAtualizado.getId());
        Set<Autor> autoresFinais = livroFinal.getAutores();
        
        assertNotNull(autoresFinais, "Set de autores não deve ser nulo");
        assertEquals(1, autoresFinais.size(), "Livro deve ter apenas 1 autor após atualização");
        System.out.println("✓ Livro agora possui apenas 1 autor:");
        autoresFinais.forEach(a -> System.out.println("  - " + a.getNome() + " (ID: " + a.getId() + ")"));

        // Verificar se é o autor correto (autor1)
        Autor autorFinal = autoresFinais.iterator().next();
        assertEquals(autor1.getId(), autorFinal.getId(), "O autor restante deve ser o Isaac Asimov");
        assertEquals(autor1.getNome(), autorFinal.getNome(), "O nome do autor deve ser Isaac Asimov");
        System.out.println("✓ O autor correto permaneceu associado");

        System.out.println("\n=== TESTE CONCLUÍDO COM SUCESSO ===\n");
    }

    @Test
    @DisplayName("Deve salvar livro sem autores")
    void deveSalvarLivroSemAutores() {
        System.out.println("\n=== TESTE 3: Criando livro sem autores ===");

        Livro livro = new Livro();
        livro.setTitulo("Livro sem Autor");
        livro.setIsbn("9780000000001");
        livro.setDescricao("Livro de teste sem autores");
        livro.setDataPublicacao(LocalDate.of(2024, 1, 1));
        livro.setQuantidadeTotal(5);
        livro.setQuantidadeDisponivel(5);
        livro.setCategoria(categoria);
        livro.setAutores(new HashSet<>());

        System.out.println("Salvando livro sem autores...");

        Livro livroSalvo = livroService.salvar(livro);
        assertNotNull(livroSalvo.getId(), "Livro deve ter sido salvo com ID");
        System.out.println("✓ Livro salvo - ID: " + livroSalvo.getId());

        Livro livroBuscado = livroService.buscarPorIdComDetalhes(livroSalvo.getId());
        assertNotNull(livroBuscado.getAutores(), "Set de autores não deve ser nulo");
        assertTrue(livroBuscado.getAutores().isEmpty(), "Livro não deve ter autores");
        System.out.println("✓ Livro confirmado sem autores");

        System.out.println("\n=== TESTE CONCLUÍDO COM SUCESSO ===\n");
    }

    @Test
    @DisplayName("Deve adicionar autores a um livro que não tinha nenhum")
    void deveAdicionarAutoresALivroSemAutores() {
        System.out.println("\n=== TESTE 4: Adicionando autores a livro sem autores ===");

        // Criar livro sem autores
        Livro livro = new Livro();
        livro.setTitulo("Livro Inicial Sem Autores");
        livro.setIsbn("9780000000002");
        livro.setDescricao("Livro que vai receber autores depois");
        livro.setDataPublicacao(LocalDate.of(2024, 1, 1));
        livro.setQuantidadeTotal(5);
        livro.setQuantidadeDisponivel(5);
        livro.setCategoria(categoria);
        livro.setAutores(new HashSet<>());

        Livro livroSalvo = livroService.salvar(livro);
        System.out.println("✓ Livro criado sem autores - ID: " + livroSalvo.getId());

        // Adicionar 2 autores
        Set<Autor> novosAutores = new HashSet<>();
        Autor autorTemp1 = new Autor();
        autorTemp1.setId(autor1.getId());
        novosAutores.add(autorTemp1);
        
        Autor autorTemp2 = new Autor();
        autorTemp2.setId(autor2.getId());
        novosAutores.add(autorTemp2);
        
        livroSalvo.setAutores(novosAutores);
        System.out.println("Adicionando 2 autores ao livro...");

        Livro livroAtualizado = livroService.atualizar(livroSalvo.getId(), livroSalvo);
        System.out.println("✓ Livro atualizado - ID: " + livroAtualizado.getId());

        // Verificar se os autores foram adicionados
        Livro livroFinal = livroService.buscarPorIdComDetalhes(livroAtualizado.getId());
        assertEquals(2, livroFinal.getAutores().size(), "Livro deve ter 2 autores após atualização");
        System.out.println("✓ Livro agora possui 2 autores:");
        livroFinal.getAutores().forEach(a -> System.out.println("  - " + a.getNome() + " (ID: " + a.getId() + ")"));

        System.out.println("\n=== TESTE CONCLUÍDO COM SUCESSO ===\n");
    }
}
