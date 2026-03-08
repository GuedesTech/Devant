<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Instituto Devant - Cadastro</title>
    <link
      rel="icon"
      type="image/png"
      href="<%= request.getContextPath() %>/pages/assets/logo-dark.png"
    />
    <link
      <link
      rel="stylesheet"
      href="<%= request.getContextPath() %>/pages/login/style.css"
    />
  </head>

  <body>
    <header>
      <img src="<%= request.getContextPath() %>/pages/login/logo.png" />
    </header>

    <div class="titulo-login">Cadastro</div>
    <div class="linha"></div>

    <div class="container">
      <div class="card">
        <h1>Cadastre suas informações!</h1>

        <form
          action="<%= request.getContextPath() %>/cadastrar"
          method="post"
          onsubmit="return validarFormulario(event)"
        >
          <input type="hidden" name="cargo" value="aluno" />

          <input
            class="input"
            type="email"
            name="email"
            placeholder="Email"
            required
          />

          <input
            class="input"
            type="password"
            name="password"
            placeholder="Senha"
            required
          />

          <div id="erroSenha" class="erro-senha"></div>

          <% String erro = (String) request.getAttribute("erro"); if (erro !=
          null) { %>
          <div class="erro"><%= erro %></div>
          <% } %>

          <input
            class="input"
            type="password"
            name="confirmarSenha"
            placeholder="Confirmar Senha"
            required
          />

          <button type="submit" class="btn-entrar">
            <span>Cadastrar</span>

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
          <a href="<%= request.getContextPath() %>/pages/login/index.jsp">
            Voltar
          </a>
        </div>
      </div>
      <div class="tipo-wrapper">
        <button class="tipo tipo-ativo">Aluno</button>
      </div>
    </div>

    <div id="modalConfirmacao" class="modal">
      <div class="modal-content">
        <p id="mensagem_confirm">
          Você tem certeza que deseja finalizar o cadastro?
        </p>
        <div class="modal-botoes">
          <button
            id="botao_cadastro"
            type="button"
            onclick="enviarFormulario()"
          >
            Cadastrar
          </button>
          <button id="botao_cancelar" type="button" onclick="fecharModal()">
            Cancelar
          </button>
        </div>
      </div>
    </div>

    <script>
      function validarFormulario(event) {
        event.preventDefault(); // impede envio imediato

        const senha = document.querySelector('input[name="password"]').value;
        const confirmarSenha = document.querySelector(
          'input[name="confirmarSenha"]'
        ).value;
        const erroDiv = document.getElementById("erroSenha");

        erroDiv.textContent = "";

        if (senha !== confirmarSenha) {
          erroDiv.textContent = "As senhas não são iguais.";
          return false;
        }

        document.getElementById("modalConfirmacao").style.display = "flex";
        return false;
      }

      function fecharModal() {
        document.getElementById("modalConfirmacao").style.display = "none";
      }

      function enviarFormulario() {
        document.querySelector("form").submit();
      }
    </script>
  </body>
</html>
