package com.livraria.bibliotech.controller;

import com.livraria.bibliotech.model.Categoria;
import com.livraria.bibliotech.service.CategoriaService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Controller para gerenciamento de categorias de livros.
 * Acesso restrito a administradores.
 */
@Controller
@RequestMapping("/categorias")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class CategoriaController {

    private final CategoriaService categoriaService;

    /**
     * Lista todas as categorias.
     */
    @GetMapping({"", "/"})
    public String listar(Model model) {
        model.addAttribute("categorias", categoriaService.listarTodas());
        return "categorias/lista";
    }

    /**
     * Exibe formulário para nova categoria.
     */
    @GetMapping("/nova")
    public String mostrarFormulario(Model model) {
        model.addAttribute("categoria", new Categoria());
        return "categorias/form";
    }

    /**
     * Processa criação de nova categoria.
     */
    @PostMapping
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
        model.addAttribute("categoria", categoria);
        model.addAttribute("quantidadeLivros", categoria.getLivros().size());
        return "categorias/detalhes";
    }

    /**
     * Exibe formulário de edição de categoria.
     */
    @GetMapping("/{id}/editar")
    public String mostrarFormularioEdicao(@PathVariable Long id, Model model) {
        model.addAttribute("categoria", categoriaService.buscarPorId(id));
        return "categorias/form";
    }

    /**
     * Processa atualização de categoria.
     */
    @PostMapping("/{id}")
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
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Categoria categoria = categoriaService.buscarPorId(id);
            
            // Verificar se há livros associados
            if (!categoria.getLivros().isEmpty()) {
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
        if (nome != null && !nome.isEmpty()) {
            model.addAttribute("categorias", categoriaService.buscarPorNome(nome));
            model.addAttribute("termoBusca", nome);
        } else {
            model.addAttribute("categorias", categoriaService.listarTodas());
        }
        return "categorias/lista";
    }
}
