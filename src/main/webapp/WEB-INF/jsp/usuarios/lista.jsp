<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Usuários - Bibliotech</title>
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
            display: flex;
            gap: 10px;
        }
        .search-box input {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            flex: 1;
            max-width: 400px;
        }
        .filters {
            margin-bottom: 20px;
            display: flex;
            gap: 10px;
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
        .badge-admin { background: #f8d7da; color: #721c24; }
        .badge-user { background: #d1ecf1; color: #0c5460; }
        .badge-ativo { background: #d4edda; color: #155724; }
        .badge-inativo { background: #e2e3e5; color: #383d41; }
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
            <h1>👥 Gerenciar Usuários</h1>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-secondary">Voltar</a>
        </div>

        <c:if test="${not empty mensagem}">
            <div class="alert alert-success">${mensagem}</div>
        </c:if>
        <c:if test="${not empty erro}">
            <div class="alert alert-error">${erro}</div>
        </c:if>

        <div class="search-box">
            <form action="${pageContext.request.contextPath}/usuarios/buscar" method="get" style="display: flex; gap: 10px; flex: 1;">
                <input type="text" name="nome" placeholder="🔍 Buscar por nome..." 
                       value="${termoBusca}"/>
                <button type="submit" class="btn">Buscar</button>
            </form>
        </div>

        <div class="filters">
            <a href="${pageContext.request.contextPath}/usuarios" class="btn btn-secondary">Todos</a>
            <a href="${pageContext.request.contextPath}/usuarios?filtro=ativos" class="btn btn-secondary">Ativos</a>
            <a href="${pageContext.request.contextPath}/usuarios/role/admin" class="btn btn-secondary">Administradores</a>
            <a href="${pageContext.request.contextPath}/usuarios/role/user" class="btn btn-secondary">Usuários</a>
        </div>

        <div class="table-container">
            <c:choose>
                <c:when test="${empty usuarios}">
                    <div class="empty-state">
                        <p style="font-size: 48px; margin-bottom: 10px;">👥</p>
                        <p style="font-size: 16px;">Nenhum usuário encontrado</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nome</th>
                                <th>Email</th>
                                <th>CPF</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Cadastro</th>
                                <th>Ações</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="usuario" items="${usuarios}">
                                <tr>
                                    <td>#${usuario.id}</td>
                                    <td><strong>${usuario.nome}</strong></td>
                                    <td>${usuario.email}</td>
                                    <td>${usuario.cpf}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${usuario.role == 'ADMIN'}">
                                                <span class="badge badge-admin">Admin</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-user">User</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${usuario.ativo}">
                                                <span class="badge badge-ativo">Ativo</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-inativo">Inativo</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:set var="dataStr" value="${usuario.dataCadastro.toString()}" />
                                        ${fn:substring(dataStr, 8, 10)}/${fn:substring(dataStr, 5, 7)}/${fn:substring(dataStr, 0, 4)}
                                    </td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/usuarios/${usuario.id}" 
                                           class="action-link">Detalhes</a>
                                        <a href="${pageContext.request.contextPath}/usuarios/${usuario.id}/editar" 
                                           class="action-link">Editar</a>
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
