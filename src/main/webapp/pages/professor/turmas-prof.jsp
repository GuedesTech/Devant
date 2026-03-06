<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.Turma" %>

<%
  String ctx = request.getContextPath();

  Integer totalAlunos = (Integer) request.getAttribute("totalAlunos");
  if (totalAlunos == null) totalAlunos = 0;

  List<Turma> turmas = (List<Turma>) request.getAttribute("turmas");
  if (turmas == null) turmas = new ArrayList<>();

  Map<Integer, Double> mediaPorTurma = (Map<Integer, Double>) request.getAttribute("mediaPorTurma");
  if (mediaPorTurma == null) mediaPorTurma = new HashMap<>();

  // separa por ano usando primeiro caractere do nome
  List<Turma> turmas1 = new ArrayList<>();
  List<Turma> turmas2 = new ArrayList<>();
  List<Turma> turmas3 = new ArrayList<>();

  for (Turma t : turmas) {
    String nome = (t.getNome() != null) ? t.getNome().trim() : "";
    if (nome.isEmpty()) continue;

    char c = nome.charAt(0);
    if (c == '1') turmas1.add(t);
    else if (c == '2') turmas2.add(t);
    else if (c == '3') turmas3.add(t);
  }
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="icon" href="<%= ctx %>/assets/Group 551.ico" />

  <!-- reaproveita sua topbar e base -->
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <!-- css específico dessa tela -->
  <link rel="stylesheet" href="<%= ctx %>/pages/professor/turmas-prof.css" />

  <title>Turmas - Devant</title>
</head>

<body>
<header class="topbar">
  <div class="topbar-inner">
    <a class="topbar-left" href="<%= ctx %>/login/index.jsp" aria-label="Voltar ao início">
      <img class="topbar-logo" src="<%= ctx %>/pages/assets/logo.png" alt="Logo Devant">
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a class="topbar-link is-active" href="<%= ctx %>/professor/turmas">Turmas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/disciplinas">Disciplinas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/perfil">Perfil</a>
      <span class="nav-indicador" aria-hidden="true"></span>
    </nav>

    <div class="topbar-right"></div>
  </div>
</header>

<main class="page">
  <section class="card turmas-card">
    <div class="card-header">
      <h1 class="page-title">Minhas Turmas</h1>
      <div class="title-line" aria-hidden="true"></div>

      <div class="actions-row">
        <div class="chip">
          <img src="<%= request.getContextPath() %>/pages/professor/pessoas.png" style="height: 17.5px; width: 24px"><span>Total Alunos: <strong><%= totalAlunos %></strong></span>
        </div>

        <a class="btn-primary" href="<%= ctx %>/professor/alunos">
          Ver alunos <span class="btn-arrow">›</span>
        </a>
      </div>
    </div>

    <!-- Acordeões -->
    <div class="accordions">

      <!-- 1º ano -->
      <div class="acc" data-acc>
        <button class="acc-head" type="button" data-acc-btn>
          <span class="acc-title">1° ano</span>
          <span class="acc-icon" aria-hidden="true"><img src="<%= request.getContextPath() %>/pages/professor/abrir.png" style="height: 5px; height: 11px"></span>
        </button>

        <div class="acc-body" data-acc-body>
          <div class="turmas-grid">
            <%
              if (turmas1.isEmpty()) {
            %>
            <div class="empty">Nenhuma turma do 1° ano.</div>
            <%
            } else {
              for (Turma t : turmas1) {
                Double media = mediaPorTurma.get(t.getId_turma());
                if (media == null) media = 0.0;
            %>
            <a class="turma-tile" href="<%= ctx %>/professor/turma?id_turma=<%= t.getId_turma() %>">
              <span class="turma-nome"><%= t.getNome() %></span>
              <span class="turma-media"><%= String.format(java.util.Locale.US, "%.1f", media) %></span>
            </a>
            <%
                }
              }
            %>
          </div>
        </div>
      </div>

      <!-- 2º ano -->
      <div class="acc" data-acc>
        <button class="acc-head" type="button" data-acc-btn>
          <span class="acc-title">2° ano</span>
          <span class="acc-icon" aria-hidden="true"><img src="<%= request.getContextPath() %>/pages/professor/abrir.png" style="height: 5px; height: 11px"></span>
        </button>

        <div class="acc-body" data-acc-body>
          <div class="turmas-grid">
            <%
              if (turmas2.isEmpty()) {
            %>
            <div class="empty">Nenhuma turma do 2° ano.</div>
            <%
            } else {
              for (Turma t : turmas2) {
                Double media = mediaPorTurma.get(t.getId_turma());
                if (media == null) media = 0.0;
            %>
            <a class="turma-tile" href="<%= ctx %>/professor/turma?id_turma=<%= t.getId_turma() %>">
              <span class="turma-nome"><%= t.getNome() %></span>
              <span class="turma-media"><%= String.format(java.util.Locale.US, "%.1f", media) %></span>
            </a>
            <%
                }
              }
            %>
          </div>
        </div>
      </div>

      <!-- 3º ano -->
      <div class="acc" data-acc>
        <button class="acc-head" type="button" data-acc-btn>
          <span class="acc-title">3° ano</span>
          <span class="acc-icon" aria-hidden="true"><img src="<%= request.getContextPath() %>/pages/professor/abrir.png" style="height: 5px; height: 11px"></span>
        </button>

        <div class="acc-body" data-acc-body>
          <div class="turmas-grid">
            <%
              if (turmas3.isEmpty()) {
            %>
            <div class="empty">Nenhuma turma do 3° ano.</div>
            <%
            } else {
              for (Turma t : turmas3) {
                Double media = mediaPorTurma.get(t.getId_turma());
                if (media == null) media = 0.0;
            %>
            <a class="turma-tile" href="<%= ctx %>/professor/turma?id_turma=<%= t.getId_turma() %>">
              <span class="turma-nome"><%= t.getNome() %></span>
              <span class="turma-media"><%= String.format(java.util.Locale.US, "%.1f", media) %></span>
            </a>
            <%
                }
              }
            %>
          </div>
        </div>
      </div>

    </div>
  </section>
</main>

<script>
  // ===== indicador do menu (mesmo estilo do aluno) =====
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

  // ===== acordeão (abre/fecha e muda setinha) =====
  (function(){
    document.querySelectorAll("[data-acc]").forEach(acc => {
      const btn = acc.querySelector("[data-acc-btn]");
      const body = acc.querySelector("[data-acc-body]");
      if(!btn || !body) return;

      btn.addEventListener("click", () => {
        const isOpen = acc.classList.toggle("is-open");
        body.style.maxHeight = isOpen ? (body.scrollHeight + "px") : "0px";
      });

      // começa fechado
      body.style.maxHeight = "0px";
    });
  })();
</script>

</body>
</html>