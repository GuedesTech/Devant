<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Instituto Devant</title>

    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
            href="https://fonts.googleapis.com/css2?family=Lato:wght@300;400;700&display=swap"
            rel="stylesheet"
    />
    <link
            rel="icon"
            type="image/png"
            href="<%= request.getContextPath() %>/pages/assets/logo-dark.png"
    />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/pages/login/style.css">
</head>

<body>

<header>
    <img src="<%= request.getContextPath() %>/pages/login/logo.png">

    <button class="botao-adm"
            onclick="window.location.href='<%= request.getContextPath() %>/pages/login/login_adm.jsp'">
        ADM
    </button>
</header>

<div class="titulo-login">Login</div>
<div class="linha"></div>

<div class="container">
    <div class="card">

        <h3 style="
            font-family: 'Lato', sans-serif;
            font-weight: 400;
            font-size: 16px;
            color: #274855;
            width: 550px;
            margin: 0 auto 18px auto;
            text-align: left;
        ">
            Bem-vindo à Devant!
        </h3>

        <%
            String erro = (String) request.getAttribute("erro");
            if (erro != null) {
        %>
            <div class="erro"><%= erro %></div>
        <% } %>

        <%
            String sucesso = (String) request.getAttribute("sucesso");
            if (sucesso != null) {
        %>
            <div class="sucesso"><%= sucesso %></div>
        <% } %>

        <div class="bloco-login">
            <form action="<%= request.getContextPath() %>/login" method="post">
                <input type="hidden" name="cargo" value="professor">

                <input
                    class="input"
                    type="text"
                    name="username"
                    placeholder="usuário"
                    required
                    style="font-family: 'Lato', sans-serif; font-weight: 300"
                >

                <input
                    class="input"
                    type="password"
                    name="password"
                    placeholder="senha"
                    required
                    style="font-family: 'Lato', sans-serif; font-weight: 300"
                >

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

            <div
                style="
                    margin-top: 10px;
                    width: 550px;
                    margin-left: auto;
                    margin-right: auto;
                    text-align: right;
                "
            >
                <a
                    href="#"
                    onclick="abrirModalEsqueciSenha(); return false;"
                    style="
                        color: #274855;
                        font-weight: 700;
                        text-decoration: none;
                        font-family: 'Lato', sans-serif;
                    "
                >
                    Esqueci minha senha
                </a>
            </div>

            <div class="cadastro">
                Não tem login?
                <a href="<%= request.getContextPath() %>/pages/login/cadastrar.jsp">
                    Cadastre-se
                </a>
            </div>
        </div>

        <div class="seletor-interno"></div>
    </div>

    <div class="tipo-wrapper">
        <button class="tipo tipo-inativo"
                onclick="window.location.href='<%= request.getContextPath() %>/pages/login/index.jsp'">
            Aluno
        </button>

        <button class="tipo tipo-ativo">
            Professor
        </button>
    </div>
</div>

<!-- Modal: pedir email -->
<div
    id="modalEsqueciSenha"
    style="
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.45);
        z-index: 9999;
        align-items: center;
        justify-content: center;
    "
>
    <div
        style="
            width: 360px;
            background: #2f3136;
            border-radius: 14px;
            padding: 20px;
            color: white;
            text-align: center;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.35);
        "
    >
        <h3 style="margin-bottom: 12px; font-family: 'Lato', sans-serif;">
            Recuperar senha
        </h3>

        <p
            style="
                font-size: 13px;
                opacity: 0.9;
                margin-bottom: 14px;
                font-family: 'Lato', sans-serif;
            "
        >
            Digite seu email para receber o código de 4 dígitos.
        </p>

        <form action="<%= request.getContextPath() %>/esqueci-senha" method="post">
            <input type="hidden" name="cargo" value="professor" />

            <input
                type="text"
                name="login"
                placeholder="Digite seu email"
                required
                style="
                    width: 100%;
                    height: 40px;
                    border: none;
                    border-radius: 8px;
                    padding: 0 10px;
                    margin-bottom: 12px;
                    box-sizing: border-box;
                "
            />

            <button
                type="submit"
                style="
                    width: 100%;
                    height: 40px;
                    border: none;
                    border-radius: 8px;
                    background: #5865f2;
                    color: white;
                    font-weight: 700;
                    cursor: pointer;
                "
            >
                Enviar código
            </button>
        </form>

        <button
            type="button"
            onclick="fecharModal('modalEsqueciSenha')"
            style="
                margin-top: 10px;
                width: 100%;
                height: 38px;
                border: none;
                border-radius: 8px;
                background: #444;
                color: white;
                cursor: pointer;
            "
        >
            Cancelar
        </button>
    </div>
</div>

<!-- Modal: código -->
<div
    id="modalCodigo"
    style="
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.45);
        z-index: 9999;
        align-items: center;
        justify-content: center;
    "
>
    <div
        style="
            width: 360px;
            background: #2f3136;
            border-radius: 14px;
            padding: 20px;
            color: white;
            text-align: center;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.35);
        "
    >
        <h3 style="margin-bottom: 12px; font-family: 'Lato', sans-serif;">
            Verificação
        </h3>

        <p
            style="
                font-size: 13px;
                opacity: 0.9;
                margin-bottom: 14px;
                font-family: 'Lato', sans-serif;
            "
        >
            Digite o código de 4 dígitos enviado no email.
        </p>

        <form action="<%= request.getContextPath() %>/verificar-codigo" method="post">
            <input
                type="text"
                name="codigo"
                maxlength="4"
                placeholder="Digite o código"
                required
                style="
                    width: 100%;
                    height: 40px;
                    border: none;
                    border-radius: 8px;
                    padding: 0 10px;
                    margin-bottom: 12px;
                    box-sizing: border-box;
                    text-align: center;
                    letter-spacing: 3px;
                    font-size: 16px;
                "
            />

            <button
                type="submit"
                style="
                    width: 100%;
                    height: 40px;
                    border: none;
                    border-radius: 8px;
                    background: #5865f2;
                    color: white;
                    font-weight: 700;
                    cursor: pointer;
                "
            >
                Verificar
            </button>
        </form>

        <button
            type="button"
            onclick="fecharModal('modalCodigo')"
            style="
                margin-top: 10px;
                width: 100%;
                height: 38px;
                border: none;
                border-radius: 8px;
                background: #444;
                color: white;
                cursor: pointer;
            "
        >
            Cancelar
        </button>
    </div>
</div>

<!-- Modal: nova senha -->
<div
    id="modalNovaSenha"
    style="
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.45);
        z-index: 9999;
        align-items: center;
        justify-content: center;
    "
>
    <div
        style="
            width: 360px;
            background: #2f3136;
            border-radius: 14px;
            padding: 20px;
            color: white;
            text-align: center;
            box-shadow: 0 12px 30px rgba(0, 0, 0, 0.35);
        "
    >
        <h3 style="margin-bottom: 12px; font-family: 'Lato', sans-serif;">
            Nova senha
        </h3>

        <form action="<%= request.getContextPath() %>/redefinir-senha" method="post">
            <input
                type="password"
                name="novaSenha"
                placeholder="Digite a nova senha"
                required
                style="
                    width: 100%;
                    height: 40px;
                    border: none;
                    border-radius: 8px;
                    padding: 0 10px;
                    margin-bottom: 12px;
                    box-sizing: border-box;
                "
            />

            <button
                type="submit"
                style="
                    width: 100%;
                    height: 40px;
                    border: none;
                    border-radius: 8px;
                    background: #5865f2;
                    color: white;
                    font-weight: 700;
                    cursor: pointer;
                "
            >
                Salvar nova senha
            </button>
        </form>

        <button
            type="button"
            onclick="fecharModal('modalNovaSenha')"
            style="
                margin-top: 10px;
                width: 100%;
                height: 38px;
                border: none;
                border-radius: 8px;
                background: #444;
                color: white;
                cursor: pointer;
            "
        >
            Cancelar
        </button>
    </div>
</div>

<script>
    function abrirModalEsqueciSenha() {
        document.getElementById("modalEsqueciSenha").style.display = "flex";
    }

    function abrirModalCodigo() {
        document.getElementById("modalCodigo").style.display = "flex";
    }

    function abrirModalNovaSenha() {
        document.getElementById("modalNovaSenha").style.display = "flex";
    }

    function fecharModal(id) {
        document.getElementById(id).style.display = "none";
    }
</script>

<%
    Boolean abrirModalCodigo = (Boolean) request.getAttribute("abrirModalCodigo");
    Boolean abrirModalNovaSenha = (Boolean) request.getAttribute("abrirModalNovaSenha");
%>

<% if (abrirModalCodigo != null && abrirModalCodigo) { %>
    <script>
        abrirModalCodigo();
    </script>
<% } %>

<% if (abrirModalNovaSenha != null && abrirModalNovaSenha) { %>
    <script>
        abrirModalNovaSenha();
    </script>
<% } %>

</body>
</html>