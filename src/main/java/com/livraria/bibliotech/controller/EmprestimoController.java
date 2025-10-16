package com.livraria.bibliotech.controller;

import com.livraria.bibliotech.model.Emprestimo;
import com.livraria.bibliotech.service.EmprestimoService;
import com.livraria.bibliotech.service.LivroService;
import com.livraria.bibliotech.service.UsuarioService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

/**
 * Controller para gerenciamento de empréstimos de livros.
 * Endpoints para criar, devolver, renovar e listar empréstimos.
 */
@Controller
@RequestMapping("/emprestimos")
@RequiredArgsConstructor
public class EmprestimoController {

    private final EmprestimoService emprestimoService;
    private final LivroService livroService;
    private final UsuarioService usuarioService;

    /**
     * Lista todos os empréstimos (ADMIN) ou apenas do usuário logado (USER).
     */
    @GetMapping({"", "/"})
    public String listar(Model model, Authentication authentication) {
        boolean isAdmin = authentication.getAuthorities().stream()
            .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (isAdmin) {
            model.addAttribute("emprestimos", emprestimoService.listarTodos());
            model.addAttribute("isAdmin", true);
        } else {
            String email = authentication.getName();
            var usuario = usuarioService.buscarPorEmail(email)
                .orElseThrow(() -> new IllegalStateException("Usuário não encontrado"));
            model.addAttribute("emprestimos", emprestimoService.listarPorUsuario(usuario.getId()));
            model.addAttribute("isAdmin", false);
        }

        return "emprestimos/lista";
    }

    /**
     * Exibe formulário para novo empréstimo.
     */
    @GetMapping("/novo")
    @PreAuthorize("hasRole('ADMIN')")
    public String mostrarFormulario(Model model) {
        model.addAttribute("livros", livroService.listarDisponiveis());
        model.addAttribute("usuarios", usuarioService.listarAtivos());
        return "emprestimos/form";
    }

    /**
     * Processa criação de novo empréstimo.
     */
    @PostMapping
    @PreAuthorize("hasRole('ADMIN')")
    public String criar(
        @RequestParam Long usuarioId,
        @RequestParam Long livroId,
        @RequestParam(required = false) String observacoes,
        RedirectAttributes redirectAttributes
    ) {
        try {
            emprestimoService.realizarEmprestimo(usuarioId, livroId, observacoes);
            redirectAttributes.addFlashAttribute("mensagem", "Empréstimo realizado com sucesso!");
            return "redirect:/emprestimos";
        } catch (IllegalStateException | IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erro", e.getMessage());
            return "redirect:/emprestimos/novo";
        }
    }

    /**
     * Visualiza detalhes de um empréstimo.
     */
    @GetMapping("/{id}")
    public String visualizar(@PathVariable Long id, Model model, Authentication authentication) {
        Emprestimo emprestimo = emprestimoService.buscarPorId(id);

        // Verificar se usuário comum pode ver este empréstimo
        boolean isAdmin = authentication.getAuthorities().stream()
            .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

        if (!isAdmin) {
            String email = authentication.getName();
            if (!emprestimo.getUsuario().getEmail().equals(email)) {
                throw new org.springframework.security.access.AccessDeniedException(
                    "Você não tem permissão para visualizar este empréstimo"
                );
            }
        }

        model.addAttribute("emprestimo", emprestimo);
        model.addAttribute("multa", emprestimoService.calcularMulta(id));
        return "emprestimos/detalhes";
    }

    /**
     * Realiza devolução de livro.
     */
    @PostMapping("/{id}/devolver")
    @PreAuthorize("hasRole('ADMIN')")
    public String devolver(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Emprestimo emprestimo = emprestimoService.devolverLivro(id);
            
            if (emprestimo.getStatus() == Emprestimo.Status.ATRASADO) {
                double multa = emprestimoService.calcularMulta(id);
                redirectAttributes.addFlashAttribute("aviso", 
                    String.format("Livro devolvido com ATRASO. Multa: R$ %.2f", multa));
            } else {
                redirectAttributes.addFlashAttribute("mensagem", "Livro devolvido com sucesso!");
            }
            
            return "redirect:/emprestimos/" + id;
        } catch (IllegalStateException | IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erro", e.getMessage());
            return "redirect:/emprestimos/" + id;
        }
    }

    /**
     * Renova um empréstimo.
     */
    @PostMapping("/{id}/renovar")
    public String renovar(
        @PathVariable Long id, 
        Authentication authentication,
        RedirectAttributes redirectAttributes
    ) {
        try {
            // Verificar se usuário comum pode renovar este empréstimo
            Emprestimo emprestimo = emprestimoService.buscarPorId(id);
            boolean isAdmin = authentication.getAuthorities().stream()
                .anyMatch(a -> a.getAuthority().equals("ROLE_ADMIN"));

            if (!isAdmin) {
                String email = authentication.getName();
                if (!emprestimo.getUsuario().getEmail().equals(email)) {
                    throw new org.springframework.security.access.AccessDeniedException(
                        "Você não tem permissão para renovar este empréstimo"
                    );
                }
            }

            emprestimoService.renovarEmprestimo(id);
            redirectAttributes.addFlashAttribute("mensagem", "Empréstimo renovado com sucesso!");
            return "redirect:/emprestimos/" + id;
        } catch (IllegalStateException | IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erro", e.getMessage());
            return "redirect:/emprestimos/" + id;
        }
    }

    /**
     * Cancela um empréstimo.
     */
    @PostMapping("/{id}/cancelar")
    @PreAuthorize("hasRole('ADMIN')")
    public String cancelar(
        @PathVariable Long id,
        @RequestParam String motivo,
        RedirectAttributes redirectAttributes
    ) {
        try {
            emprestimoService.cancelarEmprestimo(id, motivo);
            redirectAttributes.addFlashAttribute("mensagem", "Empréstimo cancelado com sucesso!");
            return "redirect:/emprestimos";
        } catch (IllegalStateException | IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("erro", e.getMessage());
            return "redirect:/emprestimos/" + id;
        }
    }

    /**
     * Lista empréstimos atrasados (apenas ADMIN).
     */
    @GetMapping("/atrasados")
    @PreAuthorize("hasRole('ADMIN')")
    public String listarAtrasados(Model model) {
        model.addAttribute("emprestimos", emprestimoService.listarAtrasados());
        model.addAttribute("isAtrasados", true);
        return "emprestimos/lista";
    }

    /**
     * Lista empréstimos por status.
     */
    @GetMapping("/status/{status}")
    @PreAuthorize("hasRole('ADMIN')")
    public String listarPorStatus(@PathVariable String status, Model model) {
        try {
            Emprestimo.Status statusEnum = Emprestimo.Status.valueOf(status.toUpperCase());
            model.addAttribute("emprestimos", emprestimoService.listarPorStatus(statusEnum));
            model.addAttribute("statusFiltro", statusEnum);
            return "emprestimos/lista";
        } catch (IllegalArgumentException e) {
            model.addAttribute("erro", "Status inválido");
            return "redirect:/emprestimos";
        }
    }

    /**
     * Meus empréstimos (usuário logado).
     */
    @GetMapping("/meus")
    public String meus(Model model, Authentication authentication) {
        String email = authentication.getName();
        var usuario = usuarioService.buscarPorEmail(email)
            .orElseThrow(() -> new IllegalStateException("Usuário não encontrado"));
        
        model.addAttribute("emprestimos", emprestimoService.listarPorUsuario(usuario.getId()));
        model.addAttribute("isMeus", true);
        return "emprestimos/lista";
    }
}
