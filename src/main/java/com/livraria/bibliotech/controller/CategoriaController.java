package com.livraria.bibliotech.controller;

import com.livraria.bibliotech.model.Categoria;
import com.livraria.bibliotech.repository.CategoriaRepository;
import com.livraria.bibliotech.service.CategoriaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Controller para gerenciamento de categorias de livros.
 * Visualização: Todos os usuários autenticados
 * Modificação: Apenas administradores
 */
@Controller
@RequestMapping("/categorias")
@RequiredArgsConstructor
public class CategoriaController {

    private final CategoriaService categoriaService;
    private final CategoriaRepository categoriaRepository;

    /**
     * Lista todas as categorias.
     */
    @GetMapping({"", "/"})
    public String listar(Model model) {
        List<Categoria> categorias = categoriaService.listarTodas();
        
        // Criar mapa com contagem de livros por categoria
        Map<Long, Long> contagemLivros = new HashMap<>();
        for (Categoria cat : categorias) {
            contagemLivros.put(cat.getId(), categoriaRepository.contarLivrosPorCategoria(cat.getId()));
        }
        
        model.addAttribute("categorias", categorias);
        model.addAttribute("contagemLivros", contagemLivros);
        return "categorias/lista";
    }

    /**
     * Exibe formulário para nova categoria.
     */
    @GetMapping("/nova")
    @PreAuthorize("hasRole('ADMIN')")
    public String mostrarFormulario(Model model) {
        model.addAttribute("categoria", new Categoria());
        return "categorias/form";
    }

    /**
     * Processa criação de nova categoria.
     */
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public String salvar(
        @Valid @ModelAttribute Categoria categoria,
        BindingResult result,
        RedirectAttributes redirectAttributes
    ) {
        if (result.hasErrors()) {
            return "categorias/form";
        }

        try {
            categoriaService.salvar(categoria);
            redirectAttributes.addFlashAttribute("mensagem", "Categoria cadastrada com sucesso!");
            return "redirect:/categorias";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erro", e.getMessage());
            return "redirect:/categorias/nova";
        }
    }

    /**
     * Visualiza detalhes de uma categoria.
     */
    @GetMapping("/{id}")
    public String visualizar(@PathVariable Long id, Model model) {
        Categoria categoria = categoriaService.buscarPorId(id);
        Long quantidadeLivros = categoriaRepository.contarLivrosPorCategoria(id);
        model.addAttribute("categoria", categoria);
        model.addAttribute("quantidadeLivros", quantidadeLivros);
        return "categorias/detalhes";
    }

    /**
     * Exibe formulário de edição de categoria.
     */
    @GetMapping("/{id}/editar")
    @PreAuthorize("hasRole('ADMIN')")
    public String mostrarFormularioEdicao(@PathVariable Long id, Model model) {
        model.addAttribute("categoria", categoriaService.buscarPorId(id));
        return "categorias/form";
    }

    /**
     * Processa atualização de categoria.
     */
    @PostMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String atualizar(
        @PathVariable Long id,
        @Valid @ModelAttribute Categoria categoria,
        BindingResult result,
        RedirectAttributes redirectAttributes
    ) {
        if (result.hasErrors()) {
            return "categorias/form";
        }

        try {
            categoriaService.atualizar(id, categoria);
            redirectAttributes.addFlashAttribute("mensagem", "Categoria atualizada com sucesso!");
            return "redirect:/categorias";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erro", e.getMessage());
            return "redirect:/categorias/" + id + "/editar";
        }
    }

    /**
     * Deleta uma categoria.
     */
    @PostMapping("/{id}/deletar")
    @PreAuthorize("hasRole('ADMIN')")
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            // Verificar se há livros associados
            Long quantidadeLivros = categoriaRepository.contarLivrosPorCategoria(id);
            if (quantidadeLivros > 0) {
                redirectAttributes.addFlashAttribute("erro", 
                    "Não é possível deletar categoria com livros cadastrados. " +
                    "Remova ou recategorize os livros primeiro.");
                return "redirect:/categorias/" + id;
            }

            categoriaService.deletar(id);
            redirectAttributes.addFlashAttribute("mensagem", "Categoria deletada com sucesso!");
            return "redirect:/categorias";
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erro", e.getMessage());
            return "redirect:/categorias";
        }
    }

    /**
     * Busca categorias por nome.
     */
    @GetMapping("/buscar")
    public String buscar(@RequestParam(required = false) String nome, Model model) {
        List<Categoria> categorias;
        
        if (nome != null && !nome.isEmpty()) {
            categorias = categoriaService.buscarPorNome(nome);
            model.addAttribute("termoBusca", nome);
        } else {
            categorias = categoriaService.listarTodas();
        }
        
        // Criar mapa com contagem de livros
        Map<Long, Long> contagemLivros = new HashMap<>();
        for (Categoria cat : categorias) {
            contagemLivros.put(cat.getId(), categoriaRepository.contarLivrosPorCategoria(cat.getId()));
        }
        
        model.addAttribute("categorias", categorias);
        model.addAttribute("contagemLivros", contagemLivros);
        return "categorias/lista";
    }
}
