package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.ObservacaoAdmDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/adm/observacao/excluir")
public class AdmObservacaoExcluirServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id_observacao");

        if (idStr != null && !idStr.isBlank()) {
            int idObservacao = Integer.parseInt(idStr);
            new ObservacaoAdmDAO().excluir(idObservacao);
        }

        response.sendRedirect(request.getContextPath() + "/adm/observacoes?ok=1");
    }
}