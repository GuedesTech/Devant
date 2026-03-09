<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.example.secretariaescolar.model.Aluno" %>
<%@ page import="com.example.secretariaescolar.model.MediaDisciplina" %>

<%
    String ctx = request.getContextPath();

    // ===== Dados vindos do servlet =====
    Aluno aluno = (Aluno) request.getAttribute("aluno");

    // Geral (usado nos cards e fallback)
    List<MediaDisciplina> medias =
            (List<MediaDisciplina>) request.getAttribute("medias");

    // Novos: usados pelos botões do gráfico
    List<MediaDisciplina> mediasGeral =
            (List<MediaDisciplina>) request.getAttribute("mediasGeral");

    List<MediaDisciplina> mediasS1 =
            (List<MediaDisciplina>) request.getAttribute("mediasS1");

    List<MediaDisciplina> mediasS2 =
            (List<MediaDisciplina>) request.getAttribute("mediasS2");

    Integer acima7 = (Integer) request.getAttribute("acima7");
    Integer abaixo7 = (Integer) request.getAttribute("abaixo7");
    Double mediaGeral = (Double) request.getAttribute("mediaGeral");

    // ===== Proteção contra null =====
    if (medias == null) medias = new ArrayList<>();
    if (mediasGeral == null) mediasGeral = new ArrayList<>();
    if (mediasS1 == null) mediasS1 = new ArrayList<>();
    if (mediasS2 == null) mediasS2 = new ArrayList<>();

    if (acima7 == null) acima7 = 0;
    if (abaixo7 == null) abaixo7 = 0;
    if (mediaGeral == null) mediaGeral = 0.0;

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
    <title>Notas - Devant</title>

    <style>
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
            line-height: 3;
        }
        .mini-avatar{
            width: 34px;
            height: 34px;
            border-radius: 999px;
            object-fit: cover;
            border: 2px solid rgba(40,53,101,0.15);
        }

        .cards-row{
            margin-top: 18px;
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 12px;
        }
        .disc-card{
            background: #fff;
            border-radius: 12px;
            padding: 12px 14px;
            border: 1px solid rgba(40,53,101,0.12);
            box-shadow: 0 10px 18px rgba(40, 53, 101, 0.08);
            position: relative;
            min-height: 85px;
            font-size: 30px;
        }
        .disc-card::before{
            content:"";
            position:absolute;
            left:0; top:0; bottom:0;
            width: 6px;
            border-radius: 12px 0 0 12px;
            background: #34AD38; /* default bom */
        }
        .disc-card.atencao::before{ background: #CD3434; }

        .disc-nome{
            font-weight: 800;
            color: var(--navy);
            font-size: 18px;
            line-height: 1.25;
        }
        .disc-sub{
            margin-top: 4px;
            font-size: 13px;
            font-weight: 700;
            color: rgba(40,53,101,0.60);
        }

        .grid-main{
            margin-top: 14px;
            display: grid;
            grid-template-columns: 1fr 220px;
            gap: 14px;
            align-items: start;
        }

        .chart-card{
            background:#fff;
            border-radius: 14px;
            border: 1px solid rgba(40,53,101,0.12);
            box-shadow: 0 10px 18px rgba(40, 53, 101, 0.08);
            padding: 14px;
        }

        .chart-head{
            display:flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
        }
        .chart-title{
            font-weight: 800;
            color: var(--navy);
            font-size: 14px;
        }
        .tabs{
            display:flex;
            gap: 8px;
        }
        .tab{
            border:0;
            background: #EEF3FF;
            color: var(--navy);
            font-weight: 800;
            font-size: 12px;
            padding: 6px 10px;
            border-radius: 10px;
            cursor: pointer;
            opacity: 0.9;
        }
        .tab.is-active{
            background: #E2EAFF;
            opacity: 1;
        }

        .chart-wrap{
            margin-top: 10px;
            height: 260px;
        }

        .side-stats{
            display:flex;
            flex-direction: column;
            gap: 12px;
        }
        .side-box{
            background:#fff;
            border-radius: 14px;
            border: 1px solid rgba(40,53,101,0.12);
            box-shadow: 0 10px 18px rgba(40, 53, 101, 0.08);
            padding: 20px;
            text-align: center;
        }
        .side-number{
            font-weight: 900;
            color: var(--navy);
            font-size: 25px;
            line-height: 1.1;
        }
        .side-label{
            margin-top: 6px;
            font-weight: 800;
            font-size: 15px;
            color: rgba(40,53,101,0.60);
        }

        .topbar-nav{ position: relative; }
        .nav-indicador{
            left: 0;
            height: 6px;
            border-radius: 999px;
            background: var(--white);
            opacity: .95;
            transition: all .35s ease;
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

            <div class="page-title-row">
                <button class="back-btn" type="button" onclick="history.back()" aria-label="Voltar">←</button>
                <img class="mini-avatar" src="<%= fotoSrc %>" alt="Foto">
                <h1 class="page-title" style="margin:0;">Suas Notas</h1>
            </div>

            <div class="title-line" aria-hidden="true"></div>

            <%
                MediaDisciplina cardDestaque = (MediaDisciplina) request.getAttribute("cardDestaque");
                MediaDisciplina cardAtencao = (MediaDisciplina) request.getAttribute("cardAtencao");

                String discMaiorEvolucao = (String) request.getAttribute("discMaiorEvolucao");
                Double maiorEvolucao = (Double) request.getAttribute("maiorEvolucao");

                String discMaiorRegressao = (String) request.getAttribute("discMaiorRegressao");
                Double maiorRegressao = (Double) request.getAttribute("maiorRegressao");

                if (maiorEvolucao == null) maiorEvolucao = 0.0;
                if (maiorRegressao == null) maiorRegressao = 0.0;
            %>

            <div class="cards-row">

                <div class="disc-card">
                    <div class="disc-nome"><%= (cardDestaque != null ? cardDestaque.getDisciplina() : "—") %></div>
                    <div class="disc-sub">
                        Disciplina destaque
                        <%= (cardDestaque != null ? " • " + String.format(java.util.Locale.US, "%.2f", cardDestaque.getMedia()) : "") %>
                    </div>
                </div>

                <!-- 2) Nota em atenção -->
                <div class="disc-card atencao">
                    <div class="disc-nome"><%= (cardAtencao != null ? cardAtencao.getDisciplina() : "—") %></div>
                    <div class="disc-sub">
                        Nota em atenção
                        <%= (cardAtencao != null ? " • " + String.format(java.util.Locale.US, "%.2f", cardAtencao.getMedia()) : "") %>
                    </div>
                </div>

                <!-- 3) Maior evolução -->
                <div class="disc-card">
                    <div class="disc-nome"><%= (discMaiorEvolucao != null ? discMaiorEvolucao : "—") %></div>
                    <div class="disc-sub">
                        Maior evolução • <%= String.format(java.util.Locale.US, "%.2f", maiorEvolucao) %>
                    </div>
                </div>

                <!-- 4) Maior regressão -->
                <div class="disc-card atencao">
                    <div class="disc-nome"><%= (discMaiorRegressao != null ? discMaiorRegressao : "—") %></div>
                    <div class="disc-sub">
                        Maior regressão • <%= String.format(java.util.Locale.US, "%.2f", maiorRegressao) %>
                    </div>
                </div>

            </div>

            <div class="grid-main">
                <!-- GRAFICO -->
                <div class="chart-card">
                    <div class="chart-head">
                        <div class="chart-title">Nota média por disciplina</div>
                        <div class="tabs">
                            <button class="tab is-active" type="button">Nota 1</button>
                            <button class="tab" type="button">Nota 2</button>
                            <button class="tab" type="button">Geral</button>
                        </div>
                    </div>

                    <div class="chart-wrap">
                        <canvas id="graficoMedias"></canvas>
                    </div>
                </div>

                <!-- STATS LATERAIS -->
                <div class="side-stats">
                    <div class="side-box">
                        <div class="side-number"><%= acima7 %></div>
                        <div class="side-label">Notas acima de 7</div>
                    </div>
                    <div class="side-box">
                        <div class="side-number"><%= abaixo7 %></div>
                        <div class="side-label">Notas abaixo de 7</div>
                    </div>
                    <div class="side-box">
                        <div class="side-number"><%= String.format(java.util.Locale.US, "%.2f", mediaGeral) %></div>
                        <div class="side-label">Sua média</div>
                    </div>
                </div>
            </div>

        </div>
    </section>
</main>

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

    // ===== Converte listas do servidor em JSON fácil =====
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

    // ===== Estado do gráfico =====
    let modo = "nota1"; // default: Nota 1

    function tooltipLabel(prefix, value) {
        return `${prefix}: ${value}`;
    }

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

    const canvas = document.getElementById("graficoMedias");
    let chart = null;

    function renderChart() {
        const pack = getDatasetForMode();
        const labels = pack.data.labels;
        const values = pack.data.values;

        const colors = getColors(values);

        //const tooltipPrefix = pack.title;

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
                    borderSkipped: "bottom",
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
                                // ✅ primeira linha do tooltip = nome da matéria (label do eixo X)
                                // items é array; pegamos o primeiro
                                return items[0].label || "";
                            },
                            label: function(ctx) {
                                // ✅ segunda linha = Nota 1/Nota 2/Média + valor
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
                                // "value" aqui é o índice do label
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

    // ===== Botões de filtro funcionando =====
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

    // ✅ inicia em Nota 1 (e marca o botão correto)
    (function initTabs(){
        const tabs = Array.from(document.querySelectorAll(".tab"));
        const tabNota1 = tabs.find(t => (t.textContent || "").toLowerCase().includes("nota 1"));
        if (tabNota1) setActiveTab(tabNota1);
    })();

    if (canvas) renderChart();
</script>

</body>
</html>