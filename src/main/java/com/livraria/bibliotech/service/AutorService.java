package com.livraria.bibliotech.service;

import com.livraria.bibliotech.exception.ResourceNotFoundException;
import com.livraria.bibliotech.model.Autor;
import com.livraria.bibliotech.repository.AutorRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class AutorService {

    private final AutorRepository autorRepository;

    @Transactional
    public Autor salvar(Autor autor) {
        return autorRepository.save(autor);
    }

    @Transactional
    public Autor atualizar(Long id, Autor autorAtualizado) {
        Autor autor = buscarPorId(id);

        autor.setNome(autorAtualizado.getNome());
        autor.setBiografia(autorAtualizado.getBiografia());
        autor.setDataNascimento(autorAtualizado.getDataNascimento());
        autor.setNacionalidade(autorAtualizado.getNacionalidade());
        autor.setFotoUrl(autorAtualizado.getFotoUrl());

        return autorRepository.save(autor);
    }

    @Transactional
    public void deletar(Long id) {
        Autor autor = buscarPorId(id);
        autorRepository.delete(autor);
    }

    public Autor buscarPorId(Long id) {
        return autorRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Autor", id));
    }
    
    public Autor buscarPorIdComLivros(Long id) {
        return autorRepository.findByIdWithLivros(id)
            .orElseThrow(() -> new ResourceNotFoundException("Autor", id));
    }

    public List<Autor> listarTodos() {
        return autorRepository.findAll();
    }

    public List<Autor> buscarPorNome(String nome) {
        return autorRepository.findByNomeContainingIgnoreCase(nome);
    }
}
