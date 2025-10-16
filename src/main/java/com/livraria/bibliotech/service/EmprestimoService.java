package com.livraria.bibliotech.service;

import com.livraria.bibliotech.exception.BusinessException;
import com.livraria.bibliotech.exception.ResourceNotFoundException;
import com.livraria.bibliotech.model.Emprestimo;
import com.livraria.bibliotech.model.Livro;
import com.livraria.bibliotech.model.Usuario;
import com.livraria.bibliotech.repository.EmprestimoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;

/**
 * Service para gerenciamento de empréstimos de livros.
 * Implementa regras de negócio: controle de estoque, validação de disponibilidade,
 * cálculo de multas e gestão de devoluções.
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class EmprestimoService {

    private final EmprestimoRepository emprestimoRepository;
    private final LivroService livroService;
    private final UsuarioService usuarioService;

    // Constantes de regras de negócio
    private static final int PRAZO_PADRAO_DIAS = 14;
    private static final int MAX_EMPRESTIMOS_SIMULTANEOS = 5;
    private static final int MAX_RENOVACOES = 2;

    /**
     * Realiza um novo empréstimo de livro.
     * Valida disponibilidade do livro e limites do usuário.
     */
    @Transactional
    public Emprestimo realizarEmprestimo(Long usuarioId, Long livroId, String observacoes) {
        log.info("Iniciando empréstimo - Usuário ID: {}, Livro ID: {}", usuarioId, livroId);

        // Buscar e validar usuário
        Usuario usuario = usuarioService.buscarPorId(usuarioId);
        if (!usuario.getAtivo()) {
            throw new BusinessException("Usuário inativo não pode realizar empréstimos", "USER_INACTIVE");
        }

        // Buscar e validar livro
        Livro livro = livroService.buscarPorId(livroId);
        if (livro.getQuantidadeDisponivel() <= 0) {
            throw new BusinessException("Livro sem exemplares disponíveis no momento", "OUT_OF_STOCK");
        }

        // Validar se usuário já tem empréstimo ativo deste livro
        if (emprestimoRepository.existeEmprestimoAtivoUsuarioLivro(usuarioId, livroId)) {
            throw new BusinessException("Usuário já possui empréstimo ativo deste livro", "DUPLICATE_LOAN");
        }

        // Validar limite de empréstimos simultâneos
        long emprestimosAtivos = usuarioService.contarEmprestimosAtivos(usuarioId);
        if (emprestimosAtivos >= MAX_EMPRESTIMOS_SIMULTANEOS) {
            throw new BusinessException(
                String.format("Usuário atingiu o limite máximo de %d empréstimos simultâneos", 
                    MAX_EMPRESTIMOS_SIMULTANEOS),
                "MAX_LOANS_REACHED"
            );
        }

        // Criar empréstimo
        Emprestimo emprestimo = new Emprestimo();
        emprestimo.setUsuario(usuario);
        emprestimo.setLivro(livro);
        emprestimo.setDataEmprestimo(LocalDateTime.now());
        emprestimo.setDataPrevistaDevolucao(LocalDateTime.now().plusDays(PRAZO_PADRAO_DIAS));
        emprestimo.setStatus(Emprestimo.Status.ATIVO);
        emprestimo.setObservacoes(observacoes);

        // Diminuir estoque do livro
        livroService.diminuirEstoque(livroId);

        Emprestimo saved = emprestimoRepository.save(emprestimo);
        log.info("Empréstimo realizado com sucesso - ID: {}", saved.getId());

        return saved;
    }

    /**
     * Realiza a devolução de um livro emprestado.
     */
    @Transactional
    public Emprestimo devolverLivro(Long emprestimoId) {
        log.info("Iniciando devolução - Empréstimo ID: {}", emprestimoId);

        Emprestimo emprestimo = buscarPorId(emprestimoId);

        if (emprestimo.getStatus() != Emprestimo.Status.ATIVO) {
            throw new BusinessException("Este empréstimo não está ativo", "LOAN_NOT_ACTIVE");
        }

        // Marcar como devolvido
        emprestimo.setDataDevolucao(LocalDateTime.now());
        
        // Verificar se está atrasado
        if (emprestimo.isAtrasado()) {
            emprestimo.setStatus(Emprestimo.Status.ATRASADO);
            log.warn("Livro devolvido com atraso - Empréstimo ID: {}", emprestimoId);
        } else {
            emprestimo.setStatus(Emprestimo.Status.DEVOLVIDO);
        }

        // Aumentar estoque do livro
        livroService.aumentarEstoque(emprestimo.getLivro().getId());

        Emprestimo saved = emprestimoRepository.save(emprestimo);
        log.info("Devolução concluída com sucesso - ID: {}", saved.getId());

        return saved;
    }

    /**
     * Renova um empréstimo, estendendo o prazo de devolução.
     */
    @Transactional
    public Emprestimo renovarEmprestimo(Long emprestimoId) {
        log.info("Renovando empréstimo - ID: {}", emprestimoId);

        Emprestimo emprestimo = buscarPorId(emprestimoId);

        if (emprestimo.getStatus() != Emprestimo.Status.ATIVO) {
            throw new BusinessException("Apenas empréstimos ativos podem ser renovados", "LOAN_NOT_ACTIVE");
        }

        if (emprestimo.isAtrasado()) {
            throw new BusinessException(
                "Não é possível renovar empréstimo atrasado. Realize a devolução primeiro.",
                "LOAN_OVERDUE"
            );
        }

        // Adicionar mais dias ao prazo
        LocalDateTime novoPrazo = emprestimo.getDataPrevistaDevolucao().plusDays(PRAZO_PADRAO_DIAS);
        emprestimo.setDataPrevistaDevolucao(novoPrazo);

        Emprestimo saved = emprestimoRepository.save(emprestimo);
        log.info("Empréstimo renovado até: {}", novoPrazo);

        return saved;
    }

    /**
     * Cancela um empréstimo (apenas se ainda não foi devolvido).
     */
    @Transactional
    public void cancelarEmprestimo(Long emprestimoId, String motivo) {
        log.info("Cancelando empréstimo - ID: {}, Motivo: {}", emprestimoId, motivo);

        Emprestimo emprestimo = buscarPorId(emprestimoId);

        if (emprestimo.getStatus() == Emprestimo.Status.DEVOLVIDO) {
            throw new BusinessException("Não é possível cancelar empréstimo já devolvido", "LOAN_ALREADY_RETURNED");
        }

        emprestimo.setStatus(Emprestimo.Status.CANCELADO);
        emprestimo.setObservacoes(
            (emprestimo.getObservacoes() != null ? emprestimo.getObservacoes() + " | " : "") 
            + "CANCELADO: " + motivo
        );

        // Se estava ativo, devolver estoque
        if (emprestimo.getDataDevolucao() == null) {
            livroService.aumentarEstoque(emprestimo.getLivro().getId());
        }

        emprestimoRepository.save(emprestimo);
        log.info("Empréstimo cancelado com sucesso");
    }

    /**
     * Calcula multa por atraso (valor em reais).
     */
    public double calcularMulta(Long emprestimoId) {
        Emprestimo emprestimo = buscarPorId(emprestimoId);

        if (!emprestimo.isAtrasado() && emprestimo.getStatus() == Emprestimo.Status.ATIVO) {
            return 0.0;
        }

        LocalDateTime dataReferencia = emprestimo.getDataDevolucao() != null 
            ? emprestimo.getDataDevolucao() 
            : LocalDateTime.now();

        long diasAtraso = ChronoUnit.DAYS.between(
            emprestimo.getDataPrevistaDevolucao(), 
            dataReferencia
        );

        if (diasAtraso <= 0) {
            return 0.0;
        }

        // R$ 2,00 por dia de atraso
        double multaPorDia = 2.00;
        double multa = diasAtraso * multaPorDia;

        log.info("Multa calculada - Empréstimo ID: {}, Dias atraso: {}, Valor: R$ {}", 
            emprestimoId, diasAtraso, multa);

        return multa;
    }

    /**
     * Busca empréstimo por ID.
     */
    public Emprestimo buscarPorId(Long id) {
        return emprestimoRepository.findById(id)
            .orElseThrow(() -> new ResourceNotFoundException("Empréstimo", id));
    }

    /**
     * Lista todos os empréstimos.
     */
    public List<Emprestimo> listarTodos() {
        return emprestimoRepository.findAll();
    }

    /**
     * Lista empréstimos por usuário.
     */
    public List<Emprestimo> listarPorUsuario(Long usuarioId) {
        return emprestimoRepository.findByUsuarioId(usuarioId);
    }

    /**
     * Lista empréstimos ativos por usuário.
     */
    public List<Emprestimo> listarAtivoPorUsuario(Long usuarioId) {
        return emprestimoRepository.findEmprestimosAtivosPorUsuario(usuarioId);
    }

    /**
     * Lista empréstimos por livro.
     */
    public List<Emprestimo> listarPorLivro(Long livroId) {
        return emprestimoRepository.findByLivroId(livroId);
    }

    /**
     * Lista empréstimos por status.
     */
    public List<Emprestimo> listarPorStatus(Emprestimo.Status status) {
        return emprestimoRepository.findByStatus(status);
    }

    /**
     * Lista empréstimos atrasados.
     */
    public List<Emprestimo> listarAtrasados() {
        return emprestimoRepository.findEmprestimosAtrasados(LocalDateTime.now());
    }

    /**
     * Lista últimos empréstimos (10 mais recentes).
     */
    public List<Emprestimo> listarUltimos() {
        return emprestimoRepository.findTop10ByOrderByDataEmprestimoDesc();
    }

    /**
     * Conta empréstimos ativos no sistema.
     */
    public Long contarAtivos() {
        return emprestimoRepository.contarEmprestimosAtivos();
    }

    /**
     * Lista empréstimos por período.
     */
    public List<Emprestimo> listarPorPeriodo(LocalDateTime dataInicio, LocalDateTime dataFim) {
        return emprestimoRepository.findByPeriodo(dataInicio, dataFim);
    }
}
