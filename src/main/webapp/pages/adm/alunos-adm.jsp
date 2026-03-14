<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.AlunoAdmView" %>
<%@ page import="com.example.secretariaescolar.model.Turma" %>
<%@ page import="com.example.secretariaescolar.model.Disciplina" %>
<%@ page import="com.example.secretariaescolar.dto.NotasAlunoDTO" %>

<%
    String ctx = request.getContextPath();

    Integer total = (Integer) request.getAttribute("totalAlunos");
    if (total == null) total = 0;

    @SuppressWarnings("unchecked")
    List<AlunoAdmView> alunos = (List<AlunoAdmView>) request.getAttribute("alunos");
    if (alunos == null) alunos = new ArrayList<>();

    String q = (String) request.getAttribute("q");
    if (q == null) q = "";

    @SuppressWarnings("unchecked")
    List<Turma> turmas = (List<Turma>) request.getAttribute("turmas");
    if (turmas == null) turmas = new ArrayList<>();

    @SuppressWarnings("unchecked")
    List<Disciplina> disciplinas = (List<Disciplina>) request.getAttribute("disciplinas");
    if (disciplinas == null) disciplinas = new ArrayList<>();

    @SuppressWarnings("unchecked")
    Map<String, NotasAlunoDTO> notasMap = (Map<String, NotasAlunoDTO>) request.getAttribute("notasMap");
    if (notasMap == null) notasMap = new HashMap<>();

    String erro = (String) request.getAttribute("erro");
    if (erro == null) erro = "";

    String ok = request.getParameter("ok");
    String erroParam = request.getParameter("erro");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/pages/login/minimalismo.png">
    <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
    <link rel="stylesheet" href="<%= ctx %>/pages/adm/alunos-adm.css" />
    <title>Alunos - ADM</title>
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
            <a class="topbar-link is-active" href="<%= ctx %>/adm/alunos">Alunos</a>
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
    <section class="card adm-card">
        <div class="card-header">
            <h1 class="page-title">Alunos</h1>
            <div class="title-line" aria-hidden="true"></div>

            <% if (!erro.isBlank()) { %>
            <div class="alert err"><%= erro %></div>
            <% } %>

            <% if ("1".equals(ok)) { %>
            <div class="alert ok">Operação realizada com sucesso.</div>
            <% } %>

            <% if ("nota_salva".equals(ok)) { %>
            <div class="alert ok">Notas salvas com sucesso.</div>
            <% } %>

            <% if ("sem_prof".equals(erroParam)) { %>
            <div class="alert err">Essa disciplina não tem professor vinculado. Não foi possível salvar por causa do FK.</div>
            <% } %>

            <div class="actions-row">
                <div class="chip">
                    <img src="<%= ctx %>/pages/professor/pessoas.png" style="height: 17.5px; width: 24px" alt="">
                    <span>Total Alunos: <strong><%= total %></strong></span>
                </div>

                <button class="btn-primary" type="button" data-open-popup="popupNovo">
                    Adicionar Aluno <span class="btn-arrow">›</span>
                </button>

                <form class="search" method="get" action="<%= ctx %>/adm/alunos">
                    <input name="q" value="<%= q %>" type="text" placeholder="Pesquisar aluno">
                    <button type="submit">Buscar</button>
                </form>
            </div>
        </div>

        <div class="table-wrap">
            <table class="table">
                <thead>
                <tr>
                    <th class="left">Nome</th>
                    <th class="center">Matrícula</th>
                    <th class="center">Turma</th>
                    <th class="center">E-mail</th>
                    <th class="center">Senha</th>
                    <th class="center">Desempenho</th>
                    <th class="center">Foto</th>
                    <th class="right">Ações</th>
                </tr>
                </thead>
                <tbody>
                <%
                    for (AlunoAdmView a : alunos) {
                        String senhaMask = (a.getSenha() == null || a.getSenha().isBlank()) ? "—" : "******";
                        String email = (a.getLogin() == null || a.getLogin().isBlank()) ? "—" : a.getLogin();

                        String foto = a.getFoto();
                        boolean semFoto = (foto == null) || foto.isBlank()
                                || "null".equalsIgnoreCase(foto.trim())
                                || "[null]".equalsIgnoreCase(foto.trim());

                        String fotoSrc = !semFoto ? (ctx + "/pages/uploads/" + foto) : (ctx + "/pages/aluno/foto_sem_foto.png");

                        String nomeSafe = a.getNome() == null ? "" : a.getNome().replace("\"", "&quot;");
                        String matriculaSafe = a.getMatricula() == null ? "" : a.getMatricula().replace("\"", "&quot;");
                        String turmaNomeSafe = a.getNomeTurma() == null ? "" : a.getNomeTurma().replace("\"", "&quot;");
                        String loginSafe = a.getLogin() == null ? "" : a.getLogin().replace("\"", "&quot;");
                        String senhaSafe = a.getSenha() == null ? "" : a.getSenha().replace("\"", "&quot;");
                        String fotoSafe = fotoSrc.replace("\"", "&quot;");
                %>
                <tr>
                    <td><%= a.getNome() %></td>
                    <td class="center"><%= a.getMatricula() %></td>
                    <td class="center"><%= a.getNomeTurma() %></td>
                    <td class="center"><%= email %></td>
                    <td class="center"><%= senhaMask %></td>

                    <td class="center">
                        <button
                                class="btn-small btn-desempenho"
                                type="button"
                                data-open-popup="popupDesempenho"
                                data-id-aluno="<%= a.getIdAluno() %>"
                                data-nome="<%= nomeSafe %>">
                            Ver desempenho
                        </button>
                    </td>

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
                                data-id-aluno="<%= a.getIdAluno() %>"
                                data-id-turma="<%= a.getIdTurma() %>"
                                data-nome="<%= nomeSafe %>"
                                data-matricula="<%= matriculaSafe %>"
                                data-turma-nome="<%= turmaNomeSafe %>"
                                data-login="<%= loginSafe %>"
                                data-senha="<%= senhaSafe %>"
                                data-foto-src="<%= fotoSafe %>">
                            <img src="<%= ctx %>/pages/adm/edit.png" style="width: 20px; height: 20px">
                        </button>

                        <button
                                class="icon-btn danger btn-excluir"
                                type="button"
                                data-open-popup="popupExcluir"
                                data-id-aluno="<%= a.getIdAluno() %>"
                                data-nome="<%= nomeSafe %>">
                            <img src="<%= ctx %>/pages/adm/delete.png" style="width: 17px; height: 20px">
                        </button>
                    </td>
                </tr>
                <%
                    }
                    if (alunos.isEmpty()) {
                %>
                <tr>
                    <td colspan="8" class="empty">Nenhum aluno encontrado.</td>
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

<!-- POPUP NOVO -->
<div class="popup" id="popupNovo" aria-hidden="true">
    <div class="popup-head">
        <h2 class="popup-title">Adicionar Aluno</h2>
    </div>

    <form class="popup-form" method="post" action="<%= ctx %>/adm/aluno/novo" enctype="multipart/form-data">
        <div class="grid-2">
            <label class="field">
                <span>Nome</span>
                <input name="nome" type="text" required placeholder="Ex: Diogo Martins">
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
                <span>Foto</span>
                <input name="foto" type="file" accept="image/*">
            </label>
        </div>

        <div class="popup-actions">
            <button class="btn-ghost" type="button" data-close-popup>Cancelar</button>
            <button class="btn-primary" type="submit">Salvar aluno <span class="btn-arrow">›</span></button>
        </div>
    </form>
</div>

<!-- POPUP EDITAR -->
<div class="popup popup-large" id="popupEditar" aria-hidden="true">
    <div class="popup-head">
        <h2 class="popup-title">Editar Aluno</h2>
    </div>

    <div class="profile-row">
        <img class="avatar" id="editFotoPreview" src="<%= ctx %>/pages/aluno/foto_sem_foto.png" alt="Foto do aluno">
        <div class="profile-meta">
            <div class="profile-name" id="editNomeTitulo">Aluno</div>
        </div>

        <button class="btn-small" type="button" data-open-popup-from="popupEditar" data-target-popup="popupDesempenho" id="btnIrDesempenho">
            Ver Desempenho
        </button>
    </div>

    <form class="popup-form" method="post" action="<%= ctx %>/adm/aluno/editar" enctype="multipart/form-data">
        <input type="hidden" name="id_aluno" id="editIdAluno" value="">

        <div class="grid-2">
            <label class="field">
                <span>Nome</span>
                <input name="nome" id="editNome" type="text" required>
            </label>

            <label class="field">
                <span>Matrícula</span>
                <input name="matricula" id="editMatricula" type="text" required>
            </label>

            <label class="field">
                <span>Turma</span>
                <select name="id_turma" id="editTurma" required>
                    <option value="">Selecione a turma</option>
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
                <span>E-mail</span>
                <input name="login" id="editLogin" type="text" placeholder="ex: aluno@devant.org.br">
            </label>

            <label class="field">
                <span>Senha</span>
                <input name="senha" id="editSenha" type="text" placeholder="Defina uma senha">
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

<!-- POPUP DESEMPENHO -->
<div class="popup popup-large" id="popupDesempenho" aria-hidden="true">
    <div class="popup-head">
        <h2 class="popup-title">Desempenho do Aluno</h2>
    </div>

    <div class="chip chip-popup">
        <span id="perfNomeAluno">Aluno</span>
    </div>

    <form class="popup-form" method="post" action="<%= ctx %>/adm/aluno/desempenho">
        <input type="hidden" name="id_aluno" id="perfIdAluno" value="">
        <input type="hidden" name="id_disciplina" id="perfIdDisciplinaHidden" value="">

        <div class="grid-3">
            <label class="field">
                <span>Disciplina</span>
                <select id="perfDisciplinaSelect" required>
                    <option value="">Selecione</option>
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
                <span>Nota 1</span>
                <input name="n1" id="perfN1" type="number" step="0.1" min="0" max="10" value="0.0" required>
            </label>

            <label class="field">
                <span>Nota 2</span>
                <input name="n2" id="perfN2" type="number" step="0.1" min="0" max="10" value="0.0" required>
            </label>
        </div>

        <div class="field readonly-field perf-media-field">
            <span>Média</span>
            <div class="readonly-box" id="perfMedia">0.0</div>
        </div>

        <div class="popup-actions">
            <button class="btn-ghost" type="button" data-close-popup>Cancelar</button>
            <button class="btn-primary" type="submit">Salvar notas <span class="btn-arrow">›</span></button>
        </div>
    </form>
</div>

<!-- POPUP FOTO -->
<div class="popup popup-photo" id="popupFoto" aria-hidden="true">
    <div class="popup-head">
        <h2 class="popup-title" id="fotoTitulo">Foto do aluno</h2>
        <button class="popup-close" type="button" data-close-popup>&times;</button>
    </div>

    <div class="photo-wrap">
        <img class="photo-image" id="fotoPopupImg" src="<%= ctx %>/pages/aluno/foto_sem_foto.png" alt="Foto do aluno">
    </div>
</div>

<!-- POPUP EXCLUIR -->
<div class="popup popup-delete" id="popupExcluir" aria-hidden="true">
    <div class="popup-head">
        <h2 class="popup-title">Excluir Aluno</h2>
        <button class="popup-close" type="button" data-close-popup>&times;</button>
    </div>

    <p class="delete-text">
        Tem certeza que deseja excluir o aluno <strong id="deleteNomeAluno">—</strong>?
    </p>

    <form method="post" action="<%= ctx %>/adm/aluno/excluir">
        <input type="hidden" name="id_aluno" id="deleteIdAluno" value="">
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
  const notasMap = {
    <%
    boolean firstNota = true;
    for (Map.Entry<String, NotasAlunoDTO> entry : notasMap.entrySet()) {

        String key = entry.getKey();
        NotasAlunoDTO dto = entry.getValue();

        double n1 = dto != null ? dto.getN1() : 0.0;
        double n2 = dto != null ? dto.getN2() : 0.0;
        double media = dto != null ? dto.getMedia() : ((n1 + n2) / 2.0);

        if (!firstNota) {
%>,<%
    }
%>
      "<%= key %>": {
        n1: <%= String.format(java.util.Locale.US, "%.1f", n1) %>,
        n2: <%= String.format(java.util.Locale.US, "%.1f", n2) %>,
        media: <%= String.format(java.util.Locale.US, "%.1f", media) %>
      }
    <%
        firstNota = false;
    }
%>
  };
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
        const popupId = this.getAttribute("data-open-popup");
        openPopup(popupId);
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
    const editIdAluno = document.getElementById("editIdAluno");
    const editNome = document.getElementById("editNome");
    const editMatricula = document.getElementById("editMatricula");
    const editTurma = document.getElementById("editTurma");
    const editLogin = document.getElementById("editLogin");
    const editSenha = document.getElementById("editSenha");
    const editNomeTitulo = document.getElementById("editNomeTitulo");
    const editFotoPreview = document.getElementById("editFotoPreview");
    const btnIrDesempenho = document.getElementById("btnIrDesempenho");

    editButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        const idAluno = this.dataset.idAluno || "";
        const idTurma = this.dataset.idTurma || "";
        const nome = this.dataset.nome || "";
        const matricula = this.dataset.matricula || "";
        const login = this.dataset.login || "";
        const senha = this.dataset.senha || "";
        const fotoSrc = this.dataset.fotoSrc || "";

        editIdAluno.value = idAluno;
        editNome.value = nome;
        editMatricula.value = matricula;
        editTurma.value = idTurma;
        editLogin.value = login;
        editSenha.value = senha;
        editNomeTitulo.textContent = nome || "Aluno";
        editFotoPreview.src = fotoSrc || "<%= ctx %>/pages/aluno/foto_sem_foto.png";

        btnIrDesempenho.dataset.idAluno = idAluno;
        btnIrDesempenho.dataset.nome = nome;
      });
    });

    btnIrDesempenho.addEventListener("click", function () {
  const idAluno = this.dataset.idAluno || "";
  const nome = this.dataset.nome || "";

  closeAllPopups();

  document.getElementById("perfIdAluno").value = idAluno;
  document.getElementById("perfNomeAluno").textContent = nome || "Aluno";

  const perfDisciplinaSelect = document.getElementById("perfDisciplinaSelect");
  const perfIdDisciplinaHidden = document.getElementById("perfIdDisciplinaHidden");
  const perfN1 = document.getElementById("perfN1");
  const perfN2 = document.getElementById("perfN2");
  const perfMedia = document.getElementById("perfMedia");

  function limparNotas() {
    perfDisciplinaSelect.value = "";
    perfIdDisciplinaHidden.value = "";
    perfN1.value = "0.0";
    perfN2.value = "0.0";
    perfMedia.textContent = "0.0";
  }

  const options = Array.from(perfDisciplinaSelect.options)
    .filter(opt => opt.value && notasMap[idAluno + "_" + opt.value]);

  if (options.length > 0) {
    perfDisciplinaSelect.value = options[0].value;
    perfIdDisciplinaHidden.value = options[0].value;

    const nota = notasMap[idAluno + "_" + options[0].value];
    perfN1.value = Number(nota.n1).toFixed(1);
    perfN2.value = Number(nota.n2).toFixed(1);
    perfMedia.textContent = Number(nota.media).toFixed(1);
  } else {
    limparNotas();
  }

  openPopup("popupDesempenho");
});
  })();
</script>

<script>
  (function () {
    const buttons = document.querySelectorAll(".btn-desempenho");
    const perfIdAluno = document.getElementById("perfIdAluno");
    const perfNomeAluno = document.getElementById("perfNomeAluno");
    const perfDisciplinaSelect = document.getElementById("perfDisciplinaSelect");
    const perfIdDisciplinaHidden = document.getElementById("perfIdDisciplinaHidden");
    const perfN1 = document.getElementById("perfN1");
    const perfN2 = document.getElementById("perfN2");
    const perfMedia = document.getElementById("perfMedia");

    function atualizarMedia() {
      const n1 = parseFloat(perfN1.value || "0") || 0;
      const n2 = parseFloat(perfN2.value || "0") || 0;
      const media = (n1 + n2) / 2;
      perfMedia.textContent = media.toFixed(1);
    }

    function limparNotas() {
      perfN1.value = "0.0";
      perfN2.value = "0.0";
      perfMedia.textContent = "0.0";
    }

    function carregarNotas() {
      const idAluno = perfIdAluno.value;
      const idDisc = perfDisciplinaSelect.value;

      perfIdDisciplinaHidden.value = idDisc;

      if (!idAluno || !idDisc) {
        limparNotas();
        return;
      }

      const chave = idAluno + "_" + idDisc;
      const nota = notasMap[chave];

      if (nota) {
        perfN1.value = Number(nota.n1).toFixed(1);
        perfN2.value = Number(nota.n2).toFixed(1);
        perfMedia.textContent = Number(nota.media).toFixed(1);
      } else {
        limparNotas();
      }
    }

    function selecionarPrimeiraDisciplinaComNota(idAluno) {
      const options = Array.from(perfDisciplinaSelect.options)
        .filter(opt => opt.value && notasMap[idAluno + "_" + opt.value]);

      if (options.length > 0) {
        perfDisciplinaSelect.value = options[0].value;
        carregarNotas();
      } else {
        perfDisciplinaSelect.value = "";
        perfIdDisciplinaHidden.value = "";
        limparNotas();
      }
    }

    buttons.forEach(btn => {
      btn.addEventListener("click", function () {
        const idAluno = this.dataset.idAluno || "";
        const nome = this.dataset.nome || "";

        perfIdAluno.value = idAluno;
        perfNomeAluno.textContent = nome || "Aluno";

        selecionarPrimeiraDisciplinaComNota(idAluno);
      });
    });

    perfDisciplinaSelect.addEventListener("change", carregarNotas);
    perfN1.addEventListener("input", atualizarMedia);
    perfN2.addEventListener("input", atualizarMedia);
  })();
</script>

<script>
  (function () {
    const photoButtons = document.querySelectorAll(".btn-foto");
    const fotoPopupImg = document.getElementById("fotoPopupImg");
    const fotoTitulo = document.getElementById("fotoTitulo");

    photoButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        const src = this.dataset.fotoSrc || "";
        const nome = this.dataset.nome || "Aluno";

        fotoPopupImg.src = src;
        fotoTitulo.textContent = "Foto de " + nome;
      });
    });
  })();
</script>

<script>
  (function () {
    const deleteButtons = document.querySelectorAll(".btn-excluir");
    const deleteIdAluno = document.getElementById("deleteIdAluno");
    const deleteNomeAluno = document.getElementById("deleteNomeAluno");

    deleteButtons.forEach(btn => {
      btn.addEventListener("click", function () {
        deleteIdAluno.value = this.dataset.idAluno || "";
        deleteNomeAluno.textContent = this.dataset.nome || "—";
      });
    });
  })();
</script>

</body>
</html>