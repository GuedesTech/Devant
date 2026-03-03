<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.Aluno" %>

<%
  String ctx = request.getContextPath();

  Integer totalAlunos = (Integer) request.getAttribute("totalAlunos");
  if (totalAlunos == null) totalAlunos = 0;

  List<Aluno> alunos = (List<Aluno>) request.getAttribute("alunos");
  if (alunos == null) alunos = new ArrayList<>();

  Map<Integer, Double> mediaPorAluno = (Map<Integer, Double>) request.getAttribute("mediaPorAluno");
  if (mediaPorAluno == null) mediaPorAluno = new HashMap<>();
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="icon" href="<%= ctx %>/assets/Group 551.ico" />
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <link rel="stylesheet" href="<%= ctx %>/pages/professor/alunos.css" />
  <title>Seus Alunos - Devant</title>
</head>

<body>
<header class="topbar">
  <div class="topbar-inner">
    <a class="topbar-left" href="<%= ctx %>/professor/turmas" aria-label="Voltar ao início">
      <img class="topbar-logo" src="<%= ctx %>/pages/assets/logo.png" alt="Logo Devant">
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a class="topbar-link" href="<%= ctx %>/professor/turmas">Turmas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/disciplinas">Disciplinas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/perfil">Perfil</a>
      <span class="nav-indicador" aria-hidden="true"></span>
    </nav>

    <div class="topbar-right"></div>
  </div>
</header>

<main class="page">
  <section class="card alunos-card">
    <div class="card-header">
      <div class="page-title-row">
        <button class="back-btn" type="button" onclick="history.back()" aria-label="Voltar">←</button>
        <h1 class="page-title" style="margin:0;">Seus Alunos</h1>
      </div>

      <div class="title-line" aria-hidden="true"></div>

      <div class="chip">
        <img src="<%= request.getContextPath() %>/pages/professor/pessoas.png" style="height: 17.5px; width: 24px"><span>Total Alunos: <strong><%= totalAlunos %></strong></span>
      </div>
    </div>

    <div class="alunos-grid">
      <%
        for (Aluno a : alunos) {
          String foto = a.getFoto();
          boolean semFoto = (foto == null) || foto.isBlank()
                  || "null".equalsIgnoreCase(foto.trim())
                  || "[null]".equalsIgnoreCase(foto.trim());

          String fotoSrc = !semFoto
                  ? (ctx + "/pages/uploads/" + foto)
                  : (ctx + "/pages/aluno/foto_sem_foto.png");

          Double media = mediaPorAluno.get(a.getId_aluno());
          if (media == null) media = 0.0;

          // destino futuro (tela do aluno)
          String href = ctx + "/professor/aluno?id_aluno=" + a.getId_aluno();
      %>

      <a class="aluno-card" href="<%= href %>">
        <img class="aluno-avatar" src="<%= fotoSrc %>" alt="Foto do aluno">
        <div class="aluno-nome"><%= a.getNome() %></div>
        <div class="aluno-media"><%= String.format(java.util.Locale.US, "%.1f", media) %></div>
      </a>

      <%
        }
      %>
    </div>
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

    // nessa tela, mantém em Turmas (ou você pode marcar "Perfil" etc.)
    moverPara(links[0]);

    window.addEventListener("resize", () => moverPara(links[0]));

    links.forEach((a) => {
      a.addEventListener("click", (e) => {
        if (e.ctrlKey || e.metaKey || e.shiftKey || e.altKey) return;
        const href = a.getAttribute("href");
        if (!href) return;
        e.preventDefault();
        moverPara(a);
        setTimeout(() => window.location.href = href, 220);
      });
    });
  })();
</script>

</body>
</html>