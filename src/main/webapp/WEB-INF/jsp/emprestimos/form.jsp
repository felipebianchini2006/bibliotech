<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Novo Empréstimo - Bibliotech</title>
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
        textarea { resize: vertical; min-height: 100px; }
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
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">📚 Bibliotech</a>
        </div>
    </nav>

    <div class="container">
        <h1>📖 Novo Empréstimo</h1>

        <c:if test="${not empty erro}">
            <div class="alert alert-error">${erro}</div>
        </c:if>

        <div class="form-container">
            <form action="${pageContext.request.contextPath}/emprestimos" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="form-group">
                    <label for="usuarioId">Usuário <span class="required">*</span></label>
                    <select id="usuarioId" name="usuarioId" required>
                        <option value="">Selecione um usuário</option>
                        <c:forEach var="usuario" items="${usuarios}">
                            <option value="${usuario.id}">
                                ${usuario.nome} - ${usuario.email}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="livroId">Livro <span class="required">*</span></label>
                    <select id="livroId" name="livroId" required>
                        <option value="">Selecione um livro</option>
                        <c:forEach var="livro" items="${livros}">
                            <option value="${livro.id}">
                                ${livro.titulo} - ISBN: ${livro.isbn} (Disponível: ${livro.quantidadeDisponivel})
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div class="form-group">
                    <label for="observacoes">Observações</label>
                    <textarea id="observacoes" name="observacoes" 
                              placeholder="Observações adicionais sobre o empréstimo..."></textarea>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn">Realizar Empréstimo</button>
                    <a href="${pageContext.request.contextPath}/emprestimos" class="btn btn-secondary">Cancelar</a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
