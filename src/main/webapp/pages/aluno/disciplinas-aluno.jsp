<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %> <%@ page
import="java.util.List" %> <%@ page
import="com.example.secretariaescolar.model.Disciplina" %> <% String ctx =
request.getContextPath(); @SuppressWarnings("unchecked") List<Disciplina>
  disciplinas = (List<Disciplina
    >) request.getAttribute("disciplinas"); int total = (disciplinas != null) ?
    disciplinas.size() : 0; String q = request.getParameter("q"); if (q != null)
    q = q.trim().toLowerCase(); %>

    <!DOCTYPE html>
    <html lang="pt-br">
      <head>
        <meta charset="UTF-8" />
        <link
          rel="icon"
          type="image/png"
          href="<%= request.getContextPath() %>/pages/assets/logo-dark.png"
        />
        <link
          <meta
          name="viewport"
          content="width=device-width, initial-scale=1.0"
        />
        <link rel="icon" href="<%= ctx %>/assets/Group 551.ico" />
        <link rel="stylesheet" href="<%= ctx %>/pages/aluno/perfil.css" />
        <title>Disciplinas - Devant</title>
      </head>

      <body>
        <header class="topbar">
          <div class="topbar-inner">
            <a
              class="topbar-left"
              href="<%= ctx %>/aluno/perfil"
              aria-label="Voltar ao início"
            >
              <img
                class="topbar-logo"
                src="<%= ctx %>/pages/assets/logo.png"
                alt="Logo Devant"
              />
            </a>

            <nav class="topbar-nav" aria-label="Navegação principal">
              <a class="topbar-link" href="<%= ctx %>/aluno/perfil">Perfil</a>
              <a
                class="topbar-link is-active"
                href="<%= ctx %>/aluno/disciplinas"
                >Disciplinas</a
              >

              <span class="nav-indicador" aria-hidden="true"></span>
            </nav>

            <div class="topbar-right"></div>
          </div>
        </header>

        <main class="page">
          <section class="card">
            <div class="card-header">
              <h1 class="page-title">Minhas Disciplinas</h1>
              <div class="title-line" aria-hidden="true"></div>

              <!-- Linha: total + botão pdf + pesquisa -->
              <div
                style="
                  margin-top: 16px;
                  display: flex;
                  gap: 12px;
                  align-items: center;
                  justify-content: space-between;
                  flex-wrap: wrap;
                "
              >
                <!-- Total Disciplinas -->
                <div
                  style="
                    height: 40px;
                    display: inline-flex;
                    align-items: center;
                    gap: 10px;
                    background: #ecf5ff;
                    border: 2px solid var(--navy);
                    border-radius: 10px;
                    padding: 0 14px;
                    font-weight: 700;
                    color: var(--navy);
                  "
                >
                  <span style="font-size: 14px"
                    >Total Disciplinas: <%= total %></span
                  >
                </div>

                <!-- Botão: boletim completo PDF -->
                <a
                  href="<%= ctx %>/aluno/boletim/pdf"
                  style="
                    height: 40px;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    padding: 0 14px;
                    border-radius: 10px;
                    background: #274855;
                    color: #fafafa;
                    font-weight: 800;
                    text-decoration: none;
                    border: none;
                    box-shadow: 0 10px 18px rgba(40, 53, 101, 0.1);
                  "
                  target="_blank"
                  rel="noopener"
                >
                  Gerar boletim completo
                </a>

                <!-- Pesquisa (envia GET ?q=...) -->
                <form
                  method="get"
                  action="<%= ctx %>/aluno/disciplinas"
                  style="
                    display: flex;
                    align-items: center;
                    border: 2px solid var(--navy);
                    border-radius: 10px;
                    padding: 0 10px;
                    height: 40px;
                    width: min(340px, 100%);
                  "
                >
                  <input name="q" value="<%= (request.getParameter("q") != null
                  ? request.getParameter("q") : "") %>" type="text"
                  placeholder="Pesquisar disciplina" style="flex:1; border:none;
                  outline:none; background:transparent; font-family:Poppins,
                  sans-serif; font-weight:600; color:#334;">
                  <button
                    type="submit"
                    style="
                      border: none;
                      background: transparent;
                      cursor: pointer;
                      font-weight: 800;
                      color: var(--navy);
                    "
                  >
                    <img
                      src="<%= ctx %>/pages/assets/lupa_icon.png"
                      style="height: 20px; width: 20px"
                    />
                  </button>
                </form>
              </div>
            </div>

            <!-- Lista de disciplinas -->
            <div
              style="
                margin-top: 20px;
                display: flex;
                flex-direction: column;
                gap: 12px;
              "
            >
              <% boolean achou = false; if (disciplinas != null) { for
              (Disciplina d : disciplinas) { String nome = (d.getNome() != null)
              ? d.getNome() : ""; String nomeLower = nome.toLowerCase(); if (q
              != null && !q.isEmpty() && !nomeLower.contains(q)) { continue; }
              achou = true; %>

              <div
                style="
                  background: #fff;
                  border-radius: 10px;
                  border: 1px solid rgba(40, 53, 101, 0.18);
                  border-left: 10px solid #294c56;
                  padding: 16px 18px;
                  display: flex;
                  align-items: center;
                  justify-content: space-between;
                  box-shadow: 0 10px 18px rgba(40, 53, 101, 0.1);
                "
              >
                <span
                  style="font-weight: 800; font-size: 20px; color: var(--navy)"
                >
                  <%= nome %>
                </span>

                <a
                  href="<%= ctx %>/aluno/boletim?id_disciplina=<%= d.getId_disciplina() %>"
                  style="
                    font-weight: 800;
                    color: #294c56;
                    text-decoration: none;
                  "
                >
                  Ver Boletim
                </a>
              </div>

              <% } } if (!achou) { %>
              <p
                style="
                  margin-top: 10px;
                  font-weight: 700;
                  color: rgba(40, 53, 101, 0.65);
                "
              >
                Nenhuma disciplina encontrada.
              </p>
              <% } %>
            </div>

            <% if (disciplinas == null) { %>
            <p style="margin-top: 16px; font-weight: 700; color: #283565">
              DEBUG: "disciplinas" veio NULL (o servlet não setou
              request.setAttribute("disciplinas", ...))
            </p>
            <% } %>
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

                setTimeout(() => {
                  window.location.href = href;
                }, 220);
              });
            });
          })();
        </script>
      </body>
    </html></Disciplina
  ></Disciplina
>
