package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.TurmaAdmDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/adm/turma/excluir")
public class AdmTurmaExcluirServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id_turma");

        if (idStr != null && !idStr.isBlank()) {
            int idTurma = Integer.parseInt(idStr);
            new TurmaAdmDAO().excluir(idTurma);
        }

        response.sendRedirect(request.getContextPath() + "/adm/turmas?ok=1");
    }
}