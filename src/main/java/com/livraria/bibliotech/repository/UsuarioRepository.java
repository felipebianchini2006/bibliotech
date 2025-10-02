package com.livraria.bibliotech.repository;

import com.livraria.bibliotech.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    // Buscar usuário por email
    Optional<Usuario> findByEmail(String email);

    // Buscar usuário por CPF
    Optional<Usuario> findByCpf(String cpf);

    // Buscar usuários por nome (contém)
    List<Usuario> findByNomeContainingIgnoreCase(String nome);

    // Buscar usuários ativos
    List<Usuario> findByAtivoTrue();

    // Buscar usuários por role
    List<Usuario> findByRole(Usuario.Role role);

    // Verificar se email já existe
    boolean existsByEmail(String email);

    // Verificar se CPF já existe
    boolean existsByCpf(String cpf);

    // Buscar usuários com empréstimos ativos
    @Query("SELECT DISTINCT u FROM Usuario u JOIN u.emprestimos e WHERE e.status = 'ATIVO'")
    List<Usuario> findUsuariosComEmprestimosAtivos();

    // Contar empréstimos ativos por usuário
    @Query("SELECT COUNT(e) FROM Emprestimo e WHERE e.usuario.id = :usuarioId AND e.status = 'ATIVO'")
    Long contarEmprestimosAtivos(@Param("usuarioId") Long usuarioId);
}
