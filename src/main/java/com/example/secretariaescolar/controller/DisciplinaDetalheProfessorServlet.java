package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.DisciplinaDAO;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

@WebServlet("/professor/disciplina")
public class DisciplinaDetalheProfessorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario.getId_tipo_user() != 2) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        String idStr = request.getParameter("id_disciplina");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/professor/disciplinas");
            return;
        }

        int idDisciplina;
        try {
            idDisciplina = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/professor/disciplinas");
            return;
        }

        DisciplinaDAO disciplinaDAO = new DisciplinaDAO();
        Disciplina disciplina = disciplinaDAO.buscarPorId(idDisciplina);

        if (disciplina == null) {
            request.setAttribute("erro", "Disciplina não encontrada.");
            request.getRequestDispatcher("/pages/professor/disciplina-detalhe.jsp").forward(request, response);
            return;
        }

        // TROQUE ESTES MOCKS PELOS SEUS MÉTODOS DO DAO
        request.setAttribute("disciplina", disciplina);
        request.setAttribute("totalAlunos", 26);
        request.setAttribute("mediaDisciplina", 6.7);
        request.setAttribute("acima7", 6);
        request.setAttribute("abaixo7", 7);

        request.setAttribute("ranking", new ArrayList<>());
        request.setAttribute("ultimasObs", new ArrayList<>());
        request.setAttribute("totalObs", 67);
        request.setAttribute("topPositivo", new HashMap<>());
        request.setAttribute("topNegativo", new HashMap<>());

        request.getRequestDispatcher("/pages/professor/disciplina-detalhe.jsp")
                .forward(request, response);
    }
}