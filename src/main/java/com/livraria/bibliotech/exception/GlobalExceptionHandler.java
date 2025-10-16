package com.livraria.bibliotech.exception;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataIntegrityViolationException;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.ui.Model;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.Map;

/**
 * Tratamento global de exceções para toda a aplicação.
 * Centraliza o tratamento de erros e fornece mensagens amigáveis aos usuários.
 */
@ControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    /**
     * Trata exceções de recurso não encontrado.
     */
    @ExceptionHandler(ResourceNotFoundException.class)
    public String handleResourceNotFound(
            ResourceNotFoundException ex,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes
    ) {
        log.warn("Recurso não encontrado: {} - URL: {}", ex.getMessage(), request.getRequestURI());
        
        redirectAttributes.addFlashAttribute("erro", ex.getMessage());
        
        // Redireciona para página apropriada baseada na URL
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            return "redirect:" + referer;
        }
        return "redirect:/home";
    }

    /**
     * Trata exceções de regra de negócio.
     */
    @ExceptionHandler(BusinessException.class)
    public String handleBusinessException(
            BusinessException ex,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes
    ) {
        log.warn("Erro de negócio [{}]: {} - URL: {}", 
            ex.getErrorCode(), ex.getMessage(), request.getRequestURI());
        
        redirectAttributes.addFlashAttribute("erro", ex.getMessage());
        
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            return "redirect:" + referer;
        }
        return "redirect:/home";
    }

    /**
     * Trata exceções de validação customizada.
     */
    @ExceptionHandler(ValidationException.class)
    public String handleValidationException(
            ValidationException ex,
            HttpServletRequest request,
            Model model,
            RedirectAttributes redirectAttributes
    ) {
        log.warn("Erro de validação: {} - URL: {}", ex.getMessage(), request.getRequestURI());
        
        if (!ex.getErrors().isEmpty()) {
            redirectAttributes.addFlashAttribute("validationErrors", ex.getErrors());
        }
        redirectAttributes.addFlashAttribute("erro", ex.getMessage());
        
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            return "redirect:" + referer;
        }
        return "redirect:/home";
    }

    /**
     * Trata exceções de validação Bean Validation (@Valid).
     */
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public String handleMethodArgumentNotValid(
            MethodArgumentNotValidException ex,
            RedirectAttributes redirectAttributes
    ) {
        log.warn("Erro de validação de bean: {}", ex.getMessage());
        
        Map<String, String> errors = new HashMap<>();
        ex.getBindingResult().getFieldErrors().forEach(error -> 
            errors.put(error.getField(), error.getDefaultMessage())
        );
        
        redirectAttributes.addFlashAttribute("validationErrors", errors);
        redirectAttributes.addFlashAttribute("erro", "Erro de validação nos dados fornecidos");
        
        return "redirect:/home";
    }

    /**
     * Trata violações de integridade do banco de dados.
     */
    @ExceptionHandler(DataIntegrityViolationException.class)
    public String handleDataIntegrityViolation(
            DataIntegrityViolationException ex,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes
    ) {
        log.error("Violação de integridade de dados: {} - URL: {}", 
            ex.getMessage(), request.getRequestURI());
        
        String mensagem = "Erro ao processar operação. Verifique se não há dependências.";
        
        // Tentar identificar o tipo de violação
        String errorMessage = ex.getMostSpecificCause().getMessage().toLowerCase();
        if (errorMessage.contains("unique") || errorMessage.contains("duplicate")) {
            mensagem = "Já existe um registro com estes dados. Verifique campos únicos (email, CPF, ISBN).";
        } else if (errorMessage.contains("foreign key") || errorMessage.contains("violates")) {
            mensagem = "Não é possível excluir este registro pois existem outros dados vinculados a ele.";
        }
        
        redirectAttributes.addFlashAttribute("erro", mensagem);
        
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            return "redirect:" + referer;
        }
        return "redirect:/home";
    }

    /**
     * Trata exceções de acesso negado.
     */
    @ExceptionHandler(AccessDeniedException.class)
    public String handleAccessDenied(
            AccessDeniedException ex,
            HttpServletRequest request
    ) {
        log.warn("Acesso negado: {} - URL: {} - User: {}", 
            ex.getMessage(), 
            request.getRequestURI(),
            request.getUserPrincipal() != null ? request.getUserPrincipal().getName() : "Anonymous");
        
        return "error/acesso-negado";
    }

    /**
     * Trata exceções genéricas não capturadas.
     */
    @ExceptionHandler(Exception.class)
    public String handleGenericException(
            Exception ex,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes
    ) {
        log.error("Erro inesperado: {} - URL: {} - User: {}", 
            ex.getMessage(), 
            request.getRequestURI(),
            request.getUserPrincipal() != null ? request.getUserPrincipal().getName() : "Anonymous",
            ex);
        
        redirectAttributes.addFlashAttribute("erro", 
            "Ocorreu um erro inesperado. Nossa equipe foi notificada.");
        
        return "redirect:/home";
    }

    /**
     * Trata exceções ilegais de argumento.
     */
    @ExceptionHandler(IllegalArgumentException.class)
    public String handleIllegalArgument(
            IllegalArgumentException ex,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes
    ) {
        log.warn("Argumento inválido: {} - URL: {}", ex.getMessage(), request.getRequestURI());
        
        redirectAttributes.addFlashAttribute("erro", ex.getMessage());
        
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            return "redirect:" + referer;
        }
        return "redirect:/home";
    }

    /**
     * Trata exceções de estado ilegal.
     */
    @ExceptionHandler(IllegalStateException.class)
    public String handleIllegalState(
            IllegalStateException ex,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes
    ) {
        log.warn("Estado inválido: {} - URL: {}", ex.getMessage(), request.getRequestURI());
        
        redirectAttributes.addFlashAttribute("erro", ex.getMessage());
        
        String referer = request.getHeader("Referer");
        if (referer != null && !referer.isEmpty()) {
            return "redirect:" + referer;
        }
        return "redirect:/home";
    }
}
