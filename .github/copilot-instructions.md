# GitHub Copilot Instructions - Bibliotech

## Contexto do Projeto

Sistema de gerenciamento de biblioteca desenvolvido em **Java 21** com **Spring Boot 3.5.6**, usando **JSP** para views, **PostgreSQL** como banco de dados e **Spring Security** para autenticação.

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
- **ISBN**: 10 ou 13 dígitos (usar validador customizado)
- **CPF**: 11 dígitos (usar validador customizado)
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
Todas as exceções são tratadas centralmente. Retorna:
- Redirect com `RedirectAttributes.addFlashAttribute("erro", mensagem)`

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

## Banco de Dados

### Configurações
```properties
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
```

### Scripts SQL
1. `database/init.sql` - Criação do banco
2. `database/dados-iniciais.sql` - Usuários padrão
3. `database/dados-livros.sql` - População de dados

### Relacionamentos JPA

#### Many-to-Many (Livro-Autor)
```java
@ManyToMany(fetch = FetchType.LAZY)
@JoinTable(
    name = "livro_autor",
    joinColumns = @JoinColumn(name = "livro_id"),
    inverseJoinColumns = @JoinColumn(name = "autor_id")
)
private Set<Autor> autores = new HashSet<>();
```

**IMPORTANTE**: Ao salvar Livro com Autores, sempre buscar os autores do banco primeiro:
```java
Set<Autor> autoresPersistidos = new HashSet<>();
for (Autor autor : livro.getAutores()) {
    if (autor.getId() != null) {
        Autor autorPersistido = autorRepository.findById(autor.getId())
            .orElseThrow(() -> new ResourceNotFoundException("Autor", autor.getId()));
        autoresPersistidos.add(autorPersistido);
    }
}
livro.setAutores(autoresPersistidos);
```

#### Many-to-One (Livro-Categoria)
```java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "categoria_id")
private Categoria categoria;
```

## Controllers - Padrão para Receber Dados de Formulários

### Recebendo IDs de Relacionamentos Many-to-Many
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
    return "redirect:/entidades";
}
```

## Formulários JSP - Padrão para Checkboxes

### Checkboxes para Relacionamento Many-to-Many
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

## Testes

### Padrão de Teste
```java
@SpringBootTest
@Transactional // Rollback automático
class ServiceTest {
    @Autowired
    private Service service;
    
    @Test
    void deveRealizarOperacao() {
        // Arrange
        // Act
        // Assert
    }
}
```

## Convenções de Commit

### Formato
```
tipo(escopo): mensagem

feat(livros): adiciona busca por ISBN
fix(emprestimos): corrige cálculo de multa
docs(readme): atualiza instruções de instalação
refactor(services): simplifica lógica de validação
test(usuarios): adiciona testes de cadastro
```

### Tipos
- `feat`: Nova funcionalidade
- `fix`: Correção de bug
- `docs`: Documentação
- `refactor`: Refatoração
- `test`: Testes
- `chore`: Manutenção

## Debugging

### Logs Importantes
```java
@Slf4j // Lombok
log.info("Operação iniciada - ID: {}", id);
log.warn("Aviso: {}", mensagem);
log.error("Erro: {}", e.getMessage(), e);
```

### Níveis de Log
```properties
logging.level.com.livraria.bibliotech=DEBUG
logging.level.org.hibernate.SQL=DEBUG
```

## Comandos Úteis

### Executar Aplicação
```bash
# Windows
mvnw.cmd spring-boot:run

# Linux/Mac
./mvnw spring-boot:run
```

### Criar Build
```bash
mvnw clean package
```

### Executar Testes
```bash
mvnw test
```

## Credenciais Padrão

### Admin
- Email: `admin@bibliotech.com`
- Senha: `admin123`

### Usuário
- Email: `joao@email.com`
- Senha: `user123`

## Endpoints Principais

### Públicos
- `GET /login` - Página de login
- `POST /perform-login` - Autenticação
- `GET /registro` - Formulário de cadastro
- `POST /registro` - Processar cadastro

### Livros
- `GET /livros` - Listar todos
- `GET /livros/novo` - Formulário (ADMIN)
- `POST /livros` - Criar (ADMIN)
- `GET /livros/{id}` - Detalhes
- `GET /livros/{id}/editar` - Formulário edição (ADMIN)
- `POST /livros/{id}` - Atualizar (ADMIN)
- `POST /livros/{id}/deletar` - Deletar (ADMIN)

### Empréstimos
- `GET /emprestimos` - Listar
- `GET /emprestimos/novo` - Formulário (ADMIN)
- `POST /emprestimos` - Criar (ADMIN)
- `POST /emprestimos/{id}/devolver` - Devolver (ADMIN)
- `POST /emprestimos/{id}/renovar` - Renovar
- `GET /emprestimos/meus` - Meus empréstimos (USER)

### Usuários (ADMIN only)
- `GET /usuarios` - Listar
- `GET /usuarios/{id}` - Detalhes
- `GET /usuarios/{id}/editar` - Editar
- `POST /usuarios/{id}/status` - Ativar/Desativar

## Boas Práticas

### 1. Sempre validar entrada
```java
@Valid @ModelAttribute Entidade entidade
```

### 2. Usar Optional para buscar entidades
```java
public Optional<Usuario> buscarPorEmail(String email) {
    return usuarioRepository.findByEmail(email);
}
```

### 3. Lançar exceções apropriadas
```java
if (!found) {
    throw new ResourceNotFoundException("Usuario", "email", email);
}
```

### 4. Criptografar senhas
```java
usuario.setSenha(passwordEncoder.encode(senha));
```

### 5. Usar @PrePersist e @PreUpdate
```java
@PrePersist
protected void onCreate() {
    dataCadastro = LocalDateTime.now();
}
```

### 6. Limpar dados antes de salvar
```java
// Remover formatação de CPF
cpf = cpf.replaceAll("[^0-9]", "");

// Remover formatação de ISBN
isbn = isbn.replaceAll("[^0-9X]", "");
```

### 7. Fetch otimizado
```java
@Query("SELECT DISTINCT l FROM Livro l LEFT JOIN FETCH l.autores WHERE l.id = :id")
Optional<Livro> findByIdWithDetails(@Param("id") Long id);
```

## Checklist de Nova Feature

- [ ] Criar entidade JPA
- [ ] Criar repository
- [ ] Criar service com lógica de negócio
- [ ] Criar controller com endpoints
- [ ] Criar views JSP
- [ ] Adicionar validações
- [ ] Adicionar tratamento de erros
- [ ] Adicionar testes
- [ ] Atualizar documentação
- [ ] Testar manualmente

## Problemas Comuns e Soluções

### 1. Lazy Loading Exception
**Problema**: `LazyInitializationException` ao acessar relacionamentos
**Solução**: 
- Usar `@Transactional` no método do service
- Ou usar fetch join na query:
```java
@Query("SELECT DISTINCT e FROM Entidade e LEFT JOIN FETCH e.relacionamento WHERE e.id = :id")
Optional<Entidade> findByIdWithRelacionamento(@Param("id") Long id);
```

### 2. CSRF Token Missing
**Problema**: Erro 403 em formulários POST
**Solução**: Incluir token CSRF:
```jsp
<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
```

### 3. 403 Forbidden
**Problema**: Acesso negado a recurso
**Solução**: 
- Verificar roles em `@PreAuthorize`
- Verificar URLs permitidas em `SecurityConfig`
- Verificar se usuário está autenticado

### 4. Datas não formatando em JSP
**Problema**: LocalDate/LocalDateTime não aparecem formatadas
**Solução**: Usar tags customizadas:
```jsp
<%@ taglib prefix="fmt" tagdir="/WEB-INF/tags" %>
<fmt:formatDate value="${entidade.data}"/>
<fmt:formatDateTime value="${entidade.dataHora}"/>
```

### 5. Relacionamento Many-to-Many não salvando
**Problema**: Autores/relacionamentos não persistem ao salvar entidade
**Solução**: Buscar entidades relacionadas do banco antes de salvar:
```java
Set<Relacionamento> relacionamentosPersistidos = new HashSet<>();
for (Relacionamento rel : entidade.getRelacionamentos()) {
    if (rel.getId() != null) {
        Relacionamento relPersistido = relacionamentoRepository
            .findById(rel.getId())
            .orElseThrow(() -> new ResourceNotFoundException("Relacionamento", rel.getId()));
        relacionamentosPersistidos.add(relPersistido);
    }
}
entidade.setRelacionamentos(relacionamentosPersistidos);
```

### 6. TransientObjectException
**Problema**: Tentando salvar entidade com relacionamento transiente
**Causa**: Relacionamento não está persistido no banco
**Solução**: Sempre buscar entidades relacionadas do banco antes de salvar

### 7. Formulário não envia checkboxes
**Problema**: Relacionamentos many-to-many não chegam ao controller
**Solução**: 
- Usar `@RequestParam` para receber array de IDs
- Converter IDs em entidades no controller
- Passar entidades para o service

### 8. Estoque ficando negativo
**Problema**: `quantidadeDisponivel` fica negativo após empréstimos
**Solução**: Adicionar validação no service:
```java
if (livro.getQuantidadeDisponivel() <= 0) {
    throw new BusinessException("Livro sem estoque disponível", "OUT_OF_STOCK");
}
```

### 9. Query N+1
**Problema**: Múltiplas queries para carregar relacionamentos
**Identificação**: Ver logs do Hibernate com muitas SELECT
**Solução**: Usar JOIN FETCH:
```java
@Query("SELECT DISTINCT e FROM Entidade e LEFT JOIN FETCH e.relacionamentos")
List<Entidade> findAllWithRelacionamentos();
```

### 10. Senha não criptografando
**Problema**: Senha salva em texto plano
**Solução**: Usar `PasswordEncoder` no service:
```java
usuario.setSenha(passwordEncoder.encode(usuario.getSenha()));
```

## Regras Específicas do Projeto

### Ao criar código para LIVROS:
1. Sempre buscar autores do banco antes de salvar
2. Validar ISBN único
3. Limpar formatação do ISBN
4. Garantir `quantidadeDisponivel <= quantidadeTotal`
5. Não permitir deletar se houver empréstimos ativos

### Ao criar código para EMPRÉSTIMOS:
1. Validar limite de 5 empréstimos por usuário
2. Decrementar estoque ao criar
3. Incrementar estoque ao devolver
4. Calcular multa: R$ 2,00/dia
5. Não permitir renovação se atrasado
6. Prazo padrão: 14 dias

### Ao criar código para USUÁRIOS:
1. Criptografar senha sempre
2. Limpar formatação de CPF
3. Validar email único
4. Validar CPF único
5. Não permitir alterar email e CPF após cadastro

### Ao criar VIEWS JSP:
1. Sempre incluir CSRF token em forms POST
2. Usar tags customizadas para datas
3. Sempre exibir mensagens flash (mensagem, erro, aviso)
4. Usar checkboxes para many-to-many
5. Adicionar loading states em botões de submit

## Padrões de Resposta do Controller

### Sucesso
```java
redirectAttributes.addFlashAttribute("mensagem", "Operação realizada com sucesso!");
return "redirect:/entidades";
```

### Erro de Validação
```java
model.addAttribute("erro", "Mensagem de erro");
return "entidades/form"; // Retorna ao formulário
```

### Erro de Negócio
```java
// Lançar exceção no service
throw new BusinessException("Mensagem", "ERROR_CODE");

// GlobalExceptionHandler trata e redireciona
```

## Padrões de CSS

### Classes Utilitárias
- `.alert-success` - Mensagens de sucesso (verde)
- `.alert-error` - Mensagens de erro (vermelho)
- `.alert-warning` - Avisos (amarelo)
- `.badge` - Tags/labels
- `.btn` - Botões
- `.btn-primary` - Botão principal (preto)
- `.btn-secondary` - Botão secundário (branco)
- `.btn-danger` - Botão de ação destrutiva (vermelho)

### Padrão de Cores
- Principal: `#333` (preto suave)
- Secundário: `#666` (cinza escuro)
- Background: `#fafafa` (cinza claro)
- Borda: `#eee` (cinza muito claro)
- Sucesso: `#28a745` (verde)
- Erro: `#dc3545` (vermelho)
- Aviso: `#ffc107` (amarelo)

## Referências Rápidas

### Spring Boot
- [Documentação Oficial](https://docs.spring.io/spring-boot/docs/current/reference/html/)
- [Spring Security](https://docs.spring.io/spring-security/reference/index.html)
- [Spring Data JPA](https://docs.spring.io/spring-data/jpa/docs/current/reference/html/)

### Validação
- [Bean Validation](https://beanvalidation.org/2.0/spec/)
- [Hibernate Validator](https://hibernate.org/validator/)

### Lombok
- [Features](https://projectlombok.org/features/)
- [Annotations](https://projectlombok.org/features/all)

### JSP
- [JSTL](https://docs.oracle.com/javaee/5/jstl/1.1/docs/tlddocs/)
- [Spring Security Tags](https://docs.spring.io/spring-security/reference/servlet/integrations/jsp-taglibs.html)

## Métricas de Qualidade

### Code Coverage
- Mínimo esperado: 70%
- Services críticos: 90%+

### Complexity
- Cyclomatic Complexity máxima: 10 por método
- Evitar métodos com mais de 50 linhas

### Performance
- Tempo de resposta: < 200ms (95% das requisições)
- Queries: < 100ms
- Evitar N+1 queries

## Observações Finais

Este projeto segue padrões MVC tradicionais com Spring Boot e JSP. Ao gerar código:

1. **Sempre** respeite a arquitetura em camadas
2. **Sempre** use transações em operações de escrita
3. **Sempre** valide entrada de dados
4. **Sempre** trate exceções apropriadamente
5. **Sempre** busque entidades relacionadas do banco antes de persistir
6. **Sempre** use logs para operações importantes
7. **Nunca** exponha dados sensíveis nos logs
8. **Nunca** salve senhas em texto plano
9. **Nunca** confie em dados do cliente sem validação
10. **Nunca** ignore exceções silenciosamente