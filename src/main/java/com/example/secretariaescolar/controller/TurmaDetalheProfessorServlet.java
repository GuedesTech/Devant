package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.TurmaDAO;
import com.example.secretariaescolar.model.Turma;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/professor/turma")
public class TurmaDetalheProfessorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        // professor = tipo 2
        if (usuario.getId_tipo_user() != 2) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        String idStr = request.getParameter("id_turma");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        int idTurma;
        try {
            idTurma = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        TurmaDAO turmaDAO = new TurmaDAO();
        Turma turma = turmaDAO.buscarPorId(idTurma);

        if (turma == null) {
            request.setAttribute("erro", "Turma não encontrada.");
            request.getRequestDispatcher("/pages/professor/turma-detalhe.jsp").forward(request, response);
            return;
        }

        // ===== dados principais =====
        int totalAlunos = turmaDAO.contarAlunosDaTurma(idTurma);
        double mediaTurma = turmaDAO.buscarMediaTurma(idTurma);

        int alunosAcima7 = turmaDAO.contarAlunosComMediaAcimaDe(idTurma, 7.0);
        int alunosAbaixo7 = turmaDAO.contarAlunosComMediaAbaixoDe(idTurma, 7.0);

        // ===== gráfico =====
        Map<Integer, Integer> distribuicao = turmaDAO.buscarDistribuicaoNotasArredondadas(idTurma);

        // ===== ranking =====
        List<Map<String, Object>> ranking = turmaDAO.buscarRankingTop5(idTurma);

        // ===== observações =====
        int totalObs = turmaDAO.contarObservacoesDaTurma(idTurma);
        List<Map<String, Object>> ultimasObs = turmaDAO.buscarUltimasObservacoesDaTurma(idTurma, 5);

        Map<String, Object> topPositivo = turmaDAO.buscarAlunoTopObservacoes(idTurma, 1); // tipo 1 elogio
        Map<String, Object> topNegativo = turmaDAO.buscarAlunoTopObservacoes(idTurma, 2); // tipo 2 pdm

        // ===== seta attrs =====
        request.setAttribute("turma", turma);
        request.setAttribute("totalAlunos", totalAlunos);
        request.setAttribute("mediaTurma", mediaTurma);
        request.setAttribute("acima7", alunosAcima7);
        request.setAttribute("abaixo7", alunosAbaixo7);

        request.setAttribute("distribuicao", distribuicao);
        request.setAttribute("ranking", ranking);

        request.setAttribute("totalObs", totalObs);
        request.setAttribute("ultimasObs", ultimasObs);
        request.setAttribute("topPositivo", topPositivo);
        request.setAttribute("topNegativo", topNegativo);

        request.getRequestDispatcher("/pages/professor/turma-detalhe.jsp")
                .forward(request, response);
    }
}