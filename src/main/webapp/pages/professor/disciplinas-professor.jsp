<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.Disciplina" %>

<%
  String ctx = request.getContextPath();

  Disciplina minha = (Disciplina) request.getAttribute("minhaDisciplina");
  if (minha == null) minha = new Disciplina();

  @SuppressWarnings("unchecked")
  List<Disciplina> outras = (List<Disciplina>) request.getAttribute("outrasDisciplinas");
  if (outras == null) outras = new ArrayList<>();

  Integer totalAlunos = (Integer) request.getAttribute("totalAlunos");
  if (totalAlunos == null) totalAlunos = 0;

  String q = request.getParameter("q");
  if (q != null) q = q.trim().toLowerCase();
%>

<!DOCTYPE html>
<html lang="pt-br">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <link rel="icon" type="image/png" href="<%= request.getContextPath() %>/pages/login/minimalismo.png">
  <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
  <link rel="stylesheet" href="<%= ctx %>/pages/professor/turmas-prof.css" />
  <title>Disciplinas - Devant</title>
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
      <a href="<%= ctx %>/pages/login/index.jsp" class="logout-btn">
        Sair
      </a>
    </div>
  </div>
</header>

<main class="page">
  <section class="card">
    <div class="card-header">
      <h1 class="page-title">Disciplinas</h1>
      <div class="title-line" aria-hidden="true"></div>

      <div class="actions-row">
        <div class="actions-left">
          <div class="chip">
            <img src="<%= ctx %>/pages/professor/pessoas.png" style="height: 17.5px; width: 24px">
            <span>Total Alunos: <strong><%= totalAlunos %></strong></span>
          </div>

          <a class="btn-primary" href="<%= ctx %>/professor/alunos">
            Ver alunos <span class="btn-arrow">›</span>
          </a>
        </div>
      </div>

    <div style="margin-top:22px;">
      <a href="<%= ctx %>/professor/disciplina?id_disciplina=<%= minha.getId_disciplina() %>"
         style="font-weight:800; color:#294c56; text-decoration:none;">
        Sua Disciplina
      </a>

      <%
        String nomeMinha = (minha.getNome() != null) ? minha.getNome() : "";
        boolean mostrarMinha = true;
        if (q != null && !q.isEmpty() && !nomeMinha.toLowerCase().contains(q)) mostrarMinha = false;

        if (nomeMinha.isBlank()) {
      %>
      <p style="margin-top:10px; font-weight:700; color: rgba(40,53,101,0.65);">
        Nenhuma disciplina vinculada a este professor.
      </p>
      <%
      } else if (!mostrarMinha) {
      %>
      <p style="margin-top:10px; font-weight:700; color: rgba(40,53,101,0.65);">
        Nenhuma disciplina encontrada na pesquisa.
      </p>
      <%
      } else {
      %>
      <div style="margin-top:12px; display:flex; flex-direction:column; gap:12px;">
        <div style="
                background:#fff;
                border-radius:10px;
                border: 1px solid rgba(40, 53, 101, 0.18);
                border-left: 10px solid #294c56;
                padding: 16px 18px;
                display:flex;
                align-items:center;
                justify-content:space-between;
                box-shadow: 0 10px 18px rgba(40, 53, 101, 0.10);
          ">
            <span style="font-weight:800; font-size:20px; color: var(--navy);">
              <%= nomeMinha %>
            </span>

          <!-- se quiser ação aqui (ex: ver turmas da disciplina), pode colocar -->
          <a href="<%= ctx %>/professor/disciplina?id_disciplina=<%= minha.getId_disciplina() %>"
             style="font-weight:800; color:#294c56; text-decoration:none;">
            Ver Desempenho
          </a>
        </div>
      </div>
      <%
        }
      %>
    </div>

    <!-- ===== Outras Disciplinas ===== -->
    <div style="margin-top:28px;">
      <div style="font-weight:900; color:var(--navy); font-size:18px;">Outras Disciplinas</div>

      <div style="margin-top:12px; display:flex; flex-direction:column; gap:12px;">
        <%
          boolean achou = false;

          for (Disciplina d : outras) {
            String nome = (d.getNome() != null) ? d.getNome() : "";
            if (q != null && !q.isEmpty() && !nome.toLowerCase().contains(q)) continue;

            achou = true;
        %>

        <div style="
              background:#fff;
              border-radius:10px;
              border: 1px solid rgba(40, 53, 101, 0.18);
              border-left: 10px solid #294c56;
              padding: 16px 18px;
              display:flex;
              align-items:center;
              justify-content:space-between;
              box-shadow: 0 10px 18px rgba(40, 53, 101, 0.10);
        ">
          <span style="font-weight:800; font-size:20px; color: var(--navy);">
            <%= nome %>
          </span>

          <a href="<%= ctx %>/professor/disciplina?id_disciplina=<%= d.getId_disciplina() %>"
             style="font-weight:800; color:#294c56; text-decoration:none;">
            Ver Desempenho
          </a>
        </div>

        <%
          }

          if (!achou) {
        %>
        <p style="margin-top:10px; font-weight:700; color: rgba(40,53,101,0.65);">
          Nenhuma disciplina encontrada.
        </p>
        <%
          }
        %>
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

</body>
</html>