<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="com.example.secretariaescolar.model.Observacao" %>
<%@ page import="com.example.secretariaescolar.model.Aluno" %>

<%
    String ctx = request.getContextPath();

    // ✅ Agora tipado corretamente
    List<Observacao> observacoes = (List<Observacao>) request.getAttribute("observacoes");

    Integer totalObs = (Integer) request.getAttribute("totalObs");
    Integer totalElogios = (Integer) request.getAttribute("totalElogios");
    Integer totalPdm = (Integer) request.getAttribute("totalPdm");

    if (totalObs == null) totalObs = 0;
    if (totalElogios == null) totalElogios = 0;
    if (totalPdm == null) totalPdm = 0;

    if (observacoes == null) observacoes = new ArrayList<>();

    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM");

    Aluno aluno = (Aluno) request.getAttribute("aluno");

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
    <link rel="icon" href="<%= ctx %>/assets/Group 551.ico" />
    <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
    <title>Observações - Devant</title>

    <style>
        .back-btn{
            width: 40px;
            height: 40px;
            border-radius: 999px;
            border: 0;
            background: transparent;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: var(--navy);
            font-size: 24px;
            line-height: 3;
        }

        .stats-row{
            margin-top: 18px;
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }

        .stat-card{
            background: #fff;
            border-radius: 14px;
            padding: 14px 18px;
            min-width: 180px;
            box-shadow: 0 10px 18px rgba(40, 53, 101, 0.08);
            border: 1px solid rgba(40,53,101,0.12);
            position: relative;
        }

        .stat-card::before{
            content:"";
            position:absolute;
            left:0;
            top:0;
            bottom:0;
            width: 6px;
            border-radius: 14px 0 0 14px;
            background: #274855;
        }

        .stat-card.red::before{ background:#CD3434; }
        .stat-card.green::before{ background:#34AD38; }

        .stat-number{
            font-size: 24px;
            font-weight: 800;
            color: var(--navy);
            line-height: 1.1;
        }

        .stat-label{
            margin-top: 4px;
            font-size: 12px;
            font-weight: 600;
            color: rgba(40,53,101,0.65);
        }

        .search-box{
            margin-left: auto;
            display: flex;
            align-items: center;
            border: 2px solid var(--navy);
            border-radius: 12px;
            padding: 8px 12px;
            height: 44px;
            width: min(340px, 100%);
            background: transparent;
        }

        .search-box input{
            border: 0;
            outline: none;
            width: 100%;
            background: transparent;
            font-family: inherit;
            font-size: 14px;
            color: var(--navy);
        }

        .obs-list{
            margin-top: 18px;
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .obs-item{
            width: 100%;
            border: 1px solid rgba(40,53,101,0.12);
            border-radius: 14px;
            background: #fff;
            padding: 16px 18px;
            box-shadow: 0 10px 18px rgba(40, 53, 101, 0.08);
            cursor: pointer;
            position: relative;
            transition: transform .12s ease, filter .12s ease;
        }

        .obs-item:hover{
            transform: translateY(-1px);
            filter: brightness(1.01);
        }

        /* tipo 1 (bom) verde, tipo 2 (ruim) vermelho */
        .obs-item::before{
            content:"";
            position:absolute;
            left:0;
            top:0;
            bottom:0;
            width: 6px;
            border-radius: 14px 0 0 14px;
            background: #34AD38;
        }
        .obs-item.tipo2::before{ background:#CD3434; }

        .obs-top{
            display:flex;
            justify-content: space-between;
            gap: 14px;
            align-items: baseline;
        }

        .obs-assunto{
            font-size: 18px;
            font-weight: 800;
            color: var(--navy);
        }

        .obs-data{
            font-size: 12px;
            font-weight: 700;
            color: rgba(40,53,101,0.55);
            white-space: nowrap;
        }

        .obs-de{
            margin-top: 6px;
            font-size: 12px;
            font-weight: 700;
            color: rgba(40,53,101,0.65);
        }

        .overlay{
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.4);
            display: none;
            align-items: center;
            justify-content: center;
            padding: 18px;
            z-index: 999;
        }
        .overlay.is-open{ display:flex; }

        .popup{
            background: #fff;
            width: min(980px, 96vw);
            border-radius: 18px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.20);
            padding: 18px 18px 22px;
            position: relative;
            border: 3px solid #34AD38;
        }
        .popup.tipo2{ border-color: #CD3434; }

        .popup-head{
            display:flex;
            justify-content: space-between;
            gap: 12px;
            align-items: flex-start;
        }

        .popup-user{
            display:flex;
            gap: 12px;
            align-items: flex-start;
        }

        .popup-avatar{
            width: 44px;
            height: 44px;
            border-radius: 999px;
            object-fit: cover;
            border: 3px solid #f3f4f6;
        }

        .popup-name{
            font-weight: 800;
            color: var(--navy);
            font-size: 16px;
        }

        .popup-sub{
            font-size: 13px;
            color: rgba(40,53,101,0.65);
            font-weight: 700;
            margin-top: 2px;
        }

        .popup-date{
            font-size: 13px;
            font-weight: 800;
            color: rgba(40,53,101,0.55);
            white-space: nowrap;
        }

        .popup-body{
            margin-top: 14px;
            border-top: 1px solid rgba(40,53,101,0.12);
            padding-top: 14px;
            color: #1f2937;
            font-size: 18px;
            line-height: 1.55;
            word-break: break-word;
        }

        .popup-back{
            margin-top: 16px;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            height: 44px;
            padding: 0 18px;
            border-radius: 14px;
            border: 2px solid var(--navy);
            background: #ECF5FF;
            color: var(--navy);
            font-weight: 800;
            cursor: pointer;
            transition: filter .15s ease, transform .15s ease;
        }
        .popup-back:hover{
            filter: brightness(0.98);
            transform: translateY(-1px);
        }
        .popup-back .arrow{
            font-size: 18px;
            line-height: 1;
        }

        .topbar-nav{ position: relative; }
        .nav-indicador{
            position:absolute;
            bottom: -12px;
            left: 0;
            height: 6px;
            border-radius: 999px;
            background: var(--white);
            opacity: .95;
            transition: all .35s ease;
        }

        .page-title-row{
            display: flex;
            align-items: center;
            gap: 12px;
            margin-top: 6px;
        }

        .back-btn{
            width: 40px;
            height: 40px;
            border-radius: 999px;
            border: 0;
            background: transparent;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            color: var(--navy);
            font-size: 24px;
            line-height: 1; /* ✅ importante (o seu tá 3 e desalinha) */
        }

        .mini-avatar{
            width: 34px;
            height: 34px;
            border-radius: 999px;
            object-fit: cover;
            border: 2px solid rgba(40,53,101,0.15);
        }
    </style>
</head>

<body>
<header class="topbar">
    <div class="topbar-inner">
        <a class="topbar-left" href="<%= ctx %>/aluno/perfil" aria-label="Voltar ao início">
            <img class="topbar-logo" src="<%= ctx %>/pages/assets/logo.png" alt="Logo Devant">
        </a>

        <nav class="topbar-nav" aria-label="Navegação principal">
            <a class="topbar-link" href="<%= ctx %>/aluno/perfil">Perfil</a>
            <a class="topbar-link" href="<%= ctx %>/aluno/disciplinas">Disciplinas</a>
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
                <img class="mini-avatar" src="<%= fotoSrc %>" alt="Foto">
                <h1 class="page-title" style="margin:0;">Observações</h1>
            </div>

            <div class="title-line" aria-hidden="true"></div>

            <div class="stats-row">
                <div class="stat-card">
                    <div class="stat-number"><%= totalObs %></div>
                    <div class="stat-label">Observações recebidas</div>
                </div>

                <div class="stat-card green">
                    <div class="stat-number"><%= totalElogios %></div>
                    <div class="stat-label">Elogios recebidos</div>
                </div>

                <div class="stat-card red">
                    <div class="stat-number"><%= totalPdm %></div>
                    <div class="stat-label">Pontos de melhoria</div>
                </div>

                <div class="search-box">
                    <input id="buscaObs" type="text" placeholder="Pesquisar observação..." />
                </div>
            </div>
        </div>

        <div class="obs-list" id="obsList">

            <%
                if (observacoes.isEmpty()) {
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
                for (Observacao obs : observacoes) {

                    String mensagem = (obs.getMensagem() != null) ? obs.getMensagem() : "";
                    String de = (obs.getNomeProfessor() != null && !obs.getNomeProfessor().isBlank())
                            ? obs.getNomeProfessor()
                            : "Professor";

                    String data = (obs.getData() != null) ? obs.getData().format(fmt) : "";
                    int tipo = obs.getTipo(); // 1 ou 2

                    String cls = (tipo == 2) ? "tipo2" : "";

                    // escape simples para não quebrar atributo HTML
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

    </section>
</main>

<div class="overlay" id="overlay">
    <div class="popup" id="popup" role="dialog" aria-modal="true" aria-label="Detalhe da observação">
        <div class="popup-head">
            <div class="popup-user">
                <img class="popup-avatar" src="<%= ctx %>/pages/aluno/foto_sem_foto.png" alt="Foto">
                <div>
                    <div class="popup-name" id="popDe">—</div>
                    <div class="popup-sub" id="popPara">Para: você</div>
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

<script>
    // Indicador animado no header
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

        moverPara(links[0]);
        window.addEventListener("resize", () => moverPara(links[0]));

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

    // Busca simples
    (function(){
        const input = document.getElementById("buscaObs");
        const list = document.getElementById("obsList");
        if(!input || !list) return;

        input.addEventListener("input", () => {
            const q = input.value.toLowerCase().trim();
            const items = list.querySelectorAll(".obs-item");
            items.forEach(it => {
                const msg = (it.querySelector(".obs-assunto")?.textContent || "").toLowerCase();
                const de = (it.getAttribute("data-de") || "").toLowerCase();
                const show = msg.includes(q) || de.includes(q);
                it.style.display = show ? "" : "none";
            });
        });
    })();

    // Popup
    (function(){
        const overlay = document.getElementById("overlay");
        const popup = document.getElementById("popup");
        const btnBack = document.getElementById("btnBack");

        const popDe = document.getElementById("popDe");
        const popData = document.getElementById("popData");
        const popTexto = document.getElementById("popTexto");

        function abrir(item){
            if(!overlay || !popup) return;

            popDe.textContent = item.getAttribute("data-de") || "";
            popData.textContent = item.getAttribute("data-data") || "";
            popTexto.textContent = item.getAttribute("data-texto") || "";

            const tipo = item.getAttribute("data-tipo");
            popup.classList.toggle("tipo2", String(tipo) === "2");

            overlay.classList.add("is-open");
        }

        function fechar(){
            if(!overlay) return;
            overlay.classList.remove("is-open");
        }

        document.querySelectorAll(".obs-item").forEach(item => {
            item.addEventListener("click", () => abrir(item));
        });

        btnBack && btnBack.addEventListener("click", fechar);

        overlay && overlay.addEventListener("click", (e) => {
            if(e.target === overlay) fechar();
        });

        document.addEventListener("keydown", (e) => {
            if(e.key === "Escape") fechar();
        });
    })();
</script>

</body>
</html>