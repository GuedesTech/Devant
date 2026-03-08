<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.Aluno" %>
<%@ page import="com.example.secretariaescolar.model.Disciplina" %>
<%@ page import="com.example.secretariaescolar.model.MediaDisciplina" %>

<%
  String ctx = request.getContextPath();

  Aluno aluno = (Aluno) request.getAttribute("aluno");
  Disciplina disciplinaAtual = (Disciplina) request.getAttribute("disciplinaAtual");

  List<MediaDisciplina> mediasGeral = (List<MediaDisciplina>) request.getAttribute("mediasGeral");
  List<MediaDisciplina> mediasS1 = (List<MediaDisciplina>) request.getAttribute("mediasS1");
  List<MediaDisciplina> mediasS2 = (List<MediaDisciplina>) request.getAttribute("mediasS2");

  if (mediasGeral == null) mediasGeral = new ArrayList<>();
  if (mediasS1 == null) mediasS1 = new ArrayList<>();
  if (mediasS2 == null) mediasS2 = new ArrayList<>();

  Integer totalObs = (Integer) request.getAttribute("totalObs");
  Integer totalElogios = (Integer) request.getAttribute("totalElogios");
  Integer totalPdm = (Integer) request.getAttribute("totalPdm");

  Double nota1 = (Double) request.getAttribute("nota1");
  Double nota2 = (Double) request.getAttribute("nota2");
  Double mediaGeral = (Double) request.getAttribute("mediaGeral");

  if (totalObs == null) totalObs = 0;
  if (totalElogios == null) totalElogios = 0;
  if (totalPdm == null) totalPdm = 0;
  if (nota1 == null) nota1 = 0.0;
  if (nota2 == null) nota2 = 0.0;
  if (mediaGeral == null) mediaGeral = 0.0;

  String foto = (aluno != null) ? aluno.getFoto() : null;
  boolean semFoto = (foto == null)
          || foto.isBlank()
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
  <title>Análise Geral do Aluno - Devant</title>

  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/pages/assets/logo-dark.png" />
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <link rel="stylesheet" href="<%= ctx %>/pages/professor/aluno-analise.css" />
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>

<body>
<header class="topbar">
  <div class="topbar-inner">
    <a class="topbar-left" href="<%= ctx %>/professor/turmas" aria-label="Voltar ao início">
      <img class="topbar-logo" src="<%= ctx %>/pages/assets/logo.png" alt="Logo Devant" />
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a class="topbar-link is-active" href="<%= ctx %>/professor/turmas">Turmas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/disciplinas">Disciplinas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/perfil">Perfil</a>
      <span class="nav-indicador" aria-hidden="true"></span>
    </nav>

    <div class="topbar-right"></div>
  </div>
</header>

<main class="page page-analise-aluno">
  <section class="card analise-card">
    <div class="card-header">
      <div class="page-title-row">
        <button
                class="back-btn"
                type="button"
                onclick="history.back()"
                aria-label="Voltar"
        >
          ←
        </button>

        <img class="mini-avatar" src="<%= fotoSrc %>" alt="Foto" />

        <h1 class="page-title" style="margin: 0;">
          Análise Geral de <%= aluno != null ? aluno.getNome() : "Aluno" %>
        </h1>
      </div>

      <div class="title-line" aria-hidden="true"></div>

      <div class="filter-row">
        <label class="filter-label">Disciplina:</label>
        <div class="select-wrap">
          <select disabled>
            <option>
              <%= disciplinaAtual != null ? disciplinaAtual.getNome() : "Disciplina" %>
            </option>
          </select>
        </div>
      </div>

      <div class="top-actions-row">
        <button class="action-card action-button" type="button">
          <span class="action-ico">✎</span>
          <span>Editar<br />Notas</span>
        </button>

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

        <a
                class="action-card action-link"
                href="<%= ctx %>/professor/aluno?id_aluno=<%= aluno != null ? aluno.getId_aluno() : 0 %>"
        >
          <span class="action-ico">⌕</span>
          <span>Ver<br />Observação</span>
        </a>
      </div>
    </div>

    <div class="main-grid">
      <div class="side-stats">
        <div class="side-box">
          <div class="side-number">
            <%= String.format(java.util.Locale.US, "%.1f", nota1) %>
          </div>
          <div class="side-label">Nota 1</div>
        </div>

        <div class="side-box">
          <div class="side-number">
            <%= String.format(java.util.Locale.US, "%.1f", nota2) %>
          </div>
          <div class="side-label">Nota 2</div>
        </div>

        <div class="side-box">
          <div class="side-number">
            <%= String.format(java.util.Locale.US, "%.1f", mediaGeral) %>
          </div>
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
      </div>
    </div>
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
        setTimeout(() => (window.location.href = href), 220);
      });
    });
  })();
</script>

<script>
  function buildData(list) {
    return {
      labels: list.map(x => x.disciplina),
      values: list.map(x => Number(x.media))
    };
  }

  const geral = buildData([
    <% for (int i = 0; i < mediasGeral.size(); i++) { %>
    { disciplina: "<%= mediasGeral.get(i).getDisciplina().replace("\"", "\\\"") %>", media: <%= mediasGeral.get(i).getMedia() %> }<%= (i < mediasGeral.size() - 1 ? "," : "") %>
    <% } %>
  ]);

  const s1 = buildData([
    <% for (int i = 0; i < mediasS1.size(); i++) { %>
    { disciplina: "<%= mediasS1.get(i).getDisciplina().replace("\"", "\\\"") %>", media: <%= mediasS1.get(i).getMedia() %> }<%= (i < mediasS1.size() - 1 ? "," : "") %>
    <% } %>
  ]);

  const s2 = buildData([
    <% for (int i = 0; i < mediasS2.size(); i++) { %>
    { disciplina: "<%= mediasS2.get(i).getDisciplina().replace("\"", "\\\"") %>", media: <%= mediasS2.get(i).getMedia() %> }<%= (i < mediasS2.size() - 1 ? "," : "") %>
    <% } %>
  ]);

  let modo = "nota1";
  const canvas = document.getElementById("graficoMedias");
  let chart = null;

  function getDatasetForMode() {
    if (modo === "nota1") return { title: "Nota 1", data: s1 };
    if (modo === "nota2") return { title: "Nota 2", data: s2 };
    return { title: "Média", data: geral };
  }

  function getColors(values) {
    const bg = values.map(v => (v >= 7 ? "rgba(52,173,56,0.60)" : "rgba(205,52,52,0.65)"));
    const border = values.map(v => (v >= 7 ? "rgba(52,173,56,1)" : "rgba(205,52,52,1)"));
    return { bg, border };
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
          borderRadius: 10,
          borderSkipped: false
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
          y: {
            min: 0,
            max: 10,
            ticks: { stepSize: 1 }
          },
          x: {
            ticks: {
              autoSkip: false,
              maxRotation: 0,
              minRotation: 0
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

  if (canvas) renderChart();
</script>
</body>
</html>