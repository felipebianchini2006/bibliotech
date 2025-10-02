package com.livraria.bibliotech.repository;

import com.livraria.bibliotech.model.Categoria;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface CategoriaRepository extends JpaRepository<Categoria, Long> {

    // Buscar categoria por nome
    Optional<Categoria> findByNome(String nome);

    // Buscar categorias por nome (contém)
    List<Categoria> findByNomeContainingIgnoreCase(String nome);

    // Verificar se categoria existe por nome
    boolean existsByNome(String nome);

    // Buscar categorias com livros
    @Query("SELECT DISTINCT c FROM Categoria c JOIN c.livros l")
    List<Categoria> findCategoriasComLivros();

    // Contar livros por categoria
    @Query("SELECT COUNT(l) FROM Livro l WHERE l.categoria.id = :categoriaId")
    Long contarLivrosPorCategoria(Long categoriaId);
}
