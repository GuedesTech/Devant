<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.ProfessorAdmView" %>
<%@ page import="com.example.secretariaescolar.model.Disciplina" %>

<%
    String ctx = request.getContextPath();

    Integer total = (Integer) request.getAttribute("totalProfessores");
    if (total == null) total = 0;

    @SuppressWarnings("unchecked")
    List<ProfessorAdmView> professores = (List<ProfessorAdmView>) request.getAttribute("professores");
    if (professores == null) professores = new ArrayList<>();

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
    <title>Professores - ADM</title>
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
            <a class="topbar-link is-active" href="<%= ctx %>/adm/professores">Professores</a>
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
            <h1 class="page-title">Professores</h1>
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
                    <span>Total Professores: <strong><%= total %></strong></span>
                </div>

                <button class="btn-primary" type="button" data-open-popup="popupNovo">
                    Adicionar Professor <span class="btn-arrow">›</span>
                </button>

                <form class="search" method="get" action="<%= ctx %>/adm/professores">
                    <input name="q" value="<%= q %>" type="text" placeholder="Pesquisar professor">
                    <button type="submit">Buscar</button>
                </form>
            </div>
        </div>

        <div class="table-wrap">
            <table class="table">
                <thead>
                <tr>
                    <th class="left">Nome</th>
                    <th class="center">Disciplina</th>
                    <th class="center">Login</th>
                    <th class="center">Senha</th>
                    <th class="center">Foto</th>
                    <th class="right">Ações</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (ProfessorAdmView p : professores) {
                        String email = (p.getLogin() == null || p.getLogin().isBlank()) ? "—" : p.getLogin();
                        String senhaMask = (p.getSenha() == null || p.getSenha().isBlank()) ? "—" : "******";

                        String foto = p.getFoto();
                        boolean semFoto = (foto == null) || foto.isBlank()
                                || "null".equalsIgnoreCase(foto.trim())
                                || "[null]".equalsIgnoreCase(foto.trim());

                        String fotoSrc = !semFoto ? (ctx + "/pages/uploads/" + foto) : (ctx + "/pages/aluno/foto_sem_foto.png");

                        String nomeSafe = p.getNome() == null ? "" : p.getNome().replace("\"", "&quot;");
                        String loginSafe = p.getLogin() == null ? "" : p.getLogin().replace("\"", "&quot;");
                        String senhaSafe = p.getSenha() == null ? "" : p.getSenha().replace("\"", "&quot;");
                        String fotoSafe = fotoSrc.replace("\"", "&quot;");
                %>
                <tr>
                    <td><%= p.getNome() %></td>
                    <td class="center"><%= p.getNomeDisciplina() %></td>
                    <td class="center"><%= email %></td>
                    <td class="center"><%= senhaMask %></td>

                    <td class="center">
                        <button
                                class="btn-small btn-foto"
                                type="button"
                                data-open-popup="popupFoto"
                                data-foto-src="<%= fotoSafe %>"
                                data-nome="<%= nomeSafe %>">
                            Ver foto
                        </button>
                    </td>

                    <td class="right">
                        <button
                                class="icon-btn btn-editar"
                                type="button"
                                data-open-popup="popupEditar"
                                data-id-professor="<%= p.getIdProfessor() %>"
                                data-id-disciplina="<%= p.getIdDisciplina() %>"
                                data-nome="<%= nomeSafe %>"
                                data-login="<%= loginSafe %>"
                                data-senha="<%= senhaSafe %>"
                                data-foto-src="<%= fotoSafe %>">
                            <img src="<%= ctx %>/pages/adm/edit.png" style="width: 20px; height: 20px">
                        </button>

                        <button
                                class="icon-btn danger btn-excluir"
                                type="button"
                                data-open-popup="popupExcluir"
                                data-id-professor="<%= p.getIdProfessor() %>"
                                data-nome="<%= nomeSafe %>">
                            <img src="<%= ctx %>/pages/adm/delete.png" style="width: 17px; height: 20px">
                        </button>
                    </td>
                </tr>
                <%
                    }
                    if (professores.isEmpty()) {
                %>
                <tr>
                    <td colspan="6" class="empty">Nenhum professor encontrado.</td>
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
        <h2 class="popup-title">Adicionar Professor</h2>
    </div>

    <form class="popup-form" method="post" action="<%= ctx %>/adm/professor/novo" enctype="multipart/form-data">
        <div class="grid-2">
            <label class="field">
                <span>Nome</span>
                <input name="nome" type="text" required>
            </label>

            <label class="field">
                <span>Disciplina</span>
                <select name="id_disciplina" required>
                    <option value="" disabled selected>Selecione a disciplina</option>
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
                <span>E-mail</span>
                <input name="login" type="text" required>
            </label>

            <label class="field">
                <span>Senha</span>
                <input name="senha" type="text" required>
            </label>

            <label class="field">
                <span>Foto</span>
                <input name="foto" type="file" accept="image/*">
            </label>
        </div>

        <div class="popup-actions">
            <button class="btn-ghost" type="button" data-close-popup>Cancelar</button>
            <button class="btn-primary" type="submit">Salvar professor <span class="btn-arrow">›</span></button>
        </div>
    </form>
</div>

<div class="popup popup-large" id="popupEditar" aria-hidden="true">
    <div class="popup-head">
        <h2 class="popup-title">Editar Professor</h2>
    </div>

    <div class="profile-row">
        <img class="avatar" id="editFotoPreview" src="<%= ctx %>/pages/aluno/foto_sem_foto.png" alt="Foto do professor">
        <div class="profile-meta">
            <div class="profile-name" id="editNomeTitulo">Professor</div>
        </div>
    </div>

    <form class="popup-form" method="post" action="<%= ctx %>/adm/professor/editar" enctype="multipart/form-data">
        <input type="hidden" name="id_professor" id="editIdProfessor">

        <div class="grid-2">
            <label class="field">
                <span>Nome</span>
                <input name="nome" id="editNome" type="text" required>
            </label>

            <label class="field">
                <span>Disciplina</span>
                <select name="id_disciplina" id="editDisciplina" required>
                    <option value="">Selecione a disciplina</option>
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
                <span>Login</span>
                <input name="login" id="editLogin" type="text" required>
            </label>

            <label class="field">
                <span>Senha</span>
                <input name="senha" id="editSenha" type="text" required>
            </label>

            <label class="field">
                <span>Foto</span>
                <input name="foto" type="file" accept="image/*">
            </label>
        </div>

        <div class="popup-actions">
            <button class="btn-ghost" type="button" data-close-popup>Cancelar</button>
            <button class="btn-primary" type="submit">Salvar alterações <span class="btn-arrow">›</span></button>
        </div>
    </form>
</div>

<div class="popup popup-photo" id="popupFoto" aria-hidden="true">
    <div class="popup-head">
        <h2 class="popup-title" id="fotoTitulo">Foto do professor</h2>
        <button class="popup-close" type="button" data-close-popup>&times;</button>
    </div>

    <div class="photo-wrap">
        <img class="photo-image" id="fotoPopupImg" src="<%= ctx %>/pages/aluno/foto_sem_foto.png" alt="Foto do professor">
    </div>
</div>

<div class="popup popup-delete" id="popupExcluir" aria-hidden="true">
    <div class="popup-head">
        <h2 class="popup-title">Excluir Professor</h2>
        <button class="popup-close" type="button" data-close-popup>&times;</button>
    </div>

    <p class="delete-text">
        Tem certeza que deseja excluir o professor <strong id="deleteNomeProfessor">—</strong>?
    </p>

    <form method="post" action="<%= ctx %>/adm/professor/excluir">
        <input type="hidden" name="id_professor" id="deleteIdProfessor">
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
    const editIdProfessor = document.getElementById("editIdProfessor");
    const editNome = document.getElementById("editNome");
    const editDisciplina = document.getElementById("editDisciplina");
    const editLogin = document.getElementById("editLogin");
    const editSenha = document.getElementById("editSenha");
    const editFotoPreview = document.getElementById("editFotoPreview");
    const editNomeTitulo = document.getElementById("editNomeTitulo");

    editButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        editIdProfessor.value = this.dataset.idProfessor || "";
        editNome.value = this.dataset.nome || "";
        editDisciplina.value = this.dataset.idDisciplina || "";
        editLogin.value = this.dataset.login || "";
        editSenha.value = this.dataset.senha || "";
        editFotoPreview.src = this.dataset.fotoSrc || "<%= ctx %>/pages/aluno/foto_sem_foto.png";
        editNomeTitulo.textContent = this.dataset.nome || "Professor";
      });
    });
  })();
</script>

<script>
  (function () {
    const photoButtons = document.querySelectorAll(".btn-foto");
    const fotoPopupImg = document.getElementById("fotoPopupImg");
    const fotoTitulo = document.getElementById("fotoTitulo");

    photoButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        fotoPopupImg.src = this.dataset.fotoSrc || "";
        fotoTitulo.textContent = "Foto de " + (this.dataset.nome || "Professor");
      });
    });
  })();
</script>

<script>
  (function () {
    const deleteButtons = document.querySelectorAll(".btn-excluir");
    const deleteIdProfessor = document.getElementById("deleteIdProfessor");
    const deleteNomeProfessor = document.getElementById("deleteNomeProfessor");

    deleteButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        deleteIdProfessor.value = this.dataset.idProfessor || "";
        deleteNomeProfessor.textContent = this.dataset.nome || "—";
      });
    });
  })();
</script>

</body>
</html>