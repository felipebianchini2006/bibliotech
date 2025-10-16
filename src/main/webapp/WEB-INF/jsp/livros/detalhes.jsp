<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalhes do Livro - Bibliotech</title>
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
            max-width: 900px;
            margin: 0 auto;
            padding: 0 20px;
        }
        .navbar-brand { color: #333; font-weight: 600; font-size: 18px; text-decoration: none; }
        .container { max-width: 900px; padding: 30px 15px; margin: 0 auto; }
        .card {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 40px;
        }
        .book-header {
            display: flex;
            gap: 30px;
            margin-bottom: 30px;
        }
        .book-cover {
            flex-shrink: 0;
            width: 200px;
            height: 280px;
            background: #f5f5f5;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 60px;
        }
        .book-cover img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            border-radius: 8px;
        }
        .book-info h1 {
            color: #333;
            font-size: 28px;
            font-weight: 600;
            margin-bottom: 20px;
        }
        .info-row {
            display: flex;
            margin-bottom: 12px;
        }
        .info-label {
            color: #999;
            min-width: 120px;
            font-size: 14px;
        }
        .info-value {
            color: #333;
            font-size: 14px;
            font-weight: 500;
        }
        .badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            margin-left: 10px;
        }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-danger { background: #f8d7da; color: #721c24; }
        .description {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid #eee;
        }
        .description-label {
            color: #999;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .description-text {
            color: #666;
            font-size: 15px;
            line-height: 1.6;
        }
        .actions {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 1px solid #eee;
            display: flex;
            justify-content: space-between;
        }
        .btn-back { 
            background: none; 
            border: 1px solid #ddd; 
            color: #666; 
            padding: 10px 20px; 
            border-radius: 6px; 
            font-size: 14px;
            text-decoration: none;
        }
        .btn-back:hover { border-color: #333; color: #333; }
        .btn-edit {
            background: #333;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            color: white;
            text-decoration: none;
        }
        .btn-edit:hover { background: #000; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">📚 Bibliotech</a>
        </div>
    </nav>

    <div class="container">
        <div class="card">
            <div class="book-header">
                <div class="book-cover">
                    <c:choose>
                        <c:when test="${livro.imagemUrl != null && !livro.imagemUrl.isEmpty()}">
                            <img src="${livro.imagemUrl}" alt="Capa">
                        </c:when>
                        <c:otherwise>
                            <span>📖</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="book-info">
                    <h1>${livro.titulo}</h1>
                    
                    <div class="info-row">
                        <div class="info-label">ISBN</div>
                        <div class="info-value">${livro.isbn}</div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Categoria</div>
                        <div class="info-value">
                            <c:choose>
                                <c:when test="${livro.categoria != null}">
                                    ${livro.categoria.nome}
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Publicação</div>
                        <div class="info-value">
                            <tags:formatDate value="${livro.dataPublicacao}"/>
                        </div>
                    </div>

                    <div class="info-row">
                        <div class="info-label">Estoque</div>
                        <div class="info-value">
                            ${livro.quantidadeDisponivel} / ${livro.quantidadeTotal}
                            <c:choose>
                                <c:when test="${livro.quantidadeDisponivel == 0}">
                                    <span class="badge badge-danger">Esgotado</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-success">Disponível</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <c:if test="${livro.autores != null && !livro.autores.isEmpty()}">
                        <div class="info-row">
                            <div class="info-label">Autores</div>
                            <div class="info-value">
                                <c:forEach items="${livro.autores}" var="autor" varStatus="status">
                                    ${autor.nome}<c:if test="${!status.last}">, </c:if>
                                </c:forEach>
                            </div>
                        </div>
                    </c:if>
                </div>
            </div>

            <c:if test="${livro.descricao != null && !livro.descricao.isEmpty()}">
                <div class="description">
                    <div class="description-label">Descrição</div>
                    <div class="description-text">${livro.descricao}</div>
                </div>
            </c:if>

            <div class="actions">
                <a href="${pageContext.request.contextPath}/livros" class="btn-back">← Voltar</a>
                <a href="${pageContext.request.contextPath}/livros/${livro.id}/editar" class="btn-edit">Editar</a>
            </div>
        </div>
    </div>
</body>
</html>
