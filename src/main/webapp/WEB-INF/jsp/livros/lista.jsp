<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Livros - Bibliotech</title>
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
            max-width: 1400px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .navbar-brand { color: #333; font-weight: 600; font-size: 18px; text-decoration: none; }
        .container { max-width: 1400px; margin: 0 auto; padding: 30px 20px; }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        h1 { color: #333; font-size: 28px; font-weight: 600; }
        .btn-new {
            background: #333;
            color: white;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
        }
        .btn-new:hover { background: #000; }
        .search-box {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .search-form {
            display: flex;
            gap: 10px;
        }
        .search-input {
            flex: 1;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 10px 12px;
            font-size: 14px;
        }
        .btn-search {
            background: #333;
            color: white;
            border: none;
            padding: 10px 24px;
            border-radius: 6px;
            cursor: pointer;
        }
        .table-container {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            overflow: hidden;
        }
        table { width: 100%; border-collapse: collapse; }
        th {
            background: #fafafa;
            color: #666;
            font-size: 13px;
            font-weight: 600;
            text-align: left;
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
        }
        td {
            padding: 15px;
            border-bottom: 1px solid #f5f5f5;
            font-size: 14px;
            color: #333;
        }
        tr:last-child td { border-bottom: none; }
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }
        .badge-success { background: #d4edda; color: #155724; }
        .badge-danger { background: #f8d7da; color: #721c24; }
        .btn-group { display: flex; gap: 8px; }
        .btn-sm {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 13px;
            text-decoration: none;
            border: none;
            cursor: pointer;
        }
        .btn-info { background: #e7f3ff; color: #004085; }
        .btn-warning { background: #fff3cd; color: #856404; }
        .btn-danger { background: #f8d7da; color: #721c24; }
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
            <h1>📖 Livros</h1>
            <a href="${pageContext.request.contextPath}/livros/novo" class="btn-new">+ Novo Livro</a>
        </div>

        <div class="search-box">
            <form action="${pageContext.request.contextPath}/livros/buscar" method="get" class="search-form">
                <input type="text" name="termo" class="search-input" placeholder="Buscar por título, ISBN ou autor...">
                <button type="submit" class="btn-search">Buscar</button>
            </form>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Título</th>
                        <th>ISBN</th>
                        <th>Categoria</th>
                        <th>Estoque</th>
                        <th>Status</th>
                        <th>Ações</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${livros}" var="livro">
                        <tr>
                            <td><strong>${livro.titulo}</strong></td>
                            <td>${livro.isbn}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${livro.categoria != null}">
                                        ${livro.categoria.nome}
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${livro.quantidadeDisponivel} / ${livro.quantidadeTotal}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${livro.quantidadeDisponivel > 0}">
                                        <span class="badge badge-success">Disponível</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">Esgotado</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="btn-group">
                                    <a href="${pageContext.request.contextPath}/livros/${livro.id}" class="btn-sm btn-info">Ver</a>
                                    <a href="${pageContext.request.contextPath}/livros/${livro.id}/editar" class="btn-sm btn-warning">Editar</a>
                                    <form action="${pageContext.request.contextPath}/livros/${livro.id}/deletar" method="post" 
                                          onsubmit="return confirm('Tem certeza que deseja deletar este livro?');" style="display: inline;">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button type="submit" class="btn-sm btn-danger">Deletar</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
