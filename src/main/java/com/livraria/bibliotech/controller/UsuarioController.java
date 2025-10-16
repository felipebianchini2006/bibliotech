package com.livraria.bibliotech.controller;

import com.livraria.bibliotech.model.Usuario;
import com.livraria.bibliotech.service.EmprestimoService;
import com.livraria.bibliotech.service.UsuarioService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Controller para administração de usuários.
 * Acesso restrito a administradores.
 */
@Controller
@RequestMapping("/usuarios")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class UsuarioController {

    private final UsuarioService usuarioService;
    private final EmprestimoService emprestimoService;

    /**
     * Lista todos os usuários.
     */
    @GetMapping({"", "/"})
    public String listar(
        @RequestParam(required = false) String filtro,
        Model model
    ) {
        if ("ativos".equals(filtro)) {
            model.addAttribute("usuarios", usuarioService.listarAtivos());
            model.addAttribute("filtroAtivo", true);
        } else {
            model.addAttribute("usuarios", usuarioService.listarTodos());
        }
        return "usuarios/lista";
    }

    /**
     * Visualiza detalhes de um usuário.
     */
    @GetMapping("/{id}")
    public String visualizar(@PathVariable Long id, Model model) {
        Usuario usuario = usuarioService.buscarPorId(id);
        model.addAttribute("usuario", usuario);
        model.addAttribute("emprestimos", emprestimoService.listarPorUsuario(id));
        model.addAttribute("emprestimosAtivos", 
            emprestimoService.listarAtivoPorUsuario(id).size());
        return "usuarios/detalhes";
    }

    /**
     * Exibe formulário de edição de usuário.
     */
    @GetMapping("/{id}/editar")
    public String mostrarFormularioEdicao(@PathVariable Long id, Model model) {
        Usuario usuario = usuarioService.buscarPorId(id);
        // Limpar senha para não mostrar no formulário
        usuario.setSenha("");
        model.addAttribute("usuario", usuario);
        model.addAttribute("editando", true);
        return "usuarios/form";
    }

    /**
     * Processa atualização de usuário.
     */
    @PostMapping("/{id}")
    public String atualizar(
        @PathVariable Long id,
        @ModelAttribute Usuario usuario,
        @RequestParam(required = false) String novaSenha,
        Model model,
        RedirectAttributes redirectAttributes
    ) {
        // Se fornecida nova senha, atualizar
        if (novaSenha != null && !novaSenha.isEmpty()) {
            if (novaSenha.length() < 6) {
                model.addAttribute("erro", "Senha deve ter no mínimo 6 caracteres");
                model.addAttribute("editando", true);
                return "usuarios/form";
            }
            usuario.setSenha(novaSenha);
        }

        try {
            usuarioService.atualizar(id, usuario);
            redirectAttributes.addFlashAttribute("mensagem", "Usuário atualizado com sucesso!");
            return "redirect:/usuarios/" + id;
        } catch (IllegalArgumentException e) {
            model.addAttribute("erro", e.getMessage());
            model.addAttribute("editando", true);
            return "usuarios/form";
        }
    }

    /**
     * Ativa ou desativa um usuário.
     */
    @PostMapping("/{id}/status")
    public String alterarStatus(
        @PathVariable Long id,
        @RequestParam boolean ativo,
        RedirectAttributes redirectAttributes
    ) {
        try {
            Usuario usuario = usuarioService.buscarPorId(id);
            
            // Não permitir desativar o próprio usuário admin
            if (!ativo && usuario.getRole() == Usuario.Role.ADMIN) {
                redirectAttributes.addFlashAttribute("aviso", 
                    "Atenção: Desativar administradores pode afetar o acesso ao sistema.");
            }

            usuarioService.alterarStatus(id, ativo);
            String mensagem = ativo ? "Usuário ativado com sucesso!" : "Usuário desativado com sucesso!";
            redirectAttributes.addFlashAttribute("mensagem", mensagem);
            
            return "redirect:/usuarios/" + id;
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erro", e.getMessage());
            return "redirect:/usuarios";
        }
    }

    /**
     * Busca usuários por nome.
     */
    @GetMapping("/buscar")
    public String buscar(@RequestParam(required = false) String nome, Model model) {
        if (nome != null && !nome.isEmpty()) {
            model.addAttribute("usuarios", 
                usuarioService.listarTodos().stream()
                    .filter(u -> u.getNome().toLowerCase().contains(nome.toLowerCase()))
                    .toList()
            );
            model.addAttribute("termoBusca", nome);
        } else {
            model.addAttribute("usuarios", usuarioService.listarTodos());
        }
        return "usuarios/lista";
    }

    /**
     * Lista usuários por role.
     */
    @GetMapping("/role/{role}")
    public String listarPorRole(@PathVariable String role, Model model) {
        try {
            Usuario.Role roleEnum = Usuario.Role.valueOf(role.toUpperCase());
            model.addAttribute("usuarios", 
                usuarioService.listarTodos().stream()
                    .filter(u -> u.getRole() == roleEnum)
                    .toList()
            );
            model.addAttribute("roleFiltro", roleEnum);
            return "usuarios/lista";
        } catch (IllegalArgumentException e) {
            model.addAttribute("erro", "Role inválida");
            return "redirect:/usuarios";
        }
    }

    /**
     * Lista empréstimos de um usuário específico.
     */
    @GetMapping("/{id}/emprestimos")
    public String listarEmprestimos(@PathVariable Long id, Model model) {
        Usuario usuario = usuarioService.buscarPorId(id);
        model.addAttribute("usuario", usuario);
        model.addAttribute("emprestimos", emprestimoService.listarPorUsuario(id));
        return "usuarios/emprestimos";
    }
}
