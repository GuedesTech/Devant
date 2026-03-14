package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.ObservacaoDAO;
import com.example.secretariaescolar.dao.ProfessorDAO;
import com.example.secretariaescolar.model.Observacao;
import com.example.secretariaescolar.model.Usuario;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/professor/observacao/excluir")
public class ProfessorObservacaoExcluirServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

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
            int idObservacao = Integer.parseInt(request.getParameter("id_observacao"));
            int idAluno = Integer.parseInt(request.getParameter("id_aluno"));

            ProfessorDAO professorDAO = new ProfessorDAO();
            Integer idProfessorLogado = professorDAO.buscarIdProfessorPorIdUser(usuario.getId_user());

            ObservacaoDAO obsDAO = new ObservacaoDAO();
            Observacao obs = obsDAO.buscarPorId(idObservacao);

            if (obs == null || idProfessorLogado == null || obs.getId_professor() != idProfessorLogado) {
                response.sendRedirect(request.getContextPath() + "/professor/aluno/observacoes?id_aluno=" + idAluno + "&erro=permissao");
                return;
            }

            boolean ok = obsDAO.excluirDoProfessor(idObservacao);

            if (ok) {
                response.sendRedirect(request.getContextPath() + "/professor/aluno/observacoes?id_aluno=" + idAluno + "&ok=3");
            } else {
                response.sendRedirect(request.getContextPath() + "/professor/aluno/observacoes?id_aluno=" + idAluno + "&erro=3");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
        }
    }
}