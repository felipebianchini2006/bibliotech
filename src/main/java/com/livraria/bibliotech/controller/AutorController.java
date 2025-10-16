package com.livraria.bibliotech.controller;

import com.livraria.bibliotech.model.Autor;
import com.livraria.bibliotech.service.AutorService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/autores")
@RequiredArgsConstructor
public class AutorController {

    private final AutorService autorService;

    @GetMapping({"", "/"})
    public String listar(Model model) {
        model.addAttribute("autores", autorService.listarTodos());
        return "autores/lista";
    }

    @GetMapping("/novo")
    public String mostrarFormulario(Model model) {
        model.addAttribute("autor", new Autor());
        return "autores/form";
    }

    @PostMapping
    public String salvar(@Valid @ModelAttribute Autor autor, 
                        BindingResult result, 
                        Model model,
                        RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "autores/form";
        }

        try {
            autorService.salvar(autor);
            redirectAttributes.addFlashAttribute("mensagem", "Autor cadastrado com sucesso!");
            return "redirect:/autores";
        } catch (Exception e) {
            model.addAttribute("erro", "Erro ao cadastrar autor: " + e.getMessage());
            return "autores/form";
        }
    }

    @GetMapping("/{id}")
    public String visualizar(@PathVariable Long id, Model model) {
        Autor autor = autorService.buscarPorIdComLivros(id);
        model.addAttribute("autor", autor);
        return "autores/detalhes";
    }

    @GetMapping("/{id}/editar")
    public String mostrarFormularioEdicao(@PathVariable Long id, Model model) {
        model.addAttribute("autor", autorService.buscarPorId(id));
        return "autores/form";
    }

    @PostMapping("/{id}")
    public String atualizar(@PathVariable Long id,
                           @Valid @ModelAttribute Autor autor,
                           BindingResult result,
                           Model model,
                           RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "autores/form";
        }

        try {
            autorService.atualizar(id, autor);
            redirectAttributes.addFlashAttribute("mensagem", "Autor atualizado com sucesso!");
            return "redirect:/autores";
        } catch (IllegalArgumentException e) {
            model.addAttribute("erro", e.getMessage());
            return "autores/form";
        }
    }

    @PostMapping("/{id}/deletar")
    public String deletar(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            autorService.deletar(id);
            redirectAttributes.addFlashAttribute("mensagem", "Autor deletado com sucesso!");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("erro", "Erro ao deletar autor: " + e.getMessage());
        }
        return "redirect:/autores";
    }

    @GetMapping("/buscar")
    public String buscar(@RequestParam(required = false) String nome, Model model) {
        if (nome != null && !nome.isEmpty()) {
            model.addAttribute("autores", autorService.buscarPorNome(nome));
        } else {
            model.addAttribute("autores", autorService.listarTodos());
        }
        model.addAttribute("termoBusca", nome);
        return "autores/lista";
    }
}
