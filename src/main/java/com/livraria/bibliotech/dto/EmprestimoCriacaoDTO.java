package com.livraria.bibliotech.dto;

import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO para criação de empréstimo.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class EmprestimoCriacaoDTO {
    
    @NotNull(message = "Usuário é obrigatório")
    private Long usuarioId;
    
    @NotNull(message = "Livro é obrigatório")
    private Long livroId;
    
    private String observacoes;
}
