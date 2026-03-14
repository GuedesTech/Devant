package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.dao.ObservacaoDAO;
import com.example.secretariaescolar.dao.ProfessorDAO;
import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Observacao;
import com.example.secretariaescolar.model.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/professor/aluno/observacoes")
public class ProfessorAlunoObservacoesServlet extends HttpServlet {

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

        try {
            String idAlunoStr = request.getParameter("id_aluno");
            if (idAlunoStr == null || idAlunoStr.isBlank()) {
                response.sendRedirect(request.getContextPath() + "/professor/turmas");
                return;
            }

            int idAluno = Integer.parseInt(idAlunoStr);

            AlunoDAO alunoDAO = new AlunoDAO();
            ObservacaoDAO obsDAO = new ObservacaoDAO();
            ProfessorDAO professorDAO = new ProfessorDAO();

            Aluno aluno = alunoDAO.buscarPorIdAluno(idAluno);
            if (aluno == null) {
                response.sendRedirect(request.getContextPath() + "/professor/turmas");
                return;
            }

            List<Observacao> observacoes = obsDAO.listarPorAluno(idAluno);
            if (observacoes == null) observacoes = new ArrayList<>();

            int totalObs = obsDAO.contarTotalPorAluno(idAluno);
            int totalElogios = obsDAO.contarPorAlunoETipo(idAluno, 1);
            int totalPdm = obsDAO.contarPorAlunoETipo(idAluno, 2);

            Integer idProfessorLogado = professorDAO.buscarIdProfessorPorIdUser(usuario.getId_user());
            if (idProfessorLogado == null) idProfessorLogado = 0;

            Disciplina disciplinaProfessor = null;
            if (idProfessorLogado != 0) {
                disciplinaProfessor = professorDAO.getDisciplina(idProfessorLogado);
            }

            request.setAttribute("aluno", aluno);
            request.setAttribute("observacoes", observacoes);
            request.setAttribute("totalObs", totalObs);
            request.setAttribute("totalElogios", totalElogios);
            request.setAttribute("totalPdm", totalPdm);
            request.setAttribute("idProfessorLogado", idProfessorLogado);
            request.setAttribute("disciplinaProfessor", disciplinaProfessor);

            request.getRequestDispatcher("/pages/professor/professor-aluno-observacoes.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
        }
    }
}