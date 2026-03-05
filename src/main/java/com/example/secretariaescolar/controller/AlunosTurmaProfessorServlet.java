package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.dao.TurmaDAO;
import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.model.Turma;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/professor/alunos-turma")
public class AlunosTurmaProfessorServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");
        if (usuario.getId_tipo_user() != 2) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        String idStr = request.getParameter("id_turma");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        int idTurma;
        try {
            idTurma = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        AlunoDAO alunoDAO = new AlunoDAO();
        TurmaDAO turmaDAO = new TurmaDAO();

        Turma turma = turmaDAO.buscarPorId(idTurma);
        if (turma == null) {
            request.setAttribute("nomeTurma", "Turma");
        } else {
            request.setAttribute("nomeTurma", turma.getNome());
        }

        List<Aluno> alunos = alunoDAO.listarPorTurmaComFoto(idTurma);
        Map<Integer, Double> mediaPorAluno = alunoDAO.buscarMediaPorAlunoDaTurma(idTurma);

        request.setAttribute("alunos", alunos);
        request.setAttribute("mediaPorAluno", mediaPorAluno);
        request.setAttribute("totalAlunos", alunos.size());

        request.getRequestDispatcher("/pages/professor/alunosTurma.jsp")
                .forward(request, response);
    }
}