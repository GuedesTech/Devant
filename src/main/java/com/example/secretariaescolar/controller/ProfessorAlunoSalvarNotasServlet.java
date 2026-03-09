package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.NotaDAO;
import com.example.secretariaescolar.dao.ProfessorDAO;
import com.example.secretariaescolar.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/professor/aluno/notas/salvar")
public class ProfessorAlunoSalvarNotasServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

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

        int idAluno = Integer.parseInt(request.getParameter("id_aluno"));
        int idDisciplina = Integer.parseInt(request.getParameter("id_disciplina"));

        double n1 = parseDoubleSafe(request.getParameter("n1"));
        double n2 = parseDoubleSafe(request.getParameter("n2"));

        ProfessorDAO professorDAO = new ProfessorDAO();
        Integer idProfessor = professorDAO.buscarIdProfessorPorIdUser(usuario.getId_user());

        if (idProfessor == null) {
            response.sendRedirect(request.getContextPath()
                    + "/professor/aluno/analise?id_aluno=" + idAluno
                    + "&id_disciplina=" + idDisciplina
                    + "&erro=sem_prof");
            return;
        }

        NotaDAO notaDAO = new NotaDAO();
        notaDAO.salvarOuAtualizarN1N2(idAluno, idDisciplina, idProfessor, n1, n2);

        response.sendRedirect(request.getContextPath()
                + "/professor/aluno/analise?id_aluno=" + idAluno
                + "&id_disciplina=" + idDisciplina
                + "&ok=1");
    }

    private double parseDoubleSafe(String s) {
        try {
            if (s == null || s.isBlank()) return 0.0;
            return Double.parseDouble(s.replace(",", "."));
        } catch (Exception e) {
            return 0.0;
        }
    }
}