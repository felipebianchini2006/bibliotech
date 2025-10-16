<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${categoria.nome} - Bibliotech</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #fafafa;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
        }
        .navbar {
            background: white;
            border-bottom: 1px solid #eee;
            padding: 15px 0;
        }
        .navbar-content {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar-brand { color: #333; font-weight: 600; font-size: 18px; text-decoration: none; }
        .container { max-width: 900px; margin: 0 auto; padding: 40px 20px; }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        h1 { color: #333; font-size: 28px; font-weight: 600; }
        .card {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 20px;
        }
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eee;
        }
        .info-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 6px;
            margin-bottom: 15px;
        }
        .info-label {
            font-size: 12px;
            text-transform: uppercase;
            color: #999;
            margin-bottom: 5px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .info-value {
            font-size: 16px;
            color: #333;
            line-height: 1.6;
        }
        .btn {
            background: #333;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
        }
        .btn:hover { background: #555; }
        .btn-secondary {
            background: white;
            color: #333;
            border: 1px solid #ddd;
        }
        .btn-secondary:hover { border-color: #333; }
        .btn-danger {
            background: #dc3545;
        }
        .btn-danger:hover { background: #c82333; }
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .stat-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
        }
        .stat-number {
            font-size: 48px;
            font-weight: 700;
            margin: 10px 0;
        }
        .stat-label {
            font-size: 14px;
            opacity: 0.9;
            text-transform: uppercase;
            letter-spacing: 1px;
        }
        .livros-list {
            list-style: none;
        }
        .livros-list li {
            padding: 12px;
            border-bottom: 1px solid #eee;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .livros-list li:last-child {
            border-bottom: none;
        }
        .livros-list a {
            color: #007bff;
            text-decoration: none;
            font-size: 14px;
        }
        .livros-list a:hover {
            text-decoration: underline;
        }
        .actions {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">📚 Bibliotech</a>
        </div>
    </nav>

    <div class="container">
        <div class="header">
            <h1>🏷️ ${categoria.nome}</h1>
            <a href="${pageContext.request.contextPath}/categorias" class="btn btn-secondary">Voltar</a>
        </div>

        <c:if test="${not empty mensagem}">
            <div class="alert alert-success">${mensagem}</div>
        </c:if>
        <c:if test="${not empty erro}">
            <div class="alert alert-error">${erro}</div>
        </c:if>

        <div class="stat-box">
            <div class="stat-label">Total de Livros</div>
            <div class="stat-number">${quantidadeLivros}</div>
            <div class="stat-label">nesta categoria</div>
        </div>

        <div class="card">
            <div class="section-title">Informações da Categoria</div>
            
            <div class="info-item">
                <div class="info-label">Nome</div>
                <div class="info-value">${categoria.nome}</div>
            </div>

            <c:if test="${not empty categoria.descricao}">
                <div class="info-item">
                    <div class="info-label">Descrição</div>
                    <div class="info-value">${categoria.descricao}</div>
                </div>
            </c:if>

            <c:if test="${empty categoria.descricao}">
                <div class="info-item">
                    <div class="info-label">Descrição</div>
                    <div class="info-value" style="color: #999; font-style: italic;">
                        Nenhuma descrição cadastrada
                    </div>
                </div>
            </c:if>
        </div>

        <c:if test="${not empty categoria.livros}">
            <div class="card">
                <div class="section-title">📚 Livros nesta Categoria</div>
                <ul class="livros-list">
                    <c:forEach var="livro" items="${categoria.livros}">
                        <li>
                            <div>
                                <strong>${livro.titulo}</strong>
                                <br/>
                                <span style="color: #999; font-size: 13px;">ISBN: ${livro.isbn}</span>
                            </div>
                            <a href="${pageContext.request.contextPath}/livros/${livro.id}">Ver detalhes →</a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </c:if>

        <div class="card">
            <div class="actions">
                <a href="${pageContext.request.contextPath}/categorias/${categoria.id}/editar" 
                   class="btn">✏️ Editar Categoria</a>
                
                <a href="${pageContext.request.contextPath}/livros/buscar?categoriaId=${categoria.id}" 
                   class="btn btn-secondary">📚 Ver Livros</a>

                <c:if test="${quantidadeLivros == 0}">
                    <form action="${pageContext.request.contextPath}/categorias/${categoria.id}/deletar" 
                          method="post" 
                          style="display: inline;"
                          onsubmit="return confirm('Tem certeza que deseja deletar esta categoria?');">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-danger">🗑️ Deletar</button>
                    </form>
                </c:if>

                <c:if test="${quantidadeLivros > 0}">
                    <button type="button" 
                            class="btn btn-danger" 
                            style="opacity: 0.5; cursor: not-allowed;"
                            title="Não é possível deletar categoria com livros cadastrados"
                            disabled>
                        🗑️ Deletar
                    </button>
                    <div style="margin-top: 10px; color: #999; font-size: 13px;">
                        ℹ️ Para deletar esta categoria, remova ou recategorize todos os livros primeiro.
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</body>
</html>
