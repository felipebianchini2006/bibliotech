package com.livraria.bibliotech.service;

import com.livraria.bibliotech.exception.BusinessException;
import com.livraria.bibliotech.exception.ResourceNotFoundException;
import com.livraria.bibliotech.exception.ValidationException;
import com.livraria.bibliotech.model.Usuario;
import com.livraria.bibliotech.repository.UsuarioRepository;
import com.livraria.bibliotech.validator.CPFValidator;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    @Transactional
    public Usuario cadastrar(Usuario usuario) {
        // Validar CPF
        String cpfLimpo = CPFValidator.cleanCPF(usuario.getCpf());
        if (!CPFValidator.isValidCPF(cpfLimpo)) {
            throw new ValidationException("cpf", "CPF inválido");
        }
        
        // Verificar se email já existe
        if (usuarioRepository.existsByEmail(usuario.getEmail())) {
            throw new BusinessException("Email já cadastrado", "EMAIL_ALREADY_EXISTS");
        }

        // Verificar se CPF já existe
        if (usuarioRepository.existsByCpf(cpfLimpo)) {
            throw new BusinessException("CPF já cadastrado", "CPF_ALREADY_EXISTS");
        }

        // Limpar e armazenar CPF sem formatação
        usuario.setCpf(cpfLimpo);

        // Criptografar senha
        usuario.setSenha(passwordEncoder.encode(usuario.getSenha()));

        return usuarioRepository.save(usuario);
    }

    @Transactional
    public Usuario atualizar(Long id, Usuario usuarioAtualizado) {
        Usuario usuario = buscarPorId(id);

        usuario.setNome(usuarioAtualizado.getNome());
        usuario.setTelefone(usuarioAtualizado.getTelefone());
        usuario.setEndereco(usuarioAtualizado.getEndereco());

        // Atualizar senha apenas se foi fornecida
        if (usuarioAtualizado.getSenha() != null && !usuarioAtualizado.getSenha().isEmpty()) {
            usuario.setSenha(passwordEncoder.encode(usuarioAtualizado.getSenha()));
        }

        return usuarioRepository.save(usuario);
    }

    @Transactional
    public void alterarStatus(Long id, boolean ativo) {
        Usuario usuario = buscarPorId(id);
        usuario.setAtivo(ativo);
        usuarioRepository.save(usuario);
    }

    public Usuario buscarPorId(Long id) {
        return usuarioRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Usuário", id));
    }

    public Optional<Usuario> buscarPorEmail(String email) {
        return usuarioRepository.findByEmail(email);
    }

    public List<Usuario> listarTodos() {
        return usuarioRepository.findAll();
    }

    public List<Usuario> listarAtivos() {
        return usuarioRepository.findByAtivoTrue();
    }

    public Long contarEmprestimosAtivos(Long usuarioId) {
        return usuarioRepository.contarEmprestimosAtivos(usuarioId);
    }
}
