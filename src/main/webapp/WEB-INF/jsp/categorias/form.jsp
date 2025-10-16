<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${categoria.id != null ? 'Editar' : 'Nova'} Categoria - Bibliotech</title>
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
        input, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            font-family: inherit;
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: #333;
        }
        textarea { resize: vertical; min-height: 120px; }
        .error {
            color: #e74c3c;
            font-size: 13px;
            margin-top: 5px;
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
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">📚 Bibliotech</a>
        </div>
    </nav>

    <div class="container">
        <h1>🏷️ ${categoria.id != null ? 'Editar' : 'Nova'} Categoria</h1>

        <c:if test="${not empty erro}">
            <div class="alert alert-error">${erro}</div>
        </c:if>

        <div class="form-container">
            <form action="${categoria.id != null ? pageContext.request.contextPath.concat('/categorias/').concat(categoria.id) : pageContext.request.contextPath.concat('/categorias')}" 
                  method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="form-group">
                    <label for="nome">Nome da Categoria <span class="required">*</span></label>
                    <input type="text" 
                           id="nome" 
                           name="nome" 
                           value="${categoria.nome}" 
                           required
                           maxlength="100"
                           placeholder="Ex: Ficção Científica, Romance, Biografia..."/>
                    <div class="help-text">Nome único que identifica a categoria</div>
                </div>

                <div class="form-group">
                    <label for="descricao">Descrição</label>
                    <textarea id="descricao" 
                              name="descricao" 
                              maxlength="500"
                              placeholder="Descreva brevemente esta categoria de livros...">${categoria.descricao}</textarea>
                    <div class="help-text">Descrição opcional (máximo 500 caracteres)</div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn">
                        ${categoria.id != null ? '💾 Salvar Alterações' : '✓ Criar Categoria'}
                    </button>
                    <a href="${pageContext.request.contextPath}/categorias" class="btn btn-secondary">Cancelar</a>
                </div>
            </form>
        </div>
    </div>

    <script>
        // Contador de caracteres para descrição
        const textarea = document.getElementById('descricao');
        const maxLength = 500;
        
        if (textarea) {
            const counter = document.createElement('div');
            counter.className = 'help-text';
            counter.style.textAlign = 'right';
            textarea.parentNode.appendChild(counter);
            
            function updateCounter() {
                const remaining = maxLength - textarea.value.length;
                counter.textContent = remaining + ' caracteres restantes';
                counter.style.color = remaining < 50 ? '#e74c3c' : '#999';
            }
            
            textarea.addEventListener('input', updateCounter);
            updateCounter();
        }
    </script>
</body>
</html>
