<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.Turma" %>

<%
  String ctx = request.getContextPath();

  @SuppressWarnings("unchecked")
  List<Turma> turmas = (List<Turma>) request.getAttribute("turmas");
  if (turmas == null) turmas = new ArrayList<>();

  String erro = (String) request.getAttribute("erro");
  if (erro == null) erro = "";
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="icon" href="<%= ctx %>/assets/Group 551.ico" />
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <link rel="stylesheet" href="<%= ctx %>/pages/adm/aluno-form.css" />
  <title>Novo Aluno - ADM</title>
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
  <section class="card form-card">
    <div class="card-header">
      <div class="page-title-row">
        <button class="back-btn" type="button" onclick="history.back()" aria-label="Voltar">←</button>
        <h1 class="page-title" style="margin:0;">Adicionar Aluno</h1>
      </div>
      <div class="title-line" aria-hidden="true"></div>

      <% if (!erro.isBlank()) { %>
      <div class="alert"><%= erro %></div>
      <% } %>
    </div>

    <form class="form" method="post" action="<%= ctx %>/adm/aluno/novo" enctype="multipart/form-data">
      <div class="grid">
        <label class="field">
          <span>Nome</span>
          <input name="nome" type="text" required placeholder="Nome do aluno">
        </label>

        <label class="field">
          <span>Matrícula</span>
          <input name="matricula" type="text" required placeholder="Ex: 1GT">
        </label>

        <label class="field">
          <span>Turma</span>
          <select name="id_turma" required>
            <option value="" disabled selected>Selecione a turma</option>
            <%
              for (Turma t : turmas) {
            %>
            <option value="<%= t.getId_turma() %>"><%= t.getNome() %></option>
            <%
              }
            %>
          </select>
        </label>

        <label class="field">
          <span>Foto (opcional)</span>
          <input name="foto" type="file" accept="image/*">
          <small class="hint">A imagem será salva em <strong>/pages/uploads</strong>.</small>
        </label>
      </div>

      <div class="form-actions">
        <a class="btn-ghost" href="<%= ctx %>/adm/alunos">Cancelar</a>
        <button class="btn-primary" type="submit">Salvar aluno <span class="btn-arrow">›</span></button>
      </div>

      <div class="note">
        Login e senha <strong>não</strong> são cadastrados aqui (ficam vazios). As notas começam em 0 e 0 — edite em <strong>Ver desempenho</strong>.
      </div>
    </form>
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