package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.DisciplinaAdmDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/adm/disciplina/excluir")
public class AdmDisciplinaExcluirServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id_disciplina");

        if (idStr != null && !idStr.isBlank()) {
            int idDisciplina = Integer.parseInt(idStr);
            new DisciplinaAdmDAO().excluir(idDisciplina);
        }

        response.sendRedirect(request.getContextPath() + "/adm/disciplinas?ok=1");
    }
}