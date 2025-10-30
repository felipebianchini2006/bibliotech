package com.livraria.bibliotech.controller;

import com.livraria.bibliotech.model.Usuario;
import com.livraria.bibliotech.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;

@Controller
@RequiredArgsConstructor
public class AuthController {

    private final UsuarioService usuarioService;

    @GetMapping("/")
    public String index() {
        return "redirect:/login";
    }

    @GetMapping("/login")
    public String login(
        @RequestParam(value = "error", required = false) String error,
        @RequestParam(value = "logout", required = false) String logout,
        Model model
    ) {
        if (error != null) {
            model.addAttribute("erro", "Email ou senha inválidos");
        }
        if (logout != null) {
            model.addAttribute("mensagem", "Logout realizado com sucesso");
        }
        return "auth/login";
    }

    @GetMapping("/registro")
    public String mostrarFormularioRegistro(Model model) {
        model.addAttribute("usuario", new Usuario());
        return "auth/registro";
    }

    @PostMapping("/registro")
    public String registrar(
        @Valid @ModelAttribute Usuario usuario,
        BindingResult result,
        RedirectAttributes redirectAttributes
    ) {
        if (result.hasErrors()) {
            return "auth/registro";
        }

        try {
            // Definir role padrão como USER
            usuario.setRole(Usuario.Role.USER);
            usuarioService.cadastrar(usuario);
            redirectAttributes.addFlashAttribute("mensagem", "Cadastro realizado com sucesso! Faça login.");
            return "redirect:/login";
        } catch (IllegalArgumentException | com.livraria.bibliotech.exception.BusinessException e) {
            redirectAttributes.addFlashAttribute("erro", e.getMessage());
            return "redirect:/registro";
        }
    }

    @GetMapping("/home")
    public String home() {
        return "home";
    }

    @GetMapping("/acesso-negado")
    public String acessoNegado() {
        return "error/acesso-negado";
    }
}
