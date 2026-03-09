package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.ObservacaoAdmDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Date;

@WebServlet("/adm/observacao/editar")
public class AdmObservacaoEditarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        int idObservacao = Integer.parseInt(request.getParameter("id_observacao"));
        Integer idAluno = Integer.parseInt(request.getParameter("id_aluno"));

        String idDiscStr = request.getParameter("id_disciplina");
        Integer idDisciplina = (idDiscStr == null || idDiscStr.isBlank()) ? null : Integer.parseInt(idDiscStr);

        String mensagem = request.getParameter("mensagem");
        int tipo = Integer.parseInt(request.getParameter("tipo"));
        Date data = Date.valueOf(request.getParameter("data"));

        ObservacaoAdmDAO dao = new ObservacaoAdmDAO();
        boolean ok = dao.atualizar(idObservacao, idAluno, idDisciplina, mensagem, tipo, data);

        if (!ok) {
            response.sendRedirect(request.getContextPath() + "/adm/observacoes?erro=1");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/adm/observacoes?ok=1");
    }
}