<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.Aluno" %>
<%@ page import="com.example.secretariaescolar.model.Disciplina" %>
<%@ page import="com.example.secretariaescolar.model.MediaDisciplina" %>
<%@ page import="com.example.secretariaescolar.dto.NotasAlunoDTO" %>

<%
  String ctx = request.getContextPath();

  Aluno aluno = (Aluno) request.getAttribute("aluno");
  Disciplina disciplinaProfessor = (Disciplina) request.getAttribute("disciplinaProfessor");
  NotasAlunoDTO notasProfessor = (NotasAlunoDTO) request.getAttribute("notasProfessor");

  Integer totalObs = (Integer) request.getAttribute("totalObs");
  Integer totalElogios = (Integer) request.getAttribute("totalElogios");
  Integer totalPdm = (Integer) request.getAttribute("totalPdm");

  @SuppressWarnings("unchecked")
  List<MediaDisciplina> mediasGeral = (List<MediaDisciplina>) request.getAttribute("mediasGeral");
  @SuppressWarnings("unchecked")
  List<MediaDisciplina> mediasS1 = (List<MediaDisciplina>) request.getAttribute("mediasS1");
  @SuppressWarnings("unchecked")
  List<MediaDisciplina> mediasS2 = (List<MediaDisciplina>) request.getAttribute("mediasS2");

  if (mediasGeral == null) mediasGeral = new ArrayList<>();
  if (mediasS1 == null) mediasS1 = new ArrayList<>();
  if (mediasS2 == null) mediasS2 = new ArrayList<>();

  if (notasProfessor == null) {
    notasProfessor = new NotasAlunoDTO();
    notasProfessor.setN1(0.0);
    notasProfessor.setN2(0.0);
  }

  if (totalObs == null) totalObs = 0;
  if (totalElogios == null) totalElogios = 0;
  if (totalPdm == null) totalPdm = 0;

  double nota1 = notasProfessor.getN1();
  double nota2 = notasProfessor.getN2();
  double media = notasProfessor.getMedia();

  String foto = (aluno != null) ? aluno.getFoto() : null;

  boolean semFoto = (foto == null) || foto.isBlank()
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
  <title>Análise do Aluno - Devant</title>

  <style>
    .page-title-row{
      display:flex;
      align-items:center;
      gap:12px;
      margin-top:6px;
    }

    .back-btn{
      width:40px;
      height:40px;
      border-radius:999px;
      border:0;
      background:transparent;
      display:inline-flex;
      align-items:center;
      justify-content:center;
      cursor:pointer;
      color:var(--navy);
      font-size:24px;
      line-height:1;
    }

    .mini-avatar{
      width:46px;
      height:46px;
      border-radius:999px;
      object-fit:cover;
      border:2px solid rgba(40,53,101,0.15);
    }

    .chip-disciplina{
      margin-top:14px;
      display:inline-flex;
      align-items:center;
      gap:10px;
      background:#EFF5FF;
      border:2px solid rgba(40,53,101,0.20);
      border-radius:12px;
      min-height:36px;
      padding:7px 14px;
      font-weight:700;
      color:var(--navy);
      box-shadow:0 6px 14px rgba(40,53,101,0.06);
    }

    .top-actions-row{
      margin-top:18px;
      display:grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap:14px;
      align-items:stretch;
    }

    .info-card,
    .action-card{
      background:#fff;
      border-radius:14px;
      border:1px solid rgba(40,53,101,0.12);
      box-shadow:0 10px 18px rgba(40,53,101,0.08);
      min-height:92px;
      padding:14px 16px;
    }

    .info-card{
      text-align:center;
      display:flex;
      flex-direction:column;
      justify-content:center;
    }

    .info-number{
      font-size:28px;
      font-weight:900;
      color:var(--navy);
      line-height:1.1;
    }

    .info-label{
      margin-top:6px;
      font-size:13px;
      font-weight:800;
      color:rgba(40,53,101,0.60);
    }

    .action-card{
      display:flex;
      flex-direction:column;
      align-items:center;
      justify-content:center;
      gap:10px;
      text-decoration:none;
      color:#fff;
      background:#2F3F7C;
      font-weight:900;
      text-align:center;
    }

    .action-icon{
      font-size:28px;
      line-height:1;
    }

    .grid-main{
      margin-top:18px;
      display:grid;
      grid-template-columns:120px 1fr;
      gap:16px;
      align-items:start;
    }

    .side-stats{
      display:flex;
      flex-direction:column;
      gap:14px;
    }

    .side-box{
      background:#EEF1FB;
      border-radius:14px;
      border:1px solid rgba(40,53,101,0.08);
      padding:32.6px 10px;
      text-align:center;
      box-shadow:0 8px 18px rgba(40,53,101,0.05);
    }

    .side-number{
      font-weight:900;
      color:var(--navy);
      font-size:22px;
      line-height:1.1;
    }

    .side-label{
      margin-top:6px;
      font-weight:800;
      font-size:14px;
      color:rgba(40,53,101,0.70);
    }

    .chart-card{
      background:#fff;
      border-radius:14px;
      border:1px solid rgba(40,53,101,0.12);
      box-shadow:0 10px 18px rgba(40,53,101,0.08);
      padding:16px 18px;
    }

    .chart-title{
      font-weight:800;
      color:var(--navy);
      font-size:14px;
    }

    .tabs{
      margin-top:10px;
      display:flex;
      gap:8px;
    }

    .tab{
      border:0;
      background:#EEF3FF;
      color:var(--navy);
      font-weight:800;
      font-size:12px;
      padding:7px 14px;
      border-radius:10px;
      cursor:pointer;
      opacity:.9;
    }

    .tab.is-active{
      background:#E2EAFF;
      opacity:1;
    }

    .chart-wrap{
      margin-top:12px;
      height:260px;
    }

    .toolbar-row{
      margin-top:12px;
      display:flex;
      justify-content:flex-end;
    }

    .btn-edit-notes{
      height:36px;
      padding:0 14px;
      border-radius:12px;
      border:1px solid rgba(40,53,101,0.18);
      background:#F4F7FF;
      color:var(--navy);
      font-weight:900;
      cursor:pointer;
    }

    .overlay{
      position:fixed;
      inset:0;
      background:rgba(0,0,0,0.40);
      display:none;
      z-index:9998;
    }

    .overlay.is-open{
      display:block;
    }

    .popup{
      position:fixed;
      top:50%;
      left:50%;
      transform:translate(-50%, -50%) scale(.96);
      width:min(760px, 94vw);
      max-height:90vh;
      overflow-y:auto;
      background:#fff;
      border-radius:18px;
      box-shadow:0 24px 50px rgba(0,0,0,0.20);
      border:1px solid rgba(40,53,101,0.14);
      padding:18px 18px 20px;
      z-index:9999;
      display:none;
    }

    .popup.is-open{
      display:block;
      transform:translate(-50%, -50%) scale(1);
    }

    .popup-head{
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:12px;
    }

    .popup-title{
      margin:0;
      font-size:20px;
      font-weight:900;
      color:var(--navy);
    }

    .popup-close{
      border:0;
      background:transparent;
      cursor:pointer;
      font-size:26px;
      font-weight:900;
      color:rgba(40,53,101,0.7);
      line-height:1;
    }

    .chip{
      display:inline-flex;
      align-items:center;
      gap:10px;
      background:#EFF5FF;
      border:2px solid rgba(40,53,101,0.20);
      border-radius:12px;
      min-height:36px;
      padding:7px 14px;
      font-weight:700;
      color:var(--navy);
      box-shadow:0 6px 14px rgba(40,53,101,0.06);
    }

    .chip-popup{
      margin-top:14px;
    }

    .popup-form{
      margin-top:16px;
    }

    .grid-3{
      display:grid;
      grid-template-columns: repeat(3, minmax(0, 1fr));
      gap:14px;
      margin-top:16px;
    }

    .field{
      display:flex;
      flex-direction:column;
      gap:6px;
    }

    .field span{
      font-weight:900;
      color:var(--navy);
      font-size:13px;
    }

    .field input{
      height:42px;
      border-radius:12px;
      border:1px solid rgba(40,53,101,0.18);
      padding:0 12px;
      font-weight:800;
      color:#1f2937;
      outline:none;
      background:#fff;
    }

    .readonly-box{
      height:42px;
      border-radius:12px;
      border:1px solid rgba(40,53,101,0.12);
      background:#F3F6FF;
      display:flex;
      align-items:center;
      padding:0 12px;
      font-weight:900;
      color:var(--navy);
    }

    .popup-actions{
      margin-top:18px;
      display:flex;
      justify-content:flex-end;
      gap:10px;
      flex-wrap:wrap;
    }

    .btn-ghost{
      height:38px;
      display:inline-flex;
      align-items:center;
      padding:0 14px;
      border-radius:12px;
      background:#F3F6FF;
      border:1px solid rgba(40,53,101,0.18);
      color:var(--navy);
      text-decoration:none;
      font-weight:900;
      cursor:pointer;
    }

    .btn-primary{
      height:38px;
      display:inline-flex;
      align-items:center;
      gap:10px;
      padding:0 16px;
      border-radius:12px;
      background:var(--teal);
      color:var(--white);
      text-decoration:none;
      font-weight:900;
      border:0;
      cursor:pointer;
    }

    .alert{
      margin-top:14px;
      padding:12px 14px;
      border-radius:12px;
      font-weight:800;
    }

    .alert.ok{
      background:#EAF8EC;
      color:#1f6b29;
      border:1px solid #b9e3c1;
    }

    .alert.err{
      background:#FFF1F1;
      color:#9d2d2d;
      border:1px solid #f1c3c3;
    }

    .topbar-nav{ position:relative; }
    .nav-indicador{
      left:0;
      height:6px;
      border-radius:999px;
      background:var(--white);
      opacity:.95;
      transition:all .35s ease;
    }

    .no-scroll{
      overflow:hidden;
    }

    @media (max-width: 980px){
      .top-actions-row{
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }

      .grid-main{
        grid-template-columns:1fr;
      }

      .grid-3{
        grid-template-columns:1fr;
      }
    }
  </style>
</head>

<body>
<header class="topbar">
  <div class="topbar-inner">
    <a class="topbar-left" href="<%= ctx %>/professor/turmas" aria-label="Voltar ao início">
      <img class="topbar-logo" src="<%= ctx %>/pages/assets/logo.png" alt="Logo Devant">
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a class="topbar-link is-active" href="<%= ctx %>/professor/turmas">Turmas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/disciplinas">Disciplinas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/perfil">Perfil</a>
      <span class="nav-indicador" aria-hidden="true"></span>
    </nav>

    <div class="topbar-right">
      <a href="<%= ctx %>/pages/login/index.jsp" class="logout-btn">Sair</a>
    </div>
  </div>
</header>

<main class="page">
  <section class="card">
    <div class="card-header">

      <div class="page-title-row">
        <button class="back-btn" type="button" onclick="history.back()" aria-label="Voltar">←</button>
        <img class="mini-avatar" src="<%= fotoSrc %>" alt="Foto">
        <h1 class="page-title" style="margin:0;">
          Análise Geral de <%= aluno != null ? aluno.getNome() : "Aluno" %>
        </h1>
      </div>

      <div class="title-line" aria-hidden="true"></div>

      <% if ("nota_salva".equals(ok)) { %>
      <div class="alert ok">Notas salvas com sucesso.</div>
      <% } %>

      <% if ("nota".equals(erro) || "sem_prof".equals(erro) || "sem_disc".equals(erro)) { %>
      <div class="alert err">Não foi possível salvar as notas.</div>
      <% } %>

      <div class="chip-disciplina">
        Sua Disciplina:
        <strong><%= disciplinaProfessor != null ? disciplinaProfessor.getNome() : "—" %></strong>
      </div>

      <div class="top-actions-row">
        <div class="info-card">
          <div class="info-number"><%= totalObs %></div>
          <div class="info-label">Observações</div>
        </div>

        <div class="info-card">
          <div class="info-number"><%= totalElogios %></div>
          <div class="info-label">Elogios</div>
        </div>

        <div class="info-card">
          <div class="info-number"><%= totalPdm %></div>
          <div class="info-label">Pontos de Melhoria</div>
        </div>

        <a class="action-card"
           href="<%= ctx %>/professor/aluno/observacoes?id_aluno=<%= aluno != null ? aluno.getId_aluno() : 0 %>">
          <img src="<%= ctx %>/pages/professor/vizu_branco.png" style="width: 46px; height: 32px">
          <div style="font-size: 14px">Histórico Completo de Observações</div>
        </a>
      </div>

      <div class="grid-main">
        <div class="side-stats">
          <div class="chart-title" style="text-align: center; font-size: 12px">Notas na Disciplina</div>
          <div class="side-box">
            <div class="side-number"><%= String.format(java.util.Locale.US, "%.1f", nota1) %></div>
            <div class="side-label">Nota 1</div>
          </div>

          <div class="side-box">
            <div class="side-number"><%= String.format(java.util.Locale.US, "%.1f", nota2) %></div>
            <div class="side-label">Nota 2</div>
          </div>

          <div class="side-box">
            <div class="side-number"><%= String.format(java.util.Locale.US, "%.1f", media) %></div>
            <div class="side-label">Média</div>
          </div>
        </div>

        <div class="chart-card">
          <div class="chart-title">Nota média por disciplina</div>

          <div class="tabs">
            <button class="tab is-active" type="button">Nota 1</button>
            <button class="tab" type="button">Nota 2</button>
            <button class="tab" type="button">Geral</button>
          </div>

          <div class="chart-wrap">
            <canvas id="graficoMedias"></canvas>
          </div>

          <div class="toolbar-row">
            <button class="btn-edit-notes" type="button" id="btnAbrirPopupNotas">
              Editar Notas
            </button>
          </div>
        </div>
      </div>

    </div>
  </section>
</main>

<div class="overlay" id="overlayNotas"></div>

<div class="popup" id="popupEditarNotas" aria-hidden="true">
  <div class="popup-head">
    <h2 class="popup-title">Editar Notas</h2>
    <button class="popup-close" type="button" id="btnFecharPopupNotas">&times;</button>
  </div>

  <div class="chip chip-popup">
    <span>
      <%= aluno != null ? aluno.getNome() : "Aluno" %>
      <% if (disciplinaProfessor != null) { %>
        - <%= disciplinaProfessor.getNome() %>
      <% } %>
    </span>
  </div>

  <form class="popup-form" method="post" action="<%= ctx %>/professor/aluno/notas/salvar">
    <input type="hidden" name="id_aluno" value="<%= aluno != null ? aluno.getId_aluno() : 0 %>">

    <div class="grid-3">
      <label class="field">
        <span>Nota 1</span>
        <input name="n1" id="popupN1" type="number" step="0.1" min="0" max="10"
               value="<%= String.format(java.util.Locale.US, "%.1f", nota1) %>" required>
      </label>

      <label class="field">
        <span>Nota 2</span>
        <input name="n2" id="popupN2" type="number" step="0.1" min="0" max="10"
               value="<%= String.format(java.util.Locale.US, "%.1f", nota2) %>" required>
      </label>

      <div class="field">
        <span>Média</span>
        <div class="readonly-box" id="popupMedia">
          <%= String.format(java.util.Locale.US, "%.1f", media) %>
        </div>
      </div>
    </div>

    <div class="popup-actions">
      <button class="btn-ghost" type="button" id="btnCancelarPopupNotas">Cancelar</button>
      <button class="btn-primary" type="submit">Salvar notas</button>
    </div>
  </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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

  function buildData(list) {
    return {
      labels: list.map(x => x.disciplina),
      values: list.map(x => Number(x.media))
    };
  }

  const geral = buildData([
    <% for (int i=0; i<mediasGeral.size(); i++) { %>
    { disciplina: "<%= mediasGeral.get(i).getDisciplina().replace("\"","\\\"") %>", media: <%= mediasGeral.get(i).getMedia() %> }<%= (i<mediasGeral.size()-1?",":"") %>
    <% } %>
  ]);

  const s1 = buildData([
    <% for (int i=0; i<mediasS1.size(); i++) { %>
    { disciplina: "<%= mediasS1.get(i).getDisciplina().replace("\"","\\\"") %>", media: <%= mediasS1.get(i).getMedia() %> }<%= (i<mediasS1.size()-1?",":"") %>
    <% } %>
  ]);

  const s2 = buildData([
    <% for (int i=0; i<mediasS2.size(); i++) { %>
    { disciplina: "<%= mediasS2.get(i).getDisciplina().replace("\"","\\\"") %>", media: <%= mediasS2.get(i).getMedia() %> }<%= (i<mediasS2.size()-1?",":"") %>
    <% } %>
  ]);

  let modo = "nota1";
  const canvas = document.getElementById("graficoMedias");
  let chart = null;

  function getColors(values) {
    const bg = values.map(v => (v >= 7 ? "rgba(52,173,56,0.65)" : "rgba(205,52,52,0.65)"));
    const border = values.map(v => (v >= 7 ? "rgba(52,173,56,1)" : "rgba(205,52,52,1)"));
    return { bg, border };
  }

  function getDatasetForMode() {
    if (modo === "nota1") return { title: "Nota 1", data: s1 };
    if (modo === "nota2") return { title: "Nota 2", data: s2 };
    return { title: "Média", data: geral };
  }

  function renderChart() {
    const pack = getDatasetForMode();
    const labels = pack.data.labels;
    const values = pack.data.values;
    const colors = getColors(values);

    const config = {
      type: "bar",
      data: {
        labels,
        datasets: [{
          label: pack.title,
          data: values,
          backgroundColor: colors.bg,
          borderColor: colors.border,
          borderWidth: 1,
          borderRadius: { topLeft: 10, topRight: 10, bottomLeft: 10, bottomRight: 10},
          borderSkipped: "bottom"
        }]
      },
      options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
          legend: { display: false },
          tooltip: {
            displayColors: false,
            callbacks: {
              title: function(items) {
                return items[0].label || "";
              },
              label: function(ctx) {
                return ctx.dataset.label + ": " + ctx.parsed.y;
              }
            }
          }
        },
        scales: {
          y: { min: 0, max: 10, ticks: { stepSize: 1 } },
          x: {
            ticks: {
              autoSkip: false,
              maxRotation: 0,
              minRotation: 0,
              padding: 8,
              callback: function(value) {
                const label = this.getLabelForValue(value) || "";
                const max = 7;
                return label.length > max ? (label.slice(0, max) + "...") : label;
              }
            }
          }
        }
      }
    };

    if (chart) chart.destroy();
    chart = new Chart(canvas, config);
  }

  function setActiveTab(btn) {
    document.querySelectorAll(".tab").forEach(b => b.classList.remove("is-active"));
    btn.classList.add("is-active");
  }

  document.querySelectorAll(".tab").forEach(btn => {
    btn.addEventListener("click", () => {
      const text = (btn.textContent || "").trim().toLowerCase();

      if (text.includes("nota 1")) modo = "nota1";
      else if (text.includes("nota 2")) modo = "nota2";
      else modo = "geral";

      setActiveTab(btn);
      renderChart();
    });
  });

  (function initTabs(){
    const tabs = Array.from(document.querySelectorAll(".tab"));
    const tabNota1 = tabs.find(t => (t.textContent || "").toLowerCase().includes("nota 1"));
    if (tabNota1) setActiveTab(tabNota1);
  })();

  if (canvas) renderChart();
</script>

<script>
  (function () {
    const btnAbrir = document.getElementById("btnAbrirPopupNotas");
    const btnFechar = document.getElementById("btnFecharPopupNotas");
    const btnCancelar = document.getElementById("btnCancelarPopupNotas");
    const overlay = document.getElementById("overlayNotas");
    const popup = document.getElementById("popupEditarNotas");

    const n1 = document.getElementById("popupN1");
    const n2 = document.getElementById("popupN2");
    const media = document.getElementById("popupMedia");

    function abrirPopup() {
      popup.classList.add("is-open");
      popup.setAttribute("aria-hidden", "false");
      overlay.classList.add("is-open");
      document.body.classList.add("no-scroll");
    }

    function fecharPopup() {
      popup.classList.remove("is-open");
      popup.setAttribute("aria-hidden", "true");
      overlay.classList.remove("is-open");
      document.body.classList.remove("no-scroll");
    }

    function atualizarMedia() {
      const v1 = parseFloat(n1.value || "0") || 0;
      const v2 = parseFloat(n2.value || "0") || 0;
      const m = (v1 + v2) / 2;
      media.textContent = m.toFixed(1);
    }

    btnAbrir.addEventListener("click", abrirPopup);
    btnFechar.addEventListener("click", fecharPopup);
    btnCancelar.addEventListener("click", fecharPopup);
    overlay.addEventListener("click", fecharPopup);

    n1.addEventListener("input", atualizarMedia);
    n2.addEventListener("input", atualizarMedia);

    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape") fecharPopup();
    });
  })();
</script>

</body>
</html>