package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoAdmDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/adm/aluno/excluir")
public class AdmAlunoExcluirServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id_aluno");
        if (idStr != null && !idStr.isBlank()) {
            int idAluno = Integer.parseInt(idStr);
            new AlunoAdmDAO().excluir(idAluno);
        }

        response.sendRedirect(request.getContextPath() + "/adm/alunos");
    }
}