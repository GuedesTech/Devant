<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.example.secretariaescolar.model.Turma" %>

<%
    String ctx = request.getContextPath();

    Turma turma = (Turma) request.getAttribute("turma");
    String nomeTurma = (turma != null && turma.getNome() != null) ? turma.getNome() : "Turma";

    Integer totalAlunos = (Integer) request.getAttribute("totalAlunos");
    if (totalAlunos == null) totalAlunos = 0;

    Double mediaTurma = (Double) request.getAttribute("mediaTurma");
    if (mediaTurma == null) mediaTurma = 0.0;

    Integer acima7 = (Integer) request.getAttribute("acima7");
    if (acima7 == null) acima7 = 0;

    Integer abaixo7 = (Integer) request.getAttribute("abaixo7");
    if (abaixo7 == null) abaixo7 = 0;

    Map<Integer, Integer> distribuicao = (Map<Integer, Integer>) request.getAttribute("distribuicao");
    if (distribuicao == null) distribuicao = new HashMap<>();

    List<Map<String, Object>> ranking = (List<Map<String, Object>>) request.getAttribute("ranking");
    if (ranking == null) ranking = new ArrayList<>();

    Integer totalObs = (Integer) request.getAttribute("totalObs");
    if (totalObs == null) totalObs = 0;

    List<Map<String, Object>> ultimasObs = (List<Map<String, Object>>) request.getAttribute("ultimasObs");
    if (ultimasObs == null) ultimasObs = new ArrayList<>();

    Map<String, Object> topPositivo = (Map<String, Object>) request.getAttribute("topPositivo");
    Map<String, Object> topNegativo = (Map<String, Object>) request.getAttribute("topNegativo");

    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM");

    StringBuilder valoresSb = new StringBuilder();
    for (int i = 1; i <= 10; i++) {
        Integer v = distribuicao.get(i);
        if (v == null) v = 0;
        valoresSb.append(v);
        if (i < 10) valoresSb.append(",");
    }
    String valoresJS = valoresSb.toString();

    String fotoPos = (topPositivo != null) ? (String) topPositivo.get("foto") : null;

    boolean semFotoPos = (fotoPos == null)
            || fotoPos.isBlank()
            || "null".equalsIgnoreCase(fotoPos.trim())
            || "[null]".equalsIgnoreCase(fotoPos.trim());

    String fotoPosSrc = !semFotoPos
            ? (ctx + "/pages/uploads/" + fotoPos)
            : (ctx + "/pages/aluno/foto_sem_foto.png");


    String fotoNeg = (topNegativo != null) ? (String) topNegativo.get("foto") : null;

    boolean semFotoNeg = (fotoNeg == null)
            || fotoNeg.isBlank()
            || "null".equalsIgnoreCase(fotoNeg.trim())
            || "[null]".equalsIgnoreCase(fotoNeg.trim());

    String fotoNegSrc = !semFotoNeg
            ? (ctx + "/pages/uploads/" + fotoNeg)
            : (ctx + "/pages/aluno/foto_sem_foto.png");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <link rel="icon" href="<%= ctx %>/assets/Group 551.ico" />
    <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
    <link rel="stylesheet" href="<%= ctx %>/pages/professor/turma-detalhe.css" />
    <title>Análise da Turma - <%= nomeTurma %></title>

    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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

        <div class="topbar-right"></div>
    </div>
</header>

<main class="page">
    <section class="card turma-card">

        <div class="card-header">
            <div class="page-title-row">
                <button class="back-btn" type="button" onclick="history.back()" aria-label="Voltar">←</button>
                <h1 class="page-title" style="margin:0;">Análise geral da turma <%= nomeTurma %></h1>
            </div>

            <div class="title-line" aria-hidden="true"></div>

            <div class="actions-row">
                <div class="chip">
                    <img src="<%= request.getContextPath() %>/pages/professor/pessoas.png" style="height: 17.5px; width: 24px"><span>Total Alunos: <strong><%= totalAlunos %></strong></span>
                </div>

                <a class="btn-primary" href="<%= ctx %>/professor/alunos-turma?id_turma=<%= turma.getId_turma() %>">
                    Ver alunos <span class="btn-arrow">›</span>
                </a>
            </div>
        </div>

        <div class="grid">
            <!-- ===== Gráfico ===== -->
            <div class="box grafico">
                <div class="box-title">Quantidade de alunos por média</div>
                <div class="box-sub">*As médias das notas estão arredondadas.</div>

                <div class="chart-wrap">
                    <canvas id="graficoNotas"></canvas>
                </div>

                <div class="legend">
                    <div class="leg"><span class="dot green"></span> Acima da média da turma</div>
                    <div class="leg"><span class="dot blue"></span> Dentro da média da turma</div>
                    <div class="leg"><span class="dot red"></span> Abaixo da média da turma</div>
                </div>
            </div>

            <!-- ===== Cards topo ===== -->
            <div class="box kpi">
                <div class="kpi-number"><%= String.format(java.util.Locale.US, "%.1f", mediaTurma) %></div>
                <div class="kpi-label">Média geral da turma</div>
            </div>

            <div class="box kpi">
                <div class="kpi-number"><%= acima7 %></div>
                <div class="kpi-label">Aluno acima de 7</div>
            </div>

            <div class="box kpi">
                <div class="kpi-number"><%= abaixo7 %></div>
                <div class="kpi-label">Alunos abaixo de 7</div>
            </div>

            <!-- ===== Ranking ===== -->
            <div class="box ranking">
                <div class="box-head">
                    <div class="box-title">Ranking de Alunos</div>
                </div>

                <div class="ranking-list">
                    <%
                        if (ranking.isEmpty()) {
                    %>
                    <div class="empty">Sem dados de ranking ainda.</div>
                    <%
                    } else {
                        for (Map<String, Object> r : ranking) {
                            String nome = String.valueOf(r.get("nome"));
                            Double med = (Double) r.get("media");
                            if (med == null) med = 0.0;
                    %>
                    <div class="rank-item">
                        <span class="bar"></span>
                        <span class="rank-name"><%= nome %></span>
                        <span class="rank-media"><%= String.format(java.util.Locale.US, "%.1f", med) %></span>
                    </div>
                    <%
                            }
                        }
                    %>
                </div>
            </div>

            <div class="box obs">
                <div class="box-head">
                    <div class="box-title">Últimas Observações</div>
                    <div class="filter-wrap" id="obsFilterWrap">
                        <div class="filter-menu" id="obsFilterMenu" role="menu" aria-label="Filtros de observações">
                        </div>
                    </div>
                </div>

                <div class="obs-list">
                    <%
                        if (ultimasObs.isEmpty()) {
                    %>
                    <div class="empty">Nenhuma observação nessa turma.</div>
                    <%
                    } else {
                        for (Map<String, Object> o : ultimasObs) {

                            String paraNome = String.valueOf(o.get("nome"));
                            String msg = String.valueOf(o.get("mensagem"));

                            String deNome = null;
                            if (o.get("professor") != null) deNome = String.valueOf(o.get("professor"));
                            else if (o.get("de") != null) deNome = String.valueOf(o.get("de"));
                            else if (o.get("autor") != null) deNome = String.valueOf(o.get("autor"));
                            else if (o.get("nome_professor") != null) deNome = String.valueOf(o.get("nome_professor"));
                            else deNome = "Professor";

                            Object tipoObj = o.get("tipo");
                            int tipo = 1;
                            if (tipoObj instanceof Number) {
                                tipo = ((Number) tipoObj).intValue();
                            }

                            Date d = (Date) o.get("data");
                            String dataStr = "";
                            if (d != null) {
                                dataStr = d.toLocalDate().format(fmt);
                            }

                            String msgAttr = msg
                                    .replace("&","&amp;")
                                    .replace("\"","&quot;")
                                    .replace("'","&#39;")
                                    .replace("<","&lt;")
                                    .replace(">","&gt;");
                    %>

                    <div class="obs-item"
                         role="button"
                         tabindex="0"
                         data-de="<%= deNome %>"
                         data-para="<%= paraNome %>"
                         data-data="<%= dataStr %>"
                         data-texto="<%= msgAttr %>"
                         data-tipo="<%= tipo %>">

                        <span class="mini-bar <%= (tipo==2 ? "neg" : "pos") %>"></span>

                        <div class="obs-text">
                            <div class="obs-line">
                                <strong>Para:</strong> <%= paraNome %> - <%= msg %>
                            </div>
                        </div>

                        <div class="obs-date"><%= dataStr %></div>
                    </div>

                    <%
                            }
                        }
                    %>
                </div>
            </div>

            <div class="box totalobs">
                <div class="kpi-number"><%= totalObs %></div>
                <div class="kpi-label">Número total de observações</div>
            </div>

            <div class="box topcard pos">
                <div class="top-title">Aluno com mais observações positivas</div>
                <div class="top-user">
                    <div class="avatar-wrap-small">
                        <img class="avatar-small" src="<%= fotoPosSrc %>" alt="Foto do aluno" />
                    </div>
                    <div class="top-name">
                        <%
                            String nomePos = (topPositivo != null) ? String.valueOf(topPositivo.get("nome")) : "";
                            String nomeFormatadoPos = "—";

                            if(!nomePos.isBlank()){
                                String[] partes = nomePos.split(" ");
                                if(partes.length > 1){
                                    nomeFormatadoPos = partes[0] + " " + partes[1].charAt(0) + ".";
                                } else {
                                    nomeFormatadoPos = partes[0];
                                }
                            }
                        %>
                        <%= nomeFormatadoPos %>
                    </div>
                </div>
            </div>

            <div class="box topcard neg">
                <div class="top-title">Aluno com mais observações negativas</div>
                <div class="top-user">
                    <div class="avatar-wrap-small">
                        <img class="avatar-small" src="<%= fotoNegSrc %>" alt="Foto do aluno" />
                    </div>
                    <div class="top-name">
                        <%
                            String nomeNeg = (topNegativo != null) ? String.valueOf(topNegativo.get("nome")) : "";
                            String nomeFormatadoNeg = "—";

                            if(!nomeNeg.isBlank()){
                                String[] partes = nomeNeg.split(" ");
                                if(partes.length > 1){
                                    nomeFormatadoNeg = partes[0] + " " + partes[1].charAt(0) + ".";
                                } else {
                                    nomeFormatadoNeg = partes[0];
                                }
                            }
                        %>

                        <%= nomeFormatadoNeg %>
                    </div>
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
        setTimeout(() => window.location.href = href, 220);
      });
    });
  })();

  // ===== dados do gráfico (1 a 10) =====
  const labels = [1,2,3,4,5,6,7,8,9,10];

  const valores = [<%= valoresJS %>];

  const colors = labels.map(n => {
    if (n > 7) return "#8FCF92";
    if (n == 7) return "#A6B1D9";
    return "#D16F6F";
  });

  const ctx = document.getElementById("graficoNotas");

  new Chart(ctx, {
    type: "bar",
    data: {
      labels,
      datasets: [{
        label: "Quantidade",
        data: valores,
        backgroundColor: colors,
        borderRadius: 6
      }]
    },
    options: {
      responsive: true,
      plugins: {
        legend: { display: false }
      },
      scales: {
        y: {
          beginAtZero: true,
          ticks: { precision: 0 }
        }
      }
    }
  });
</script>

<script>
document.addEventListener("DOMContentLoaded", () => {
  const overlay = document.getElementById("overlay");
  const popup = document.getElementById("popup");
  const btnBack = document.getElementById("btnBack");

  const popDe = document.getElementById("popDe");
  const popPara = document.getElementById("popPara");
  const popData = document.getElementById("popData");
  const popTexto = document.getElementById("popTexto");

  function abrir(item){
    if(!overlay || !popup) return;

    const de = item.dataset.de || "—";
    const para = item.dataset.para || "—";
    const data = item.dataset.data || "—";
    const texto = item.dataset.texto || "—";
    const tipo = item.dataset.tipo;

    popDe.textContent = de;
    popPara.textContent = "Para: " + para;
    popData.textContent = data;
    popTexto.textContent = texto;

    popup.classList.toggle("tipo2", String(tipo) === "2");
    overlay.classList.add("is-open");
  }

  function fechar(){
    overlay && overlay.classList.remove("is-open");
  }

  // clique + teclado
  document.querySelectorAll(".obs-item").forEach(item => {
    item.addEventListener("click", () => abrir(item));
    item.addEventListener("keydown", (e) => {
      if(e.key === "Enter" || e.key === " ") {
        e.preventDefault();
        abrir(item);
      }
    });
  });

  btnBack && btnBack.addEventListener("click", fechar);

  overlay && overlay.addEventListener("click", (e) => {
    if(e.target === overlay) fechar();
  });

  document.addEventListener("keydown", (e) => {
    if(e.key === "Escape") fechar();
  });
});
</script>

<div class="overlay" id="overlay">
    <div class="popup" id="popup" role="dialog" aria-modal="true" aria-label="Detalhe da observação">
        <div class="popup-head">
            <div class="popup-user">
                <img class="popup-avatar" id="popAvatar" src="<%= ctx %>/pages/aluno/foto_sem_foto.png" alt="Foto">
                <div>
                    <div class="popup-name" id="popDe">—</div>
                    <div class="popup-sub" id="popPara">—</div>
                </div>
            </div>

            <div class="popup-date" id="popData">—</div>
        </div>

        <div class="popup-body">
            <div id="popTexto">—</div>
        </div>

        <button class="popup-back" id="btnBack" type="button">
            <span class="arrow">‹</span> Voltar
        </button>
    </div>
</div>

</body>
</html>