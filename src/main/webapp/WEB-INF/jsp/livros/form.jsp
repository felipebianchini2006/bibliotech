<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${livro.id != null ? 'Editar' : 'Novo'} Livro - Bibliotech</title>
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
            max-width: 700px;
            margin: 0 auto;
            padding: 0 20px;
        }
        .navbar-brand { color: #333; font-weight: 600; font-size: 18px; text-decoration: none; }
        .container { max-width: 700px; padding: 30px 15px; margin: 0 auto; }
        h2 { color: #333; font-size: 24px; font-weight: 600; margin-bottom: 30px; }
        .card {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 30px;
        }
        .row { display: flex; gap: 15px; margin-bottom: 15px; }
        .col-12 { width: 100%; margin-bottom: 15px; }
        .col-6 { flex: 1; }
        .col-4 { flex: 1; }
        label { color: #555; font-size: 14px; font-weight: 500; display: block; margin-bottom: 6px; }
        input, select, textarea {
            width: 100%;
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 10px 12px;
            font-size: 14px;
        }
        input:focus, select:focus, textarea:focus {
            border-color: #333;
            box-shadow: 0 0 0 3px rgba(0,0,0,0.05);
            outline: none;
        }
        textarea { resize: vertical; font-family: inherit; }
        small { color: #999; font-size: 12px; }
        
        /* Checkbox Group */
        .checkbox-group {
            border: 1px solid #ddd;
            border-radius: 6px;
            padding: 12px;
            max-height: 200px;
            overflow-y: auto;
            background: #fafafa;
        }
        .checkbox-item {
            display: flex;
            align-items: center;
            padding: 8px;
            border-radius: 4px;
            transition: background 0.2s;
        }
        .checkbox-item:hover {
            background: #f0f0f0;
        }
        .checkbox-item input[type="checkbox"] {
            width: auto;
            margin: 0;
            margin-right: 10px;
            cursor: pointer;
        }
        .checkbox-item label {
            margin: 0;
            cursor: pointer;
            flex: 1;
            font-weight: 400;
            color: #333;
        }
        
        .form-actions {
            display: flex;
            justify-content: space-between;
            margin-top: 30px;
        }
        .btn-back { 
            background: none; 
            border: 1px solid #ddd; 
            color: #666; 
            padding: 10px 20px; 
            border-radius: 6px; 
            font-size: 14px;
            text-decoration: none;
        }
        .btn-back:hover { border-color: #333; color: #333; }
        .btn-primary {
            background: #333;
            border: none;
            padding: 10px 24px;
            border-radius: 6px;
            font-size: 14px;
            color: white;
            cursor: pointer;
        }
        .btn-primary:hover { background: #000; }
    </style>
</head>
<body>
    <nav class="navbar">
        <div class="navbar-content">
            <a class="navbar-brand" href="${pageContext.request.contextPath}/home">📚 Bibliotech</a>
        </div>
    </nav>

    <div class="container">
        <h2>${livro.id != null ? 'Editar' : 'Novo'} Livro</h2>

        <div class="card">
            <form action="${livro.id != null ? pageContext.request.contextPath.concat('/livros/').concat(livro.id) : pageContext.request.contextPath.concat('/livros')}" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                
                <div class="col-12">
                    <label for="titulo">Título *</label>
                    <input type="text" id="titulo" name="titulo" value="${livro.titulo}" required>
                </div>

                <div class="row">
                    <div class="col-6">
                        <label for="isbn">ISBN *</label>
                        <input type="text" id="isbn" name="isbn" value="${livro.isbn}" maxlength="13" required>
                    </div>
                    <div class="col-6">
                        <label for="dataPublicacao">Data de Publicação *</label>
                        <c:choose>
                            <c:when test="${not empty livro.dataPublicacao}">
                                <input type="date" id="dataPublicacao" name="dataPublicacao" 
                                       value="${com.livraria.bibliotech.util.DateFormatter.formatDateISO(livro.dataPublicacao)}" required>
                            </c:when>
                            <c:otherwise>
                                <input type="date" id="dataPublicacao" name="dataPublicacao" required>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="col-12">
                    <label for="descricao">Descrição</label>
                    <textarea id="descricao" name="descricao" rows="3">${livro.descricao}</textarea>
                </div>

                <div class="row">
                    <div class="col-6">
                        <label for="categoriaId">Categoria</label>
                        <select id="categoriaId" name="categoria.id">
                            <option value="">Selecione...</option>
                            <c:forEach items="${categorias}" var="cat">
                                <option value="${cat.id}" 
                                    <c:if test="${livro.categoria != null && livro.categoria.id == cat.id}">selected</c:if>>
                                    ${cat.nome}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="col-4">
                        <label for="quantidadeTotal">Quantidade *</label>
                        <input type="number" id="quantidadeTotal" name="quantidadeTotal" 
                               value="${livro.quantidadeTotal}" min="1" required>
                    </div>
                    <div class="col-4">
                        <label for="quantidadeDisponivel">Disponível *</label>
                        <input type="number" id="quantidadeDisponivel" name="quantidadeDisponivel" 
                               value="${livro.quantidadeDisponivel}" min="0" required>
                    </div>
                </div>

                <div class="col-12">
                    <label>Autores</label>
                    <div class="checkbox-group">
                        <c:forEach items="${autores}" var="autor">
                            <div class="checkbox-item">
                                <input type="checkbox" 
                                       name="autoresIds" 
                                       value="${autor.id}" 
                                       id="autor_${autor.id}"
                                       <c:if test="${livro.autores != null}">
                                           <c:forEach items="${livro.autores}" var="livroAutor">
                                               <c:if test="${livroAutor.id == autor.id}">checked</c:if>
                                           </c:forEach>
                                       </c:if>>
                                <label for="autor_${autor.id}">${autor.nome}</label>
                            </div>
                        </c:forEach>
                    </div>
                    <c:if test="${empty autores}">
                        <small style="color: #999;">Nenhum autor cadastrado. 
                            <a href="${pageContext.request.contextPath}/autores/novo" style="color: #333;">Cadastrar autor</a>
                        </small>
                    </c:if>
                </div>

                <div class="col-12">
                    <label for="imagemUrl">URL da Imagem</label>
                    <input type="url" id="imagemUrl" name="imagemUrl" value="${livro.imagemUrl}" 
                           placeholder="https://...">
                </div>

                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/livros" class="btn-back">Cancelar</a>
                    <button type="submit" class="btn-primary">
                        ${livro.id != null ? 'Atualizar' : 'Salvar'}
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
