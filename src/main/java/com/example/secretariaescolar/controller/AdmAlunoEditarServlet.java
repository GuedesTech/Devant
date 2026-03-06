package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoAdmDAO;
import com.example.secretariaescolar.dao.TurmaDAO;
import com.example.secretariaescolar.model.AlunoAdmView;
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

@WebServlet("/adm/aluno/editar")
@MultipartConfig
public class AdmAlunoEditarServlet extends HttpServlet {

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

        String idStr = request.getParameter("id_aluno");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/adm/alunos");
            return;
        }

        int idAluno = Integer.parseInt(idStr);

        AlunoAdmDAO dao = new AlunoAdmDAO();
        AlunoAdmView aluno = dao.buscarPorIdAluno(idAluno);

        if (aluno == null) {
            response.sendRedirect(request.getContextPath() + "/adm/alunos");
            return;
        }

        TurmaDAO turmaDAO = new TurmaDAO();
        List<Turma> turmas = turmaDAO.listarTodas();

        request.setAttribute("aluno", aluno);
        request.setAttribute("turmas", turmas);

        request.getRequestDispatcher("/pages/adm/aluno-editar.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int idAluno = Integer.parseInt(request.getParameter("id_aluno"));
        String nome = request.getParameter("nome");
        String matricula = request.getParameter("matricula");
        int idTurma = Integer.parseInt(request.getParameter("id_turma"));
        String login = request.getParameter("login");
        String senha = request.getParameter("senha");

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
        boolean ok = dao.atualizar(idAluno, nome, matricula, idTurma, login, senha, fotoArquivo);

        if (!ok) {
            request.setAttribute("erro", "Erro ao atualizar aluno.");
            doGet(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/adm/alunos");
    }
}