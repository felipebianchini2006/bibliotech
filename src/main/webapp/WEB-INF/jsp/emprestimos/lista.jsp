<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Empréstimos - Bibliotech</title>
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
        .navbar-user { color: #666; font-size: 14px; }
        .btn-logout {
            background: none;
            border: 1px solid #ddd;
            color: #666;
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 13px;
            margin-left: 15px;
            cursor: pointer;
        }
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
        .alert-warning { background: #fff3cd; color: #856404; border: 1px solid #ffeaa7; }
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
        .badge-cancelado { background: #e2e3e5; color: #383d41; }
        .action-link {
            color: #007bff;
            text-decoration: none;
            font-size: 13px;
            margin-right: 10px;
        }
        .action-link:hover { text-decoration: underline; }
        .empty-state {
            padding: 60px 20px;
            text-align: center;
            color: #999;
        }
        .filters {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">📚 Bibliotech</a>
            <div>
                <span class="navbar-user">
                    Olá, <sec:authentication property="principal.username"/>
                </span>
                <form action="${pageContext.request.contextPath}/logout" method="post" style="display: inline;">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <button type="submit" class="btn-logout">Sair</button>
                </form>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="header">
            <h1>
                <c:if test="${isAtrasados}">⚠️ Empréstimos Atrasados</c:if>
                <c:if test="${isMeus}">📖 Meus Empréstimos</c:if>
                <c:if test="${!isAtrasados && !isMeus}">🔄 Empréstimos</c:if>
            </h1>
            <div>
                <sec:authorize access="hasRole('ADMIN')">
                    <a href="${pageContext.request.contextPath}/emprestimos/novo" class="btn">+ Novo Empréstimo</a>
                </sec:authorize>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Voltar</a>
            </div>
        </div>

        <c:if test="${not empty mensagem}">
            <div class="alert alert-success">${mensagem}</div>
        </c:if>
        <c:if test="${not empty erro}">
            <div class="alert alert-error">${erro}</div>
        </c:if>
        <c:if test="${not empty aviso}">
            <div class="alert alert-warning">${aviso}</div>
        </c:if>

        <sec:authorize access="hasRole('ADMIN')">
            <div class="filters">
                <a href="${pageContext.request.contextPath}/emprestimos" class="btn btn-secondary">Todos</a>
                <a href="${pageContext.request.contextPath}/emprestimos/status/ativo" class="btn btn-secondary">Ativos</a>
                <a href="${pageContext.request.contextPath}/emprestimos/atrasados" class="btn btn-secondary">Atrasados</a>
                <a href="${pageContext.request.contextPath}/emprestimos/status/devolvido" class="btn btn-secondary">Devolvidos</a>
            </div>
        </sec:authorize>

        <div class="table-container">
            <c:choose>
                <c:when test="${empty emprestimos}">
                    <div class="empty-state">
                        <p style="font-size: 48px; margin-bottom: 10px;">📚</p>
                        <p style="font-size: 16px;">Nenhum empréstimo encontrado</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Usuário</th>
                                <th>Livro</th>
                                <th>Data Empréstimo</th>
                                <th>Previsão Devolução</th>
                                <th>Status</th>
                                <th>Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="emprestimo" items="${emprestimos}">
                                <tr>
                                    <td>#${emprestimo.id}</td>
                                    <td>${emprestimo.usuario.nome}</td>
                                    <td>${emprestimo.livro.titulo}</td>
                                    <td>
                                        <c:set var="dataEmpStr" value="${emprestimo.dataEmprestimo.toString()}" />
                                        ${fn:substring(dataEmpStr, 8, 10)}/${fn:substring(dataEmpStr, 5, 7)}/${fn:substring(dataEmpStr, 0, 4)}
                                    </td>
                                    <td>
                                        <c:set var="dataPrevStr" value="${emprestimo.dataPrevistaDevolucao.toString()}" />
                                        ${fn:substring(dataPrevStr, 8, 10)}/${fn:substring(dataPrevStr, 5, 7)}/${fn:substring(dataPrevStr, 0, 4)}
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${emprestimo.status == 'ATIVO'}">
                                                <span class="badge badge-ativo">Ativo</span>
                                            </c:when>
                                            <c:when test="${emprestimo.status == 'DEVOLVIDO'}">
                                                <span class="badge badge-devolvido">Devolvido</span>
                                            </c:when>
                                            <c:when test="${emprestimo.status == 'ATRASADO'}">
                                                <span class="badge badge-atrasado">Atrasado</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-cancelado">Cancelado</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/emprestimos/${emprestimo.id}" 
                                           class="action-link">Detalhes</a>
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
