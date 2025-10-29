package com.livraria.bibliotech.service;

import com.livraria.bibliotech.exception.BusinessException;
import com.livraria.bibliotech.exception.ResourceNotFoundException;
import com.livraria.bibliotech.model.Autor;
import com.livraria.bibliotech.model.Categoria;
import com.livraria.bibliotech.model.Livro;
import com.livraria.bibliotech.repository.AutorRepository;
import com.livraria.bibliotech.repository.CategoriaRepository;
import com.livraria.bibliotech.repository.LivroRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

@Slf4j
@Service
@RequiredArgsConstructor
public class LivroService {

    private final LivroRepository livroRepository;
    private final AutorRepository autorRepository;
    private final CategoriaRepository categoriaRepository;

    @Transactional
    public Livro salvar(Livro livro) {
        log.info("Salvando livro - ISBN: {}", livro.getIsbn());
        
        // Limpar ISBN (remover espaços e hífens)
        String isbnLimpo = livro.getIsbn().replaceAll("[^0-9X]", "");
        
        if (livroRepository.existsByIsbn(isbnLimpo)) {
            log.warn("Tentativa de salvar livro com ISBN duplicado: {}", isbnLimpo);
            throw new BusinessException("ISBN já cadastrado", "ISBN_ALREADY_EXISTS");
        }
        
        // Limpar e armazenar ISBN sem formatação
        livro.setIsbn(isbnLimpo);
        
        // Validar quantidade disponível
        if (livro.getQuantidadeDisponivel() > livro.getQuantidadeTotal()) {
            throw new BusinessException("Quantidade disponível não pode ser maior que quantidade total", "QUANTIDADE_INVALIDA");
        }
        
        // Buscar categoria do banco
        if (livro.getCategoria() != null && livro.getCategoria().getId() != null) {
            Categoria categoria = categoriaRepository.findById(livro.getCategoria().getId())
                .orElseThrow(() -> new ResourceNotFoundException("Categoria", livro.getCategoria().getId()));
            livro.setCategoria(categoria);
            log.debug("Categoria atribuída: {}", categoria.getNome());
        }
        
        // Buscar autores do banco antes de salvar
        if (livro.getAutores() != null && !livro.getAutores().isEmpty()) {
            Set<Autor> autoresPersistidos = new HashSet<>();
            for (Autor autor : livro.getAutores()) {
                if (autor.getId() != null) {
                    Autor autorPersistido = autorRepository.findById(autor.getId())
                        .orElseThrow(() -> new ResourceNotFoundException("Autor", autor.getId()));
                    autoresPersistidos.add(autorPersistido);
                    log.debug("Autor adicionado: {} (ID: {})", autorPersistido.getNome(), autorPersistido.getId());
                }
            }
            livro.setAutores(autoresPersistidos);
            log.info("Total de autores vinculados: {}", autoresPersistidos.size());
        }
        
        Livro livroSalvo = livroRepository.save(livro);
        log.info("Livro salvo com sucesso - ID: {}, ISBN: {}", livroSalvo.getId(), livroSalvo.getIsbn());
        return livroSalvo;
    }

    @Transactional
    public Livro atualizar(Long id, Livro livroAtualizado) {
        log.info("Atualizando livro - ID: {}", id);
        
        Livro livro = buscarPorId(id);
        
        // Limpar ISBN (remover espaços e hífens)
        String isbnLimpo = livroAtualizado.getIsbn().replaceAll("[^0-9X]", "");
        
        // Verificar se ISBN mudou e se já existe
        if (!livro.getIsbn().equals(isbnLimpo) && 
            livroRepository.existsByIsbn(isbnLimpo)) {
            log.warn("Tentativa de atualizar livro com ISBN duplicado: {}", isbnLimpo);
            throw new BusinessException("ISBN já cadastrado", "ISBN_ALREADY_EXISTS");
        }
        
        // Validar quantidade disponível
        if (livroAtualizado.getQuantidadeDisponivel() > livroAtualizado.getQuantidadeTotal()) {
            throw new BusinessException("Quantidade disponível não pode ser maior que quantidade total", "QUANTIDADE_INVALIDA");
        }

        livro.setTitulo(livroAtualizado.getTitulo());
        livro.setIsbn(isbnLimpo);
        livro.setDescricao(livroAtualizado.getDescricao());
        livro.setDataPublicacao(livroAtualizado.getDataPublicacao());
        livro.setQuantidadeTotal(livroAtualizado.getQuantidadeTotal());
        livro.setQuantidadeDisponivel(livroAtualizado.getQuantidadeDisponivel());
        livro.setImagemUrl(livroAtualizado.getImagemUrl());
        
        // Buscar categoria do banco
        if (livroAtualizado.getCategoria() != null && livroAtualizado.getCategoria().getId() != null) {
            Categoria categoria = categoriaRepository.findById(livroAtualizado.getCategoria().getId())
                .orElseThrow(() -> new ResourceNotFoundException("Categoria", livroAtualizado.getCategoria().getId()));
            livro.setCategoria(categoria);
            log.debug("Categoria atualizada: {}", categoria.getNome());
        }
        
        // Buscar autores do banco antes de atualizar
        if (livroAtualizado.getAutores() != null && !livroAtualizado.getAutores().isEmpty()) {
            Set<Autor> autoresPersistidos = new HashSet<>();
            for (Autor autor : livroAtualizado.getAutores()) {
                if (autor.getId() != null) {
                    Autor autorPersistido = autorRepository.findById(autor.getId())
                        .orElseThrow(() -> new ResourceNotFoundException("Autor", autor.getId()));
                    autoresPersistidos.add(autorPersistido);
                    log.debug("Autor atualizado: {} (ID: {})", autorPersistido.getNome(), autorPersistido.getId());
                }
            }
            livro.setAutores(autoresPersistidos);
            log.info("Total de autores atualizados: {}", autoresPersistidos.size());
        } else {
            livro.setAutores(new HashSet<>());
            log.info("Autores removidos do livro");
        }

        Livro livroSalvo = livroRepository.save(livro);
        log.info("Livro atualizado com sucesso - ID: {}, ISBN: {}", livroSalvo.getId(), livroSalvo.getIsbn());
        return livroSalvo;
    }

    @Transactional
    public void deletar(Long id) {
        Livro livro = buscarPorId(id);
        
        // Verificar se há empréstimos ativos
        if (!livro.getEmprestimos().isEmpty()) {
            boolean hasActiveLoans = livro.getEmprestimos().stream()
                .anyMatch(e -> e.getStatus() == com.livraria.bibliotech.model.Emprestimo.Status.ATIVO);
            
            if (hasActiveLoans) {
                throw new BusinessException(
                    "Não é possível excluir livro com empréstimos ativos", 
                    "ACTIVE_LOANS_EXISTS"
                );
            }
        }
        
        livroRepository.delete(livro);
    }

    public Livro buscarPorId(Long id) {
        return livroRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Livro", id));
    }
    
    public Livro buscarPorIdComDetalhes(Long id) {
        return livroRepository.findByIdWithDetails(id)
            .orElseThrow(() -> new ResourceNotFoundException("Livro", id));
    }

    public List<Livro> listarTodos() {
        return livroRepository.findAllWithCategoria();
    }

    public List<Livro> listarDisponiveis() {
        return livroRepository.findLivrosDisponiveis();
    }

    public List<Livro> buscarPorTitulo(String titulo) {
        return livroRepository.findByTituloContainingIgnoreCase(titulo);
    }

    public List<Livro> buscarPorCategoria(Long categoriaId) {
        return livroRepository.findByCategoriaId(categoriaId);
    }

    public List<Livro> buscarPorAutor(Long autorId) {
        return livroRepository.findByAutorId(autorId);
    }

    @Transactional
    public void diminuirEstoque(Long id) {
        Livro livro = buscarPorId(id);
        if (livro.getQuantidadeDisponivel() <= 0) {
            throw new BusinessException("Livro sem estoque disponível", "OUT_OF_STOCK");
        }
        livro.setQuantidadeDisponivel(livro.getQuantidadeDisponivel() - 1);
        livroRepository.save(livro);
    }

    @Transactional
    public void aumentarEstoque(Long id) {
        Livro livro = buscarPorId(id);
        if (livro.getQuantidadeDisponivel() >= livro.getQuantidadeTotal()) {
            throw new BusinessException(
                "Quantidade disponível já está no máximo", 
                "MAX_STOCK_REACHED"
            );
        }
        livro.setQuantidadeDisponivel(livro.getQuantidadeDisponivel() + 1);
        livroRepository.save(livro);
    }
}
