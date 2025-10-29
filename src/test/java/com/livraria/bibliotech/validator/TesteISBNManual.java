package com.livraria.bibliotech.validator;

public class TesteISBNManual {
    public static void main(String[] args) {
        ISBNValidator validator = new ISBNValidator();
        
        System.out.println("\n╔══════════════════════════════════════════════════════════════╗");
        System.out.println("║        RESULTADOS DOS TESTES DE VALIDAÇÃO DE ISBN          ║");
        System.out.println("╚══════════════════════════════════════════════════════════════╝\n");
        
        // Teste 1
        String isbn1 = "123";
        boolean resultado1 = validator.isValid(isbn1, null);
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("📋 TESTE 1: ISBN '123' (inválido - muito curto)");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("   ISBN testado: " + isbn1);
        System.out.println("   Tamanho: " + isbn1.length() + " dígitos");
        System.out.println("   Esperado: ❌ REJEITAR");
        System.out.println("   Resultado: " + (resultado1 ? "✅ ACEITO" : "❌ REJEITADO"));
        System.out.println("   Status: " + (!resultado1 ? "✅ PASSOU" : "❌ FALHOU"));
        System.out.println();
        
        // Teste 2
        String isbn2 = "1234567890";
        boolean resultado2 = validator.isValid(isbn2, null);
        
        // Calcular se é válido
        int sum2 = 0;
        for (int i = 0; i < 10; i++) {
            sum2 += Character.getNumericValue(isbn2.charAt(i)) * (10 - i);
        }
        boolean isValidISBN10 = (sum2 % 11 == 0);
        
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("📋 TESTE 2: ISBN '1234567890' (ISBN-10)");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("   ISBN testado: " + isbn2);
        System.out.println("   Formato: ISBN-10");
        System.out.println("   Tamanho: " + isbn2.length() + " dígitos");
        System.out.println("   Soma de verificação: " + sum2);
        System.out.println("   Módulo 11: " + (sum2 % 11));
        System.out.println("   Válido por algoritmo: " + (isValidISBN10 ? "Sim" : "Não"));
        System.out.println("   Esperado: " + (isValidISBN10 ? "✅ ACEITAR" : "❌ REJEITAR"));
        System.out.println("   Resultado: " + (resultado2 ? "✅ ACEITO" : "❌ REJEITADO"));
        System.out.println("   Status: " + ((resultado2 == isValidISBN10) ? "✅ PASSOU" : "❌ FALHOU"));
        System.out.println();
        
        // Teste 3
        String isbn3 = "9788535911664";
        boolean resultado3 = validator.isValid(isbn3, null);
        
        // Calcular se é válido
        int sum3 = 0;
        for (int i = 0; i < 13; i++) {
            int digit = Character.getNumericValue(isbn3.charAt(i));
            sum3 += (i % 2 == 0) ? digit : digit * 3;
        }
        boolean isValidISBN13_3 = (sum3 % 10 == 0);
        
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("📋 TESTE 3: ISBN '9788535911664' (ISBN-13 válido)");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("   ISBN testado: " + isbn3);
        System.out.println("   Formato: ISBN-13");
        System.out.println("   Tamanho: " + isbn3.length() + " dígitos");
        System.out.println("   Soma de verificação: " + sum3);
        System.out.println("   Módulo 10: " + (sum3 % 10));
        System.out.println("   Válido por algoritmo: " + (isValidISBN13_3 ? "Sim" : "Não"));
        System.out.println("   Esperado: ✅ ACEITAR");
        System.out.println("   Resultado: " + (resultado3 ? "✅ ACEITO" : "❌ REJEITADO"));
        System.out.println("   Status: " + (resultado3 ? "✅ PASSOU" : "❌ FALHOU"));
        System.out.println();
        
        // Teste 4
        String isbn4 = "9999999999999";
        boolean resultado4 = validator.isValid(isbn4, null);
        
        // Calcular se é válido
        int sum4 = 0;
        for (int i = 0; i < 13; i++) {
            int digit = Character.getNumericValue(isbn4.charAt(i));
            sum4 += (i % 2 == 0) ? digit : digit * 3;
        }
        boolean isValidISBN13_4 = (sum4 % 10 == 0);
        
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("📋 TESTE 4: ISBN '9999999999999' (ISBN-13 inválido)");
        System.out.println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━");
        System.out.println("   ISBN testado: " + isbn4);
        System.out.println("   Formato: ISBN-13");
        System.out.println("   Tamanho: " + isbn4.length() + " dígitos");
        System.out.println("   Soma de verificação: " + sum4);
        System.out.println("   Módulo 10: " + (sum4 % 10));
        System.out.println("   Válido por algoritmo: " + (isValidISBN13_4 ? "Sim" : "Não"));
        System.out.println("   Esperado: ❌ REJEITAR");
        System.out.println("   Resultado: " + (resultado4 ? "✅ ACEITO" : "❌ REJEITADO"));
        System.out.println("   Status: " + (!resultado4 ? "✅ PASSOU" : "❌ FALHOU"));
        System.out.println();
        
        // Resumo final
        int totalPassed = 0;
        if (!resultado1) totalPassed++; // Deve rejeitar
        if (resultado2 == isValidISBN10) totalPassed++; // Depende do checksum
        if (resultado3) totalPassed++; // Deve aceitar
        if (!resultado4) totalPassed++; // Deve rejeitar
        
        System.out.println("╔══════════════════════════════════════════════════════════════╗");
        System.out.println("║                    RESUMO FINAL                             ║");
        System.out.println("╠══════════════════════════════════════════════════════════════╣");
        System.out.println("║  Total de testes: 4                                         ║");
        System.out.println("║  Testes aprovados: " + totalPassed + "                                       ║");
        System.out.println("║  Testes falhados: " + (4 - totalPassed) + "                                        ║");
        System.out.println("╚══════════════════════════════════════════════════════════════╝");
        System.out.println();
        
        if (totalPassed == 4) {
            System.out.println("✅ SUCESSO! Todos os testes passaram!");
            System.out.println("   A validação de ISBN está funcionando corretamente.");
        } else {
            System.out.println("⚠️  ATENÇÃO! Alguns testes falharam.");
            System.out.println("   Verifique os resultados acima para mais detalhes.");
        }
        System.out.println();
    }
}
