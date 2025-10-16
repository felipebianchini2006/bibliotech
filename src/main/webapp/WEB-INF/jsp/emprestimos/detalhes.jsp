<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detalhes do Empréstimo - Bibliotech</title>
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
        .container { max-width: 900px; margin: 0 auto; padding: 40px 20px; }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }
        h1 { color: #333; font-size: 28px; font-weight: 600; }
        .card {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 20px;
        }
        .info-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 20px;
        }
        .info-item {
            padding: 15px;
            background: #f8f9fa;
            border-radius: 6px;
        }
        .info-label {
            font-size: 12px;
            text-transform: uppercase;
            color: #999;
            margin-bottom: 5px;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        .info-value {
            font-size: 16px;
            color: #333;
            font-weight: 500;
        }
        .badge {
            padding: 6px 12px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            text-transform: uppercase;
            display: inline-block;
        }
        .badge-ativo { background: #d1ecf1; color: #0c5460; }
        .badge-devolvido { background: #d4edda; color: #155724; }
        .badge-atrasado { background: #f8d7da; color: #721c24; }
        .badge-cancelado { background: #e2e3e5; color: #383d41; }
        .btn {
            background: #333;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-right: 10px;
        }
        .btn:hover { background: #555; }
        .btn-success { background: #28a745; }
        .btn-success:hover { background: #218838; }
        .btn-warning { background: #ffc107; color: #333; }
        .btn-warning:hover { background: #e0a800; }
        .btn-danger { background: #dc3545; }
        .btn-danger:hover { background: #c82333; }
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
        .actions { margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee; }
        .multa-box {
            background: #fff3cd;
            border: 2px solid #ffc107;
            border-radius: 8px;
            padding: 20px;
            margin-top: 20px;
            text-align: center;
        }
        .multa-valor {
            font-size: 32px;
            font-weight: 700;
            color: #856404;
            margin: 10px 0;
        }
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eee;
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
            <h1>📖 Empréstimo #${emprestimo.id}</h1>
            <a href="${pageContext.request.contextPath}/emprestimos" class="btn btn-secondary">Voltar</a>
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

        <div class="card">
            <div class="section-title">Informações do Empréstimo</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Status</div>
                    <div class="info-value">
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
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-label">Data do Empréstimo</div>
                    <div class="info-value">
                        <c:set var="dataEmpStr" value="${emprestimo.dataEmprestimo.toString()}" />
                        ${fn:substring(dataEmpStr, 8, 10)}/${fn:substring(dataEmpStr, 5, 7)}/${fn:substring(dataEmpStr, 0, 4)} às ${fn:substring(dataEmpStr, 11, 16)}
                    </div>
                </div>

                <div class="info-item">
                    <div class="info-label">Previsão de Devolução</div>
                    <div class="info-value">
                        <c:set var="dataPrevStr" value="${emprestimo.dataPrevistaDevolucao.toString()}" />
                        ${fn:substring(dataPrevStr, 8, 10)}/${fn:substring(dataPrevStr, 5, 7)}/${fn:substring(dataPrevStr, 0, 4)}
                    </div>
                </div>

                <c:if test="${not empty emprestimo.dataDevolucao}">
                    <div class="info-item">
                        <div class="info-label">Data da Devolução</div>
                        <div class="info-value">
                            <c:set var="dataDevStr" value="${emprestimo.dataDevolucao.toString()}" />
                            ${fn:substring(dataDevStr, 8, 10)}/${fn:substring(dataDevStr, 5, 7)}/${fn:substring(dataDevStr, 0, 4)} às ${fn:substring(dataDevStr, 11, 16)}
                        </div>
                    </div>
                </c:if>
            </div>

            <c:if test="${multa > 0}">
                <div class="multa-box">
                    <div style="font-size: 14px; color: #856404; font-weight: 600;">💰 MULTA POR ATRASO</div>
                    <div class="multa-valor">R$ <fmt:formatNumber value="${multa}" pattern="#,##0.00"/></div>
                    <div style="font-size: 13px; color: #856404;">Taxa de R$ 2,00 por dia de atraso</div>
                </div>
            </c:if>
        </div>

        <div class="card">
            <div class="section-title">👤 Usuário</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Nome</div>
                    <div class="info-value">${emprestimo.usuario.nome}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">Email</div>
                    <div class="info-value">${emprestimo.usuario.email}</div>
                </div>
                <c:if test="${not empty emprestimo.usuario.telefone}">
                    <div class="info-item">
                        <div class="info-label">Telefone</div>
                        <div class="info-value">${emprestimo.usuario.telefone}</div>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="card">
            <div class="section-title">📚 Livro</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Título</div>
                    <div class="info-value">${emprestimo.livro.titulo}</div>
                </div>
                <div class="info-item">
                    <div class="info-label">ISBN</div>
                    <div class="info-value">${emprestimo.livro.isbn}</div>
                </div>
                <c:if test="${not empty emprestimo.livro.autores}">
                    <div class="info-item">
                        <div class="info-label">Autores</div>
                        <div class="info-value">
                            <c:forEach var="autor" items="${emprestimo.livro.autores}" varStatus="status">
                                ${autor.nome}<c:if test="${!status.last}">, </c:if>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <c:if test="${not empty emprestimo.observacoes}">
            <div class="card">
                <div class="section-title">📝 Observações</div>
                <p style="color: #666; line-height: 1.6;">${emprestimo.observacoes}</p>
            </div>
        </c:if>

        <div class="card">
            <div class="actions">
                <c:if test="${emprestimo.status == 'ATIVO'}">
                    <sec:authorize access="hasRole('ADMIN')">
                        <form action="${pageContext.request.contextPath}/emprestimos/${emprestimo.id}/devolver" 
                              method="post" style="display: inline;"
                              onsubmit="return confirm('Confirmar devolução do livro?');">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <button type="submit" class="btn btn-success">✓ Devolver Livro</button>
                        </form>
                    </sec:authorize>

                    <form action="${pageContext.request.contextPath}/emprestimos/${emprestimo.id}/renovar" 
                          method="post" style="display: inline;"
                          onsubmit="return confirm('Deseja renovar este empréstimo por mais 14 dias?');">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <button type="submit" class="btn btn-warning">🔄 Renovar Empréstimo</button>
                    </form>

                    <sec:authorize access="hasRole('ADMIN')">
                        <button type="button" class="btn btn-danger" 
                                onclick="document.getElementById('cancelForm').style.display='block'">
                            ✕ Cancelar
                        </button>
                    </sec:authorize>
                </c:if>

                <a href="${pageContext.request.contextPath}/livros/${emprestimo.livro.id}" 
                   class="btn btn-secondary">Ver Livro</a>
                <sec:authorize access="hasRole('ADMIN')">
                    <a href="${pageContext.request.contextPath}/usuarios/${emprestimo.usuario.id}" 
                       class="btn btn-secondary">Ver Usuário</a>
                </sec:authorize>
            </div>

            <sec:authorize access="hasRole('ADMIN')">
                <div id="cancelForm" style="display: none; margin-top: 20px; padding-top: 20px; border-top: 1px solid #eee;">
                    <form action="${pageContext.request.contextPath}/emprestimos/${emprestimo.id}/cancelar" method="post">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <div style="margin-bottom: 10px;">
                            <label style="display: block; margin-bottom: 5px; font-weight: 600;">Motivo do Cancelamento:</label>
                            <textarea name="motivo" required style="width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 6px;"></textarea>
                        </div>
                        <button type="submit" class="btn btn-danger">Confirmar Cancelamento</button>
                        <button type="button" class="btn btn-secondary" 
                                onclick="document.getElementById('cancelForm').style.display='none'">
                            Cancelar
                        </button>
                    </form>
                </div>
            </sec:authorize>
        </div>
    </div>
</body>
</html>
