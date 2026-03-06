<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.Turma" %>
<%@ page import="com.example.secretariaescolar.model.AlunoAdmView" %>

<%
  String ctx = request.getContextPath();

  AlunoAdmView aluno = (AlunoAdmView) request.getAttribute("aluno");
  if (aluno == null) aluno = new AlunoAdmView();

  @SuppressWarnings("unchecked")
  List<Turma> turmas = (List<Turma>) request.getAttribute("turmas");
  if (turmas == null) turmas = new ArrayList<>();

  String erro = (String) request.getAttribute("erro");
  if (erro == null) erro = "";

  String foto = aluno.getFoto();
  boolean semFoto = (foto == null) || foto.isBlank()
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
  <link rel="icon" href="<%= ctx %>/assets/Group 551.ico" />
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <link rel="stylesheet" href="<%= ctx %>/pages/adm/aluno-form.css" />
  <title>Editar Aluno - ADM</title>
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
        <h1 class="page-title" style="margin:0;">Editar Aluno</h1>
      </div>
      <div class="title-line" aria-hidden="true"></div>

      <% if (!erro.isBlank()) { %>
      <div class="alert"><%= erro %></div>
      <% } %>
    </div>

    <div class="profile-row">
      <img class="avatar" src="<%= fotoSrc %>" alt="Foto do aluno">
      <div class="profile-meta">
        <div class="profile-name"><%= (aluno.getNome() != null ? aluno.getNome() : "") %></div>
        <div class="profile-sub">ID Aluno: <strong><%= aluno.getIdAluno() %></strong></div>
      </div>

      <a class="btn-small" href="<%= ctx %>/adm/aluno/desempenho?id_aluno=<%= aluno.getIdAluno() %>">Ver desempenho</a>
    </div>

    <form class="form" method="post" action="<%= ctx %>/adm/aluno/editar" enctype="multipart/form-data">
      <input type="hidden" name="id_aluno" value="<%= aluno.getIdAluno() %>"/>

      <div class="grid">
        <label class="field">
          <span>Nome</span>
          <input name="nome" type="text" required value="<%= (aluno.getNome() != null ? aluno.getNome() : "") %>">
        </label>

        <label class="field">
          <span>Matrícula</span>
          <input name="matricula" type="text" required value="<%= (aluno.getMatricula() != null ? aluno.getMatricula() : "") %>">
        </label>

        <label class="field">
          <span>Turma</span>
          <select name="id_turma" required>
            <option value="" disabled>Selecione a turma</option>
            <%
              for (Turma t : turmas) {
                boolean sel = (t.getId_turma() == aluno.getIdTurma());
            %>
            <option value="<%= t.getId_turma() %>" <%= (sel ? "selected" : "") %>><%= t.getNome() %></option>
            <%
              }
            %>
          </select>
        </label>

        <label class="field">
          <span>E-mail (login)</span>
          <input name="login" type="email" value="<%= (aluno.getLogin() != null ? aluno.getLogin() : "") %>" placeholder="ex: aluno@devant.org.br">
        </label>

        <label class="field">
          <span>Senha</span>
          <input name="senha" type="text" value="<%= (aluno.getSenha() != null ? aluno.getSenha() : "") %>" placeholder="Defina uma senha">
          <small class="hint">Na listagem, a senha aparece como ******.</small>
        </label>

        <label class="field">
          <span>Trocar foto (opcional)</span>
          <input name="foto" type="file" accept="image/*">
          <small class="hint">Se não escolher arquivo, mantém a foto atual.</small>
        </label>
      </div>

      <div class="form-actions">
        <a class="btn-ghost" href="<%= ctx %>/adm/alunos">Cancelar</a>
        <button class="btn-primary" type="submit">Salvar alterações <span class="btn-arrow">›</span></button>
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