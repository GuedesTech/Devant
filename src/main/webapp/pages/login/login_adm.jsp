<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>Instituto Devant - Área Secreta</title>
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>assets/minimalismo.png">
  <link rel="stylesheet" href="<%= request.getContextPath() %>/pages/login/style.css">
</head>

<body>

<header>
  <img src="<%= request.getContextPath() %>/pages/login/logo.png">
</header>

<div class="titulo-login">Login ADM</div>
<div class="linha"></div>

<div class="container">

  <div class="card">

    <h1>Painel Administrativo</h1>

    <%
      String erro = (String) request.getAttribute("erro");
      if (erro != null) {
    %>
    <div class="erro"><%= erro %></div>
    <% } %>

    <form action="<%= request.getContextPath() %>/login" method="post">

      <input type="hidden" name="cargo" value="adm">

      <input class="input"
             type="text"
             name="username"
             placeholder="Usuário"
             required>

      <input class="input"
             type="password"
             name="password"
             placeholder="Senha"
             required>

      <button type="submit" class="btn-entrar">
        <span>Entrar</span>

        <svg width="7" height="12" viewBox="0 0 7 12" fill="none"
             xmlns="http://www.w3.org/2000/svg">
          <path d="M1.283 0.221L6.283 5.221C6.353 5.291 6.409 5.374 6.446 5.465
                    C6.484 5.556 6.504 5.654 6.504 5.753C6.504 5.851 6.484 5.949
                    6.446 6.040C6.409 6.131 6.353 6.214 6.283 6.284L1.283 11.284
                    C1.142 11.425 0.951 11.504 0.752 11.504C0.553 11.504 0.362 11.425
                    0.221 11.284C0.080 11.143 0.001 10.952 0.001 10.753C0.001 10.553
                    0.080 10.362 0.221 10.221L4.690 5.752L0.220 1.283C0.079 1.142
                    0 0.951 0 0.751C0 0.552 0.079 0.361 0.220 0.220C0.361 0.079
                    0.552 0 0.751 0C0.951 0 1.142 0.079 1.283 0.220L1.283 0.221Z"
                fill="#FAFAFA"/>
        </svg>
      </button>

    </form>

    <div class="cadastro">
      <a href="<%= request.getContextPath() %>/pages/login/index.jsp">
        Voltar
      </a>
    </div>

    <div class="seletor-interno">
      Você está entrando como:
    </div>

  </div>

  <div class="tipo-wrapper">
    <button class="tipo tipo-ativo">
      ADM
    </button>
  </div>

</div>

</body>
</html>