package com.livraria.bibliotech.exception;

import java.util.HashMap;
import java.util.Map;

/**
 * Exceção para erros de validação de dados.
 */
public class ValidationException extends RuntimeException {
    
    private final Map<String, String> errors;
    
    public ValidationException(String message) {
        super(message);
        this.errors = new HashMap<>();
    }
    
    public ValidationException(String field, String message) {
        super(message);
        this.errors = new HashMap<>();
        this.errors.put(field, message);
    }
    
    public ValidationException(Map<String, String> errors) {
        super("Erro de validação");
        this.errors = errors;
    }
    
    public Map<String, String> getErrors() {
        return errors;
    }
    
    public void addError(String field, String message) {
        this.errors.put(field, message);
    }
}
