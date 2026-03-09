<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.AdmPerfilView" %>

<%
  String ctx = request.getContextPath();

  AdmPerfilView adm = (AdmPerfilView) request.getAttribute("adm");

  @SuppressWarnings("unchecked")
  List<AdmPerfilView> outrosAdms = (List<AdmPerfilView>) request.getAttribute("outrosAdms");
  if (outrosAdms == null) outrosAdms = new ArrayList<>();

  String nome = (adm != null && adm.getNome() != null) ? adm.getNome() : "";
  String login = (adm != null && adm.getLogin() != null) ? adm.getLogin() : "";
  String senha = (adm != null && adm.getSenha() != null) ? adm.getSenha() : "";

  String foto = (adm != null) ? adm.getFoto() : null;

  boolean semFoto = (foto == null)
          || foto.isBlank()
          || "null".equalsIgnoreCase(foto.trim())
          || "[null]".equalsIgnoreCase(foto.trim());

  String fotoSrc = !semFoto
          ? (ctx + "/pages/uploads/" + foto)
          : (ctx + "/pages/aluno/foto_sem_foto.png");

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
  <link rel="stylesheet" href="<%= ctx %>/pages/adm/perfil-adm.css" />
  <title>Perfil ADM - Devant</title>
</head>

<body>
<header class="topbar">
  <div class="topbar-inner">
    <a class="topbar-left" href="<%= ctx %>/adm/perfil" aria-label="Voltar ao início">
      <img class="topbar-logo" src="<%= request.getContextPath() %>/pages/assets/logo.png" alt="Logo Devant">
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a class="topbar-link is-active" href="<%= ctx %>/adm/perfil">Perfil</a>
      <a class="topbar-link" href="<%= ctx %>/adm/turmas">Turmas</a>
      <a class="topbar-link" href="<%= ctx %>/adm/alunos">Alunos</a>
      <a class="topbar-link" href="<%= ctx %>/adm/professores">Professores</a>
      <a class="topbar-link" href="<%= ctx %>/adm/disciplinas">Disciplinas</a>
      <a class="topbar-link" href="<%= ctx %>/adm/observacoes">Observações</a>
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
        <img class="avatar" src="<%= fotoSrc %>" alt="Foto do administrador" />
      </div>

      <div class="profile-info">
        <h2 class="student-name"><%= nome %></h2>

        <div class="info-block">
          <p class="info-label">Login:</p>
          <p class="info-value"><%= login %></p>
        </div>

        <div class="info-block">
          <p class="info-label">Senha:</p>
          <p class="info-value"><%= senha %></p>
        </div>
      </div>
    </div>
  </section>

  <section class="card other-admins-card">
    <div class="card-header">
      <div class="card-header">
        <h1 class="page-title">Outros Administradores</h1>
        <div class="title-line" aria-hidden="true"></div>

        <div class="actions-row">
          <button class="btn-primary" type="button" data-open-popup="popupNovoAdm">
            Adicionar Administrador <span class="btn-arrow">›</span>
          </button>
        </div>
      </div>
    </div>

    <% if ("1".equals(ok)) { %>
    <div class="alert ok">Administrador cadastrado com sucesso.</div>
    <% } %>

    <% if ("1".equals(erro)) { %>
    <div class="alert err">Não foi possível cadastrar o administrador.</div>
    <% } %>

    <div class="table-wrap">
      <table class="table">
        <thead>
        <tr>
          <th class="left">Nome</th>
          <th class="center">Login</th>
          <th class="center">Senha</th>
          <th class="center">Foto</th>
          <th class="right">Ações</th>
        </tr>
        </thead>
        <tbody>
        <%
          for (AdmPerfilView a : outrosAdms) {
            String senhaMask = (a.getSenha() == null || a.getSenha().isBlank()) ? "—" : "******";
            String email = (a.getLogin() == null || a.getLogin().isBlank()) ? "—" : a.getLogin();

            String fotoOutro = a.getFoto();
            boolean semFotoOutro = (fotoOutro == null)
                    || fotoOutro.isBlank()
                    || "null".equalsIgnoreCase(fotoOutro.trim())
                    || "[null]".equalsIgnoreCase(fotoOutro.trim());

            String fotoOutroSrc = !semFotoOutro
                    ? (ctx + "/pages/uploads/" + fotoOutro)
                    : (ctx + "/pages/aluno/foto_sem_foto.png");

            String nomeSafe = a.getNome() == null ? "" : a.getNome().replace("\"", "&quot;");
            String loginSafe = a.getLogin() == null ? "" : a.getLogin().replace("\"", "&quot;");
            String senhaSafe = a.getSenha() == null ? "" : a.getSenha().replace("\"", "&quot;");
            String fotoSafe = fotoOutroSrc.replace("\"", "&quot;");
        %>
        <tr>
          <td><%= a.getNome() %></td>
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
                    data-open-popup="popupEditarAdm"
                    data-id-user="<%= a.getIdUser() %>"
                    data-nome="<%= nomeSafe %>"
                    data-login="<%= loginSafe %>"
                    data-senha="<%= senhaSafe %>"
                    data-foto-src="<%= fotoSafe %>">
              <img src="<%= ctx %>/pages/adm/edit.png" style="width: 20px; height: 20px">
            </button>

            <button
                    class="icon-btn danger btn-excluir"
                    type="button"
                    data-open-popup="popupExcluirAdm"
                    data-id-user="<%= a.getIdUser() %>"
                    data-nome="<%= nomeSafe %>">
              <img src="<%= ctx %>/pages/adm/delete.png" style="width: 17px; height: 20px">
            </button>
          </td>
        </tr>
        <%
          }
          if (outrosAdms.isEmpty()) {
        %>
        <tr>
          <td colspan="5" class="empty">Não há outros administradores cadastrados.</td>
        </tr>
        <%
          }
        %>
        <%
          if (outrosAdms.isEmpty()) {
        %>
        <tr>
          <td colspan="4" class="empty">Não há outros administradores cadastrados.</td>
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

<div class="popup popup-photo" id="popupFoto" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title" id="fotoTitulo">Foto do administrador</h2>
    <button class="popup-close" type="button" data-close-popup>&times;</button>
  </div>

  <div class="photo-wrap">
    <img class="photo-image" id="fotoPopupImg" src="<%= ctx %>/pages/aluno/foto_sem_foto.png" alt="Foto do administrador">
  </div>
</div>

<div class="popup" id="popupNovoAdm" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title">Adicionar Administrador</h2>
    <button class="popup-close" type="button" data-close-popup>&times;</button>
  </div>

  <form class="popup-form" method="post" action="<%= ctx %>/adm/novo" enctype="multipart/form-data">
    <div class="grid-2">
      <label class="field">
        <span>Nome</span>
        <input name="nome" type="text" required>
      </label>

      <label class="field">
        <span>Login</span>
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
      <button class="btn-primary" type="submit">Salvar administrador <span class="btn-arrow">›</span></button>
    </div>
  </form>
</div>

<div class="popup" id="popupEditarAdm" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title">Editar Administrador</h2>
    <button class="popup-close" type="button" data-close-popup>&times;</button>
  </div>

  <form class="popup-form" method="post" action="<%= ctx %>/adm/editar" enctype="multipart/form-data">
    <input type="hidden" name="id_user" id="editIdUser">

    <div class="grid-2">
      <label class="field">
        <span>Nome</span>
        <input name="nome" id="editNome" type="text" required>
      </label>

      <label class="field">
        <span>Login</span>
        <input name="login" id="editLogin" type="email" required>
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

<div class="popup popup-delete" id="popupExcluirAdm" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title">Excluir Administrador</h2>
    <button class="popup-close" type="button" data-close-popup>&times;</button>
  </div>

  <p class="delete-text">
    Tem certeza que deseja excluir o administrador <strong id="deleteNomeAdm">—</strong>?
  </p>

  <form method="post" action="<%= ctx %>/adm/excluir">
    <input type="hidden" name="id_user" id="deleteIdUser">
    <div class="popup-actions">
      <button class="btn-ghost" type="button" data-close-popup>Cancelar</button>
      <button class="btn-danger" type="submit">Excluir</button>
    </div>
  </form>
</div>

<script>
  (function () {
    const editButtons = document.querySelectorAll(".btn-editar");
    const editIdUser = document.getElementById("editIdUser");
    const editNome = document.getElementById("editNome");
    const editLogin = document.getElementById("editLogin");
    const editSenha = document.getElementById("editSenha");

    editButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        editIdUser.value = this.dataset.idUser || "";
        editNome.value = this.dataset.nome || "";
        editLogin.value = this.dataset.login || "";
        editSenha.value = this.dataset.senha || "";
      });
    });
  })();
</script>

<script>
  (function () {
    const deleteButtons = document.querySelectorAll(".btn-excluir");
    const deleteIdUser = document.getElementById("deleteIdUser");
    const deleteNomeAdm = document.getElementById("deleteNomeAdm");

    deleteButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        deleteIdUser.value = this.dataset.idUser || "";
        deleteNomeAdm.textContent = this.dataset.nome || "—";
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
      popup.classList.add("is-open");
      popup.setAttribute("aria-hidden", "false");
      overlay.classList.add("is-open");
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
    document.querySelectorAll(".btn-foto").forEach(btn => {
      btn.addEventListener("click", function () {
        document.getElementById("fotoPopupImg").src = this.dataset.fotoSrc || "";
        document.getElementById("fotoTitulo").textContent = "Foto de " + (this.dataset.nome || "Administrador");
      });
    });
  })();
</script>

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

<script>
  (function () {
    const overlay = document.getElementById("overlay");
    const popup = document.getElementById("popupFoto");
    const body = document.body;

    function closePopup() {
      popup.classList.remove("is-open");
      popup.setAttribute("aria-hidden", "true");
      overlay.classList.remove("is-open");
      body.classList.remove("no-scroll");
    }

    function openPopup() {
      popup.classList.add("is-open");
      popup.setAttribute("aria-hidden", "false");
      overlay.classList.add("is-open");
      body.classList.add("no-scroll");
    }

    document.querySelectorAll(".btn-foto").forEach(btn => {
      btn.addEventListener("click", function () {
        document.getElementById("fotoPopupImg").src = this.dataset.fotoSrc || "";
        document.getElementById("fotoTitulo").textContent = "Foto de " + (this.dataset.nome || "Administrador");
        openPopup();
      });
    });

    document.querySelectorAll("[data-close-popup]").forEach(btn => {
      btn.addEventListener("click", closePopup);
    });

    overlay.addEventListener("click", closePopup);

    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape") closePopup();
    });
  })();
</script>

</body>
</html>