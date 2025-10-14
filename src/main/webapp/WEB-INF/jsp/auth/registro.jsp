<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registro - Bibliotech</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #f5f5f5;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 40px 15px;
        }
        .registro-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            max-width: 600px;
            width: 100%;
            padding: 40px;
        }
        .logo { text-align: center; margin-bottom: 30px; }
        .logo h2 { color: #333; font-weight: 600; font-size: 24px; }
        .logo p { color: #999; font-size: 14px; margin-top: 5px; }
        .row { display: flex; gap: 15px; margin-bottom: 15px; }
        .col-6 { flex: 1; }
        .col-12 { width: 100%; margin-bottom: 15px; }
        label { color: #555; font-size: 14px; font-weight: 500; display: block; margin-bottom: 6px; }
        input {
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
        }
        .btn-primary:hover { background: #000; }
        .divider { text-align: center; margin: 20px 0; color: #999; font-size: 13px; }
        .link { color: #333; text-decoration: none; font-size: 14px; }
        .link:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <div class="registro-card">
        <div class="logo">
            <h2>📚 Bibliotech</h2>
            <p>Criar nova conta</p>
        </div>

        <form action="${pageContext.request.contextPath}/registro" method="post">
            <div class="col-12">
                <label for="nome">Nome Completo *</label>
                <input type="text" id="nome" name="nome" required>
            </div>

            <div class="row">
                <div class="col-6">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="col-6">
                    <label for="cpf">CPF *</label>
                    <input type="text" id="cpf" name="cpf" maxlength="11" pattern="[0-9]{11}" required>
                </div>
            </div>

            <div class="row">
                <div class="col-6">
                    <label for="senha">Senha *</label>
                    <input type="password" id="senha" name="senha" minlength="6" required>
                </div>
                <div class="col-6">
                    <label for="telefone">Telefone</label>
                    <input type="text" id="telefone" name="telefone">
                </div>
            </div>

            <div class="col-12">
                <label for="endereco">Endereço</label>
                <input type="text" id="endereco" name="endereco">
            </div>

            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <button type="submit" class="btn-primary">Criar Conta</button>
        </form>

        <div class="divider">ou</div>
        
        <div style="text-align: center;">
            <a href="${pageContext.request.contextPath}/login" class="link">← Voltar para Login</a>
        </div>
    </div>
</body>
</html>
