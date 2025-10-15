<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${autor.nome} - Bibliotech</title>
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
        .navbar-links a {
            color: #666;
            text-decoration: none;
            margin-left: 20px;
            font-size: 14px;
        }
        .navbar-links a:hover { color: #333; }
        .container { max-width: 1200px; margin: 0 auto; padding: 40px 20px; }
        .breadcrumb {
            color: #999;
            font-size: 14px;
            margin-bottom: 20px;
        }
        .breadcrumb a {
            color: #666;
            text-decoration: none;
        }
        .breadcrumb a:hover { color: #333; }
        .autor-header {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 30px;
            display: flex;
            gap: 30px;
        }
        .autor-foto-container {
            flex-shrink: 0;
        }
        .autor-foto {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            object-fit: cover;
        }
        .autor-foto-placeholder {
            width: 150px;
            height: 150px;
            border-radius: 50%;
            background: #e0e0e0;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
        }
        .autor-info {
            flex: 1;
        }
        .autor-nome {
            color: #333;
            font-size: 32px;
            font-weight: 600;
            margin-bottom: 15px;
        }
        .autor-meta {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .meta-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #666;
            font-size: 14px;
        }
        .meta-icon {
            font-size: 18px;
        }
        .autor-biografia {
            color: #666;
            line-height: 1.6;
            margin-top: 20px;
        }
        .actions {
            display: flex;
            gap: 10px;
            margin-top: 20px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }
        .btn-primary {
            background: #333;
            color: white;
        }
        .btn-primary:hover { background: #555; }
        .btn-secondary {
            background: white;
            color: #333;
            border: 1px solid #ddd;
        }
        .btn-secondary:hover { border-color: #333; }
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        .btn-danger:hover { background: #c82333; }
        .section {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 20px;
        }
        .section-title {
            color: #333;
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .livros-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 20px;
        }
        .livro-card {
            border: 1px solid #eee;
            border-radius: 6px;
            padding: 15px;
            text-decoration: none;
            transition: all 0.2s;
        }
        .livro-card:hover {
            border-color: #333;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .livro-titulo {
            color: #333;
            font-weight: 500;
            margin-bottom: 8px;
        }
        .livro-info {
            color: #999;
            font-size: 13px;
        }
        .livro-categoria {
            display: inline-block;
            background: #f0f0f0;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            color: #666;
            margin-top: 8px;
        }
        .empty-state {
            text-align: center;
            padding: 40px 20px;
            color: #999;
        }
        .empty-state-icon {
            font-size: 40px;
            margin-bottom: 10px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">📚 Bibliotech</a>
            <div class="navbar-links">
                <a href="${pageContext.request.contextPath}/livros">Livros</a>
                <a href="${pageContext.request.contextPath}/autores">Autores</a>
                <a href="${pageContext.request.contextPath}/categorias">Categorias</a>
                <a href="${pageContext.request.contextPath}/emprestimos">Empréstimos</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="breadcrumb">
            <a href="${pageContext.request.contextPath}/home">Home</a> / 
            <a href="${pageContext.request.contextPath}/autores">Autores</a> / 
            ${autor.nome}
        </div>

        <div class="autor-header">
            <div class="autor-foto-container">
                <c:choose>
                    <c:when test="${not empty autor.fotoUrl}">
                        <img src="${autor.fotoUrl}" alt="${autor.nome}" class="autor-foto">
                    </c:when>
                    <c:otherwise>
                        <div class="autor-foto-placeholder">👤</div>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="autor-info">
                <h1 class="autor-nome">${autor.nome}</h1>

                <div class="autor-meta">
                    <c:if test="${not empty autor.nacionalidade}">
                        <div class="meta-item">
                            <span class="meta-icon">🌍</span>
                            <span>${autor.nacionalidade}</span>
                        </div>
                    </c:if>

                    <c:if test="${not empty autor.dataNascimento}">
                        <div class="meta-item">
                            <span class="meta-icon">📅</span>
                            <span>Nascido em ${autor.dataNascimento}</span>
                        </div>
                    </c:if>

                    <div class="meta-item">
                        <span class="meta-icon">📚</span>
                        <span>${autor.livros.size()} livro(s) publicado(s)</span>
                    </div>
                </div>

                <c:if test="${not empty autor.biografia}">
                    <div class="autor-biografia">
                        ${autor.biografia}
                    </div>
                </c:if>

                <sec:authorize access="hasRole('ADMIN')">
                    <div class="actions">
                        <a href="${pageContext.request.contextPath}/autores/${autor.id}/editar" 
                           class="btn btn-primary">✏️ Editar</a>
                        <form action="${pageContext.request.contextPath}/autores/${autor.id}/deletar" 
                              method="post" 
                              style="display: inline;"
                              onsubmit="return confirm('Tem certeza que deseja deletar este autor? Esta ação não pode ser desfeita.');">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button type="submit" class="btn btn-danger">🗑️ Deletar</button>
                        </form>
                        <a href="${pageContext.request.contextPath}/autores" 
                           class="btn btn-secondary">← Voltar</a>
                    </div>
                </sec:authorize>
                <sec:authorize access="!hasRole('ADMIN')">
                    <div class="actions">
                        <a href="${pageContext.request.contextPath}/autores" 
                           class="btn btn-secondary">← Voltar</a>
                    </div>
                </sec:authorize>
            </div>
        </div>

        <div class="section">
            <h2 class="section-title">
                <span>📚</span>
                <span>Livros do Autor</span>
            </h2>

            <c:choose>
                <c:when test="${empty autor.livros}">
                    <div class="empty-state">
                        <div class="empty-state-icon">📖</div>
                        <p>Nenhum livro cadastrado para este autor ainda.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="livros-grid">
                        <c:forEach var="livro" items="${autor.livros}">
                            <a href="${pageContext.request.contextPath}/livros/${livro.id}" class="livro-card">
                                <div class="livro-titulo">${livro.titulo}</div>
                                <div class="livro-info">
                                    ISBN: ${livro.isbn}<br>
                                    Publicado: ${livro.dataPublicacao}
                                </div>
                                <c:if test="${not empty livro.categoria}">
                                    <span class="livro-categoria">${livro.categoria.nome}</span>
                                </c:if>
                            </a>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
