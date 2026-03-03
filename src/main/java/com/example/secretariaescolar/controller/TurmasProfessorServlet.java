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

@WebServlet("/professor/turmas")
public class TurmasProfessorServlet extends HttpServlet {

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

        TurmaDAO turmaDAO = new TurmaDAO();

        List<Turma> turmas = turmaDAO.listarTodas();
        int totalAlunos = turmaDAO.contarTotalAlunos();
        Map<Integer, Double> mediaPorTurma = turmaDAO.buscarMediaPorTurma();

        request.setAttribute("turmas", turmas);
        request.setAttribute("totalAlunos", totalAlunos);
        request.setAttribute("mediaPorTurma", mediaPorTurma);

        request.getRequestDispatcher("/pages/professor/turmas-prof.jsp")
                .forward(request, response);
    }
}