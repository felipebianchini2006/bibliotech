package com.livraria.bibliotech.exception;

/**
 * Exceção lançada quando um recurso não é encontrado no sistema.
 */
public class ResourceNotFoundException extends RuntimeException {
    
    public ResourceNotFoundException(String message) {
        super(message);
    }
    
    public ResourceNotFoundException(String resourceName, Long id) {
        super(String.format("%s com ID %d não encontrado", resourceName, id));
    }
    
    public ResourceNotFoundException(String resourceName, String fieldName, Object fieldValue) {
        super(String.format("%s não encontrado com %s: %s", resourceName, fieldName, fieldValue));
    }
}
