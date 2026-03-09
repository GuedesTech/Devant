package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.ProfessorAdmDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/adm/professor/excluir")
public class AdmProfessorExcluirServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id_professor");

        if (idStr != null && !idStr.isBlank()) {
            int idProfessor = Integer.parseInt(idStr);
            new ProfessorAdmDAO().excluir(idProfessor);
        }

        response.sendRedirect(request.getContextPath() + "/adm/professores?ok=1");
    }
}