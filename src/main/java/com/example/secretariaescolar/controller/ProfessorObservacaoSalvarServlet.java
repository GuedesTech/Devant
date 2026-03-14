package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.*;
import com.example.secretariaescolar.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/professor/observacao/salvar")
public class ProfessorObservacaoSalvarServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {

            HttpSession session = request.getSession();
            Usuario user = (Usuario) session.getAttribute("usuario");

            int idAluno = Integer.parseInt(request.getParameter("id_aluno"));
            int idDisciplina = Integer.parseInt(request.getParameter("id_disciplina"));
            int tipo = Integer.parseInt(request.getParameter("tipo"));
            String mensagem = request.getParameter("mensagem");

            ProfessorDAO profDAO = new ProfessorDAO();
            int idProfessor = profDAO.buscarIdProfessorPorIdUser(user.getId_user());

            Observacao obs = new Observacao();
            obs.setId_aluno(idAluno);
            obs.setId_disciplina(idDisciplina);
            obs.setId_professor(idProfessor);
            obs.setMensagem(mensagem);
            obs.setTipo(tipo);
            obs.setData(java.time.LocalDate.now());

            ObservacaoDAO dao = new ObservacaoDAO();
            dao.salvar(obs);

            response.sendRedirect(
                    request.getContextPath() +
                            "/professor/aluno/observacoes?id_aluno=" + idAluno +
                            "&id_disciplina=" + idDisciplina
            );

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}