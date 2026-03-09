<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.example.secretariaescolar.model.Aluno" %>
<%@ page import="com.example.secretariaescolar.model.Disciplina" %>
<%@ page import="com.example.secretariaescolar.model.MediaDisciplina" %>
<%@ page import="com.example.secretariaescolar.model.Observacao" %>
<%@ page import="com.example.secretariaescolar.dto.NotasAlunoDTO" %>

<%
  String ctx = request.getContextPath();

  Aluno aluno = (Aluno) request.getAttribute("aluno");
  Disciplina disciplinaAtual = (Disciplina) request.getAttribute("disciplinaAtual");

  @SuppressWarnings("unchecked")
  List<Disciplina> disciplinas = (List<Disciplina>) request.getAttribute("disciplinas");
  if (disciplinas == null) disciplinas = new ArrayList<>();

  @SuppressWarnings("unchecked")
  List<MediaDisciplina> mediasGeral = (List<MediaDisciplina>) request.getAttribute("mediasGeral");
  @SuppressWarnings("unchecked")
  List<MediaDisciplina> mediasS1 = (List<MediaDisciplina>) request.getAttribute("mediasS1");
  @SuppressWarnings("unchecked")
  List<MediaDisciplina> mediasS2 = (List<MediaDisciplina>) request.getAttribute("mediasS2");

  if (mediasGeral == null) mediasGeral = new ArrayList<>();
  if (mediasS1 == null) mediasS1 = new ArrayList<>();
  if (mediasS2 == null) mediasS2 = new ArrayList<>();

  @SuppressWarnings("unchecked")
  Map<String, NotasAlunoDTO> notasMap = (Map<String, NotasAlunoDTO>) request.getAttribute("notasMap");
  if (notasMap == null) notasMap = new HashMap<>();

  @SuppressWarnings("unchecked")
  Map<String, Integer> totalObsMap = (Map<String, Integer>) request.getAttribute("totalObsMap");
  if (totalObsMap == null) totalObsMap = new HashMap<>();

  @SuppressWarnings("unchecked")
  Map<String, Integer> totalElogiosMap = (Map<String, Integer>) request.getAttribute("totalElogiosMap");
  if (totalElogiosMap == null) totalElogiosMap = new HashMap<>();

  @SuppressWarnings("unchecked")
  Map<String, Integer> totalPdmMap = (Map<String, Integer>) request.getAttribute("totalPdmMap");
  if (totalPdmMap == null) totalPdmMap = new HashMap<>();

  @SuppressWarnings("unchecked")
  Map<String, List<Observacao>> observacoesMap = (Map<String, List<Observacao>>) request.getAttribute("observacoesMap");
  if (observacoesMap == null) observacoesMap = new HashMap<>();

  Integer idDisciplina = (Integer) request.getAttribute("idDisciplina");
  if (idDisciplina == null) idDisciplina = 0;

  NotasAlunoDTO notasAtual = notasMap.get(String.valueOf(idDisciplina));
  if (notasAtual == null) {
    notasAtual = new NotasAlunoDTO();
    notasAtual.setN1(0.0);
    notasAtual.setN2(0.0);
    notasAtual.getMedia();
  }

  Integer totalObs = totalObsMap.get(String.valueOf(idDisciplina));
  Integer totalElogios = totalElogiosMap.get(String.valueOf(idDisciplina));
  Integer totalPdm = totalPdmMap.get(String.valueOf(idDisciplina));

  if (totalObs == null) totalObs = 0;
  if (totalElogios == null) totalElogios = 0;
  if (totalPdm == null) totalPdm = 0;

  double nota1 = notasAtual.getN1();
  double nota2 = notasAtual.getN2();
  double mediaDisciplina = notasAtual.getMedia();

  List<Observacao> observacoesAtuais = observacoesMap.get(String.valueOf(idDisciplina));
  if (observacoesAtuais == null) observacoesAtuais = new ArrayList<>();

  String foto = (aluno != null) ? aluno.getFoto() : null;
  boolean semFoto = (foto == null)
          || foto.isBlank()
          || "null".equalsIgnoreCase(foto.trim())
          || "[null]".equalsIgnoreCase(foto.trim());

  String fotoSrc = !semFoto
          ? (ctx + "/pages/uploads/" + foto)
          : (ctx + "/pages/aluno/foto_sem_foto.png");

  String ok = request.getParameter("ok");
  String erro = request.getParameter("erro");

  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM");
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Análise Geral do Aluno - Devant</title>

  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/pages/login/minimalismo.png" />
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

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
      width:34px;
      height:34px;
      border-radius:999px;
      object-fit:cover;
      border:2px solid rgba(40,53,101,0.15);
    }

    .filter-row{
      margin-top:16px;
      display:flex;
      align-items:center;
      gap:12px;
      flex-wrap:wrap;
    }

    .filter-label{
      font-weight:800;
      color:var(--navy);
    }

    .select-wrap select{
      height:40px;
      min-width:220px;
      border-radius:12px;
      border:1px solid rgba(40,53,101,0.18);
      padding:0 12px;
      font-weight:800;
      color:var(--navy);
      background:#fff;
    }

    .top-actions-row{
      margin-top:18px;
      display:grid;
      grid-template-columns: repeat(5, minmax(0, 1fr));
      gap:12px;
      align-items:stretch;
    }

    .action-card,
    .info-card{
      background:#fff;
      border-radius:14px;
      border:1px solid rgba(40,53,101,0.12);
      box-shadow:0 10px 18px rgba(40, 53, 101, 0.08);
      min-height:95px;
      padding:14px 16px;
    }

    .action-button,
    .action-link{
      display:flex;
      align-items:center;
      justify-content:center;
      gap:12px;
      text-decoration:none;
      color:var(--navy);
      font-weight:800;
      cursor:pointer;
      background:#fff;
      border:1px solid rgba(40,53,101,0.12);
    }

    .action-ico{
      font-size:20px;
      font-weight:900;
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

    .main-grid{
      margin-top:16px;
      display:grid;
      grid-template-columns:220px 1fr;
      gap:14px;
      align-items:start;
    }

    .side-stats{
      display:flex;
      flex-direction:column;
      gap:12px;
    }

    .side-box{
      background:#fff;
      border-radius:14px;
      border:1px solid rgba(40,53,101,0.12);
      box-shadow:0 10px 18px rgba(40,53,101,0.08);
      padding:20px;
      text-align:center;
    }

    .side-number{
      font-weight:900;
      color:var(--navy);
      font-size:25px;
      line-height:1.1;
    }

    .side-label{
      margin-top:6px;
      font-weight:800;
      font-size:15px;
      color:rgba(40,53,101,0.60);
    }

    .chart-card{
      background:#fff;
      border-radius:14px;
      border:1px solid rgba(40,53,101,0.12);
      box-shadow:0 10px 18px rgba(40,53,101,0.08);
      padding:14px;
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
      padding:6px 10px;
      border-radius:10px;
      cursor:pointer;
      opacity:.9;
    }

    .tab.is-active{
      background:#E2EAFF;
      opacity:1;
    }

    .chart-wrap{
      margin-top:10px;
      height:260px;
    }

    .alert{
      margin-top:12px;
      padding:10px 12px;
      border-radius:12px;
      border:1px solid rgba(40,53,101,0.18);
      background:#fff;
      font-weight:800;
    }

    .alert.ok{ color:#156b2a; }
    .alert.err{ color:#a11; }

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

    .obs-list{
      margin-top:14px;
      display:flex;
      flex-direction:column;
      gap:10px;
    }

    .obs-item{
      width:100%;
      border:1px solid rgba(40,53,101,0.12);
      border-radius:14px;
      background:#fff;
      padding:16px 18px;
      box-shadow:0 10px 18px rgba(40, 53, 101, 0.08);
      cursor:pointer;
      position:relative;
      transition:transform .12s ease, filter .12s ease;
    }

    .obs-item:hover{
      transform:translateY(-1px);
      filter:brightness(1.01);
    }

    .obs-item::before{
      content:"";
      position:absolute;
      left:0;
      top:0;
      bottom:0;
      width:6px;
      border-radius:14px 0 0 14px;
      background:#34AD38;
    }

    .obs-item.tipo2::before{ background:#CD3434; }

    .obs-top{
      display:flex;
      justify-content:space-between;
      gap:14px;
      align-items:baseline;
    }

    .obs-assunto{
      font-size:18px;
      font-weight:800;
      color:var(--navy);
    }

    .obs-data{
      font-size:12px;
      font-weight:700;
      color:rgba(40,53,101,0.55);
      white-space:nowrap;
    }

    .obs-de{
      margin-top:6px;
      font-size:12px;
      font-weight:700;
      color:rgba(40,53,101,0.65);
    }

    .popup-obs{
      border:3px solid #34AD38;
    }

    .popup-obs.tipo2{
      border-color:#CD3434;
    }

    .popup-user{
      display:flex;
      gap:12px;
      align-items:flex-start;
    }

    .popup-avatar{
      width:44px;
      height:44px;
      border-radius:999px;
      object-fit:cover;
      border:3px solid #f3f4f6;
    }

    .popup-name{
      font-weight:800;
      color:var(--navy);
      font-size:16px;
    }

    .popup-sub{
      font-size:13px;
      color:rgba(40,53,101,0.65);
      font-weight:700;
      margin-top:2px;
    }

    .popup-date{
      font-size:13px;
      font-weight:800;
      color:rgba(40,53,101,0.55);
      white-space:nowrap;
    }

    .popup-body{
      margin-top:14px;
      border-top:1px solid rgba(40,53,101,0.12);
      padding-top:14px;
      color:#1f2937;
      font-size:18px;
      line-height:1.55;
      word-break:break-word;
    }

    .popup-back{
      margin-top:16px;
      display:inline-flex;
      align-items:center;
      gap:10px;
      height:44px;
      padding:0 18px;
      border-radius:14px;
      border:2px solid var(--navy);
      background:#ECF5FF;
      color:var(--navy);
      font-weight:800;
      cursor:pointer;
      transition:filter .15s ease, transform .15s ease;
    }

    .popup-back:hover{
      filter:brightness(0.98);
      transform:translateY(-1px);
    }

    .popup-back .arrow{
      font-size:18px;
      line-height:1;
    }

    @media (max-width: 980px){
      .top-actions-row{
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }

      .main-grid{
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

<main class="page">
  <section class="card">
    <div class="card-header">

      <div class="page-title-row">
        <button class="back-btn" type="button" onclick="history.back()" aria-label="Voltar">←</button>
        <img class="mini-avatar" src="<%= fotoSrc %>" alt="Foto" />
        <h1 class="page-title" style="margin:0;">
          Análise Geral de <%= aluno != null ? aluno.getNome() : "Aluno" %>
        </h1>
      </div>

      <div class="title-line" aria-hidden="true"></div>

      <% if ("1".equals(ok)) { %>
      <div class="alert ok">Notas salvas com sucesso.</div>
      <% } %>

      <% if ("sem_prof".equals(erro)) { %>
      <div class="alert err">Professor não encontrado para salvar as notas.</div>
      <% } %>

      <div class="filter-row">
        <label class="filter-label" for="disciplinaSelect">Disciplina:</label>

        <div class="select-wrap">
          <select name="id_disciplina" id="disciplinaSelect">
            <%
              for (Disciplina d : disciplinas) {
                boolean selecionada = (idDisciplina != null && d.getId_disciplina() == idDisciplina);
            %>
            <option value="<%= d.getId_disciplina() %>" <%= selecionada ? "selected" : "" %>>
              <%= d.getNome() %>
            </option>
            <%
              }
            %>
          </select>
        </div>
      </div>

      <div class="top-actions-row">
        <button class="action-card action-button" type="button" id="btnAbrirPopupNotas">
          <span class="action-ico">✎</span>
          <span>Editar<br />Notas</span>
        </button>

        <div class="info-card">
          <div class="info-number" id="totalObs"><%= totalObs %></div>
          <div class="info-label">Observações</div>
        </div>

        <div class="info-card">
          <div class="info-number" id="totalElogios"><%= totalElogios %></div>
          <div class="info-label">Elogios</div>
        </div>

        <div class="info-card">
          <div class="info-number" id="totalPdm"><%= totalPdm %></div>
          <div class="info-label">Pontos de Melhoria</div>
        </div>

        <a class="action-card action-link"
           href="<%= ctx %>/professor/aluno?id_aluno=<%= aluno != null ? aluno.getId_aluno() : 0 %>">
          <span class="action-ico">⌕</span>
          <span>Ver<br />Observação</span>
        </a>
      </div>

      <div class="main-grid">
        <div class="side-stats">
          <div class="side-box">
            <div class="side-number" id="nota1Box"><%= String.format(java.util.Locale.US, "%.1f", nota1) %></div>
            <div class="side-label">Nota 1</div>
          </div>

          <div class="side-box">
            <div class="side-number" id="nota2Box"><%= String.format(java.util.Locale.US, "%.1f", nota2) %></div>
            <div class="side-label">Nota 2</div>
          </div>

          <div class="side-box">
            <div class="side-number" id="mediaBox"><%= String.format(java.util.Locale.US, "%.1f", mediaDisciplina) %></div>
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

      <div class="chart-card" style="margin-top:14px;">
        <div class="chart-title">Observações da disciplina</div>

        <div class="obs-list" id="obsListDisciplina">
          <%
            if (observacoesAtuais.isEmpty()) {
          %>
          <div class="obs-item" data-de="Sistema" data-data="" data-texto="Nenhuma observação encontrada." data-tipo="1">
            <div class="obs-top">
              <div class="obs-assunto">Nenhuma observação ainda</div>
              <div class="obs-data"></div>
            </div>
            <div class="obs-de">De: Sistema</div>
          </div>
          <%
          } else {
            for (Observacao obs : observacoesAtuais) {
              String mensagem = (obs.getMensagem() != null) ? obs.getMensagem() : "";
              String de = (obs.getNomeProfessor() != null && !obs.getNomeProfessor().isBlank())
                      ? obs.getNomeProfessor()
                      : "Professor";
              String data = (obs.getData() != null) ? obs.getData().format(fmt) : "";
              int tipo = obs.getTipo();
              String cls = (tipo == 2) ? "tipo2" : "";

              String mensagemAttr = mensagem.replace("\"", "&quot;").replace("\n", " ").replace("\r", " ");
              String deAttr = de.replace("\"", "&quot;");
          %>
          <div class="obs-item <%= cls %>"
               data-de="<%= deAttr %>"
               data-data="<%= data %>"
               data-texto="<%= mensagemAttr %>"
               data-tipo="<%= tipo %>">
            <div class="obs-top">
              <div class="obs-assunto"><%= mensagem %></div>
              <div class="obs-data"><%= data %></div>
            </div>
            <div class="obs-de">De: <%= de %></div>
          </div>
          <%
              }
            }
          %>
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
    <span id="popupDisciplinaTitulo">
      <%= aluno != null ? aluno.getNome() : "Aluno" %> -
      <%= disciplinaAtual != null ? disciplinaAtual.getNome() : "Disciplina" %>
    </span>
  </div>

  <form class="popup-form" method="post" action="<%= ctx %>/professor/aluno/notas/salvar">
    <input type="hidden" name="id_aluno" value="<%= aluno != null ? aluno.getId_aluno() : 0 %>">
    <input type="hidden" name="id_disciplina" id="popupIdDisciplina" value="<%= idDisciplina %>">

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
          <%= String.format(java.util.Locale.US, "%.1f", mediaDisciplina) %>
        </div>
      </div>
    </div>

    <div class="popup-actions">
      <button class="btn-ghost" type="button" id="btnCancelarPopupNotas">Cancelar</button>
      <button class="btn-primary" type="submit">Salvar notas</button>
    </div>
  </form>
</div>

<div class="overlay" id="overlayObs"></div>

<div class="popup popup-obs" id="popupObs" aria-hidden="true">
  <div class="popup-head">
    <div class="popup-user">
      <img class="popup-avatar" src="<%= ctx %>/pages/aluno/foto_sem_foto.png" alt="Foto">
      <div>
        <div class="popup-name" id="popDeObs">—</div>
        <div class="popup-sub">Observação da disciplina</div>
      </div>
    </div>

    <div class="popup-date" id="popDataObs">—</div>
  </div>

  <div class="popup-body">
    <div id="popTextoObs">—</div>
  </div>

  <button class="popup-back" id="btnBackObs" type="button">
    <span class="arrow">‹</span> Voltar
  </button>
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
          y: {
            min: 0,
            max: 10,
            ticks: { stepSize: 1 }
          },
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

    if (chart) {
      chart.destroy();
    }
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
  const notasMapJs = {
    <%
  boolean firstNota = true;
  for (Map.Entry<String, NotasAlunoDTO> entry : notasMap.entrySet()) {
    String key = entry.getKey();
    NotasAlunoDTO dto = entry.getValue();

    double n1Val = dto != null ? dto.getN1() : 0.0;
    double n2Val = dto != null ? dto.getN2() : 0.0;
    double mediaVal = dto != null ? dto.getMedia() : ((n1Val + n2Val) / 2.0);

    if (!firstNota) {
%>,<%
  }
%>
    "<%= key %>": {
      n1: <%= String.format(java.util.Locale.US, "%.1f", n1Val) %>,
      n2: <%= String.format(java.util.Locale.US, "%.1f", n2Val) %>,
      media: <%= String.format(java.util.Locale.US, "%.1f", mediaVal) %>
    }
    <%
    firstNota = false;
  }
%>
  };

  const obsTotaisMapJs = {
    <%
  boolean firstObs = true;
  for (Disciplina d : disciplinas) {
    String key = String.valueOf(d.getId_disciplina());

    int tObs = totalObsMap.get(key) != null ? totalObsMap.get(key) : 0;
    int tElog = totalElogiosMap.get(key) != null ? totalElogiosMap.get(key) : 0;
    int tPdm = totalPdmMap.get(key) != null ? totalPdmMap.get(key) : 0;

    if (!firstObs) {
%>,<%
  }
%>
    "<%= key %>": {
      totalObs: <%= tObs %>,
      totalElogios: <%= tElog %>,
      totalPdm: <%= tPdm %>
    }
    <%
    firstObs = false;
  }
%>
  };

  const observacoesMapJs = {
    <%
  boolean firstDiscObs = true;
  for (Disciplina d : disciplinas) {
    String key = String.valueOf(d.getId_disciplina());
    List<Observacao> listaObs = observacoesMap.get(key);
    if (listaObs == null) listaObs = new ArrayList<>();

    if (!firstDiscObs) {
%>,<%
  }
%>
    "<%= key %>": [
      <%
  for (int i = 0; i < listaObs.size(); i++) {
    Observacao obs = listaObs.get(i);

    String mensagem = obs.getMensagem() != null ? obs.getMensagem() : "";
    String de = (obs.getNomeProfessor() != null && !obs.getNomeProfessor().isBlank())
            ? obs.getNomeProfessor()
            : "Professor";
    String data = (obs.getData() != null) ? obs.getData().format(fmt) : "";

    mensagem = mensagem.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", " ").replace("\r", " ");
    de = de.replace("\\", "\\\\").replace("\"", "\\\"");
%>
      {
        mensagem: "<%= mensagem %>",
        de: "<%= de %>",
        data: "<%= data %>",
        tipo: <%= obs.getTipo() %>
      }<%= (i < listaObs.size() - 1 ? "," : "") %>
      <% } %>
    ]
    <%
    firstDiscObs = false;
  }
%>
  };
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

    btnAbrir && btnAbrir.addEventListener("click", abrirPopup);
    btnFechar && btnFechar.addEventListener("click", fecharPopup);
    btnCancelar && btnCancelar.addEventListener("click", fecharPopup);
    overlay && overlay.addEventListener("click", fecharPopup);

    n1 && n1.addEventListener("input", atualizarMedia);
    n2 && n2.addEventListener("input", atualizarMedia);

    document.addEventListener("keydown", function (e) {
      if (e.key === "Escape") fecharPopup();
    });
  })();
</script>

<script>
  (function () {
    const overlay = document.getElementById("overlayObs");
    const popup = document.getElementById("popupObs");
    const btnBack = document.getElementById("btnBackObs");

    const popDe = document.getElementById("popDeObs");
    const popData = document.getElementById("popDataObs");
    const popTexto = document.getElementById("popTextoObs");

    function abrir(item){
      if(!overlay || !popup) return;

      popDe.textContent = item.getAttribute("data-de") || "";
      popData.textContent = item.getAttribute("data-data") || "";
      popTexto.textContent = item.getAttribute("data-texto") || "";

      const tipo = item.getAttribute("data-tipo");
      popup.classList.toggle("tipo2", String(tipo) === "2");

      overlay.classList.add("is-open");
      popup.classList.add("is-open");
      popup.setAttribute("aria-hidden", "false");
      document.body.classList.add("no-scroll");
    }

    function fechar(){
      if(!overlay || !popup) return;
      overlay.classList.remove("is-open");
      popup.classList.remove("is-open");
      popup.setAttribute("aria-hidden", "true");
      document.body.classList.remove("no-scroll");
    }

    function bindObsClicks() {
      document.querySelectorAll("#obsListDisciplina .obs-item").forEach(item => {
        item.onclick = () => abrir(item);
      });
    }

    btnBack && btnBack.addEventListener("click", fechar);

    overlay && overlay.addEventListener("click", (e) => {
      if(e.target === overlay) fechar();
    });

    document.addEventListener("keydown", (e) => {
      if(e.key === "Escape") fechar();
    });

    window.bindObsClicks = bindObsClicks;
    bindObsClicks();
  })();
</script>

<script>
  (function () {
    const disciplinaSelect = document.getElementById("disciplinaSelect");

    const nota1Box = document.getElementById("nota1Box");
    const nota2Box = document.getElementById("nota2Box");
    const mediaBox = document.getElementById("mediaBox");

    const totalObs = document.getElementById("totalObs");
    const totalElogios = document.getElementById("totalElogios");
    const totalPdm = document.getElementById("totalPdm");

    const popupN1 = document.getElementById("popupN1");
    const popupN2 = document.getElementById("popupN2");
    const popupMedia = document.getElementById("popupMedia");
    const popupIdDisciplina = document.getElementById("popupIdDisciplina");
    const popupDisciplinaTitulo = document.getElementById("popupDisciplinaTitulo");

    const obsListDisciplina = document.getElementById("obsListDisciplina");

    const nomeAluno = "<%= aluno != null ? aluno.getNome().replace("\\", "\\\\").replace("\"", "\\\"") : "Aluno" %>";

    function formatarNota(v) {
      return Number(v || 0).toFixed(1);
    }

    function escapeHtml(text) {
      return String(text || "")
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
    }

    function montarObsHtml(lista) {
      if (!lista || lista.length === 0) {
        return `
          <div class="obs-item" data-de="Sistema" data-data="" data-texto="Nenhuma observação encontrada." data-tipo="1">
            <div class="obs-top">
              <div class="obs-assunto">Nenhuma observação ainda</div>
              <div class="obs-data"></div>
            </div>
            <div class="obs-de">De: Sistema</div>
          </div>
        `;
      }

      return lista.map(obs => {
        const cls = Number(obs.tipo) === 2 ? "tipo2" : "";
        const msg = escapeHtml(obs.mensagem || "");
        const de = escapeHtml(obs.de || "Professor");
        const data = escapeHtml(obs.data || "");

        return `
          <div class="obs-item ${cls}" data-de="${de}" data-data="${data}" data-texto="${msg}" data-tipo="${obs.tipo}">
            <div class="obs-top">
              <div class="obs-assunto">${msg}</div>
              <div class="obs-data">${data}</div>
            </div>
            <div class="obs-de">De: ${de}</div>
          </div>
        `;
      }).join("");
    }

    function atualizarTela(idDisc) {
      const nota = notasMapJs[idDisc] || { n1: 0, n2: 0, media: 0 };
      const obs = obsTotaisMapJs[idDisc] || { totalObs: 0, totalElogios: 0, totalPdm: 0 };
      const lista = observacoesMapJs[idDisc] || [];

      nota1Box.textContent = formatarNota(nota.n1);
      nota2Box.textContent = formatarNota(nota.n2);
      mediaBox.textContent = formatarNota(nota.media);

      totalObs.textContent = obs.totalObs || 0;
      totalElogios.textContent = obs.totalElogios || 0;
      totalPdm.textContent = obs.totalPdm || 0;

      popupN1.value = formatarNota(nota.n1);
      popupN2.value = formatarNota(nota.n2);
      popupMedia.textContent = formatarNota(nota.media);
      popupIdDisciplina.value = idDisc;

      const nomeDisciplina = disciplinaSelect.options[disciplinaSelect.selectedIndex]?.text || "Disciplina";
      popupDisciplinaTitulo.textContent = nomeAluno + " - " + nomeDisciplina;

      obsListDisciplina.innerHTML = montarObsHtml(lista);

      if (window.bindObsClicks) {
        window.bindObsClicks();
      }

      const url = new URL(window.location.href);
      url.searchParams.set("id_aluno", "<%= aluno != null ? aluno.getId_aluno() : 0 %>");
      url.searchParams.set("id_disciplina", idDisc);
      window.history.replaceState({}, "", url.toString());
    }

    disciplinaSelect && disciplinaSelect.addEventListener("change", function () {
      atualizarTela(this.value);
    });
  })();
</script>

</body>
</html>