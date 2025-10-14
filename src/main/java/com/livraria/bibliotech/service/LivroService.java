package com.livraria.bibliotech.service;

import com.livraria.bibliotech.model.Livro;
import com.livraria.bibliotech.repository.LivroRepository;
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
        if (livroRepository.existsByIsbn(livro.getIsbn())) {
            throw new IllegalArgumentException("ISBN já cadastrado");
        }
        return livroRepository.save(livro);
    }

    @Transactional
    public Livro atualizar(Long id, Livro livroAtualizado) {
        Livro livro = buscarPorId(id);
        
        // Verificar se ISBN mudou e se já existe
        if (!livro.getIsbn().equals(livroAtualizado.getIsbn()) && 
            livroRepository.existsByIsbn(livroAtualizado.getIsbn())) {
            throw new IllegalArgumentException("ISBN já cadastrado");
        }

        livro.setTitulo(livroAtualizado.getTitulo());
        livro.setIsbn(livroAtualizado.getIsbn());
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
        livroRepository.delete(livro);
    }

    public Livro buscarPorId(Long id) {
        return livroRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Livro não encontrado"));
    }

    public List<Livro> listarTodos() {
        return livroRepository.findAll();
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
            throw new IllegalStateException("Livro sem estoque disponível");
        }
        livro.setQuantidadeDisponivel(livro.getQuantidadeDisponivel() - 1);
        livroRepository.save(livro);
    }

    @Transactional
    public void aumentarEstoque(Long id) {
        Livro livro = buscarPorId(id);
        if (livro.getQuantidadeDisponivel() >= livro.getQuantidadeTotal()) {
            throw new IllegalStateException("Quantidade disponível já está no máximo");
        }
        livro.setQuantidadeDisponivel(livro.getQuantidadeDisponivel() + 1);
        livroRepository.save(livro);
    }
}
