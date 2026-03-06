package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoAdmDAO;
import com.example.secretariaescolar.dao.TurmaDAO;
import com.example.secretariaescolar.model.Turma;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@WebServlet("/adm/aluno/novo")
@MultipartConfig
public class AdmAlunoNovoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        Usuario u = (Usuario) session.getAttribute("usuario");
        if (u.getId_tipo_user() != 3) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        TurmaDAO turmaDAO = new TurmaDAO();
        List<Turma> turmas = turmaDAO.listarTodas();
        request.setAttribute("turmas", turmas);

        request.getRequestDispatcher("/pages/adm/aluno-novo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nome = request.getParameter("nome");
        String matricula = request.getParameter("matricula");
        String idTurmaStr = request.getParameter("id_turma");

        int idTurma = Integer.parseInt(idTurmaStr);

        Part fotoPart = request.getPart("foto");
        String fotoArquivo = null;

        if (fotoPart != null && fotoPart.getSize() > 0) {
            String submitted = Paths.get(fotoPart.getSubmittedFileName()).getFileName().toString();
            String ext = "";

            int dot = submitted.lastIndexOf('.');
            if (dot >= 0) ext = submitted.substring(dot);

            fotoArquivo = "aluno_" + UUID.randomUUID() + ext;

            String uploadDir = getServletContext().getRealPath("/pages/uploads");
            new File(uploadDir).mkdirs();

            fotoPart.write(uploadDir + File.separator + fotoArquivo);
        }

        AlunoAdmDAO dao = new AlunoAdmDAO();
        boolean ok = dao.inserir(nome, matricula, idTurma, fotoArquivo);

        if (!ok) {
            request.setAttribute("erro", "Erro ao cadastrar aluno.");
            doGet(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/adm/alunos");
    }
}