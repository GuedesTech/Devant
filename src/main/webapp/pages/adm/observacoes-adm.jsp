<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.example.secretariaescolar.model.ObservacaoAdmView" %>
<%@ page import="com.example.secretariaescolar.model.Aluno" %>
<%@ page import="com.example.secretariaescolar.model.Disciplina" %>

<%
  String ctx = request.getContextPath();
  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");

  Integer total = (Integer) request.getAttribute("totalObservacoes");
  if (total == null) total = 0;

  @SuppressWarnings("unchecked")
  List<ObservacaoAdmView> observacoes = (List<ObservacaoAdmView>) request.getAttribute("observacoes");
  if (observacoes == null) observacoes = new ArrayList<>();

  @SuppressWarnings("unchecked")
  List<Aluno> alunos = (List<Aluno>) request.getAttribute("alunos");
  if (alunos == null) alunos = new ArrayList<>();

  @SuppressWarnings("unchecked")
  List<Disciplina> disciplinas = (List<Disciplina>) request.getAttribute("disciplinas");
  if (disciplinas == null) disciplinas = new ArrayList<>();

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
  <title>Observações - ADM</title>
</head>

<body>
<header class="topbar">
  <div class="topbar-inner">
    <a class="topbar-left" href="<%= ctx %>/adm/perfil" aria-label="Voltar ao início">
      <img class="topbar-logo" src="<%= ctx %>/pages/assets/logo.png" alt="Logo Devant">
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a class="topbar-link" href="<%= ctx %>/adm/perfil">Perfil</a>
      <a class="topbar-link" href="<%= ctx %>/adm/turmas">Turmas</a>
      <a class="topbar-link" href="<%= ctx %>/adm/alunos">Alunos</a>
      <a class="topbar-link" href="<%= ctx %>/adm/professores">Professores</a>
      <a class="topbar-link" href="<%= ctx %>/adm/disciplinas">Disciplinas</a>
      <a class="topbar-link is-active" href="<%= ctx %>/adm/observacoes">Observações</a>
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
      <h1 class="page-title">Observações</h1>
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
          <span>Total Observações: <strong><%= total %></strong></span>
        </div>

        <button class="btn-primary" type="button" data-open-popup="popupNovo">
          Adicionar Observação <span class="btn-arrow">›</span>
        </button>

        <form class="search" method="get" action="<%= ctx %>/adm/observacoes">
          <input name="q" value="<%= q %>" type="text" placeholder="Pesquisar observação">
          <button type="submit">Buscar</button>
        </form>
      </div>
    </div>

    <div class="table-wrap">
      <table class="table">
        <thead>
        <tr>
          <th class="left">Aluno</th>
          <th class="center">Responsável</th>
          <th class="center">Disciplina</th>
          <th class="center">Data</th>
          <th class="center">Tipo</th>
          <th class="right">Ações</th>
        </tr>
        </thead>
        <tbody>
        <%
          for (ObservacaoAdmView o : observacoes) {
            String alunoSafe = o.getNomeAluno() == null ? "" : o.getNomeAluno().replace("\"", "&quot;");
            String autorSafe = o.getAutor() == null ? "" : o.getAutor().replace("\"", "&quot;");
            String disciplinaSafe = o.getNomeDisciplina() == null ? "" : o.getNomeDisciplina().replace("\"", "&quot;");
            String mensagemSafe = o.getMensagem() == null ? "" : o.getMensagem().replace("\"", "&quot;");
            String dataValue = o.getData() != null ? o.getData().toString() : "";
        %>
        <tr>
          <td><%= o.getNomeAluno() %></td>
          <td class="center"><%= o.getAutor() %></td>
          <td class="center"><%= o.getNomeDisciplina() == null ? "—" : o.getNomeDisciplina() %></td>
          <td class="center"><%= o.getData() != null ? o.getData().format(fmt) : "—" %></td>
          <td class="center">
                        <span class="tipo-badge <%= o.getTipo() == 2 ? "ruim" : "boa" %>">
                            <%= o.getTipoTexto() %>
                        </span>
          </td>
          <td class="right">
            <button
                    class="icon-btn btn-visualizar"
                    type="button"
                    data-open-popup="popupVisualizar"
                    data-mensagem="<%= mensagemSafe %>"
                    data-aluno="<%= alunoSafe %>">
              <img src="<%= ctx %>/pages/adm/vizu.png" style="height: 14px; width: 20px">
            </button>

            <button
                    class="icon-btn btn-editar"
                    type="button"
                    data-open-popup="popupEditar"
                    data-id-observacao="<%= o.getIdObservacao() %>"
                    data-id-aluno="<%= o.getIdAluno() %>"
                    data-id-disciplina="<%= o.getIdDisciplina() == null ? "" : o.getIdDisciplina() %>"
                    data-mensagem="<%= mensagemSafe %>"
                    data-tipo="<%= o.getTipo() %>"
                    data-data="<%= dataValue %>">
              <img src="<%= ctx %>/pages/adm/edit.png" style="width: 20px; height: 20px">
            </button>

            <button
                    class="icon-btn danger btn-excluir"
                    type="button"
                    data-open-popup="popupExcluir"
                    data-id-observacao="<%= o.getIdObservacao() %>"
                    data-aluno="<%= alunoSafe %>">
              <img src="<%= ctx %>/pages/adm/delete.png" style="width: 17px; height: 20px">
            </button>
          </td>
        </tr>
        <%
          }
          if (observacoes.isEmpty()) {
        %>
        <tr>
          <td colspan="6" class="empty">Nenhuma observação encontrada.</td>
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

<div class="popup popup-large" id="popupNovo" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title">Adicionar Observação</h2>
  </div>

  <form class="popup-form" method="post" action="<%= ctx %>/adm/observacao/novo">
    <div class="grid-2">
      <label class="field">
        <span>Aluno</span>
        <select name="id_aluno" required>
          <option value="" disabled selected>Selecione o aluno</option>
          <%
            for (Aluno a : alunos) {
          %>
          <option value="<%= a.getId_aluno() %>"><%= a.getNome() %></option>
          <%
            }
          %>
        </select>
      </label>

      <label class="field">
        <span>Disciplina</span>
        <select name="id_disciplina">
          <option value="">Sem disciplina</option>
          <%
            for (Disciplina d : disciplinas) {
          %>
          <option value="<%= d.getId_disciplina() %>"><%= d.getNome() %></option>
          <%
            }
          %>
        </select>
      </label>

      <label class="field">
        <span>Data</span>
        <input name="data" type="date" required>
      </label>

      <label class="field">
        <span>Tipo</span>
        <select name="tipo" required>
          <option value="1">Boa</option>
          <option value="2">Ruim</option>
        </select>
      </label>
    </div>

    <label class="field field-textarea">
      <span>Mensagem</span>
      <textarea name="mensagem" rows="6" required></textarea>
    </label>

    <div class="popup-actions">
      <button class="btn-ghost" type="button" data-close-popup>Cancelar</button>
      <button class="btn-primary" type="submit">Salvar observação <span class="btn-arrow">›</span></button>
    </div>
  </form>
</div>

<div class="popup popup-large" id="popupEditar" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title">Editar Observação</h2>
  </div>

  <form class="popup-form" method="post" action="<%= ctx %>/adm/observacao/editar">
    <input type="hidden" name="id_observacao" id="editIdObservacao">

    <div class="grid-2">
      <label class="field">
        <span>Aluno</span>
        <select name="id_aluno" id="editIdAluno" required>
          <option value="" disabled>Selecione o aluno</option>
          <%
            for (Aluno a : alunos) {
          %>
          <option value="<%= a.getId_aluno() %>"><%= a.getNome() %></option>
          <%
            }
          %>
        </select>
      </label>

      <label class="field">
        <span>Disciplina</span>
        <select name="id_disciplina" id="editIdDisciplina">
          <option value="">Sem disciplina</option>
          <%
            for (Disciplina d : disciplinas) {
          %>
          <option value="<%= d.getId_disciplina() %>"><%= d.getNome() %></option>
          <%
            }
          %>
        </select>
      </label>

      <label class="field">
        <span>Data</span>
        <input name="data" id="editData" type="date" required>
      </label>

      <label class="field">
        <span>Tipo</span>
        <select name="tipo" id="editTipo" required>
          <option value="1">Boa</option>
          <option value="2">Ruim</option>
        </select>
      </label>
    </div>

    <label class="field field-textarea">
      <span>Mensagem</span>
      <textarea name="mensagem" id="editMensagem" rows="6" required></textarea>
    </label>

    <div class="popup-actions">
      <button class="btn-ghost" type="button" data-close-popup>Cancelar</button>
      <button class="btn-primary" type="submit">Salvar alterações <span class="btn-arrow">›</span></button>
    </div>
  </form>
</div>

<div class="popup popup-large" id="popupVisualizar" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title" id="viewTitulo">Mensagem da Observação</h2>
    <button class="popup-close" type="button" data-close-popup>&times;</button>
  </div>

  <div class="mensagem-view" id="viewMensagem"></div>
</div>

<div class="popup popup-delete" id="popupExcluir" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title">Excluir Observação</h2>
    <button class="popup-close" type="button" data-close-popup>&times;</button>
  </div>

  <p class="delete-text">
    Tem certeza que deseja excluir a observação de <strong id="deleteAlunoObs">—</strong>?
  </p>

  <form method="post" action="<%= ctx %>/adm/observacao/excluir">
    <input type="hidden" name="id_observacao" id="deleteIdObservacao">
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
    const viewButtons = document.querySelectorAll(".btn-visualizar");
    const viewTitulo = document.getElementById("viewTitulo");
    const viewMensagem = document.getElementById("viewMensagem");

    viewButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        viewTitulo.textContent = "Mensagem da observação - " + (this.dataset.aluno || "Aluno");
        viewMensagem.textContent = this.dataset.mensagem || "—";
      });
    });
  })();
</script>

<script>
  (function () {
    const editButtons = document.querySelectorAll(".btn-editar");

    const editIdObservacao = document.getElementById("editIdObservacao");
    const editIdAluno = document.getElementById("editIdAluno");
    const editIdDisciplina = document.getElementById("editIdDisciplina");
    const editMensagem = document.getElementById("editMensagem");
    const editTipo = document.getElementById("editTipo");
    const editData = document.getElementById("editData");

    editButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        editIdObservacao.value = this.dataset.idObservacao || "";
        editIdAluno.value = this.dataset.idAluno || "";
        editIdDisciplina.value = this.dataset.idDisciplina || "";
        editMensagem.value = this.dataset.mensagem || "";
        editTipo.value = this.dataset.tipo || "1";
        editData.value = this.dataset.data || "";
      });
    });
  })();
</script>

<script>
  (function () {
    const deleteButtons = document.querySelectorAll(".btn-excluir");
    const deleteIdObservacao = document.getElementById("deleteIdObservacao");
    const deleteAlunoObs = document.getElementById("deleteAlunoObs");

    deleteButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        deleteIdObservacao.value = this.dataset.idObservacao || "";
        deleteAlunoObs.textContent = this.dataset.aluno || "—";
      });
    });
  })();
</script>

</body>
</html>