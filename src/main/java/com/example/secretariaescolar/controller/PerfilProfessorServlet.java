package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.ProfessorDAO;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Professor;
import com.example.secretariaescolar.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/professor/perfil")
public class PerfilProfessorServlet extends HttpServlet {

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

        ProfessorDAO professorDAO = new ProfessorDAO();

        Professor professor = professorDAO.buscaPorUsuario(usuario.getId_user());
        Disciplina disciplina = null;

        if (professor != null) {
            disciplina = professorDAO.getDisciplina(professor.getId_professor());
        }

        request.setAttribute("professor", professor);
        request.setAttribute("disciplina", disciplina);

        request.getRequestDispatcher("/pages/professor/perfil-professor.jsp").forward(request, response);
    }
}