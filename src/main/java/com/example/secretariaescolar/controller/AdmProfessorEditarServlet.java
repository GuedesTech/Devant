package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.ProfessorAdmDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

@WebServlet("/adm/professor/editar")
@MultipartConfig
public class AdmProfessorEditarServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int idProfessor = Integer.parseInt(request.getParameter("id_professor"));
        String nome = request.getParameter("nome");
        String login = request.getParameter("login");
        String senha = request.getParameter("senha");
        int idDisciplina = Integer.parseInt(request.getParameter("id_disciplina"));

        Part fotoPart = request.getPart("foto");
        String fotoArquivo = null;

        if (fotoPart != null && fotoPart.getSize() > 0) {
            String submitted = Paths.get(fotoPart.getSubmittedFileName()).getFileName().toString();
            String ext = "";

            int dot = submitted.lastIndexOf('.');
            if (dot >= 0) ext = submitted.substring(dot);

            fotoArquivo = "professor_" + UUID.randomUUID() + ext;

            String uploadDir = getServletContext().getRealPath("/pages/uploads");
            new File(uploadDir).mkdirs();

            fotoPart.write(uploadDir + File.separator + fotoArquivo);
        }

        ProfessorAdmDAO dao = new ProfessorAdmDAO();
        boolean ok = dao.atualizar(idProfessor, nome, login, senha, idDisciplina, fotoArquivo);

        if (!ok) {
            response.sendRedirect(request.getContextPath() + "/adm/professores?erro=1");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/adm/professores?ok=1");
    }
}