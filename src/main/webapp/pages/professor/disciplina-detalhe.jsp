<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.example.secretariaescolar.model.Disciplina" %>
<%@ page import="com.example.secretariaescolar.model.Turma" %>

<%
  String ctx = request.getContextPath();

  Disciplina disciplina = (Disciplina) request.getAttribute("disciplina");
  String nomeDisciplina = (disciplina != null && disciplina.getNome() != null) ? disciplina.getNome() : "Disciplina";

  String filtroSelecionado = (String) request.getAttribute("filtroSelecionado");
  if (filtroSelecionado == null || filtroSelecionado.isBlank()) filtroSelecionado = "geral";

  @SuppressWarnings("unchecked")
  List<Turma> turmasDaDisciplina = (List<Turma>) request.getAttribute("turmasDaDisciplina");
  if (turmasDaDisciplina == null) turmasDaDisciplina = new ArrayList<>();

  Integer totalAlunos = (Integer) request.getAttribute("totalAlunos");
  if (totalAlunos == null) totalAlunos = 0;

  Double mediaDisciplina = (Double) request.getAttribute("mediaDisciplina");
  if (mediaDisciplina == null) mediaDisciplina = 0.0;

  Integer acima7 = (Integer) request.getAttribute("acima7");
  if (acima7 == null) acima7 = 0;

  Integer abaixo7 = (Integer) request.getAttribute("abaixo7");
  if (abaixo7 == null) abaixo7 = 0;

  List<Map<String, Object>> ranking = (List<Map<String, Object>>) request.getAttribute("ranking");
  if (ranking == null) ranking = new ArrayList<>();

  Integer totalObs = (Integer) request.getAttribute("totalObs");
  if (totalObs == null) totalObs = 0;

  List<Map<String, Object>> ultimasObs = (List<Map<String, Object>>) request.getAttribute("ultimasObs");
  if (ultimasObs == null) ultimasObs = new ArrayList<>();

  Map<String, Object> topPositivo = (Map<String, Object>) request.getAttribute("topPositivo");
  Map<String, Object> topNegativo = (Map<String, Object>) request.getAttribute("topNegativo");

  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM");

  String fotoPos = (topPositivo != null) ? (String) topPositivo.get("foto") : null;
  boolean semFotoPos = (fotoPos == null) || fotoPos.isBlank()
          || "null".equalsIgnoreCase(fotoPos.trim())
          || "[null]".equalsIgnoreCase(fotoPos.trim());
  String fotoPosSrc = !semFotoPos ? (ctx + "/pages/uploads/" + fotoPos) : (ctx + "/pages/aluno/foto_sem_foto.png");

  String fotoNeg = (topNegativo != null) ? (String) topNegativo.get("foto") : null;
  boolean semFotoNeg = (fotoNeg == null) || fotoNeg.isBlank()
          || "null".equalsIgnoreCase(fotoNeg.trim())
          || "[null]".equalsIgnoreCase(fotoNeg.trim());
  String fotoNegSrc = !semFotoNeg ? (ctx + "/pages/uploads/" + fotoNeg) : (ctx + "/pages/aluno/foto_sem_foto.png");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/pages/login/minimalismo.png">
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <link rel="stylesheet" href="<%= ctx %>/pages/professor/disciplina-detalhe.css" />
  <title>Análise da Disciplina - Devant</title>
</head>

<body>
<header class="topbar">
  <div class="topbar-inner">
    <a class="topbar-left" href="<%= ctx %>/professor/turmas" aria-label="Voltar ao início">
      <img class="topbar-logo" src="<%= ctx %>/pages/assets/logo.png" alt="Logo Devant">
    </a>

    <nav class="topbar-nav" aria-label="Navegação principal">
      <a class="topbar-link" href="<%= ctx %>/professor/turmas">Turmas</a>
      <a class="topbar-link is-active" href="<%= ctx %>/professor/disciplinas">Disciplinas</a>
      <a class="topbar-link" href="<%= ctx %>/professor/perfil">Perfil</a>
      <span class="nav-indicador" aria-hidden="true"></span>
    </nav>

    <div class="topbar-right">
      <a href="<%= ctx %>/pages/login/index.jsp" class="logout-btn">Sair</a>
    </div>
  </div>
</header>

<main class="page">
  <section class="card turma-card">
    <div class="card-header">
      <div class="page-title-row">
        <button class="back-btn" type="button" onclick="history.back()" aria-label="Voltar">←</button>
        <h1 class="page-title" style="margin:0;">Análise da Disciplina de <%= nomeDisciplina %></h1>
      </div>

      <div class="title-line" aria-hidden="true"></div>

      <form class="actions-row" method="get" action="<%= ctx %>/professor/disciplina">
        <input type="hidden" name="id_disciplina" value="<%= disciplina != null ? disciplina.getId_disciplina() : 0 %>">

        <select class="periodo-select" name="filtro" onchange="this.form.submit()">
          <option value="geral" <%= "geral".equals(filtroSelecionado) ? "selected" : "" %>>Geral</option>
          <option value="1geral" <%= "1geral".equals(filtroSelecionado) ? "selected" : "" %>>1°s em geral</option>
          <option value="2geral" <%= "2geral".equals(filtroSelecionado) ? "selected" : "" %>>2°s em geral</option>
          <option value="3geral" <%= "3geral".equals(filtroSelecionado) ? "selected" : "" %>>3°s em geral</option>

          <%
            for (Turma t : turmasDaDisciplina) {
              String val = String.valueOf(t.getId_turma());
          %>
          <option value="<%= val %>" <%= val.equals(filtroSelecionado) ? "selected" : "" %>><%= t.getNome() %></option>
          <%
            }
          %>
        </select>

        <div class="chip">
          <img src="<%= ctx %>/pages/professor/pessoas.png" style="height: 17.5px; width: 24px">
          <span>Total Alunos: <strong><%= totalAlunos %></strong></span>
        </div>

        <a class="btn-primary"
           href="<%= ctx %>/professor/alunos-disciplina?id_disciplina=<%= disciplina != null ? disciplina.getId_disciplina() : 0 %>&filtro=<%= filtroSelecionado %>">
          Ver alunos <span class="btn-arrow">›</span>
        </a>
      </form>
    </div>

    <div class="grid">
      <div class="box kpi">
        <div class="kpi-number"><%= String.format(java.util.Locale.US, "%.1f", mediaDisciplina) %></div>
        <div class="kpi-label">Média geral da turma</div>
      </div>

      <div class="box kpi">
        <div class="kpi-number"><%= acima7 %></div>
        <div class="kpi-label">Alunos acima de 7</div>
      </div>

      <div class="box kpi">
        <div class="kpi-number"><%= abaixo7 %></div>
        <div class="kpi-label">Alunos abaixo de 7</div>
      </div>

      <div class="box obs">
        <div class="box-head">
          <div class="box-title">Últimas Observações</div>
        </div>

        <div class="obs-list">
          <%
            if (ultimasObs.isEmpty()) {
          %>
          <div class="empty">Nenhuma observação nessa disciplina.</div>
          <%
          } else {
            for (Map<String, Object> o : ultimasObs) {
              String paraNome = String.valueOf(o.get("nome"));
              String msg = String.valueOf(o.get("mensagem"));

              String deNome = (o.get("nome_professor") != null)
                      ? String.valueOf(o.get("nome_professor"))
                      : "Professor";

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

      <div class="box totalobs">
        <div class="kpi-number"><%= totalObs %></div>
        <div class="kpi-label">Número total de observações</div>
      </div>

      <div class="box topcard pos">
        <div class="top-title">Destaque Elogios</div>
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
                nomeFormatadoPos = (partes.length > 1)
                        ? partes[0] + " " + partes[1].charAt(0) + "."
                        : partes[0];
              }
            %>
            <%= nomeFormatadoPos %>
          </div>
        </div>
      </div>

      <div class="box topcard neg">
        <div class="top-title">Destaque a Melhorar</div>
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
                nomeFormatadoNeg = (partes.length > 1)
                        ? partes[0] + " " + partes[1].charAt(0) + "."
                        : partes[0];
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