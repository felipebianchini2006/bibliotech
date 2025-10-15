<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Autores - Bibliotech</title>
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
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        h1 { color: #333; font-size: 28px; font-weight: 600; }
        .search-box {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        .search-box input {
            flex: 1;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
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
        .alert {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .table-container {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            overflow: hidden;
        }
        table {
            width: 100%;
            border-collapse: collapse;
        }
        thead {
            background: #f8f9fa;
        }
        th {
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #333;
            font-size: 14px;
            border-bottom: 2px solid #eee;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 14px;
            color: #666;
        }
        tr:hover {
            background: #fafafa;
        }
        .autor-foto {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            object-fit: cover;
        }
        .autor-nome {
            color: #333;
            font-weight: 500;
            text-decoration: none;
        }
        .autor-nome:hover {
            color: #0066cc;
        }
        .actions {
            display: flex;
            gap: 10px;
        }
        .btn-small {
            padding: 6px 12px;
            font-size: 13px;
        }
        .btn-danger {
            background: #dc3545;
            color: white;
        }
        .btn-danger:hover { background: #c82333; }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-state-icon {
            font-size: 60px;
            margin-bottom: 20px;
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
        <div class="header">
            <h1>✍️ Autores</h1>
            <sec:authorize access="hasRole('ADMIN')">
                <a href="${pageContext.request.contextPath}/autores/novo" class="btn btn-primary">+ Novo Autor</a>
            </sec:authorize>
        </div>

        <c:if test="${not empty mensagem}">
            <div class="alert alert-success">${mensagem}</div>
        </c:if>

        <c:if test="${not empty erro}">
            <div class="alert alert-error">${erro}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/autores/buscar" method="get" class="search-box">
            <input type="text" name="nome" placeholder="Buscar autor por nome..." value="${termoBusca}">
            <button type="submit" class="btn btn-secondary">🔍 Buscar</button>
            <c:if test="${not empty termoBusca}">
                <a href="${pageContext.request.contextPath}/autores" class="btn btn-secondary">Limpar</a>
            </c:if>
        </form>

        <div class="table-container">
            <c:choose>
                <c:when test="${empty autores}">
                    <div class="empty-state">
                        <div class="empty-state-icon">✍️</div>
                        <h3>Nenhum autor encontrado</h3>
                        <p>
                            <c:choose>
                                <c:when test="${not empty termoBusca}">
                                    Tente buscar com outros termos.
                                </c:when>
                                <c:otherwise>
                                    Comece cadastrando o primeiro autor!
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>Foto</th>
                                <th>Nome</th>
                                <th>Nacionalidade</th>
                                <th>Data Nascimento</th>
                                <th>Livros</th>
                                <th>Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="autor" items="${autores}">
                                <tr>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty autor.fotoUrl}">
                                                <img src="${autor.fotoUrl}" alt="${autor.nome}" class="autor-foto">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="autor-foto" style="background: #e0e0e0; display: flex; align-items: center; justify-content: center; font-size: 20px;">
                                                    👤
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/autores/${autor.id}" class="autor-nome">
                                            ${autor.nome}
                                        </a>
                                    </td>
                                    <td>${autor.nacionalidade}</td>
                                    <td>
                                        <c:if test="${not empty autor.dataNascimento}">
                                            ${autor.dataNascimento}
                                        </c:if>
                                    </td>
                                    <td>${autor.livros.size()} livro(s)</td>
                                    <td>
                                        <div class="actions">
                                            <a href="${pageContext.request.contextPath}/autores/${autor.id}" 
                                               class="btn btn-secondary btn-small">Ver</a>
                                            <sec:authorize access="hasRole('ADMIN')">
                                                <a href="${pageContext.request.contextPath}/autores/${autor.id}/editar" 
                                                   class="btn btn-secondary btn-small">Editar</a>
                                                <form action="${pageContext.request.contextPath}/autores/${autor.id}/deletar" 
                                                      method="post" 
                                                      style="display: inline;"
                                                      onsubmit="return confirm('Tem certeza que deseja deletar este autor?');">
                                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                    <button type="submit" class="btn btn-danger btn-small">Deletar</button>
                                                </form>
                                            </sec:authorize>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</body>
</html>
