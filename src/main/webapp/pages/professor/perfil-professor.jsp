<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.example.secretariaescolar.model.Professor" %>
<%@ page import="com.example.secretariaescolar.model.Disciplina" %>

<%
  Professor professor = (Professor) request.getAttribute("professor");
  Disciplina disciplina = (Disciplina) request.getAttribute("disciplina");

  String ctx = request.getContextPath();

  String nome = (professor != null && professor.getNome() != null) ? professor.getNome() : "";
  String login = (professor != null && professor.getLogin() != null) ? professor.getLogin() : "";

  String nomeDisciplina = (disciplina != null && disciplina.getNome() != null) ? disciplina.getNome() : "";

  String foto = (professor != null) ? professor.getFoto() : null;

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
  <title>Perfil - Devant</title>
</head>

<body>
<header class="topbar">
  <div class="topbar-inner">
    <a class="topbar-left" href="<%= ctx %>/pages/login/index.jsp" aria-label="Voltar ao início">
      <img class="topbar-logo" src="<%= request.getContextPath() %>/pages/assets/logo.png" alt="Logo Devant">
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a class="topbar-link" href="<%= ctx %>/professor/turmas">Turmas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/disciplinas">Disciplinas</a>
      <a class="topbar-link is-active" href="<%= ctx %>/professor/perfil">Perfil</a>

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
    </div>

    <div class="profile">
      <div class="avatar-wrap">
        <img class="avatar" src="<%= fotoSrc %>" alt="Foto do professor" />
      </div>

      <div class="profile-info">
        <h2 class="student-name"><%= nome %></h2>

        <div class="info-block">
          <p class="info-label" style="font-size: 15px">Login:</p>
          <p class="info-value" style="font-size: 25px"><%= login %></p>
        </div>

        <div class="info-block">
          <p class="info-label" style="font-size: 15px">Disciplina:</p>
          <p class="info-value" style="font-size: 25px"><%= nomeDisciplina %></p>
        </div>
      </div>
    </div>

    <% if (professor == null) { %>
    <p style="margin-top:16px; font-weight:700; color:#283565;">
      DEBUG: professor veio NULL
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

        const ativo = nav.querySelector(".topbar-link.is-active") || links[0];
        moverPara(ativo);

        window.addEventListener("resize", () => {
            const a = nav.querySelector(".topbar-link.is-active") || links[0];
            moverPara(a);
        });

        links.forEach((a) => {
            a.addEventListener("click", (e) => {
                if (e.ctrlKey || e.metaKey || e.shiftKey || e.altKey) return;

                const href = a.getAttribute("href");
                if (!href) return;

                e.preventDefault();
                moverPara(a);

                setTimeout(() => {
                    window.location.href = href;
                }, 220);
            });
        });
    })();
</script>

</body>
</html>