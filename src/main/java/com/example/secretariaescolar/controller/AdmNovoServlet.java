package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AdmPerfilDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/adm/novo")
@MultipartConfig
public class AdmNovoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nome = request.getParameter("nome");
        String login = request.getParameter("login");
        String senha = request.getParameter("senha");

        Part fotoPart = request.getPart("foto");
        String fotoArquivo = null;

        if (fotoPart != null && fotoPart.getSize() > 0) {
            String submitted = Paths.get(fotoPart.getSubmittedFileName()).getFileName().toString();
            String ext = "";

            int dot = submitted.lastIndexOf('.');
            if (dot >= 0) ext = submitted.substring(dot);

            fotoArquivo = "adm_" + UUID.randomUUID() + ext;

            String uploadDir = getServletContext().getRealPath("/pages/uploads");
            new File(uploadDir).mkdirs();

            fotoPart.write(uploadDir + File.separator + fotoArquivo);
        }

        AdmPerfilDAO dao = new AdmPerfilDAO();
        boolean ok = dao.inserir(nome, login, senha, fotoArquivo);

        if (!ok) {
            response.sendRedirect(request.getContextPath() + "/adm/perfil?erro=1");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/adm/perfil?ok=1");
    }
}