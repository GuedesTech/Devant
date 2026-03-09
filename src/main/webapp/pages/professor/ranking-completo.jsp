<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>

<%
  String ctx = request.getContextPath();

  String nomeTurma = (String) request.getAttribute("nomeTurma");
  if (nomeTurma == null || nomeTurma.isBlank()) nomeTurma = "Turma";

  Integer totalAlunos = (Integer) request.getAttribute("totalAlunos");
  if (totalAlunos == null) totalAlunos = 0;

  List<Map<String, Object>> rankingCompleto =
          (List<Map<String, Object>>) request.getAttribute("rankingCompleto");
  if (rankingCompleto == null) rankingCompleto = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/pages/login/minimalismo.png">
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <link rel="stylesheet" href="<%= ctx %>/pages/professor/ranking-completo.css" />
  <title>Ranking Completo - <%= nomeTurma %></title>
</head>

<body>
<header class="topbar">
  <div class="topbar-inner">
    <a class="topbar-left" href="<%= ctx %>/professor/turmas" aria-label="Voltar ao início">
      <img class="topbar-logo" src="<%= ctx %>/pages/assets/logo.png" alt="Logo Devant">
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a class="topbar-link is-active" href="<%= ctx %>/professor/turmas">Turmas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/disciplinas">Disciplinas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/perfil">Perfil</a>
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
  <section class="card ranking-card">
    <div class="card-header">
      <div class="page-title-row">
        <button class="back-btn" type="button" onclick="history.back()" aria-label="Voltar">←</button>
        <h1 class="page-title" style="margin:0;">Ranking Completo - <%= nomeTurma %></h1>
      </div>

      <div class="title-line" aria-hidden="true"></div>

      <div class="chip">
        <img src="<%= ctx %>/pages/professor/pessoas.png" style="height: 17.5px; width: 24px" alt="">
        <span>Total Alunos: <strong><%= totalAlunos %></strong></span>
      </div>
    </div>

    <div class="ranking-list-full">
      <%
        if (rankingCompleto.isEmpty()) {
      %>
      <div class="empty">Nenhum aluno encontrado para esta turma.</div>
      <%
      } else {
        int posicao = 1;
        for (Map<String, Object> item : rankingCompleto) {
          Integer idAluno = (Integer) item.get("id_aluno");
          String nome = String.valueOf(item.get("nome"));
          Double media = (Double) item.get("media");
          if (media == null) media = 0.0;

          String foto = (String) item.get("foto");

          boolean semFoto = (foto == null)
                  || foto.isBlank()
                  || "null".equalsIgnoreCase(foto.trim())
                  || "[null]".equalsIgnoreCase(foto.trim());

          String fotoSrc = !semFoto
                  ? (ctx + "/pages/uploads/" + foto)
                  : (ctx + "/pages/aluno/foto_sem_foto.png");

          boolean aprovado = media >= 7.0;

          String href = ctx + "/professor/aluno?id_aluno=" + idAluno;
      %>
      <a class="ranking-item-card <%= aprovado ? "ok" : "bad" %>" href="<%= href %>">
        <div class="ranking-pos"><%= posicao %>°</div>

        <div class="ranking-student">
          <img class="ranking-avatar" src="<%= fotoSrc %>" alt="Foto do aluno">
          <div class="ranking-info">
            <div class="ranking-name"><%= nome %></div>
          </div>
        </div>

        <div class="ranking-media-wrap">
          <div class="ranking-media-label">Média</div>
          <div class="ranking-media"><%= String.format(java.util.Locale.US, "%.1f", media) %></div>
        </div>
      </a>
      <%
            posicao++;
          }
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
        setTimeout(() => window.location.href = href, 220);
      });
    });
  })();
</script>

</body>
</html>