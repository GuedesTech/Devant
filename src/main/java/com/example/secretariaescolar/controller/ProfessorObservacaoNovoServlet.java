package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.ProfessorDAO;
import com.example.secretariaescolar.dao.ObservacaoDAO;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Usuario;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/professor/observacao/nova")
public class ProfessorObservacaoNovoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

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

        try {
            int idAluno = Integer.parseInt(request.getParameter("id_aluno"));
            String mensagem = request.getParameter("mensagem");
            int tipo = Integer.parseInt(request.getParameter("tipo"));

            ProfessorDAO professorDAO = new ProfessorDAO();
            Integer idProfessor = professorDAO.buscarIdProfessorPorIdUser(usuario.getId_user());

            if (idProfessor == null) {
                response.sendRedirect(request.getContextPath() + "/professor/aluno/observacoes?id_aluno=" + idAluno + "&erro=sem_prof");
                return;
            }

            Disciplina disciplina = professorDAO.getDisciplina(idProfessor);
            if (disciplina == null) {
                response.sendRedirect(request.getContextPath() + "/professor/aluno/observacoes?id_aluno=" + idAluno + "&erro=sem_disc");
                return;
            }

            ObservacaoDAO obsDAO = new ObservacaoDAO();
            boolean ok = obsDAO.inserirProfessor(idAluno, idProfessor, disciplina.getId_disciplina(), mensagem, tipo);

            if (ok) {
                response.sendRedirect(request.getContextPath() + "/professor/aluno/observacoes?id_aluno=" + idAluno + "&ok=1");
            } else {
                response.sendRedirect(request.getContextPath() + "/professor/aluno/observacoes?id_aluno=" + idAluno + "&erro=1");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
        }
    }
}