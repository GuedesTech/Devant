package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.dao.ObservacaoDAO;
import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.model.Usuario;
import com.example.secretariaescolar.model.Observacao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/aluno/observacoes")
public class ObservacoesAlunoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        if (usuario.getId_tipo_user() != 1) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        AlunoDAO alunoDAO = new AlunoDAO();
        Integer idAluno = alunoDAO.buscarIdAlunoPorIdUser(usuario.getId_user());

        Aluno aluno = alunoDAO.buscarPorIdUser(usuario.getId_user());
        request.setAttribute("aluno", aluno);

        if (idAluno == null) {
            request.setAttribute("erro", "Aluno não encontrado para este usuário.");
            request.getRequestDispatcher("/pages/aluno/observacoes-aluno.jsp").forward(request, response);
            return;
        }

        ObservacaoDAO obsDAO = new ObservacaoDAO();
        List<Observacao> observacoes = obsDAO.listarPorAluno(idAluno);

        int totalObs = obsDAO.contarTotalPorAluno(idAluno);
        int totalElogios = obsDAO.contarPorAlunoETipo(idAluno, 1);
        int totalPdm = obsDAO.contarPorAlunoETipo(idAluno, 2);

        request.setAttribute("observacoes", observacoes);
        request.setAttribute("totalObs", totalObs);
        request.setAttribute("totalElogios", totalElogios);
        request.setAttribute("totalPdm", totalPdm);

        request.getRequestDispatcher("/pages/aluno/observacoes-aluno.jsp").forward(request, response);
    }
}
