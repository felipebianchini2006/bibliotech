package com.livraria.bibliotech.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import jakarta.validation.constraints.Size;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.util.Set;

/**
 * DTO para cadastro e atualização de livro.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LivroDTO {
    
    private Long id;
    
    @NotBlank(message = "Título é obrigatório")
    @Size(max = 200, message = "Título deve ter no máximo 200 caracteres")
    private String titulo;
    
    @NotBlank(message = "ISBN é obrigatório")
    @Size(min = 10, max = 13, message = "ISBN deve ter entre 10 e 13 dígitos")
    private String isbn;
    
    @Size(max = 2000, message = "Descrição deve ter no máximo 2000 caracteres")
    private String descricao;
    
    @NotNull(message = "Data de publicação é obrigatória")
    private LocalDate dataPublicacao;
    
    @NotNull(message = "Quantidade é obrigatória")
    @Positive(message = "Quantidade deve ser positiva")
    private Integer quantidadeTotal;
    
    private Integer quantidadeDisponivel;
    
    @Size(max = 500, message = "URL da imagem deve ter no máximo 500 caracteres")
    private String imagemUrl;
    
    private Long categoriaId;
    private String categoriaNome;
    
    private Set<Long> autoresIds;
    private Set<String> autoresNomes;
}
