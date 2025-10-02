package com.livraria.bibliotech.repository;

import com.livraria.bibliotech.model.Emprestimo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

@Repository
public interface EmprestimoRepository extends JpaRepository<Emprestimo, Long> {

    // Buscar empréstimos por usuário
    List<Emprestimo> findByUsuarioId(Long usuarioId);

    // Buscar empréstimos por livro
    List<Emprestimo> findByLivroId(Long livroId);

    // Buscar empréstimos por status
    List<Emprestimo> findByStatus(Emprestimo.Status status);

    // Buscar empréstimos ativos por usuário
    @Query("SELECT e FROM Emprestimo e WHERE e.usuario.id = :usuarioId AND e.status = 'ATIVO'")
    List<Emprestimo> findEmprestimosAtivosPorUsuario(@Param("usuarioId") Long usuarioId);

    // Buscar empréstimos atrasados
    @Query("SELECT e FROM Emprestimo e WHERE e.status = 'ATIVO' AND e.dataPrevistaDevolucao < :dataAtual")
    List<Emprestimo> findEmprestimosAtrasados(@Param("dataAtual") LocalDateTime dataAtual);

    // Buscar empréstimos por período
    @Query("SELECT e FROM Emprestimo e WHERE e.dataEmprestimo BETWEEN :dataInicio AND :dataFim")
    List<Emprestimo> findByPeriodo(
        @Param("dataInicio") LocalDateTime dataInicio, 
        @Param("dataFim") LocalDateTime dataFim
    );

    // Verificar se usuário tem empréstimo ativo do livro
    @Query("SELECT CASE WHEN COUNT(e) > 0 THEN true ELSE false END FROM Emprestimo e " +
           "WHERE e.usuario.id = :usuarioId AND e.livro.id = :livroId AND e.status = 'ATIVO'")
    boolean existeEmprestimoAtivoUsuarioLivro(
        @Param("usuarioId") Long usuarioId, 
        @Param("livroId") Long livroId
    );

    // Contar empréstimos ativos
    @Query("SELECT COUNT(e) FROM Emprestimo e WHERE e.status = 'ATIVO'")
    Long contarEmprestimosAtivos();

    // Buscar últimos empréstimos
    List<Emprestimo> findTop10ByOrderByDataEmprestimoDesc();
}
