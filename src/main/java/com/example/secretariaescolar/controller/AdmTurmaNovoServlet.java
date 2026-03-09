package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.TurmaAdmDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/adm/turma/novo")
public class AdmTurmaNovoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        request.setCharacterEncoding("UTF-8");

        String nome = request.getParameter("nome");

        TurmaAdmDAO dao = new TurmaAdmDAO();
        boolean ok = dao.inserir(nome);

        if (!ok) {
            response.sendRedirect(request.getContextPath() + "/adm/turmas?erro=1");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/adm/turmas?ok=1");
    }
}