<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@ page
        import="java.util.*" %> <%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.example.secretariaescolar.model.Aluno" %> <%@ page
        import="com.example.secretariaescolar.model.Disciplina" %> <%@ page
        import="com.example.secretariaescolar.model.Observacao" %> <% String ctx =
        request.getContextPath(); Aluno aluno = (Aluno) request.getAttribute("aluno");
  Disciplina disciplinaAtual = (Disciplina)
          request.getAttribute("disciplinaAtual"); List<Observacao>
          observacoes = (List<Observacao
          >) request.getAttribute("observacoes"); Integer totalObs = (Integer)
          request.getAttribute("totalObs"); Integer totalElogios = (Integer)
          request.getAttribute("totalElogios"); Integer totalPdm = (Integer)
          request.getAttribute("totalPdm"); String ok = (String)
          request.getAttribute("ok"); String okEdicao = (String)
          request.getAttribute("okEdicao"); String erro = (String)
          request.getAttribute("erro"); if (observacoes == null) observacoes = new
          ArrayList<>(); if (totalObs == null) totalObs = 0; if (totalElogios == null)
    totalElogios = 0; if (totalPdm == null) totalPdm = 0; DateTimeFormatter fmt
          = DateTimeFormatter.ofPattern("dd/MM"); String fotoAluno = null; if (aluno
          != null) { fotoAluno = aluno.getFoto(); } boolean semFotoAluno = (fotoAluno
          == null) || fotoAluno.isBlank() || "null".equalsIgnoreCase(fotoAluno.trim())
          || "[null]".equalsIgnoreCase(fotoAluno.trim()); String fotoAlunoSrc =
          !semFotoAluno ? (ctx + "/pages/uploads/" + fotoAluno) : (ctx +
                  "/pages/aluno/foto_sem_foto.png"); %>

<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Observações do Aluno</title>

  <link
          rel="icon"
          type="image/png"
          href="<%= ctx %>/pages/assets/logo-dark.png"
  />
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <link
          rel="stylesheet"
          href="<%= ctx %>/pages/professor/aluno-observacoes.css"
  />
</head>
<body>
<header class="topbar">
  <div class="topbar-inner">
    <a
            class="topbar-left"
            href="<%= ctx %>/professor/turmas"
            aria-label="Voltar ao início"
    >
      <img
              class="topbar-logo"
              src="<%= ctx %>/pages/assets/logo.png"
              alt="Logo Devant"
      />
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a
              class="topbar-link is-active"
              href="<%= ctx %>/professor/turmas"
      >Turmas</a
      >
      <a class="topbar-link" href="<%= ctx %>/professor/disciplinas"
      >Disciplinas</a
      >
      <a class="topbar-link" href="<%= ctx %>/professor/perfil"
      >Perfil</a
      >
      <span class="nav-indicador" aria-hidden="true"></span>
    </nav>

    <div class="topbar-right"></div>
  </div>
</header>

<main class="page">
  <section class="card aluno-card">
    <div class="card-header">
      <div class="page-title-row">
        <button
                class="back-btn"
                type="button"
                onclick="window.location.href='<%= ctx %>/professor/aluno/analise?id_aluno=<%= aluno != null ? aluno.getId_aluno() : 0 %>'"
                aria-label="Voltar"
        >
          ←
        </button>

        <div class="aluno-header">
          <div class="avatar-wrap-small">
            <img
                    class="avatar-small"
                    src="<%= fotoAlunoSrc %>"
                    alt="Foto do aluno"
            />
          </div>

          <h1 class="page-title" style="margin: 0">
            Histórico de Observações de <%= (aluno != null ?
                  aluno.getNome() : "Aluno") %>
          </h1>
        </div>
      </div>

      <div class="title-line" aria-hidden="true"></div>

      <% if (ok != null) { %>
      <div class="feedback ok">Observação adicionada com sucesso.</div>
      <% } %> <% if (okEdicao != null) { %>
      <div class="feedback ok">Observação editada com sucesso.</div>
      <% } %> <% if (erro != null && !erro.isBlank()) { %>
      <div class="feedback erro"><%= erro %></div>
      <% } %>

      <div class="toolbar-row">
        <div class="disciplina-wrap">
          <label class="disciplina-label">Disciplina:</label>
          <select class="disciplina-select" disabled>
            <option>
              <%= disciplinaAtual != null ? disciplinaAtual.getNome() :
                      "Disciplina" %>
            </option>
          </select>
        </div>

        <% if (aluno != null) { %>
        <a
                class="btn-primary"
                href="<%= ctx %>/professor/aluno/analise?id_aluno=<%= aluno.getId_aluno() %>"
        >
          Ver notas <span class="btn-arrow">›</span>
        </a>
        <% } %>
      </div>
    </div>

    <div class="kpi-grid">
      <div class="box kpi">
        <div class="kpi-number"><%= totalObs %></div>
        <div class="kpi-label">Observações</div>
      </div>

      <div class="box kpi">
        <div class="kpi-number"><%= totalElogios %></div>
        <div class="kpi-label">Elogios</div>
      </div>

      <div class="box kpi">
        <div class="kpi-number"><%= totalPdm %></div>
        <div class="kpi-label">Pontos de Melhoria</div>
      </div>

      <button class="box add-box" type="button" id="abrirAdicionar">
        <div class="plus-circle">+</div>
        <div class="add-text">Adicionar<br />Observação</div>
      </button>
    </div>

    <div class="obs-list">
      <% if (observacoes.isEmpty()) { %>
      <div class="empty">
        Nenhuma observação encontrada para essa disciplina.
      </div>
      <% } else { for (Observacao obs : observacoes) { String data = "";
        if (obs.getData() != null) { data = obs.getData().format(fmt); }
        String nomeProfessor = obs.getNomeProfessor() != null ?
                obs.getNomeProfessor() : "Professor"; String mensagem =
                obs.getMensagem() != null ? obs.getMensagem() : ""; String
                mensagemAttr = mensagem .replace("&", "&amp;") .replace("\"",
                        "&quot;") .replace("'", "&#39;") .replace("<", "&lt;")
                .replace(">", "&gt;"); String deAttr = nomeProfessor .replace("&",
                        "&amp;") .replace("\"", "&quot;") .replace("'", "&#39;")
                .replace("<", "&lt;") .replace(">", "&gt;"); String tipoClasse =
                (obs.getTipo() == 2) ? "neg" : "pos"; %>
      <div
              class="obs-item <%= tipoClasse %>"
              data-id="<%= obs.getId_observacao() %>"
              data-de="<%= deAttr %>"
              data-data="<%= data %>"
              data-texto="<%= mensagemAttr %>"
              data-tipo="<%= obs.getTipo() %>"
              tabindex="0"
              role="button"
              aria-label="Abrir observação"
      >
        <div class="obs-left">
          <span class="mini-bar <%= tipoClasse %>"></span>
          <div class="obs-text">De: <%= nomeProfessor %></div>
        </div>

        <div class="obs-date"><%= data %></div>
      </div>
      <% } } %>
    </div>
  </section>
</main>

<!-- MODAL DETALHE -->
<div class="overlay" id="overlayDetalhe">
  <div
          class="popup"
          id="popupDetalhe"
          role="dialog"
          aria-modal="true"
          aria-label="Detalhe da observação"
  >
    <div class="popup-head">
      <div class="popup-user">
        <div>
          <div class="popup-name" id="detalheDe">Professor</div>
          <div class="popup-sub">
            <%= aluno != null ? aluno.getNome() : "Aluno" %> <% if
          (disciplinaAtual != null) { %> - <%=
          disciplinaAtual.getNome() %> <% } %>
          </div>
        </div>
      </div>

      <div class="popup-date" id="detalheData">--/--</div>
    </div>

    <div class="popup-body">
      <div id="detalheTexto">—</div>
    </div>

    <div class="popup-actions">
      <button class="btn-primary-solid" type="button" id="abrirEditar">
        Editar observação
      </button>

      <button class="popup-back" id="fecharDetalhe" type="button">
        <span class="arrow">‹</span> Voltar
      </button>
    </div>
  </div>
</div>

<!-- MODAL ADICIONAR -->
<div class="overlay" id="overlayAdicionar">
  <div
          class="popup form-popup"
          role="dialog"
          aria-modal="true"
          aria-label="Adicionar observação"
  >
    <div class="popup-head">
      <div>
        <div class="popup-name">Adicionar observação</div>
        <div class="popup-sub">
          <%= aluno != null ? aluno.getNome() : "Aluno" %> <% if
        (disciplinaAtual != null) { %> - <%= disciplinaAtual.getNome()
        %> <% } %>
        </div>
      </div>

      <button class="close-x" type="button" id="fecharAdicionar">
        ×
      </button>
    </div>

    <form
            method="post"
            action="<%= ctx %>/professor/aluno"
            class="obs-form"
    >
      <input
              type="hidden"
              name="id_aluno"
              value="<%= aluno != null ? aluno.getId_aluno() : 0 %>"
      />
      <input
              type="hidden"
              name="id_disciplina"
              value="<%= disciplinaAtual != null ? disciplinaAtual.getId_disciplina() : 0 %>"
      />

      <label class="form-label" for="tipo">Tipo</label>
      <select name="tipo" id="tipo" class="form-select" required>
        <option value="1">Elogio</option>
        <option value="2">Ponto de melhoria</option>
      </select>

      <label class="form-label" for="mensagem">Mensagem</label>
      <textarea
              name="mensagem"
              id="mensagem"
              class="form-textarea"
              rows="6"
              required
      ></textarea>

      <div class="form-actions">
        <button
                type="button"
                class="btn-secondary"
                id="cancelarAdicionar"
        >
          Cancelar
        </button>
        <button type="submit" class="btn-primary-solid">
          Salvar observação
        </button>
      </div>
    </form>
  </div>
</div>

<!-- MODAL EDITAR -->
<div class="overlay" id="overlayEditar">
  <div
          class="popup form-popup"
          role="dialog"
          aria-modal="true"
          aria-label="Editar observação"
  >
    <div class="popup-head">
      <div>
        <div class="popup-name">Editar observação</div>
        <div class="popup-sub">
          <%= aluno != null ? aluno.getNome() : "Aluno" %> <% if
        (disciplinaAtual != null) { %> - <%= disciplinaAtual.getNome()
        %> <% } %>
        </div>
      </div>

      <button class="close-x" type="button" id="fecharEditar">×</button>
    </div>

    <form
            method="post"
            action="<%= ctx %>/professor/observacao/editar"
            class="obs-form"
    >
      <input
              type="hidden"
              name="id_observacao"
              id="editarIdObservacao"
      />
      <input
              type="hidden"
              name="id_aluno"
              value="<%= aluno != null ? aluno.getId_aluno() : 0 %>"
      />

      <label class="form-label" for="editarTipo">Tipo</label>
      <select name="tipo" id="editarTipo" class="form-select" required>
        <option value="1">Elogio</option>
        <option value="2">Ponto de melhoria</option>
      </select>

      <label class="form-label" for="editarMensagem">Mensagem</label>
      <textarea
              name="mensagem"
              id="editarMensagem"
              class="form-textarea"
              rows="6"
              required
      ></textarea>

      <div class="form-actions">
        <button type="button" class="btn-secondary" id="cancelarEditar">
          Cancelar
        </button>
        <button type="submit" class="btn-primary-solid">
          Salvar edição
        </button>
      </div>
    </form>
  </div>
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
      indicador.style.left = rect.left - navRect.left + "px";
    }

    const ativo =
            nav.querySelector(".topbar-link.is-active") || links[0];
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
        setTimeout(() => (window.location.href = href), 220);
      });
    });
  })();
</script>

<script>
  (function () {
    const overlayDetalhe = document.getElementById("overlayDetalhe");
    const popupDetalhe = document.getElementById("popupDetalhe");
    const detalheDe = document.getElementById("detalheDe");
    const detalheData = document.getElementById("detalheData");
    const detalheTexto = document.getElementById("detalheTexto");
    const fecharDetalhe = document.getElementById("fecharDetalhe");
    const abrirEditar = document.getElementById("abrirEditar");

    const overlayAdicionar =
            document.getElementById("overlayAdicionar");
    const abrirAdicionar = document.getElementById("abrirAdicionar");
    const fecharAdicionar = document.getElementById("fecharAdicionar");
    const cancelarAdicionar =
            document.getElementById("cancelarAdicionar");

    const overlayEditar = document.getElementById("overlayEditar");
    const fecharEditar = document.getElementById("fecharEditar");
    const cancelarEditar = document.getElementById("cancelarEditar");
    const editarId = document.getElementById("editarIdObservacao");
    const editarTipo = document.getElementById("editarTipo");
    const editarMensagem = document.getElementById("editarMensagem");

    let itemAtual = null;

    function abrirDetalhe(item) {
      itemAtual = item;
      detalheDe.textContent = item.dataset.de || "Professor";
      detalheData.textContent = item.dataset.data || "--/--";
      detalheTexto.textContent = item.dataset.texto || "";
      popupDetalhe.classList.toggle(
              "tipo2",
              String(item.dataset.tipo) === "2"
      );
      overlayDetalhe.classList.add("is-open");
    }

    function fecharModalDetalhe() {
      overlayDetalhe.classList.remove("is-open");
    }

    function abrirModalAdicionar() {
      overlayAdicionar.classList.add("is-open");
    }

    function fecharModalAdicionar() {
      overlayAdicionar.classList.remove("is-open");
    }

    function abrirModalEditar() {
      if (!itemAtual) return;

      editarId.value = itemAtual.dataset.id || "";
      editarTipo.value = itemAtual.dataset.tipo || "1";
      editarMensagem.value = itemAtual.dataset.texto || "";

      overlayEditar.classList.add("is-open");
    }

    function fecharModalEditar() {
      overlayEditar.classList.remove("is-open");
    }

    document
            .querySelectorAll(".obs-item[data-texto]")
            .forEach((item) => {
              item.addEventListener("click", () => abrirDetalhe(item));
              item.addEventListener("keydown", (e) => {
                if (e.key === "Enter" || e.key === " ") {
                  e.preventDefault();
                  abrirDetalhe(item);
                }
              });
            });

    abrirAdicionar &&
    abrirAdicionar.addEventListener("click", abrirModalAdicionar);
    fecharAdicionar &&
    fecharAdicionar.addEventListener("click", fecharModalAdicionar);
    cancelarAdicionar &&
    cancelarAdicionar.addEventListener("click", fecharModalAdicionar);

    fecharDetalhe &&
    fecharDetalhe.addEventListener("click", fecharModalDetalhe);
    abrirEditar &&
    abrirEditar.addEventListener("click", abrirModalEditar);

    fecharEditar &&
    fecharEditar.addEventListener("click", fecharModalEditar);
    cancelarEditar &&
    cancelarEditar.addEventListener("click", fecharModalEditar);

    overlayDetalhe &&
    overlayDetalhe.addEventListener("click", (e) => {
      if (e.target === overlayDetalhe) fecharModalDetalhe();
    });

    overlayAdicionar &&
    overlayAdicionar.addEventListener("click", (e) => {
      if (e.target === overlayAdicionar) fecharModalAdicionar();
    });

    overlayEditar &&
    overlayEditar.addEventListener("click", (e) => {
      if (e.target === overlayEditar) fecharModalEditar();
    });

    document.addEventListener("keydown", (e) => {
      if (e.key === "Escape") {
        fecharModalDetalhe();
        fecharModalAdicionar();
        fecharModalEditar();
      }
    });
  })();
</script>
</body>
</html>
