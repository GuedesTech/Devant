<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.secretariaescolar.model.Aluno" %>

<%
    Aluno aluno = (Aluno) request.getAttribute("aluno");
    String ctx = request.getContextPath();

    String nome = (aluno != null && aluno.getNome() != null) ? aluno.getNome() : "";
    String matricula = (aluno != null && aluno.getMatricula() != null) ? aluno.getMatricula() : "";
    String idTurma = (aluno != null) ? String.valueOf(aluno.getId_turma()) : "";

    String foto = (aluno != null) ? aluno.getFoto() : null;

    boolean semFoto = (foto == null)
            || foto.isBlank()
            || "null".equalsIgnoreCase(foto.trim())
            || "[null]".equalsIgnoreCase(foto.trim());

    String fotoSrc = !semFoto
            ? (ctx + "/pages/uploads/" + foto)
            : (ctx + "/pages/aluno/foto_sem_foto.png");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/pages/login/minimalismo.png">
    <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
    <script src="<%= ctx %>/pages/aluno/indicador.js"></script>
    <title>Perfil - Devant</title>
</head>

<body>
<header class="topbar">
    <div class="topbar-inner">
        <a class="topbar-left" href="<%= ctx %>/login/index.jsp" aria-label="Voltar ao início">
            <img class="topbar-logo" src="<%= request.getContextPath() %>/pages/assets/logo.png" alt="Logo Devant">
        </a>

        <nav class="topbar-nav" aria-label="Navegação principal">
            <a class="topbar-link is-active" href="<%= ctx %>/aluno/perfil">Perfil</a>
            <a class="topbar-link" href="<%= ctx %>/aluno/disciplinas">Disciplinas</a>

            <span class="nav-indicador" aria-hidden="true"></span>
        </nav>

        <div class="topbar-right">
            <a href="<%= ctx %>/pages/login/index.jsp" class="logout-btn">
                Sair
            </a>
        </div>
    </div>
</header>

<main class="page">
    <section class="card">
        <div class="card-header">
            <h1 class="page-title">Meu Perfil</h1>
            <div class="title-line" aria-hidden="true"></div>

            <div class="pill-row">
                <a class="pill" href="<%= ctx %>/aluno/notas">
                    Notas <span class="pill-arrow">&gt;</span>
                </a>
                <a class="pill" href="<%= ctx %>/aluno/observacoes">Observações <span class="pill-arrow">&gt;</span></a>
            </div>
        </div>

        <div class="profile">
            <div class="avatar-wrap">
                <img class="avatar" src="<%= fotoSrc %>" alt="Foto do aluno" />
            </div>

            <div class="profile-info">
                <h2 class="student-name"><%= nome %></h2>

                <div class="info-block">
                    <p class="info-label">Matrícula:</p>
                    <p class="info-value"><%= matricula %></p>
                </div>

                <div class="info-block">
                    <p class="info-label">Turma:</p>
                    <p class="info-value"><%= (aluno != null ? aluno.getNomeTurma() : "") %></p>
                </div>
            </div>
        </div>

        <%-- Debug opcional (apague depois) --%>
        <% if (aluno == null) { %>
        <p style="margin-top:16px; font-weight:700; color:#283565;">
            DEBUG: aluno veio NULL (o servlet não setou request.setAttribute("aluno", ...))
        </p>
        <% } %>

    </section>
</main>

<script>
    (function () {
        const nav = document.querySelector(".topbar-nav");
        const indicador = nav ? nav.querySelector(".nav-indicador") : null;
        const links = nav ? nav.querySelectorAll(".topbar-link") : [];
        if (!nav || !indicador || links.length === 0) return;

        function moverPara(el) {
            const rect = el.getBoundingClientRect();
            const navRect = nav.getBoundingClientRect();
            indicador.style.width = rect.width + "px";
            indicador.style.left = (rect.left - navRect.left) + "px";
        }

        // posiciona ao carregar
        const ativo = nav.querySelector(".topbar-link.is-active") || links[0];
        moverPara(ativo);

        window.addEventListener("resize", () => {
            const a = nav.querySelector(".topbar-link.is-active") || links[0];
            moverPara(a);
        });

        // anima antes de navegar
        links.forEach((a) => {
            a.addEventListener("click", (e) => {
                // deixa abrir em nova aba normal
                if (e.ctrlKey || e.metaKey || e.shiftKey || e.altKey) return;

                const href = a.getAttribute("href");
                if (!href) return;

                e.preventDefault();

                // move indicador para o link clicado
                moverPara(a);

                // pequena espera para a animação aparecer
                setTimeout(() => {
                    window.location.href = href;
                }, 220);
            });
        });
    })();
</script>

</body>
</html>