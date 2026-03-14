<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Instituto Devant</title>
    <link
      rel="icon"
      type="image/png"
      href="<%= request.getContextPath() %>/pages/assets/logo-dark.png"
    />
    <link
      rel="icon"
      type="image/png"
      href="<%= request.getContextPath() %>minimalismo.png"
    />
    <link
      rel="stylesheet"
      href="<%= request.getContextPath() %>/pages/login/style.css"
    />

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700&display=swap"
      rel="stylesheet"
    />
  </head>

  <body>
    <header>
      <img src="<%= request.getContextPath() %>/pages/login/logo.png" />

      <button
        class="botao-adm"
        onclick="window.location.href='<%= request.getContextPath() %>/pages/login/login_adm.jsp'"
      >
        ADM
      </button>
    </header>

    <div class="titulo-login">Login</div>
    <div class="linha"></div>

    <div class="container">
      <div class="card">
        <h3
          style="
            font-family: 'Lato', sans-serif;
            font-weight: 400;
            font-size: 16px;
            color: #274855;
            width: 550px;
            margin: 0 auto 18px auto;
            text-align: left;
          "
        >
          Bem-vindo à Devant!
        </h3>
        <% String erro = (String) request.getAttribute("erro"); if (erro !=
        null) { %>
        <div class="erro"><%= erro %></div>
        <% } %>
        <div class="bloco-login">
          <form action="<%= request.getContextPath() %>/login" method="post">
            <input type="hidden" name="cargo" value="aluno" />

            <input
              class="input"
              type="text"
              name="username"
              placeholder="email"
              required
              style="font-family: 'Lato', sans-serif; font-weight: 300"
            />
            <input
              class="input"
              type="password"
              name="password"
              placeholder="senha"
              required
              style="font-family: 'Lato', sans-serif; font-weight: 300"
            />

            <button type="submit" class="btn-entrar">
              <span>Entrar</span>

              <svg
                width="7"
                height="12"
                viewBox="0 0 7 12"
                fill="none"
                xmlns="http://www.w3.org/2000/svg"
              >
                <path
                  d="M1.283 0.221L6.283 5.221C6.353 5.291 6.409 5.374 6.446 5.465
                C6.484 5.556 6.504 5.654 6.504 5.753C6.504 5.851 6.484 5.949
                6.446 6.040C6.409 6.131 6.353 6.214 6.283 6.284L1.283 11.284
                C1.142 11.425 0.951 11.504 0.752 11.504C0.553 11.504 0.362 11.425
                0.221 11.284C0.080 11.143 0.001 10.952 0.001 10.753C0.001 10.553
                0.080 10.362 0.221 10.221L4.690 5.752L0.220 1.283C0.079 1.142
                0 0.951 0 0.751C0 0.552 0.079 0.361 0.220 0.220C0.361 0.079
                0.552 0 0.751 0C0.951 0 1.142 0.079 1.283 0.220L1.283 0.221Z"
                  fill="#FAFAFA"
                />
              </svg>
            </button>
          </form>

          <div class="cadastro">
            Não tem login?
            <a href="<%= request.getContextPath() %>/pages/login/cadastrar.jsp"
              >Cadastre-se</a
            >
          </div>
        </div>

        <div class="seletor-interno"></div>
      </div>
      <div class="tipo-wrapper">
        <button class="tipo tipo-ativo">Aluno</button>

        <button
          class="tipo tipo-inativo"
          onclick="window.location.href='<%= request.getContextPath() %>/pages/login/login_prof.jsp'"
        >
          Professor
        </button>
      </div>
    </div>
  </body>
</html>
