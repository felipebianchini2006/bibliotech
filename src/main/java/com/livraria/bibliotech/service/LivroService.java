package com.livraria.bibliotech.service;

import com.livraria.bibliotech.exception.BusinessException;
import com.livraria.bibliotech.exception.ResourceNotFoundException;
import com.livraria.bibliotech.exception.ValidationException;
import com.livraria.bibliotech.model.Livro;
import com.livraria.bibliotech.repository.LivroRepository;
import com.livraria.bibliotech.validator.ISBNValidator;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class LivroService {

    private final LivroRepository livroRepository;

    @Transactional
    public Livro salvar(Livro livro) {
        // Limpar ISBN (remover espaços e hífens)
        String isbnLimpo = livro.getIsbn().replaceAll("[^0-9X]", "");
        
        if (livroRepository.existsByIsbn(isbnLimpo)) {
            throw new BusinessException("ISBN já cadastrado", "ISBN_ALREADY_EXISTS");
        }
        
        // Limpar e armazenar ISBN sem formatação
        livro.setIsbn(isbnLimpo);
        
        return livroRepository.save(livro);
    }

    @Transactional
    public Livro atualizar(Long id, Livro livroAtualizado) {
        Livro livro = buscarPorId(id);
        
        // Limpar ISBN (remover espaços e hífens)
        String isbnLimpo = livroAtualizado.getIsbn().replaceAll("[^0-9X]", "");
        
        // Verificar se ISBN mudou e se já existe
        if (!livro.getIsbn().equals(isbnLimpo) && 
            livroRepository.existsByIsbn(isbnLimpo)) {
            throw new BusinessException("ISBN já cadastrado", "ISBN_ALREADY_EXISTS");
        }

        livro.setTitulo(livroAtualizado.getTitulo());
        livro.setIsbn(isbnLimpo);
        livro.setDescricao(livroAtualizado.getDescricao());
        livro.setDataPublicacao(livroAtualizado.getDataPublicacao());
        livro.setQuantidadeTotal(livroAtualizado.getQuantidadeTotal());
        livro.setQuantidadeDisponivel(livroAtualizado.getQuantidadeDisponivel());
        livro.setImagemUrl(livroAtualizado.getImagemUrl());
        livro.setCategoria(livroAtualizado.getCategoria());
        livro.setAutores(livroAtualizado.getAutores());

        return livroRepository.save(livro);
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
