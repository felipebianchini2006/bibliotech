package com.livraria.bibliotech.controller;

import com.livraria.bibliotech.model.Autor;
import com.livraria.bibliotech.model.Livro;
import com.livraria.bibliotech.service.AutorService;
import com.livraria.bibliotech.service.CategoriaService;
import com.livraria.bibliotech.service.LivroService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashSet;
import java.util.Set;

@Controller
@RequestMapping("/livros")
@RequiredArgsConstructor
public class LivroController {

    private final LivroService livroService;
    private final CategoriaService categoriaService;
    private final AutorService autorService;

    @GetMapping({"", "/"})
    public String listar(Model model) {
        model.addAttribute("livros", livroService.listarTodos());
        return "livros/lista";
    }

    @GetMapping("/novo")
    @PreAuthorize("hasRole('ADMIN')")
    public String mostrarFormulario(Model model) {
        model.addAttribute("livro", new Livro());
        model.addAttribute("categorias", categoriaService.listarTodas());
        model.addAttribute("autores", autorService.listarTodos());
        return "livros/form";
    }

    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public String salvar(@Valid @ModelAttribute Livro livro,
                        @RequestParam(value = "autoresIds", required = false) Long[] autoresIds,
                        BindingResult result, 
                        Model model,
                        RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("categorias", categoriaService.listarTodas());
            model.addAttribute("autores", autorService.listarTodos());
            return "livros/form";
        }

        try {
            // Converter IDs de autores em objetos Autor
            if (autoresIds != null && autoresIds.length > 0) {
                Set<Autor> autores = new HashSet<>();
                for (Long autorId : autoresIds) {
                    Autor autor = new Autor();
                    autor.setId(autorId);
                    autores.add(autor);
                }
                livro.setAutores(autores);
            }
            
            livroService.salvar(livro);
            redirectAttributes.addFlashAttribute("mensagem", "Livro cadastrado com sucesso!");
            return "redirect:/livros";
        } catch (IllegalArgumentException e) {
            model.addAttribute("erro", e.getMessage());
            model.addAttribute("categorias", categoriaService.listarTodas());
            model.addAttribute("autores", autorService.listarTodos());
            return "livros/form";
        }
    }

    @GetMapping("/{id}")
    public String visualizar(@PathVariable Long id, Model model) {
        model.addAttribute("livro", livroService.buscarPorIdComDetalhes(id));
        return "livros/detalhes";
    }

    @GetMapping("/{id}/editar")
    @PreAuthorize("hasRole('ADMIN')")
    public String mostrarFormularioEdicao(@PathVariable Long id, Model model) {
        model.addAttribute("livro", livroService.buscarPorIdComDetalhes(id));
        model.addAttribute("categorias", categoriaService.listarTodas());
        model.addAttribute("autores", autorService.listarTodos());
        return "livros/form";
    }

    @PostMapping("/{id}")
    @PreAuthorize("hasRole('ADMIN')")
    public String atualizar(@PathVariable Long id,
                           @Valid @ModelAttribute Livro livro,
                           @RequestParam(value = "autoresIds", required = false) Long[] autoresIds,
                           BindingResult result,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("categorias", categoriaService.listarTodas());
            model.addAttribute("autores", autorService.listarTodos());
            return "livros/form";
        }

        try {
            // Converter IDs de autores em objetos Autor
            if (autoresIds != null && autoresIds.length > 0) {
                Set<Autor> autores = new HashSet<>();
                for (Long autorId : autoresIds) {
                    Autor autor = new Autor();
                    autor.setId(autorId);
                    autores.add(autor);
                }
                livro.setAutores(autores);
            } else {
                // Se nenhum autor foi selecionado, limpar autores
                livro.setAutores(new HashSet<>());
            }
            
            livroService.atualizar(id, livro);
            redirectAttributes.addFlashAttribute("mensagem", "Livro atualizado com sucesso!");
            return "redirect:/livros";
        } catch (IllegalArgumentException e) {
            model.addAttribute("erro", e.getMessage());
            model.addAttribute("categorias", categoriaService.listarTodas());
            model.addAttribute("autores", autorService.listarTodos());
            return "livros/form";
        }
    }

    @PostMapping("/{id}/deletar")
    @PreAuthorize("hasRole('ADMIN')")
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            livroService.deletar(id);
            redirectAttributes.addFlashAttribute("mensagem", "Livro deletado com sucesso!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erro", "Erro ao deletar livro: " + e.getMessage());
        }
        return "redirect:/livros";
    }

    @GetMapping("/buscar")
    public String buscar(@RequestParam(required = false) String titulo, Model model) {
        if (titulo != null && !titulo.isEmpty()) {
            model.addAttribute("livros", livroService.buscarPorTitulo(titulo));
        } else {
            model.addAttribute("livros", livroService.listarTodos());
        }
        model.addAttribute("termoBusca", titulo);
        return "livros/lista";
    }
}
