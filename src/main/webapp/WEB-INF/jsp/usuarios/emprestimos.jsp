<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Empréstimos de ${usuario.nome} - Bibliotech</title>
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
        .subtitle {
            color: #666;
            font-size: 16px;
            margin-top: 5px;
        }
        .btn-secondary {
            background: white;
            color: #333;
            border: 1px solid #ddd;
            padding: 10px 20px;
            border-radius: 6px;
            text-decoration: none;
            font-size: 14px;
            display: inline-block;
        }
        .btn-secondary:hover { border-color: #333; }
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
        th {
            background: #f8f9fa;
            padding: 15px;
            text-align: left;
            font-weight: 600;
            color: #333;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        td {
            padding: 15px;
            border-top: 1px solid #eee;
            color: #666;
            font-size: 14px;
        }
        tr:hover { background: #f8f9fa; }
        .badge {
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
            text-transform: uppercase;
        }
        .badge-ativo { background: #d1ecf1; color: #0c5460; }
        .badge-devolvido { background: #d4edda; color: #155724; }
        .badge-atrasado { background: #f8d7da; color: #721c24; }
        .empty-state {
            padding: 60px 20px;
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
            <div>
                <h1>📖 Empréstimos</h1>
                <div class="subtitle">Usuário: ${usuario.nome}</div>
            </div>
            <a href="${pageContext.request.contextPath}/usuarios/${usuario.id}" class="btn-secondary">Voltar</a>
        </div>

        <div class="table-container">
            <c:choose>
                <c:when test="${empty emprestimos}">
                    <div class="empty-state">
                        <p style="font-size: 48px; margin-bottom: 10px;">📚</p>
                        <p style="font-size: 16px;">Este usuário ainda não possui empréstimos</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Livro</th>
                                <th>ISBN</th>
                                <th>Data Empréstimo</th>
                                <th>Previsão Devolução</th>
                                <th>Data Devolução</th>
                                <th>Status</th>
                                <th>Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="emprestimo" items="${emprestimos}">
                                <tr>
                                    <td>#${emprestimo.id}</td>
                                    <td><strong>${emprestimo.livro.titulo}</strong></td>
                                    <td>${emprestimo.livro.isbn}</td>
                                    <td>
                                        <fmt:formatDateTime value="${emprestimo.dataEmprestimo}"/>
                                    </td>
                                    <td>
                                        <fmt:formatDateTime value="${emprestimo.dataPrevistaDevolucao}"/>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty emprestimo.dataDevolucao}">
                                                <fmt:formatDateTime value="${emprestimo.dataDevolucao}"/>
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #999;">-</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${emprestimo.status == 'ATIVO'}">
                                                <span class="badge badge-ativo">Ativo</span>
                                            </c:when>
                                            <c:when test="${emprestimo.status == 'DEVOLVIDO'}">
                                                <span class="badge badge-devolvido">Devolvido</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-atrasado">Atrasado</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/emprestimos/${emprestimo.id}" 
                                           style="color: #007bff; text-decoration: none; font-size: 13px;">
                                            Ver detalhes →
                                        </a>
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
