package com.livraria.bibliotech.dto;

import com.livraria.bibliotech.model.Usuario;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * DTO para resposta com dados de usuário (sem informações sensíveis).
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class UsuarioResponseDTO {
    
    private Long id;
    private String nome;
    private String email;
    private String telefone;
    private String endereco;
    private String cpf;
    private Usuario.Role role;
    private Boolean ativo;
    private LocalDateTime dataCadastro;
    private Long emprestimoAtivos;
    
    /**
     * Converte entidade Usuario para DTO.
     */
    public static UsuarioResponseDTO fromEntity(Usuario usuario) {
        return UsuarioResponseDTO.builder()
            .id(usuario.getId())
            .nome(usuario.getNome())
            .email(usuario.getEmail())
            .telefone(usuario.getTelefone())
            .endereco(usuario.getEndereco())
            .cpf(maskCPF(usuario.getCpf()))
            .role(usuario.getRole())
            .ativo(usuario.getAtivo())
            .dataCadastro(usuario.getDataCadastro())
            .build();
    }
    
    /**
     * Mascara CPF para exibição (123.456.789-00 -> 123.***.**9-00)
     */
    private static String maskCPF(String cpf) {
        if (cpf == null || cpf.length() != 11) {
            return cpf;
        }
        return cpf.substring(0, 3) + ".***.**" + cpf.substring(9, 10) + "-" + cpf.substring(10);
    }
}
