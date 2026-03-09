<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.Disciplina" %>
<%@ page import="com.example.secretariaescolar.dto.NotasAlunoDTO" %>

<%
  String ctx = request.getContextPath();

  Integer idAluno = (Integer) request.getAttribute("idAluno");
  if (idAluno == null) idAluno = 0;

  @SuppressWarnings("unchecked")
  List<Disciplina> disciplinas = (List<Disciplina>) request.getAttribute("disciplinas");
  if (disciplinas == null) disciplinas = new ArrayList<>();

  Integer idDisc = (Integer) request.getAttribute("idDisciplina"); // pode ser null
  NotasAlunoDTO notas = (NotasAlunoDTO) request.getAttribute("notas");
  if (notas == null) {
    notas = new NotasAlunoDTO();
    notas.setN1(0.0);
    notas.setN2(0.0);
  }

  String ok = request.getParameter("ok");
  String erro = request.getParameter("erro"); // ex: sem_prof
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/pages/login/minimalismo.png">
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <link rel="stylesheet" href="<%= ctx %>/pages/adm/aluno-desempenho.css" />
  <title>Desempenho do Aluno - ADM</title>
</head>

<body>
<header class="topbar">
  <div class="topbar-inner">
    <a class="topbar-left" href="<%= ctx %>/adm/alunos" aria-label="Voltar">
      <img class="topbar-logo" src="<%= ctx %>/pages/assets/logo.png" alt="Logo Devant">
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a class="topbar-link" href="<%= ctx %>/adm/perfil">Perfil</a>
      <a class="topbar-link" href="<%= ctx %>/adm/turmas">Turmas</a>
      <a class="topbar-link is-active" href="<%= ctx %>/adm/alunos">Alunos</a>
      <a class="topbar-link" href="<%= ctx %>/adm/professores">Professores</a>
      <a class="topbar-link" href="<%= ctx %>/adm/disciplinas">Disciplinas</a>
      <a class="topbar-link" href="<%= ctx %>/adm/observacoes">Observações</a>
      <span class="nav-indicador" aria-hidden="true"></span>
    </nav>

    <div class="topbar-right">
      <a class="btn-outline" href="<%= ctx %>/index.jsp">Sair</a>
    </div>
  </div>
</header>

<main class="page">
  <section class="card perf-card">
    <div class="card-header">
      <div class="page-title-row">
        <button class="back-btn" type="button" onclick="history.back()" aria-label="Voltar">←</button>
        <h1 class="page-title" style="margin:0;">Desempenho</h1>
      </div>
      <div class="title-line" aria-hidden="true"></div>

      <% if ("1".equals(ok)) { %>
      <div class="alert ok">Notas salvas com sucesso.</div>
      <% } %>

      <% if ("sem_prof".equals(erro)) { %>
      <div class="alert err">Essa disciplina não tem professor vinculado. Não foi possível salvar por causa do FK.</div>
      <% } %>

      <div class="chip">
        <span>Aluno ID: <strong><%= idAluno %></strong></span>
      </div>
    </div>

    <div class="row">
      <!-- FILTRO DE DISCIPLINA -->
      <form class="disc-filter" method="get" action="<%= ctx %>/adm/aluno/desempenho">
        <input type="hidden" name="id_aluno" value="<%= idAluno %>">

        <label class="field">
          <span>Disciplina</span>
          <select name="id_disciplina" onchange="this.form.submit()">
            <option value="" disabled <%= (idDisc == null ? "selected" : "") %>>Selecione</option>
            <%
              for (Disciplina d : disciplinas) {
                boolean sel = (idDisc != null && d.getId_disciplina() == idDisc);
            %>
            <option value="<%= d.getId_disciplina() %>" <%= (sel ? "selected" : "") %>><%= d.getNome() %></option>
            <%
              }
            %>
          </select>
        </label>
      </form>

      <a class="btn-ghost" href="<%= ctx %>/adm/aluno/editar?id_aluno=<%= idAluno %>">Voltar para editar aluno</a>
    </div>

    <!-- FORM NOTAS (só aparece se tiver disciplina selecionada) -->
    <%
      if (idDisc != null) {
        double media = notas.getMedia();
    %>

    <form class="nota-form" method="post" action="<%= ctx %>/adm/aluno/desempenho">
      <input type="hidden" name="id_aluno" value="<%= idAluno %>">
      <input type="hidden" name="id_disciplina" value="<%= idDisc %>">

      <div class="grid">
        <label class="field">
          <span>Nota 1 (semestre 1)</span>
          <input name="n1" type="number" step="0.1" min="0" max="10" value="<%= notas.getN1() %>" required>
        </label>

        <label class="field">
          <span>Nota 2 (semestre 2)</span>
          <input name="n2" type="number" step="0.1" min="0" max="10" value="<%= notas.getN2() %>" required>
        </label>

        <div class="field readonly">
          <span>Média</span>
          <div class="readonly-box"><%= String.format(java.util.Locale.US, "%.1f", media) %></div>
          <small class="hint">A média é calculada como (N1 + N2) / 2.</small>
        </div>
      </div>

      <div class="form-actions">
        <a class="btn-ghost" href="<%= ctx %>/adm/alunos">Voltar para lista</a>
        <button class="btn-primary" type="submit">Salvar notas <span class="btn-arrow">›</span></button>
      </div>
    </form>

    <%
    } else {
    %>
    <p class="empty">Selecione uma disciplina para ver/editar as notas.</p>
    <%
      }
    %>

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