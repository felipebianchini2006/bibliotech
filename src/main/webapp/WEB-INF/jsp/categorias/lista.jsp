<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Categorias - Bibliotech</title>
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
        .container { max-width: 1200px; margin: 0 auto; padding: 40px 20px; }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        h1 { color: #333; font-size: 28px; font-weight: 600; }
        .btn {
            background: #333;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            cursor: pointer;
            display: inline-block;
        }
        .btn:hover { background: #555; }
        .btn-secondary {
            background: white;
            color: #333;
            border: 1px solid #ddd;
        }
        .btn-secondary:hover { border-color: #333; }
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .search-box {
            margin-bottom: 20px;
        }
        .search-box input {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            width: 300px;
        }
        .cards-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
        }
        .card {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 25px;
            transition: all 0.2s;
        }
        .card:hover {
            border-color: #333;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .card-icon {
            font-size: 32px;
            margin-bottom: 15px;
        }
        .card-title {
            font-size: 20px;
            font-weight: 600;
            color: #333;
            margin-bottom: 10px;
        }
        .card-desc {
            color: #666;
            font-size: 14px;
            line-height: 1.5;
            margin-bottom: 15px;
        }
        .card-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 20px;
            padding-top: 15px;
            border-top: 1px solid #eee;
        }
        .card-count {
            color: #999;
            font-size: 13px;
        }
        .card-actions a {
            color: #007bff;
            text-decoration: none;
            font-size: 13px;
            margin-left: 15px;
        }
        .card-actions a:hover {
            text-decoration: underline;
        }
        .empty-state {
            padding: 80px 20px;
            text-align: center;
            color: #999;
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
            <h1>🏷️ Categorias</h1>
            <div>
                <a href="${pageContext.request.contextPath}/categorias/nova" class="btn">+ Nova Categoria</a>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Voltar</a>
            </div>
        </div>

        <c:if test="${not empty mensagem}">
            <div class="alert alert-success">${mensagem}</div>
        </c:if>
        <c:if test="${not empty erro}">
            <div class="alert alert-error">${erro}</div>
        </c:if>

        <div class="search-box">
            <form action="${pageContext.request.contextPath}/categorias/buscar" method="get">
                <input type="text" name="nome" placeholder="🔍 Buscar categoria..." 
                       value="${termoBusca}"/>
                <button type="submit" class="btn">Buscar</button>
            </form>
        </div>

        <c:choose>
            <c:when test="${empty categorias}">
                <div class="empty-state">
                    <p style="font-size: 64px; margin-bottom: 15px;">🏷️</p>
                    <p style="font-size: 18px; color: #666;">Nenhuma categoria cadastrada</p>
                    <p style="font-size: 14px; margin-top: 10px;">
                        <a href="${pageContext.request.contextPath}/categorias/nova" class="btn" style="margin-top: 20px;">
                            Criar Primeira Categoria
                        </a>
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="cards-grid">
                    <c:forEach var="categoria" items="${categorias}">
                        <div class="card">
                            <div class="card-icon">🏷️</div>
                            <div class="card-title">${categoria.nome}</div>
                            <div class="card-desc">
                                <c:choose>
                                    <c:when test="${not empty categoria.descricao}">
                                        ${categoria.descricao}
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #ccc;">Sem descrição</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="card-footer">
                                <span class="card-count">
                                    📚 ${categoria.livros.size()} 
                                    ${categoria.livros.size() == 1 ? 'livro' : 'livros'}
                                </span>
                                <div class="card-actions">
                                    <a href="${pageContext.request.contextPath}/categorias/${categoria.id}">
                                        Ver detalhes
                                    </a>
                                    <a href="${pageContext.request.contextPath}/categorias/${categoria.id}/editar">
                                        Editar
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</body>
</html>
