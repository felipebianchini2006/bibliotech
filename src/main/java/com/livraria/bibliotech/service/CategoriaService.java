package com.livraria.bibliotech.service;

import com.livraria.bibliotech.model.Categoria;
import com.livraria.bibliotech.repository.CategoriaRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class CategoriaService {

    private final CategoriaRepository categoriaRepository;

    @Transactional
    public Categoria salvar(Categoria categoria) {
        if (categoriaRepository.existsByNome(categoria.getNome())) {
            throw new IllegalArgumentException("Categoria já existe");
        }
        return categoriaRepository.save(categoria);
    }

    @Transactional
    public Categoria atualizar(Long id, Categoria categoriaAtualizada) {
        Categoria categoria = buscarPorId(id);
        
        if (!categoria.getNome().equals(categoriaAtualizada.getNome()) && 
            categoriaRepository.existsByNome(categoriaAtualizada.getNome())) {
            throw new IllegalArgumentException("Nome da categoria já existe");
        }

        categoria.setNome(categoriaAtualizada.getNome());
        categoria.setDescricao(categoriaAtualizada.getDescricao());

        return categoriaRepository.save(categoria);
    }

    @Transactional
    public void deletar(Long id) {
        Categoria categoria = buscarPorId(id);
        categoriaRepository.delete(categoria);
    }

    public Categoria buscarPorId(Long id) {
        return categoriaRepository.findById(id)
            .orElseThrow(() -> new IllegalArgumentException("Categoria não encontrada"));
    }

    public List<Categoria> listarTodas() {
        return categoriaRepository.findAll();
    }

    public List<Categoria> buscarPorNome(String nome) {
        return categoriaRepository.findByNomeContainingIgnoreCase(nome);
    }
}
