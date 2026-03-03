package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.dao.BoletimDAO;
import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.model.Observacao;
import com.example.secretariaescolar.model.Usuario;
import com.example.secretariaescolar.util.Conexao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.List;

@WebServlet("/aluno/boletim")
public class BoletimDisciplinaServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // aluno = tipo 1 (como você já usa)
        if (usuario.getId_tipo_user() != 1) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        // pega id_disciplina por parâmetro
        String idDiscStr = request.getParameter("id_disciplina");
        if (idDiscStr == null || idDiscStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/aluno/disciplinas");
            return;
        }

        int idDisciplina;
        try {
            idDisciplina = Integer.parseInt(idDiscStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/aluno/disciplinas");
            return;
        }

        // pega aluno (id_aluno) pelo id_user
        AlunoDAO alunoDAO = new AlunoDAO();
        Aluno aluno = alunoDAO.buscarPorIdUser(usuario.getId_user());

        if (aluno == null) {
            request.setAttribute("erro", "Aluno não encontrado.");
            request.getRequestDispatcher("/pages/aluno/boletim-disciplina.jsp").forward(request, response);
            return;
        }

        // pega connection do seu projeto (use o mesmo padrão que você já usa)
        // ✅ Se você já tem uma classe de conexão (ex: Conexao.getConnection()), troque aqui.
        Connection conn = null;
        try {
            conn = Conexao.conectar(); // <-- ajuste para sua classe real
            BoletimDAO boletimDAO = new BoletimDAO(conn);

            String nomeDisciplina = boletimDAO.buscarNomeDisciplina(idDisciplina);

            Double nota1 = boletimDAO.buscarNotaSemestre(aluno.getId_aluno(), idDisciplina, "1");
            Double nota2 = boletimDAO.buscarNotaSemestre(aluno.getId_aluno(), idDisciplina, "2");
            Double media = boletimDAO.buscarMediaDisciplina(aluno.getId_aluno(), idDisciplina);

            int totalObs = boletimDAO.contarObservacoes(aluno.getId_aluno(), idDisciplina);
            int totalElogios = boletimDAO.contarObservacoesPorTipo(aluno.getId_aluno(), idDisciplina, 1);
            int totalPdm = boletimDAO.contarObservacoesPorTipo(aluno.getId_aluno(), idDisciplina, 2);

            List<Observacao> observacoes = boletimDAO.listarObservacoesDaDisciplina(aluno.getId_aluno(), idDisciplina);

            // manda pro JSP
            request.setAttribute("aluno", aluno);
            request.setAttribute("disciplinaNome", nomeDisciplina != null ? nomeDisciplina : "Disciplina");

            request.setAttribute("nota1", nota1 != null ? nota1 : 0.0);
            request.setAttribute("nota2", nota2 != null ? nota2 : 0.0);
            request.setAttribute("media", media != null ? media : 0.0);

            request.setAttribute("totalObs", totalObs);
            request.setAttribute("totalElogios", totalElogios);
            request.setAttribute("totalPdm", totalPdm);

            request.setAttribute("observacoes", observacoes);

            request.getRequestDispatcher("/pages/aluno/boletim-disciplina.jsp").forward(request, response);

        } catch (Exception e) {
            request.setAttribute("erro", "Erro ao carregar boletim: " + e.getMessage());
            request.getRequestDispatcher("/pages/aluno/boletim-disciplina.jsp").forward(request, response);
        } finally {
            try { if (conn != null) conn.close(); } catch (Exception ignore) {}
        }
    }
}