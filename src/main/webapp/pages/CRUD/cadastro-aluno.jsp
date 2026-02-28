<%--
  Created by IntelliJ IDEA.
  User: guilhermemontoni-ieg
  Date: 10/02/2026
  Time: 20:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Cadastro de Aluno</title>
</head>
<body>
    <h2>Cadastro de Aluno</h2>

    <!-- Mostra erro, se existir -->
    <%
        String erro = (String) request.getAttribute("erro"); // Atributte pega do Servlet
        if (erro != null) {
    %>
        <p style="color:red;"><%= erro %></p>
    <%
        }
    %>

    <form action="<%= request.getContextPath() %>/aluno" method="post">

        <label>Nome:</label><br>
        <input type="text" name="nome" required><br><br>

        <label>Email:</label><br>
        <input type="email" name="email" required><br><br>

        <label>Senha:</label><br>
        <input type="password" name="senha" required><br><br>

        <label>Matrícula:</label><br>
        <input type="text" name="matricula" required><br><br>

        <label>Tipo de Usuário:</label><br>
        <select name="idTipoUser" required>
            <option value="1">Aluno</option>
            <option value="2">Professor</option>
            <option value="3">Administrador</option>
        </select><br><br>

        <label>Turma:</label><br>
        <select name="idTurma" required>
            <option value="1">1º Ano A</option>
            <option value="2">1º Ano B</option>
            <option value="3">2º Ano A</option>
        </select><br><br>

        <button type="submit">Cadastrar</button>
    </form>
</body>
</html>
