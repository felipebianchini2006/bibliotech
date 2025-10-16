package com.livraria.bibliotech.repository;

import com.livraria.bibliotech.model.Livro;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface LivroRepository extends JpaRepository<Livro, Long> {

    // Buscar livro por ISBN
    Optional<Livro> findByIsbn(String isbn);

    // Buscar livros por título (contém)
    List<Livro> findByTituloContainingIgnoreCase(String titulo);

    // Buscar livros por categoria
    List<Livro> findByCategoriaId(Long categoriaId);

    // Buscar livros por autor
    @Query("SELECT l FROM Livro l JOIN l.autores a WHERE a.id = :autorId")
    List<Livro> findByAutorId(@Param("autorId") Long autorId);

    // Buscar livros disponíveis
    @Query("SELECT l FROM Livro l WHERE l.quantidadeDisponivel > 0")
    List<Livro> findLivrosDisponiveis();

    // Buscar livros por autor nome
    @Query("SELECT l FROM Livro l JOIN l.autores a WHERE LOWER(a.nome) LIKE LOWER(CONCAT('%', :nomeAutor, '%'))")
    List<Livro> findByAutorNome(@Param("nomeAutor") String nomeAutor);

    // Buscar livros por categoria nome
    @Query("SELECT l FROM Livro l WHERE LOWER(l.categoria.nome) LIKE LOWER(CONCAT('%', :nomeCategoria, '%'))")
    List<Livro> findByCategoriaNome(@Param("nomeCategoria") String nomeCategoria);

    // Verificar se ISBN já existe
    boolean existsByIsbn(String isbn);
    
    // Buscar livro com autores e categoria carregados (para detalhes)
    @Query("SELECT DISTINCT l FROM Livro l LEFT JOIN FETCH l.autores LEFT JOIN FETCH l.categoria WHERE l.id = :id")
    Optional<Livro> findByIdWithDetails(@Param("id") Long id);
    
    // Buscar todos os livros com autores e categoria carregados (para lista)
    @Query("SELECT DISTINCT l FROM Livro l LEFT JOIN FETCH l.categoria ORDER BY l.titulo")
    List<Livro> findAllWithCategoria();
}
