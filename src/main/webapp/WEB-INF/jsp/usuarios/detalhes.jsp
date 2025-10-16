<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${usuario.nome} - Bibliotech</title>
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
        .container { max-width: 1000px; margin: 0 auto; padding: 40px 20px; }
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
        .section-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 2px solid #eee;
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
        .badge-admin { background: #f8d7da; color: #721c24; }
        .badge-user { background: #d1ecf1; color: #0c5460; }
        .badge-ativo { background: #d4edda; color: #155724; }
        .badge-inativo { background: #e2e3e5; color: #383d41; }
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
        .stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 20px;
        }
        .stat-box {
            background: white;
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 20px;
            text-align: center;
        }
        .stat-number {
            font-size: 36px;
            font-weight: 700;
            color: #333;
            margin-bottom: 5px;
        }
        .stat-label {
            font-size: 13px;
            color: #999;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .actions {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #eee;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 15px;
        }
        th {
            background: #f8f9fa;
            padding: 12px;
            text-align: left;
            font-weight: 600;
            color: #333;
            font-size: 12px;
            text-transform: uppercase;
        }
        td {
            padding: 12px;
            border-top: 1px solid #eee;
            color: #666;
            font-size: 14px;
        }
        .badge-emprestimo-ativo { background: #d1ecf1; color: #0c5460; }
        .badge-emprestimo-devolvido { background: #d4edda; color: #155724; }
        .badge-emprestimo-atrasado { background: #f8d7da; color: #721c24; }
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
            <h1>👤 ${usuario.nome}</h1>
            <a href="${pageContext.request.contextPath}/usuarios" class="btn btn-secondary">Voltar</a>
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

        <div class="stats">
            <div class="stat-box">
                <div class="stat-number">${emprestimos.size()}</div>
                <div class="stat-label">Total Empréstimos</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">${emprestimosAtivos}</div>
                <div class="stat-label">Ativos Agora</div>
            </div>
            <div class="stat-box">
                <div class="stat-number">
                    <c:choose>
                        <c:when test="${usuario.ativo}">
                            <span class="badge badge-ativo">Ativo</span>
                        </c:when>
                        <c:otherwise>
                            <span class="badge badge-inativo">Inativo</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-label">Status</div>
            </div>
        </div>

        <div class="card">
            <div class="section-title">Informações Pessoais</div>
            <div class="info-grid">
                <div class="info-item">
                    <div class="info-label">Nome</div>
                    <div class="info-value">${usuario.nome}</div>
                </div>

                <div class="info-item">
                    <div class="info-label">Email</div>
                    <div class="info-value">${usuario.email}</div>
                </div>

                <div class="info-item">
                    <div class="info-label">CPF</div>
                    <div class="info-value">${usuario.cpf}</div>
                </div>

                <div class="info-item">
                    <div class="info-label">Perfil</div>
                    <div class="info-value">
                        <c:choose>
                            <c:when test="${usuario.role == 'ADMIN'}">
                                <span class="badge badge-admin">Administrador</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge badge-user">Usuário</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <c:if test="${not empty usuario.telefone}">
                    <div class="info-item">
                        <div class="info-label">Telefone</div>
                        <div class="info-value">${usuario.telefone}</div>
                    </div>
                </c:if>

                <div class="info-item">
                    <div class="info-label">Data de Cadastro</div>
                    <div class="info-value">
                        <c:set var="dataStr" value="${usuario.dataCadastro.toString()}" />
                        ${fn:substring(dataStr, 8, 10)}/${fn:substring(dataStr, 5, 7)}/${fn:substring(dataStr, 0, 4)} às ${fn:substring(dataStr, 11, 16)}
                    </div>
                </div>
            </div>

            <c:if test="${not empty usuario.endereco}">
                <div style="margin-top: 20px;">
                    <div class="info-item">
                        <div class="info-label">Endereço</div>
                        <div class="info-value">${usuario.endereco}</div>
                    </div>
                </div>
            </c:if>
        </div>

        <c:if test="${not empty emprestimos}">
            <div class="card">
                <div class="section-title">📚 Histórico de Empréstimos</div>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Livro</th>
                            <th>Data Empréstimo</th>
                            <th>Devolução Prevista</th>
                            <th>Status</th>
                            <th>Ações</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="emprestimo" items="${emprestimos}">
                            <tr>
                                <td>#${emprestimo.id}</td>
                                <td>${emprestimo.livro.titulo}</td>
                                <td>
                                    <c:set var="dataEmpStr" value="${emprestimo.dataEmprestimo.toString()}" />
                                    ${fn:substring(dataEmpStr, 8, 10)}/${fn:substring(dataEmpStr, 5, 7)}/${fn:substring(dataEmpStr, 0, 4)}
                                </td>
                                <td>
                                    <c:set var="dataPrevStr" value="${emprestimo.dataPrevistaDevolucao.toString()}" />
                                    ${fn:substring(dataPrevStr, 8, 10)}/${fn:substring(dataPrevStr, 5, 7)}/${fn:substring(dataPrevStr, 0, 4)}
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${emprestimo.status == 'ATIVO'}">
                                            <span class="badge badge-emprestimo-ativo">Ativo</span>
                                        </c:when>
                                        <c:when test="${emprestimo.status == 'DEVOLVIDO'}">
                                            <span class="badge badge-emprestimo-devolvido">Devolvido</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge badge-emprestimo-atrasado">Atrasado</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/emprestimos/${emprestimo.id}" 
                                       style="color: #007bff; text-decoration: none; font-size: 13px;">
                                        Ver detalhes
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:if>

        <div class="card">
            <div class="actions">
                <a href="${pageContext.request.contextPath}/usuarios/${usuario.id}/editar" 
                   class="btn">✏️ Editar Usuário</a>

                <c:choose>
                    <c:when test="${usuario.ativo}">
                        <form action="${pageContext.request.contextPath}/usuarios/${usuario.id}/status" 
                              method="post" 
                              style="display: inline;"
                              onsubmit="return confirm('Deseja desativar este usuário?');">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="ativo" value="false"/>
                            <button type="submit" class="btn btn-danger">🚫 Desativar</button>
                        </form>
                    </c:when>
                    <c:otherwise>
                        <form action="${pageContext.request.contextPath}/usuarios/${usuario.id}/status" 
                              method="post" 
                              style="display: inline;"
                              onsubmit="return confirm('Deseja reativar este usuário?');">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <input type="hidden" name="ativo" value="true"/>
                            <button type="submit" class="btn btn-success">✓ Reativar</button>
                        </form>
                    </c:otherwise>
                </c:choose>

                <a href="${pageContext.request.contextPath}/usuarios/${usuario.id}/emprestimos" 
                   class="btn btn-secondary">📖 Ver Todos Empréstimos</a>
            </div>
        </div>
    </div>
</body>
</html>
