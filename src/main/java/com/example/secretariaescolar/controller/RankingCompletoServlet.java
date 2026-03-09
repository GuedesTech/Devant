package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.TurmaDAO;
import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.model.Turma;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/professor/ranking-completo")
public class RankingCompletoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");
        if (u.getId_tipo_user() != 2) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        String idTurmaStr = request.getParameter("id_turma");
        if (idTurmaStr == null || idTurmaStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        int idTurma = Integer.parseInt(idTurmaStr);

        TurmaDAO turmaDAO = new TurmaDAO();
        Turma turma = turmaDAO.buscarPorId(idTurma);

        AlunoDAO alunoDAO = new AlunoDAO();
        List<Map<String, Object>> rankingCompleto = alunoDAO.buscarRankingCompletoDaTurma(idTurma);

        if (rankingCompleto == null) rankingCompleto = new ArrayList<>();

        request.setAttribute("turma", turma);
        request.setAttribute("nomeTurma", turma != null ? turma.getNome() : "Turma");
        request.setAttribute("totalAlunos", rankingCompleto.size());
        request.setAttribute("rankingCompleto", rankingCompleto);

        request.getRequestDispatcher("/pages/professor/ranking-completo.jsp").forward(request, response);
    }
}