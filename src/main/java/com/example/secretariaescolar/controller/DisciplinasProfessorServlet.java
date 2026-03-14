package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.DisciplinaDAO;
import com.example.secretariaescolar.dao.TurmaDAO;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/professor/disciplinas")
public class DisciplinasProfessorServlet extends HttpServlet {

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

        int idUser = usuario.getId_user();

        DisciplinaDAO disciplinaDAO = new DisciplinaDAO();
        TurmaDAO turmaDAO = new TurmaDAO();

        Disciplina minha = disciplinaDAO.buscarDisciplinaDoProfessorPorIdUser(idUser);
        List<Disciplina> outras = disciplinaDAO.listarOutrasDisciplinasDoProfessorPorIdUser(idUser);

        int totalAlunos = turmaDAO.contarTotalAlunos();

        request.setAttribute("minhaDisciplina", minha);
        request.setAttribute("outrasDisciplinas", outras);
        request.setAttribute("totalAlunos", totalAlunos);

        request.getRequestDispatcher("/pages/professor/disciplinas-professor.jsp").forward(request, response);
    }
}