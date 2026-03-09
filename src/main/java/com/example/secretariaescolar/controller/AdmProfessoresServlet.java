package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.DisciplinaDAO;
import com.example.secretariaescolar.dao.ProfessorAdmDAO;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.ProfessorAdmView;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/adm/professores")
public class AdmProfessoresServlet extends HttpServlet {

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

        ProfessorAdmDAO professorDao = new ProfessorAdmDAO();
        DisciplinaDAO disciplinaDao = new DisciplinaDAO();

        List<ProfessorAdmView> professores = professorDao.listar(q);
        List<Disciplina> disciplinas = disciplinaDao.listarTodas();

        request.setAttribute("professores", professores);
        request.setAttribute("totalProfessores", professores.size());
        request.setAttribute("q", q == null ? "" : q);
        request.setAttribute("disciplinas", disciplinas);

        request.getRequestDispatcher("/pages/adm/professores-adm.jsp").forward(request, response);
    }
}