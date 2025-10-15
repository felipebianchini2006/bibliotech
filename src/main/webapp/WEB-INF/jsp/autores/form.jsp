<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${autor.id == null ? 'Novo Autor' : 'Editar Autor'} - Bibliotech</title>
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
        .navbar-links a {
            color: #666;
            text-decoration: none;
            margin-left: 20px;
            font-size: 14px;
        }
        .navbar-links a:hover { color: #333; }
        .container { max-width: 800px; margin: 0 auto; padding: 40px 20px; }
        .header {
            margin-bottom: 30px;
        }
        h1 { color: #333; font-size: 28px; font-weight: 600; margin-bottom: 10px; }
        .breadcrumb {
            color: #999;
            font-size: 14px;
        }
        .breadcrumb a {
            color: #666;
            text-decoration: none;
        }
        .breadcrumb a:hover { color: #333; }
        .form-card {
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
            color: #333;
            font-weight: 500;
            margin-bottom: 8px;
            font-size: 14px;
        }
        .required::after {
            content: " *";
            color: #dc3545;
        }
        input, textarea {
            width: 100%;
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            font-family: inherit;
        }
        input:focus, textarea:focus {
            outline: none;
            border-color: #333;
        }
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        .error {
            color: #dc3545;
            font-size: 13px;
            margin-top: 5px;
        }
        .alert {
            padding: 12px 15px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 14px;
        }
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .form-actions {
            display: flex;
            gap: 10px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            transition: all 0.2s;
        }
        .btn-primary {
            background: #333;
            color: white;
        }
        .btn-primary:hover { background: #555; }
        .btn-secondary {
            background: white;
            color: #333;
            border: 1px solid #ddd;
        }
        .btn-secondary:hover { border-color: #333; }
        .hint {
            color: #999;
            font-size: 13px;
            margin-top: 5px;
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">📚 Bibliotech</a>
            <div class="navbar-links">
                <a href="${pageContext.request.contextPath}/livros">Livros</a>
                <a href="${pageContext.request.contextPath}/autores">Autores</a>
                <a href="${pageContext.request.contextPath}/categorias">Categorias</a>
                <a href="${pageContext.request.contextPath}/emprestimos">Empréstimos</a>
            </div>
        </div>
    </nav>

    <div class="container">
        <div class="header">
            <h1>${autor.id == null ? '✍️ Novo Autor' : '✏️ Editar Autor'}</h1>
            <div class="breadcrumb">
                <a href="${pageContext.request.contextPath}/home">Home</a> / 
                <a href="${pageContext.request.contextPath}/autores">Autores</a> / 
                ${autor.id == null ? 'Novo' : 'Editar'}
            </div>
        </div>

        <c:if test="${not empty erro}">
            <div class="alert alert-error">${erro}</div>
        </c:if>

        <div class="form-card">
            <form action="${autor.id == null ? pageContext.request.contextPath.concat('/autores') : pageContext.request.contextPath.concat('/autores/').concat(autor.id)}" 
                  method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

                <div class="form-group">
                    <label for="nome" class="required">Nome</label>
                    <input type="text" 
                           id="nome" 
                           name="nome" 
                           value="${autor.nome}"
                           required
                           maxlength="200"
                           placeholder="Nome completo do autor">
                    <c:if test="${not empty errors.nome}">
                        <div class="error">${errors.nome}</div>
                    </c:if>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="nacionalidade">Nacionalidade</label>
                        <input type="text" 
                               id="nacionalidade" 
                               name="nacionalidade" 
                               value="${autor.nacionalidade}"
                               maxlength="100"
                               placeholder="Ex: Brasileiro, Americano">
                    </div>

                    <div class="form-group">
                        <label for="dataNascimento">Data de Nascimento</label>
                        <input type="date" 
                               id="dataNascimento" 
                               name="dataNascimento" 
                               value="${autor.dataNascimento}">
                        <div class="hint">Opcional</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="biografia">Biografia</label>
                    <textarea id="biografia" 
                              name="biografia" 
                              rows="6"
                              maxlength="2000"
                              placeholder="Breve biografia do autor...">${autor.biografia}</textarea>
                    <div class="hint">Máximo 2000 caracteres</div>
                </div>

                <div class="form-group">
                    <label for="fotoUrl">URL da Foto</label>
                    <input type="url" 
                           id="fotoUrl" 
                           name="fotoUrl" 
                           value="${autor.fotoUrl}"
                           maxlength="500"
                           placeholder="https://exemplo.com/foto.jpg">
                    <div class="hint">URL pública da foto do autor (opcional)</div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">
                        ${autor.id == null ? '✓ Cadastrar' : '✓ Salvar Alterações'}
                    </button>
                    <a href="${pageContext.request.contextPath}/autores" class="btn btn-secondary">
                        ✕ Cancelar
                    </a>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
