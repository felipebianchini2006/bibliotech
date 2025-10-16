package com.livraria.bibliotech.repository;

import com.livraria.bibliotech.model.Autor;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface AutorRepository extends JpaRepository<Autor, Long> {

    // Buscar autor por nome (contém)
    List<Autor> findByNomeContainingIgnoreCase(String nome);

    // Buscar autores por nacionalidade
    List<Autor> findByNacionalidade(String nacionalidade);

    // Buscar autores com livros
    @Query("SELECT DISTINCT a FROM Autor a JOIN a.livros l")
    List<Autor> findAutoresComLivros();

    // Buscar autor por nome exato
    @Query("SELECT a FROM Autor a WHERE LOWER(a.nome) = LOWER(:nome)")
    List<Autor> findByNomeExato(@Param("nome") String nome);
    
    // Buscar autor com livros carregados (para detalhes)
    @Query("SELECT DISTINCT a FROM Autor a LEFT JOIN FETCH a.livros WHERE a.id = :id")
    Optional<Autor> findByIdWithLivros(@Param("id") Long id);
}
