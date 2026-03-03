package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/professor/alunos")
public class AlunosProfessorServlet extends HttpServlet {

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

        AlunoDAO alunoDAO = new AlunoDAO();

        List<Aluno> alunos = alunoDAO.listarTodosComFoto();
        Map<Integer, Double> mediaPorAluno = alunoDAO.buscarMediaPorAluno();

        request.setAttribute("alunos", alunos);
        request.setAttribute("mediaPorAluno", mediaPorAluno);
        request.setAttribute("totalAlunos", alunos.size());

        request.getRequestDispatcher("/pages/professor/alunos.jsp")
                .forward(request, response);
    }
}