package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.DisciplinaAdmDAO;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/adm/disciplinas")
public class AdmDisciplinasServlet extends HttpServlet {

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

        DisciplinaAdmDAO dao = new DisciplinaAdmDAO();
        List<Disciplina> disciplinas = dao.listar(q);

        request.setAttribute("disciplinas", disciplinas);
        request.setAttribute("totalDisciplinas", disciplinas.size());
        request.setAttribute("q", q == null ? "" : q);

        request.getRequestDispatcher("/pages/adm/disciplinas-adm.jsp").forward(request, response);
    }
}