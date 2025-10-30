# GitHub Copilot Instructions - Bibliotech

## Contexto do Projeto

Sistema de gerenciamento de biblioteca desenvolvido em **Java 21** com **Spring Boot 3.5.6**, usando **JSP** para views, **PostgreSQL** como banco de dados e **Spring Security** para autenticação.

Sistema 100% funcional e testado com 35/35 funcionalidades aprovadas.

## Arquitetura e Padrões

### Estrutura de Camadas
```
Controller → Service → Repository → Entity
```

**IMPORTANTE**: Sempre manter esta separação de responsabilidades:
- **Controllers**: Apenas roteamento e validação de entrada
- **Services**: Lógica de negócio e transações
- **Repositories**: Acesso a dados (Spring Data JPA)
- **Entities**: Modelos de dados JPA

### Padrões de Código

#### Nomenclatura
- **Classes de Entidade**: Singular (Livro, Usuario, Autor)
- **Repositories**: NomeEntidadeRepository (LivroRepository)
- **Services**: NomeEntidadeService (LivroService)
- **Controllers**: NomeEntidadeController (LivroController)
- **DTOs**: NomeEntidadeDTO, NomeEntidadeResponseDTO

#### Annotations Lombok
Sempre usar em entidades:
```java
@Data
@NoArgsConstructor
@AllArgsConstructor
@ToString(exclude = {"relacionamentos"})
@EqualsAndHashCode(exclude = {"relacionamentos"})
```

#### Transações
```java
@Transactional // Para métodos que modificam dados
public TipoRetorno metodoQueModifica() { ... }
```

## Regras de Negócio

### Sistema de Empréstimos
1. **Prazo padrão**: 14 dias
2. **Limite por usuário**: 5 empréstimos simultâneos
3. **Multa**: R$ 2,00 por dia de atraso
4. **Renovações**: Ilimitadas (se não estiver atrasado)
5. **Status**: ATIVO, DEVOLVIDO, ATRASADO, CANCELADO

### Validações
- **ISBN**: 10 ou 13 dígitos com checksum (validador customizado @ValidISBN)
- **CPF**: 11 dígitos com checksum (validador customizado @ValidCPF)
- **Email**: Formato válido e único
- **Senha**: Mínimo 6 caracteres (criptografada com BCrypt)

### Controle de Estoque
- Ao criar empréstimo: `quantidadeDisponivel--`
- Ao devolver/cancelar: `quantidadeDisponivel++`
- Nunca permitir estoque negativo

## Segurança (Spring Security)

### Roles
- **ROLE_ADMIN**: Acesso total
- **ROLE_USER**: Acesso limitado (seus próprios empréstimos)

### Rotas Protegidas
```java
@PreAuthorize("hasRole('ADMIN')") // Apenas admin
@PreAuthorize("hasRole('USER')")  // Usuários autenticados
```

### URLs Públicas
- `/login`, `/registro`, `/css/**`, `/js/**`, `/images/**`

## Tratamento de Erros

### Exceções Customizadas
```java
throw new ResourceNotFoundException("Entidade", id);
throw new BusinessException("Mensagem", "ERROR_CODE");
throw new ValidationException("campo", "mensagem");
```

### GlobalExceptionHandler
Todas as exceções são tratadas centralmente e retornam redirect com flash attributes.

## Views JSP

### Estrutura Padrão
```jsp
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" tagdir="/WEB-INF/tags" %>
```

### Formatação de Datas
```jsp
<!-- LocalDate -->
<fmt:formatDate value="${livro.dataPublicacao}"/>

<!-- LocalDateTime -->
<fmt:formatDateTime value="${emprestimo.dataEmprestimo}"/>

<!-- Para inputs date HTML5 -->
<fmt:formatDateISO value="${livro.dataPublicacao}"/>
```

### CSRF Token
Sempre incluir em formulários POST:
```jsp
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
```

### Mensagens Flash
```jsp
<c:if test="${not empty mensagem}">
    <div class="alert alert-success">${mensagem}</div>
</c:if>
<c:if test="${not empty erro}">
    <div class="alert alert-error">${erro}</div>
</c:if>
```

## Relacionamentos JPA - PADRÃO OBRIGATÓRIO

### Many-to-Many (Livro-Autor)
```java
@ManyToMany(fetch = FetchType.LAZY)
@JoinTable(
    name = "livro_autor",
    joinColumns = @JoinColumn(name = "livro_id"),
    inverseJoinColumns = @JoinColumn(name = "autor_id")
)
private Set<Autor> autores = new HashSet<>();
```

**CRÍTICO**: Ao salvar Livro com Autores, SEMPRE buscar os autores do banco primeiro:
```java
if (livro.getAutores() != null && !livro.getAutores().isEmpty()) {
    Set<Autor> autoresPersistidos = new HashSet<>();
    for (Autor autor : livro.getAutores()) {
        if (autor.getId() != null) {
            Autor autorPersistido = autorRepository.findById(autor.getId())
                .orElseThrow(() -> new ResourceNotFoundException("Autor", autor.getId()));
            autoresPersistidos.add(autorPersistido);
        }
    }
    livro.setAutores(autoresPersistidos);
}
```

## Controllers - Padrão para Formulários

### Recebendo Many-to-Many via Checkboxes
```java
@PostMapping
public String salvar(
    @Valid @ModelAttribute Entidade entidade,
    @RequestParam(value = "relacionamentosIds", required = false) Long[] relacionamentosIds,
    BindingResult result,
    RedirectAttributes redirectAttributes) {
    
    if (relacionamentosIds != null && relacionamentosIds.length > 0) {
        Set<Relacionamento> relacionamentos = new HashSet<>();
        for (Long id : relacionamentosIds) {
            Relacionamento rel = new Relacionamento();
            rel.setId(id);
            relacionamentos.add(rel);
        }
        entidade.setRelacionamentos(relacionamentos);
    }
    
    service.salvar(entidade);
    redirectAttributes.addFlashAttribute("mensagem", "Salvo com sucesso!");
    return "redirect:/entidades";
}
```

## Formulários JSP - Checkboxes para Many-to-Many
```jsp
<div class="col-12">
    <label>Relacionamentos</label>
    <div class="checkbox-group">
        <c:forEach items="${relacionamentos}" var="item">
            <div class="checkbox-item">
                <input type="checkbox" 
                       name="relacionamentosIds" 
                       value="${item.id}" 
                       id="item_${item.id}"
                       <c:if test="${entidade.relacionamentos != null}">
                           <c:forEach items="${entidade.relacionamentos}" var="rel">
                               <c:if test="${rel.id == item.id}">checked</c:if>
                           </c:forEach>
                       </c:if>>
                <label for="item_${item.id}">${item.nome}</label>
            </div>
        </c:forEach>
    </div>
</div>
```

## Busca Avançada - Padrão Implementado
```java
// Repository
@Query("SELECT DISTINCT e FROM Entidade e " +
       "LEFT JOIN e.relacionamento1 r1 " +
       "LEFT JOIN e.relacionamento2 r2 " +
       "WHERE LOWER(e.campo1) LIKE LOWER(CONCAT('%', :termo, '%')) " +
       "OR LOWER(r1.nome) LIKE LOWER(CONCAT('%', :termo, '%')) " +
       "OR LOWER(r2.nome) LIKE LOWER(CONCAT('%', :termo, '%'))")
List<Entidade> buscarPorTermo(@Param("termo") String termo);
```

## Queries Otimizadas - Evitar N+1
```java
@Query("SELECT DISTINCT e FROM Entidade e " +
       "LEFT JOIN FETCH e.relacionamento1 " +
       "LEFT JOIN FETCH e.relacionamento2")
List<Entidade> findAllWithDetails();
```

## Validações - Padrões Implementados

### ISBN
```java
@ValidISBN(message = "ISBN inválido")
@NotBlank(message = "ISBN é obrigatório")
@Column(unique = true, nullable = false, length = 13)
private String isbn;
```

### CPF
```java
@ValidCPF(message = "CPF inválido")
@NotBlank(message = "CPF é obrigatório")
@Column(unique = true, nullable = false, length = 11)
private String cpf;
```

### Máscara de CPF no Frontend
```javascript
document.getElementById('cpf').addEventListener('input', function(e) {
    let value = e.target.value.replace(/\D/g, '');
    if (value.length <= 11) {
        value = value.replace(/(\d{3})(\d)/, '$1.$2');
        value = value.replace(/(\d{3})(\d)/, '$1.$2');
        value = value.replace(/(\d{3})(\d{1,2})$/, '$1-$2');
    }
    e.target.value = value;
});
```

## Credenciais Padrão

### Admin
- Email: `admin@bibliotech.com`
- Senha: `admin123`
- Role: ADMIN

### Usuário Teste
- Email: `joao@email.com`
- Senha: `user123`
- Role: USER

## Endpoints Principais

### Livros
- `GET /livros` - Listar
- `GET /livros/novo` - Formulário (ADMIN)
- `POST /livros` - Criar (ADMIN)
- `GET /livros/{id}` - Detalhes
- `GET /livros/{id}/editar` - Editar (ADMIN)
- `POST /livros/{id}` - Atualizar (ADMIN)
- `POST /livros/{id}/deletar` - Deletar (ADMIN)
- `GET /livros/buscar?titulo=termo` - Buscar (título, autor ou categoria)

### Empréstimos
- `GET /emprestimos` - Listar
- `GET /emprestimos/novo` - Formulário (ADMIN)
- `POST /emprestimos` - Criar (ADMIN)
- `GET /emprestimos/{id}` - Detalhes
- `POST /emprestimos/{id}/devolver` - Devolver (ADMIN)
- `POST /emprestimos/{id}/renovar` - Renovar
- `GET /emprestimos/meus` - Meus empréstimos (USER)

## Comandos Úteis
```bash
# Executar aplicação
./mvnw spring-boot:run  # Linux/Mac
mvnw.cmd spring-boot:run  # Windows

# Compilar
./mvnw clean package

# Executar testes
./mvnw test
```

## Problemas Comuns e Soluções

### 1. TransientObjectException ao salvar relacionamento
**Causa**: Tentando salvar entidade com relacionamento não persistido
**Solução**: Sempre buscar entidades relacionadas do banco antes de salvar (ver padrão acima)

### 2. Query N+1
**Identificação**: Múltiplas SELECTs no log do Hibernate
**Solução**: Usar JOIN FETCH nas queries

### 3. Lazy Loading Exception
**Solução**: Usar @Transactional no método do service ou JOIN FETCH

### 4. CSRF 403
**Solução**: Incluir `${_csrf.parameterName}` e `${_csrf.token}` em todos os forms POST

## Checklist de Nova Feature

- [ ] Criar entidade JPA com Lombok annotations
- [ ] Criar repository com queries customizadas se necessário
- [ ] Criar service com @Transactional nos métodos de escrita
- [ ] Criar controller com endpoints e @PreAuthorize
- [ ] Criar views JSP com CSRF token
- [ ] Adicionar validações Bean Validation
- [ ] Adicionar tratamento de erros
- [ ] Testar manualmente todas as operações
- [ ] Verificar logs do Hibernate para queries N+1

## Observações Finais

Este projeto está 100% funcional e testado. Ao gerar código:

1. **Sempre** busque entidades relacionadas do banco antes de persistir
2. **Sempre** use @Transactional em operações de escrita
3. **Sempre** valide entrada de dados
4. **Sempre** use queries com JOIN FETCH para evitar N+1
5. **Sempre** inclua CSRF token em formulários POST
6. **Nunca** salve senhas em texto plano
7. **Nunca** confie em dados do cliente sem validação

Sistema testado e aprovado com 35/35 funcionalidades operacionais.