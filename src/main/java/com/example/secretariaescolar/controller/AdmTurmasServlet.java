package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.TurmaAdmDAO;
import com.example.secretariaescolar.model.Turma;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/adm/turmas")
public class AdmTurmasServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");
        if (u.getId_tipo_user() != 3) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        String q = request.getParameter("q");
        if (q != null) {
            q = q.trim();
            if (q.isEmpty()) q = null;
        }

        TurmaAdmDAO dao = new TurmaAdmDAO();
        List<Turma> turmas = dao.listar(q);

        request.setAttribute("turmas", turmas);
        request.setAttribute("totalTurmas", turmas.size());
        request.setAttribute("q", q == null ? "" : q);

        request.getRequestDispatcher("/pages/adm/turmas-adm.jsp").forward(request, response);
    }
}