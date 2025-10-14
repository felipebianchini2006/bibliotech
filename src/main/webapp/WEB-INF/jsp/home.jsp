<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Home - Bibliotech</title>
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
        .btn-logout:hover { border-color: #333; color: #333; }
        .container { max-width: 1200px; margin: 0 auto; padding: 40px 20px; }
        h1 { color: #333; font-size: 28px; font-weight: 600; margin-bottom: 30px; }
        .cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 20px; }
        .card {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 30px;
            text-decoration: none;
            transition: all 0.2s;
        }
        .card:hover {
            border-color: #333;
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .card-icon { font-size: 40px; margin-bottom: 15px; }
        .card-title { color: #333; font-size: 18px; font-weight: 600; margin-bottom: 8px; }
        .card-desc { color: #999; font-size: 14px; }
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
        <h1>Dashboard</h1>
        
        <div class="cards">
            <a href="${pageContext.request.contextPath}/livros" class="card">
                <div class="card-icon">📚</div>
                <div class="card-title">Livros</div>
                <div class="card-desc">Gerenciar acervo de livros</div>
            </a>

            <a href="${pageContext.request.contextPath}/emprestimos" class="card">
                <div class="card-icon">🔄</div>
                <div class="card-title">Empréstimos</div>
                <div class="card-desc">Controlar empréstimos e devoluções</div>
            </a>

            <sec:authorize access="hasRole('ADMIN')">
                <a href="${pageContext.request.contextPath}/usuarios" class="card">
                    <div class="card-icon">👥</div>
                    <div class="card-title">Usuários</div>
                    <div class="card-desc">Administrar usuários do sistema</div>
                </a>
            </sec:authorize>
        </div>
    </div>
</body>
</html>
