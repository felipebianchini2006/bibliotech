<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Bibliotech</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #f5f5f5;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 400px;
            padding: 40px;
        }
        .logo { text-align: center; margin-bottom: 30px; }
        .logo h2 { color: #333; font-weight: 600; font-size: 24px; }
        .logo p { color: #999; font-size: 14px; margin-top: 5px; }
        .form-group { margin-bottom: 20px; }
        label { color: #555; font-size: 14px; font-weight: 500; display: block; margin-bottom: 6px; }
        input[type="email"], input[type="password"], input[type="text"] {
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 10px 12px;
            font-size: 14px;
        }
        input:focus {
            border-color: #333;
            box-shadow: 0 0 0 3px rgba(0,0,0,0.05);
            outline: none;
        }
        .btn-primary {
            width: 100%;
            background: #333;
            border: none;
            border-radius: 6px;
            padding: 12px;
            color: white;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s;
        }
        .btn-primary:hover { background: #000; }
        .divider { 
            text-align: center; 
            margin: 20px 0; 
            color: #999;
            font-size: 13px;
        }
        .link { color: #333; text-decoration: none; font-size: 14px; }
        .link:hover { text-decoration: underline; }
        .alert {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-danger { background: #fee; color: #c33; border: 1px solid #fcc; }
        .alert-success { background: #efe; color: #3c3; border: 1px solid #cfc; }
    </style>
</head>
<body>
    <div class="login-card">
        <div class="logo">
            <h2>📚 Bibliotech</h2>
            <p>Sistema de Gerenciamento de Biblioteca</p>
        </div>

        <c:if test="${param.error != null}">
            <div class="alert alert-danger">
                Email ou senha inválidos
            </div>
        </c:if>

        <c:if test="${param.logout != null}">
            <div class="alert alert-success">
                Logout realizado com sucesso!
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/perform-login" method="post">
            <div class="form-group">
                <label for="username">Email</label>
                <input type="text" id="username" name="username" required autofocus>
            </div>

            <div class="form-group">
                <label for="password">Senha</label>
                <input type="password" id="password" name="password" required>
            </div>

            <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>

            <button type="submit" class="btn-primary">Entrar</button>
        </form>

        <div class="divider">ou</div>

        <div style="text-align: center;">
            <a href="${pageContext.request.contextPath}/registro" class="link">Criar nova conta →</a>
        </div>
    </div>
</body>
</html>
