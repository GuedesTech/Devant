<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.Turma" %>

<%
  String ctx = request.getContextPath();

  Integer total = (Integer) request.getAttribute("totalTurmas");
  if (total == null) total = 0;

  @SuppressWarnings("unchecked")
  List<Turma> turmas = (List<Turma>) request.getAttribute("turmas");
  if (turmas == null) turmas = new ArrayList<>();

  String q = (String) request.getAttribute("q");
  if (q == null) q = "";

  String ok = request.getParameter("ok");
  String erro = request.getParameter("erro");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/pages/login/minimalismo.png">
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <link rel="stylesheet" href="<%= ctx %>/pages/adm/alunos-adm.css" />
  <title>Turmas - ADM</title>
</head>

<body>
<header class="topbar">
  <div class="topbar-inner">
    <a class="topbar-left" href="<%= ctx %>/adm/perfil" aria-label="Voltar ao início">
      <img class="topbar-logo" src="<%= ctx %>/pages/assets/logo.png" alt="Logo Devant">
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a class="topbar-link" href="<%= ctx %>/adm/perfil">Perfil</a>
      <a class="topbar-link is-active" href="<%= ctx %>/adm/turmas">Turmas</a>
      <a class="topbar-link" href="<%= ctx %>/adm/alunos">Alunos</a>
      <a class="topbar-link" href="<%= ctx %>/adm/professores">Professores</a>
      <a class="topbar-link" href="<%= ctx %>/adm/disciplinas">Disciplinas</a>
      <a class="topbar-link" href="<%= ctx %>/adm/observacoes">Observações</a>
      <span class="nav-indicador" aria-hidden="true"></span>
    </nav>

    <div class="topbar-right">
      <a href="<%= ctx %>/pages/login/index.jsp" class="logout-btn">Sair</a>
    </div>
  </div>
</header>

<main class="page">
  <section class="card adm-card">
    <div class="card-header">
      <h1 class="page-title">Turmas</h1>
      <div class="title-line" aria-hidden="true"></div>

      <% if ("1".equals(ok)) { %>
      <div class="alert ok">Operação realizada com sucesso.</div>
      <% } %>

      <% if ("1".equals(erro)) { %>
      <div class="alert err">Não foi possível concluir a operação.</div>
      <% } %>

      <div class="actions-row">
        <div class="chip">
          <img src="<%= ctx %>/pages/professor/pessoas.png" style="height: 17.5px; width: 24px" alt="">
          <span>Total Turmas: <strong><%= total %></strong></span>
        </div>

        <button class="btn-primary" type="button" data-open-popup="popupNovo">
          Adicionar Turma <span class="btn-arrow">›</span>
        </button>

        <form class="search" method="get" action="<%= ctx %>/adm/turmas">
          <input name="q" value="<%= q %>" type="text" placeholder="Pesquisar turma">
          <button type="submit">Buscar</button>
        </form>
      </div>
    </div>

    <div class="table-wrap">
      <table class="table">
        <thead>
        <tr>
          <th class="left">Nome da Turma</th>
          <th class="right">Ações</th>
        </tr>
        </thead>
        <tbody>
        <%
          for (Turma t : turmas) {
            String nomeSafe = t.getNome() == null ? "" : t.getNome().replace("\"", "&quot;");
        %>
        <tr>
          <td><%= t.getNome() %></td>
          <td class="right">
            <button
                    class="icon-btn btn-editar"
                    type="button"
                    data-open-popup="popupEditar"
                    data-id-turma="<%= t.getId_turma() %>"
                    data-nome="<%= nomeSafe %>">
              <img src="<%= ctx %>/pages/adm/edit.png" style="width: 20px; height: 20px">
            </button>

            <button
                    class="icon-btn danger btn-excluir"
                    type="button"
                    data-open-popup="popupExcluir"
                    data-id-turma="<%= t.getId_turma() %>"
                    data-nome="<%= nomeSafe %>">
              <img src="<%= ctx %>/pages/adm/delete.png" style="width: 17px; height: 20px">
            </button>
          </td>
        </tr>
        <%
          }
          if (turmas.isEmpty()) {
        %>
        <tr>
          <td colspan="2" class="empty">Nenhuma turma encontrada.</td>
        </tr>
        <%
          }
        %>
        </tbody>
      </table>
    </div>
  </section>
</main>

<div class="overlay" id="overlay"></div>

<div class="popup" id="popupNovo" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title">Adicionar Turma</h2>
  </div>

  <form class="popup-form" method="post" action="<%= ctx %>/adm/turma/novo">
    <label class="field">
      <span>Nome da turma</span>
      <input name="nome" type="text" required placeholder="Ex: 1º A">
    </label>

    <div class="popup-actions">
      <button class="btn-ghost" type="button" data-close-popup>Cancelar</button>
      <button class="btn-primary" type="submit">Salvar turma <span class="btn-arrow">›</span></button>
    </div>
  </form>
</div>

<div class="popup" id="popupEditar" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title">Editar Turma</h2>
  </div>

  <form class="popup-form" method="post" action="<%= ctx %>/adm/turma/editar">
    <input type="hidden" name="id_turma" id="editIdTurma">

    <label class="field">
      <span>Nome da turma</span>
      <input name="nome" id="editNomeTurma" type="text" required>
    </label>

    <div class="popup-actions">
      <button class="btn-ghost" type="button" data-close-popup>Cancelar</button>
      <button class="btn-primary" type="submit">Salvar alterações <span class="btn-arrow">›</span></button>
    </div>
  </form>
</div>

<div class="popup popup-delete" id="popupExcluir" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title">Excluir Turma</h2>
    <button class="popup-close" type="button" data-close-popup>&times;</button>
  </div>

  <p class="delete-text">
    Tem certeza que deseja excluir a turma <strong id="deleteNomeTurma">—</strong>?
  </p>

  <form method="post" action="<%= ctx %>/adm/turma/excluir">
    <input type="hidden" name="id_turma" id="deleteIdTurma">
    <div class="popup-actions">
      <button class="btn-ghost" type="button" data-close-popup>Cancelar</button>
      <button class="btn-danger" type="submit">Excluir</button>
    </div>
  </form>
</div>

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

<script>
  (function () {
    const overlay = document.getElementById("overlay");
    const popups = document.querySelectorAll(".popup");
    const body = document.body;

    function closeAllPopups() {
      popups.forEach(p => {
        p.classList.remove("is-open");
        p.setAttribute("aria-hidden", "true");
      });
      overlay.classList.remove("is-open");
      body.classList.remove("no-scroll");
    }

    function openPopup(id) {
      const popup = document.getElementById(id);
      if (!popup) return;
      overlay.classList.add("is-open");
      popup.classList.add("is-open");
      popup.setAttribute("aria-hidden", "false");
      body.classList.add("no-scroll");
    }

    window.openPopup = openPopup;
    window.closeAllPopups = closeAllPopups;

    document.querySelectorAll("[data-open-popup]").forEach(btn => {
      btn.addEventListener("click", function () {
        openPopup(this.getAttribute("data-open-popup"));
      });
    });

    document.querySelectorAll("[data-close-popup]").forEach(btn => {
      btn.addEventListener("click", closeAllPopups);
    });

    overlay.addEventListener("click", closeAllPopups);

    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape") closeAllPopups();
    });
  })();
</script>

<script>
  (function () {
    const editButtons = document.querySelectorAll(".btn-editar");
    const editIdTurma = document.getElementById("editIdTurma");
    const editNomeTurma = document.getElementById("editNomeTurma");

    editButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        editIdTurma.value = this.dataset.idTurma || "";
        editNomeTurma.value = this.dataset.nome || "";
      });
    });
  })();
</script>

<script>
  (function () {
    const deleteButtons = document.querySelectorAll(".btn-excluir");
    const deleteIdTurma = document.getElementById("deleteIdTurma");
    const deleteNomeTurma = document.getElementById("deleteNomeTurma");

    deleteButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        deleteIdTurma.value = this.dataset.idTurma || "";
        deleteNomeTurma.textContent = this.dataset.nome || "—";
      });
    });
  })();
</script>

</body>
</html>