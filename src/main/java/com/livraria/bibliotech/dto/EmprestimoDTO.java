package com.livraria.bibliotech.dto;

import com.livraria.bibliotech.model.Emprestimo;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO para resposta de empréstimo.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EmprestimoDTO {
    
    private Long id;
    
    // Dados do usuário
    private Long usuarioId;
    private String usuarioNome;
    private String usuarioEmail;
    
    // Dados do livro
    private Long livroId;
    private String livroTitulo;
    private String livroIsbn;
    
    // Datas
    private LocalDateTime dataEmprestimo;
    private LocalDateTime dataPrevistaDevolucao;
    private LocalDateTime dataDevolucao;
    
    // Status
    private Emprestimo.Status status;
    private Boolean atrasado;
    private Long diasRestantes;
    private Long diasAtraso;
    
    // Observações
    private String observacoes;
    
    // Multa
    private Double multa;
}
