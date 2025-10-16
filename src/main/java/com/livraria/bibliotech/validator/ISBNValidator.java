package com.livraria.bibliotech.validator;

import jakarta.validation.ConstraintValidator;
import jakarta.validation.ConstraintValidatorContext;

/**
 * Validador de ISBN (ISBN-10 e ISBN-13).
 * Implementa algoritmo de validação de dígito verificador.
 */
public class ISBNValidator implements ConstraintValidator<ValidISBN, String> {

    @Override
    public void initialize(ValidISBN constraintAnnotation) {
        // Inicialização se necessário
    }

    @Override
    public boolean isValid(String isbn, ConstraintValidatorContext context) {
        if (isbn == null || isbn.isEmpty()) {
            return true; // Use @NotBlank para obrigatoriedade
        }

        // Remove hífens e espaços
        isbn = isbn.replaceAll("[\\s-]", "");

        // Valida ISBN-10 ou ISBN-13
        if (isbn.length() == 10) {
            return isValidISBN10(isbn);
        } else if (isbn.length() == 13) {
            return isValidISBN13(isbn);
        }

        return false;
    }

    /**
     * Valida ISBN-10.
     * Algoritmo: soma de (dígito * posição) mod 11 = 0
     */
    private boolean isValidISBN10(String isbn) {
        try {
            int sum = 0;
            for (int i = 0; i < 9; i++) {
                char c = isbn.charAt(i);
                if (!Character.isDigit(c)) {
                    return false;
                }
                sum += Character.getNumericValue(c) * (10 - i);
            }

            // Último caractere pode ser 'X' (representa 10)
            char lastChar = isbn.charAt(9);
            if (lastChar == 'X' || lastChar == 'x') {
                sum += 10;
            } else if (Character.isDigit(lastChar)) {
                sum += Character.getNumericValue(lastChar);
            } else {
                return false;
            }

            return sum % 11 == 0;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Valida ISBN-13.
     * Algoritmo: soma de (dígito * [1 ou 3 alternado]) mod 10 = 0
     */
    private boolean isValidISBN13(String isbn) {
        try {
            int sum = 0;
            for (int i = 0; i < 13; i++) {
                char c = isbn.charAt(i);
                if (!Character.isDigit(c)) {
                    return false;
                }
                int digit = Character.getNumericValue(c);
                sum += (i % 2 == 0) ? digit : digit * 3;
            }

            return sum % 10 == 0;
        } catch (Exception e) {
            return false;
        }
    }

    /**
     * Método utilitário para validar ISBN sem anotação.
     */
    public static boolean isValidISBN(String isbn) {
        ISBNValidator validator = new ISBNValidator();
        return validator.isValid(isbn, null);
    }

    /**
     * Formata ISBN-13 para exibição (9781234567890 -> 978-1-234-56789-0)
     */
    public static String formatISBN13(String isbn) {
        if (isbn == null || isbn.length() != 13) {
            return isbn;
        }
        isbn = isbn.replaceAll("[^0-9X]", "");
        return isbn.substring(0, 3) + "-" + 
               isbn.substring(3, 4) + "-" + 
               isbn.substring(4, 7) + "-" + 
               isbn.substring(7, 12) + "-" + 
               isbn.substring(12, 13);
    }

    /**
     * Formata ISBN-10 para exibição (1234567890 -> 1-234-56789-0)
     */
    public static String formatISBN10(String isbn) {
        if (isbn == null || isbn.length() != 10) {
            return isbn;
        }
        isbn = isbn.replaceAll("[^0-9X]", "");
        return isbn.substring(0, 1) + "-" + 
               isbn.substring(1, 4) + "-" + 
               isbn.substring(4, 9) + "-" + 
               isbn.substring(9, 10);
    }

    /**
     * Remove formatação do ISBN
     */
    public static String cleanISBN(String isbn) {
        if (isbn == null) {
            return null;
        }
        return isbn.replaceAll("[^0-9X]", "");
    }
}
