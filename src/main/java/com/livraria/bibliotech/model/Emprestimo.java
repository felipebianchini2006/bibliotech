package com.livraria.bibliotech.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDateTime;

@Entity
@Table(name = "emprestimos")
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"usuario", "livro"})
public class Emprestimo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotNull(message = "Usuário é obrigatório")
    @ManyToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @NotNull(message = "Livro é obrigatório")
    @ManyToOne
    @JoinColumn(name = "livro_id", nullable = false)
    private Livro livro;

    @Column(name = "data_emprestimo", nullable = false, updatable = false)
    private LocalDateTime dataEmprestimo;

    @Column(name = "data_prevista_devolucao", nullable = false)
    private LocalDateTime dataPrevistaDevolucao;

    @Column(name = "data_devolucao")
    private LocalDateTime dataDevolucao;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Status status = Status.ATIVO;

    @Column(length = 500)
    private String observacoes;

    @PrePersist
    protected void onCreate() {
        dataEmprestimo = LocalDateTime.now();
        // Define prazo padrão de 14 dias
        if (dataPrevistaDevolucao == null) {
            dataPrevistaDevolucao = LocalDateTime.now().plusDays(14);
        }
    }

    public boolean isAtrasado() {
        return status == Status.ATIVO && 
               LocalDateTime.now().isAfter(dataPrevistaDevolucao);
    }

    public enum Status {
        ATIVO, DEVOLVIDO, ATRASADO, CANCELADO
    }
}
