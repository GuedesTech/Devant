<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.example.secretariaescolar.model.Observacao" %>
<%@ page import="com.example.secretariaescolar.model.Aluno" %>
<%@ page import="com.example.secretariaescolar.model.Disciplina" %>

<%
  String ctx = request.getContextPath();

  Aluno aluno = (Aluno) request.getAttribute("aluno");
  Disciplina disciplinaProfessor = (Disciplina) request.getAttribute("disciplinaProfessor");

  @SuppressWarnings("unchecked")
  List<Observacao> observacoes = (List<Observacao>) request.getAttribute("observacoes");
  if (observacoes == null) observacoes = new ArrayList<>();

  Integer totalObs = (Integer) request.getAttribute("totalObs");
  Integer totalElogios = (Integer) request.getAttribute("totalElogios");
  Integer totalPdm = (Integer) request.getAttribute("totalPdm");
  Integer idProfessorLogado = (Integer) request.getAttribute("idProfessorLogado");

  if (totalObs == null) totalObs = 0;
  if (totalElogios == null) totalElogios = 0;
  if (totalPdm == null) totalPdm = 0;
  if (idProfessorLogado == null) idProfessorLogado = 0;

  String ok = request.getParameter("ok");
  String erro = request.getParameter("erro");

  DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM");

  String foto = (aluno != null) ? aluno.getFoto() : null;

  boolean semFoto = (foto == null) || foto.isBlank()
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
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/pages/login/minimalismo.png">
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <title>Histórico de Observações - Devant</title>

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

    .stats-row{
      margin-top:18px;
      display:grid;
      grid-template-columns: repeat(4, minmax(0, 1fr));
      gap:14px;
      align-items:stretch;
    }

    .stat-card,
    .add-card{
      background:#fff;
      border-radius:14px;
      border:1px solid rgba(40,53,101,0.12);
      box-shadow:0 10px 18px rgba(40,53,101,0.08);
      min-height:92px;
      padding:14px 16px;
      position:relative;
    }

    .stat-card{
      text-align:center;
      display:flex;
      flex-direction:column;
      justify-content:center;
    }

    .stat-card::before{
      content:"";
      position:absolute;
      left:0;
      top:0;
      bottom:0;
      width:6px;
      border-radius:14px 0 0 14px;
      background:#274855;
    }

    .stat-card.green::before{ background:#34AD38; }
    .stat-card.red::before{ background:#CD3434; }

    .stat-number{
      font-size:28px;
      font-weight:900;
      color:var(--navy);
      line-height:1.1;
    }

    .stat-label{
      margin-top:6px;
      font-size:13px;
      font-weight:800;
      color:rgba(40,53,101,0.60);
    }

    .add-card{
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
      cursor:pointer;
      border:none;
    }

    .add-icon{
      font-size:32px;
      line-height:1;
    }

    .chip-info{
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

    .obs-list{
      margin-top:18px;
      display:flex;
      flex-direction:column;
      gap:10px;
    }

    .obs-item{
      width:100%;
      border:1px solid rgba(40,53,101,0.12);
      border-radius:14px;
      background:#fff;
      padding:14px 16px;
      box-shadow:0 10px 18px rgba(40,53,101,0.08);
      cursor:pointer;
      position:relative;
      transition:transform .12s ease, filter .12s ease;
      display:grid;
      grid-template-columns: 1fr auto;
      gap:10px;
      align-items:center;
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

    .obs-main{
      min-width:0;
    }

    .obs-top{
      display:flex;
      align-items:center;
      justify-content:space-between;
      gap:14px;
    }

    .obs-de{
      font-size:15px;
      font-weight:800;
      color:var(--navy);
      white-space:nowrap;
      overflow:hidden;
      text-overflow:ellipsis;
    }

    .obs-data{
      font-size:12px;
      font-weight:800;
      color:rgba(40,53,101,0.55);
      white-space:nowrap;
    }

    .obs-msg{
      margin-top:6px;
      font-size:13px;
      font-weight:700;
      color:rgba(40,53,101,0.72);
      white-space:nowrap;
      overflow:hidden;
      text-overflow:ellipsis;
    }

    .obs-actions{
      display:flex;
      align-items:center;
      gap:8px;
      position:relative;
      z-index:2;
    }

    .icon-btn{
      width:34px;
      height:34px;
      border-radius:10px;
      border:1px solid rgba(40,53,101,0.14);
      background:#fff;
      display:inline-flex;
      align-items:center;
      justify-content:center;
      cursor:pointer;
      box-shadow:0 6px 12px rgba(40,53,101,0.05);
    }

    .empty-box{
      background:#fff;
      border:1px solid rgba(40,53,101,0.12);
      border-radius:14px;
      padding:18px;
      box-shadow:0 10px 18px rgba(40,53,101,0.08);
      font-weight:800;
      color:rgba(40,53,101,0.70);
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

    .overlay{
      position:fixed;
      inset:0;
      background:rgba(0,0,0,0.40);
      display:none;
      align-items:center;
      justify-content:center;
      padding:18px;
      z-index:9998;
    }

    .overlay.is-open{
      display:flex;
    }

    .popup{
      background:#fff;
      width:min(980px, 96vw);
      border-radius:18px;
      box-shadow:0 20px 40px rgba(0,0,0,0.20);
      padding:18px 18px 22px;
      position:relative;
      border:3px solid #34AD38;
    }

    .popup.tipo2{ border-color:#CD3434; }

    .popup-head{
      display:flex;
      justify-content:space-between;
      gap:12px;
      align-items:flex-start;
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

    .popup-form-title{
      margin:0 0 10px 0;
      font-size:18px;
      font-weight:900;
      color:var(--navy);
    }

    .field{
      display:flex;
      flex-direction:column;
      gap:6px;
      margin-top:14px;
    }

    .field span{
      font-weight:900;
      color:var(--navy);
      font-size:13px;
    }

    .field textarea{
      min-height:120px;
      border-radius:12px;
      border:1px solid rgba(40,53,101,0.18);
      padding:12px;
      font-weight:700;
      color:#1f2937;
      outline:none;
      resize:vertical;
    }

    .radio-row{
      display:flex;
      gap:18px;
      flex-wrap:wrap;
      margin-top:14px;
    }

    .radio-item{
      display:flex;
      align-items:center;
      gap:8px;
      font-weight:800;
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

    .btn-danger{
      height:38px;
      display:inline-flex;
      align-items:center;
      gap:10px;
      padding:0 16px;
      border-radius:12px;
      background:#CD3434;
      color:#fff;
      text-decoration:none;
      font-weight:900;
      border:0;
      cursor:pointer;
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

    .no-scroll{ overflow:hidden; }

    @media (max-width: 980px){
      .stats-row{
        grid-template-columns: repeat(2, minmax(0, 1fr));
      }
    }

    @media (max-width: 640px){
      .stats-row{
        grid-template-columns: 1fr;
      }

      .obs-item{
        grid-template-columns: 1fr;
      }

      .obs-actions{
        justify-content:flex-end;
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
          Histórico de Observações de <%= aluno != null ? aluno.getNome() : "Aluno" %>
        </h1>
      </div>

      <div class="title-line" aria-hidden="true"></div>

      <% if ("1".equals(ok)) { %>
      <div class="alert ok">Observação adicionada com sucesso.</div>
      <% } %>

      <% if ("2".equals(ok)) { %>
      <div class="alert ok">Observação editada com sucesso.</div>
      <% } %>

      <% if ("3".equals(ok)) { %>
      <div class="alert ok">Observação excluída com sucesso.</div>
      <% } %>

      <% if ("1".equals(erro)) { %>
      <div class="alert err">Não foi possível adicionar a observação.</div>
      <% } %>

      <% if ("2".equals(erro)) { %>
      <div class="alert err">Não foi possível editar a observação.</div>
      <% } %>

      <% if ("3".equals(erro)) { %>
      <div class="alert err">Não foi possível excluir a observação.</div>
      <% } %>

      <% if ("permissao".equals(erro)) { %>
      <div class="alert err">Você só pode editar ou excluir observações criadas por você.</div>
      <% } %>

      <% if (disciplinaProfessor != null) { %>
      <div class="chip-info">
        Nova observação será enviada em: <strong><%= disciplinaProfessor.getNome() %></strong>
      </div>
      <% } %>

      <div class="stats-row">
        <div class="stat-card">
          <div class="stat-number"><%= totalObs %></div>
          <div class="stat-label">Observações</div>
        </div>

        <div class="stat-card green">
          <div class="stat-number"><%= totalElogios %></div>
          <div class="stat-label">Elogios</div>
        </div>

        <div class="stat-card red">
          <div class="stat-number"><%= totalPdm %></div>
          <div class="stat-label">Pontos de Melhoria</div>
        </div>

        <button class="add-card" type="button" id="btnAbrirNovaObs">
          <div class="add-icon">⊕</div>
          <div>Adicionar<br>Observação</div>
        </button>
      </div>
    </div>

    <div class="obs-list" id="obsList">
      <%
        if (observacoes.isEmpty()) {
      %>
      <div class="empty-box">Nenhuma observação encontrada para este aluno.</div>
      <%
      } else {
        for (Observacao obs : observacoes) {
          String mensagem = (obs.getMensagem() != null) ? obs.getMensagem() : "";
          String de = (obs.getNomeProfessor() != null && !obs.getNomeProfessor().isBlank())
                  ? obs.getNomeProfessor()
                  : "Professor";

          String data = (obs.getData() != null) ? obs.getData().format(fmt) : "";
          int tipo = obs.getTipo();
          String cls = (tipo == 2) ? "tipo2" : "";

          String mensagemAttr = mensagem
                  .replace("&", "&amp;")
                  .replace("\"", "&quot;")
                  .replace("'", "&#39;")
                  .replace("<", "&lt;")
                  .replace(">", "&gt;")
                  .replace("\n", " ")
                  .replace("\r", " ");

          String deAttr = de.replace("\"", "&quot;");
          boolean podeEditar = obs.getId_professor() == idProfessorLogado;
      %>
      <div class="obs-item <%= cls %>"
           data-id-observacao="<%= obs.getId_observacao() %>"
           data-de="<%= deAttr %>"
           data-data="<%= data %>"
           data-texto="<%= mensagemAttr %>"
           data-tipo="<%= tipo %>">

        <div class="obs-main">
          <div class="obs-top">
            <div class="obs-de">De: <%= de %></div>
            <div class="obs-data"><%= data %></div>
          </div>
          <div class="obs-msg"><%= mensagem %></div>
        </div>

        <% if (podeEditar) { %>
        <div class="obs-actions">
          <button class="icon-btn btn-editar-obs"
                  type="button"
                  data-id-observacao="<%= obs.getId_observacao() %>"
                  data-mensagem="<%= mensagemAttr %>"
                  data-tipo="<%= tipo %>">
            <img src="<%= ctx %>/pages/adm/edit.png" style="width: 20px; height: 20px">
          </button>

          <button class="icon-btn btn-excluir-obs"
                  type="button"
                  data-id-observacao="<%= obs.getId_observacao() %>">
            <img src="<%= ctx %>/pages/adm/delete.png" style="width: 17px; height: 20px">
          </button>
        </div>
        <% } %>
      </div>
      <%
          }
        }
      %>
    </div>
  </section>
</main>

<div class="overlay" id="overlayLeitura">
  <div class="popup" id="popupLeitura" role="dialog" aria-modal="true" aria-label="Detalhe da observação">
    <div class="popup-head">
      <div class="popup-user">
        <img class="popup-avatar" src="<%= ctx %>/pages/aluno/foto_sem_foto.png" alt="Foto">
        <div>
          <div class="popup-name" id="popDe">—</div>
          <div class="popup-sub">Para: <%= aluno != null ? aluno.getNome() : "Aluno" %></div>
        </div>
      </div>

      <div class="popup-date" id="popData">—</div>
    </div>

    <div class="popup-body">
      <div id="popTexto">—</div>
    </div>

    <button class="popup-back" id="btnFecharLeitura" type="button">
      <span class="arrow">‹</span> Voltar
    </button>
  </div>
</div>

<div class="overlay" id="overlayNova">
  <div class="popup" role="dialog" aria-modal="true" aria-label="Adicionar observação">
    <h2 class="popup-form-title">Adicionar observação para <%= aluno != null ? aluno.getNome() : "Aluno" %></h2>

    <form method="post" action="<%= ctx %>/professor/observacao/nova">
      <input type="hidden" name="id_aluno" value="<%= aluno != null ? aluno.getId_aluno() : 0 %>">

      <div class="chip-info" style="margin-top:0;">
        Disciplina automática:
        <strong><%= disciplinaProfessor != null ? disciplinaProfessor.getNome() : "—" %></strong>
      </div>

      <div class="radio-row">
        <label class="radio-item">
          <input type="radio" name="tipo" value="1" checked>
          Elogio
        </label>

        <label class="radio-item">
          <input type="radio" name="tipo" value="2">
          Ponto de melhoria
        </label>
      </div>

      <label class="field">
        <span>Observação</span>
        <textarea name="mensagem" required placeholder="Digite a observação..."></textarea>
      </label>

      <div class="popup-actions">
        <button class="btn-ghost" type="button" id="btnFecharNovaObs">Cancelar</button>
        <button class="btn-primary" type="submit">Salvar observação</button>
      </div>
    </form>
  </div>
</div>

<div class="overlay" id="overlayEditar">
  <div class="popup" role="dialog" aria-modal="true" aria-label="Editar observação">
    <h2 class="popup-form-title">Editar observação</h2>

    <form method="post" action="<%= ctx %>/professor/observacao/editar">
      <input type="hidden" name="id_observacao" id="editIdObservacao">
      <input type="hidden" name="id_aluno" value="<%= aluno != null ? aluno.getId_aluno() : 0 %>">

      <div class="radio-row">
        <label class="radio-item">
          <input type="radio" name="tipo" value="1" id="editTipo1">
          Elogio
        </label>

        <label class="radio-item">
          <input type="radio" name="tipo" value="2" id="editTipo2">
          Ponto de melhoria
        </label>
      </div>

      <label class="field">
        <span>Observação</span>
        <textarea name="mensagem" id="editMensagem" required></textarea>
      </label>

      <div class="popup-actions">
        <button class="btn-ghost" type="button" id="btnFecharEditarObs">Cancelar</button>
        <button class="btn-primary" type="submit">Salvar alterações</button>
      </div>
    </form>
  </div>
</div>

<div class="overlay" id="overlayExcluir">
  <div class="popup" role="dialog" aria-modal="true" aria-label="Excluir observação">
    <h2 class="popup-form-title">Excluir observação</h2>

    <p style="margin-top:12px; font-weight:800; color:rgba(40,53,101,0.75);">
      Tem certeza que deseja excluir esta observação?
    </p>

    <form method="post" action="<%= ctx %>/professor/observacao/excluir">
      <input type="hidden" name="id_observacao" id="deleteIdObservacao">
      <input type="hidden" name="id_aluno" value="<%= aluno != null ? aluno.getId_aluno() : 0 %>">

      <div class="popup-actions">
        <button class="btn-ghost" type="button" id="btnFecharExcluirObs">Cancelar</button>
        <button class="btn-danger" type="submit">Excluir</button>
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

    function abrirOverlay(id) {
        const overlay = document.getElementById(id);
        if (!overlay) return;
        overlay.classList.add("is-open");
        document.body.classList.add("no-scroll");
    }

    function fecharOverlay(id) {
        const overlay = document.getElementById(id);
        if (!overlay) return;
        overlay.classList.remove("is-open");
        document.body.classList.remove("no-scroll");
    }

    (function () {
        const overlay = document.getElementById("overlayLeitura");
        const popup = document.getElementById("popupLeitura");
        const btnFechar = document.getElementById("btnFecharLeitura");

        const popDe = document.getElementById("popDe");
        const popData = document.getElementById("popData");
        const popTexto = document.getElementById("popTexto");

        function abrir(item){
            popDe.textContent = item.getAttribute("data-de") || "";
            popData.textContent = item.getAttribute("data-data") || "";
            popTexto.textContent = item.getAttribute("data-texto") || "";

            const tipo = item.getAttribute("data-tipo");
            popup.classList.toggle("tipo2", String(tipo) === "2");

            abrirOverlay("overlayLeitura");
        }

        function fechar(){
            fecharOverlay("overlayLeitura");
        }

        document.querySelectorAll(".obs-item").forEach(item => {
            item.addEventListener("click", (e) => {
                if (e.target.closest(".obs-actions")) return;
                abrir(item);
            });
        });

        btnFechar && btnFechar.addEventListener("click", fechar);
        overlay && overlay.addEventListener("click", (e) => {
            if (e.target === overlay) fechar();
        });
    })();

    (function () {
        const btnAbrir = document.getElementById("btnAbrirNovaObs");
        const btnFechar = document.getElementById("btnFecharNovaObs");
        const overlay = document.getElementById("overlayNova");

        btnAbrir && btnAbrir.addEventListener("click", () => abrirOverlay("overlayNova"));
        btnFechar && btnFechar.addEventListener("click", () => fecharOverlay("overlayNova"));

        overlay && overlay.addEventListener("click", (e) => {
            if (e.target === overlay) fecharOverlay("overlayNova");
        });
    })();

    (function () {
        const overlay = document.getElementById("overlayEditar");
        const btnFechar = document.getElementById("btnFecharEditarObs");
        const editId = document.getElementById("editIdObservacao");
        const editMensagem = document.getElementById("editMensagem");
        const editTipo1 = document.getElementById("editTipo1");
        const editTipo2 = document.getElementById("editTipo2");

        document.querySelectorAll(".btn-editar-obs").forEach(btn => {
            btn.addEventListener("click", (e) => {
                e.stopPropagation();

                const id = btn.getAttribute("data-id-observacao") || "";
                const mensagem = btn.getAttribute("data-mensagem") || "";
                const tipo = btn.getAttribute("data-tipo") || "1";

                editId.value = id;
                editMensagem.value = mensagem;

                editTipo1.checked = String(tipo) === "1";
                editTipo2.checked = String(tipo) === "2";

                abrirOverlay("overlayEditar");
            });
        });

        btnFechar && btnFechar.addEventListener("click", () => fecharOverlay("overlayEditar"));

        overlay && overlay.addEventListener("click", (e) => {
            if (e.target === overlay) fecharOverlay("overlayEditar");
        });
    })();

    (function () {
        const overlay = document.getElementById("overlayExcluir");
        const btnFechar = document.getElementById("btnFecharExcluirObs");
        const deleteId = document.getElementById("deleteIdObservacao");

        document.querySelectorAll(".btn-excluir-obs").forEach(btn => {
            btn.addEventListener("click", (e) => {
                e.stopPropagation();
                deleteId.value = btn.getAttribute("data-id-observacao") || "";
                abrirOverlay("overlayExcluir");
            });
        });

        btnFechar && btnFechar.addEventListener("click", () => fecharOverlay("overlayExcluir"));

        overlay && overlay.addEventListener("click", (e) => {
            if (e.target === overlay) fecharOverlay("overlayExcluir");
        });
    })();

    document.addEventListener("keydown", (e) => {
        if (e.key === "Escape") {
            fecharOverlay("overlayLeitura");
            fecharOverlay("overlayNova");
            fecharOverlay("overlayEditar");
            fecharOverlay("overlayExcluir");
        }
    });
</script>

</body>
</html>