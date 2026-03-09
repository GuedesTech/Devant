package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.DisciplinaAdmDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/adm/disciplina/novo")
public class AdmDisciplinaNovoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        String nome = request.getParameter("nome");

        DisciplinaAdmDAO dao = new DisciplinaAdmDAO();
        boolean ok = dao.inserir(nome);

        if (!ok) {
            response.sendRedirect(request.getContextPath() + "/adm/disciplinas?erro=1");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/adm/disciplinas?ok=1");
    }
}