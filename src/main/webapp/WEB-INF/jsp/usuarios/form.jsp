<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Editar Usuário - Bibliotech</title>
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
        .container { max-width: 800px; margin: 0 auto; padding: 40px 20px; }
        h1 { color: #333; font-size: 28px; font-weight: 600; margin-bottom: 30px; }
        .form-container {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 30px;
        }
        .form-group {
            margin-bottom: 20px;
        }
        label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
            font-size: 14px;
        }
        .required { color: #e74c3c; }
        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            font-family: inherit;
        }
        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: #333;
        }
        input:disabled {
            background: #f8f9fa;
            cursor: not-allowed;
        }
        .btn {
            background: #333;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            margin-right: 10px;
        }
        .btn:hover { background: #555; }
        .btn-secondary {
            background: white;
            color: #333;
            border: 1px solid #ddd;
            text-decoration: none;
            display: inline-block;
        }
        .btn-secondary:hover { border-color: #333; }
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .form-actions {
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .help-text {
            font-size: 13px;
            color: #999;
            margin-top: 5px;
        }
        .info-box {
            background: #e7f3ff;
            border-left: 4px solid #2196f3;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            font-size: 14px;
            color: #0c5460;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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
        <h1>✏️ Editar Usuário</h1>

        <c:if test="${not empty erro}">
            <div class="alert alert-error">${erro}</div>
        </c:if>

        <div class="info-box">
            ℹ️ <strong>Atenção:</strong> Email e CPF não podem ser alterados. 
            Para alterar a senha, preencha o campo "Nova Senha".
        </div>

        <div class="form-container">
            <form action="${pageContext.request.contextPath}/usuarios/${usuario.id}" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="form-group">
                    <label for="nome">Nome Completo <span class="required">*</span></label>
                    <input type="text" 
                           id="nome" 
                           name="nome" 
                           value="${usuario.nome}" 
                           required
                           maxlength="100"/>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="email">Email</label>
                        <input type="email" 
                               id="email" 
                               value="${usuario.email}" 
                               disabled/>
                        <div class="help-text">Email não pode ser alterado</div>
                    </div>

                    <div class="form-group">
                        <label for="cpf">CPF</label>
                        <input type="text" 
                               id="cpf" 
                               value="${usuario.cpf}" 
                               disabled/>
                        <div class="help-text">CPF não pode ser alterado</div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="telefone">Telefone</label>
                        <input type="text" 
                               id="telefone" 
                               name="telefone" 
                               value="${usuario.telefone}"
                               maxlength="20"
                               placeholder="(11) 99999-9999"/>
                    </div>

                    <div class="form-group">
                        <label for="novaSenha">Nova Senha</label>
                        <input type="password" 
                               id="novaSenha" 
                               name="novaSenha"
                               minlength="6"
                               placeholder="Deixe em branco para não alterar"/>
                        <div class="help-text">Mínimo 6 caracteres</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="endereco">Endereço</label>
                    <textarea id="endereco" 
                              name="endereco" 
                              maxlength="200"
                              rows="3"
                              placeholder="Endereço completo...">${usuario.endereco}</textarea>
                </div>

                <input type="hidden" name="role" value="${usuario.role}"/>
                <input type="hidden" name="ativo" value="${usuario.ativo}"/>

                <div class="form-actions">
                    <button type="submit" class="btn">💾 Salvar Alterações</button>
                    <a href="${pageContext.request.contextPath}/usuarios/${usuario.id}" 
                       class="btn btn-secondary">Cancelar</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
