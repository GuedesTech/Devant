package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AdmPerfilDAO;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/adm/excluir")
public class AdmExcluirServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        String idStr = request.getParameter("id_user");

        if (idStr != null && !idStr.isBlank()) {
            int idUser = Integer.parseInt(idStr);
            new AdmPerfilDAO().excluir(idUser);
        }

        response.sendRedirect(request.getContextPath() + "/adm/perfil?ok=1");
    }
}