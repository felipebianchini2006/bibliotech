package com.livraria.bibliotech.model;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.livraria.bibliotech.validator.ValidISBN;
import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;

import java.time.LocalDate;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "livros")
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"autores", "emprestimos"})
public class Livro {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Título é obrigatório")
    @Column(nullable = false)
    private String titulo;

    @NotBlank(message = "ISBN é obrigatório")
    @ValidISBN(message = "ISBN inválido")
    @Column(unique = true, nullable = false, length = 13)
    private String isbn;

    @Column(length = 2000)
    private String descricao;

    @NotNull(message = "Data de publicação é obrigatória")
    @Column(name = "data_publicacao", nullable = false)
    private LocalDate dataPublicacao;

    @NotNull(message = "Quantidade é obrigatória")
    @Positive(message = "Quantidade deve ser positiva")
    @Column(nullable = false)
    private Integer quantidadeTotal;

    @Column(nullable = false)
    private Integer quantidadeDisponivel;

    @Column(length = 500)
    private String imagemUrl;

    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
        name = "livro_autor",
        joinColumns = @JoinColumn(name = "livro_id"),
        inverseJoinColumns = @JoinColumn(name = "autor_id")
    )
    private Set<Autor> autores = new HashSet<>();

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "categoria_id")
    private Categoria categoria;

    @OneToMany(mappedBy = "livro", cascade = {CascadeType.PERSIST, CascadeType.MERGE}, fetch = FetchType.LAZY)
    @JsonIgnore
    private Set<Emprestimo> emprestimos = new HashSet<>();

    @PrePersist
    protected void onCreate() {
        if (quantidadeDisponivel == null) {
            quantidadeDisponivel = quantidadeTotal;
        }
        // Remove formatação do ISBN
        if (isbn != null) {
            isbn = isbn.replaceAll("[^0-9X]", "");
        }
    }

    @PreUpdate
    protected void onUpdate() {
        // Remove formatação do ISBN
        if (isbn != null) {
            isbn = isbn.replaceAll("[^0-9X]", "");
        }
    }
}
