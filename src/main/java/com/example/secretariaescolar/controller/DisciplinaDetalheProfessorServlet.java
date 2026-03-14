package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.DisciplinaDAO;
import com.example.secretariaescolar.dao.TurmaDAO;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Turma;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@WebServlet("/professor/disciplina")
public class DisciplinaDetalheProfessorServlet extends HttpServlet {

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

        String idStr = request.getParameter("id_disciplina");
        if (idStr == null || idStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/professor/disciplinas");
            return;
        }

        int idDisciplina;
        try {
            idDisciplina = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/professor/disciplinas");
            return;
        }

        DisciplinaDAO disciplinaDAO = new DisciplinaDAO();
        TurmaDAO turmaDAO = new TurmaDAO();

        Disciplina disciplina = disciplinaDAO.buscarPorId(idDisciplina);

        if (disciplina == null) {
            response.sendRedirect(request.getContextPath() + "/professor/disciplinas");
            return;
        }

        String filtro = request.getParameter("filtro");
        if (filtro == null || filtro.isBlank()) filtro = "geral";

        List<Turma> turmasDaDisciplina = turmaDAO.listarTurmasDaDisciplina(idDisciplina);
        if (turmasDaDisciplina == null) turmasDaDisciplina = new ArrayList<>();

        int totalAlunos = 0;
        double mediaDisciplina = 0.0;
        int acima7 = 0;
        int abaixo7 = 0;
        int totalObs = 0;
        List<Map<String, Object>> ranking = new ArrayList<>();
        List<Map<String, Object>> ultimasObs = new ArrayList<>();
        Map<String, Object> topPositivo = null;
        Map<String, Object> topNegativo = null;

        if ("geral".equalsIgnoreCase(filtro)) {

            totalAlunos = disciplinaDAO.contarAlunosPorDisciplina(idDisciplina);
            mediaDisciplina = disciplinaDAO.buscarMediaDisciplina(idDisciplina);
            acima7 = disciplinaDAO.contarAlunosComMediaAcimaOuIgual7NaDisciplina(idDisciplina);
            abaixo7 = disciplinaDAO.contarAlunosComMediaAbaixo7NaDisciplina(idDisciplina);
            ranking = disciplinaDAO.buscarRankingTop5Disciplina(idDisciplina);
            totalObs = disciplinaDAO.contarObservacoesDaDisciplina(idDisciplina);
            ultimasObs = disciplinaDAO.buscarUltimasObservacoesDaDisciplina(idDisciplina, 5);
            topPositivo = disciplinaDAO.buscarAlunoTopObservacoesDisciplina(idDisciplina, 1);
            topNegativo = disciplinaDAO.buscarAlunoTopObservacoesDisciplina(idDisciplina, 2);

        } else if ("1geral".equalsIgnoreCase(filtro) || "2geral".equalsIgnoreCase(filtro) || "3geral".equalsIgnoreCase(filtro)) {

            int serie = Integer.parseInt(filtro.substring(0, 1));

            totalAlunos = disciplinaDAO.contarAlunosPorDisciplinaESerie(idDisciplina, serie);
            mediaDisciplina = disciplinaDAO.buscarMediaDisciplinaESerie(idDisciplina, serie);
            acima7 = disciplinaDAO.contarAlunosComMediaAcimaOuIgual7NaDisciplinaESerie(idDisciplina, serie);
            abaixo7 = disciplinaDAO.contarAlunosComMediaAbaixo7NaDisciplinaESerie(idDisciplina, serie);
            ranking = disciplinaDAO.buscarRankingTop5DisciplinaESerie(idDisciplina, serie);
            totalObs = disciplinaDAO.contarObservacoesDaDisciplinaESerie(idDisciplina, serie);
            ultimasObs = disciplinaDAO.buscarUltimasObservacoesDaDisciplinaESerie(idDisciplina, serie, 5);
            topPositivo = disciplinaDAO.buscarAlunoTopObservacoesDisciplinaESerie(idDisciplina, serie, 1);
            topNegativo = disciplinaDAO.buscarAlunoTopObservacoesDisciplinaESerie(idDisciplina, serie, 2);

        } else {
            try {
                int idTurma = Integer.parseInt(filtro);

                totalAlunos = disciplinaDAO.contarAlunosPorDisciplinaETurma(idDisciplina, idTurma);
                mediaDisciplina = disciplinaDAO.buscarMediaDisciplinaETurma(idDisciplina, idTurma);
                acima7 = disciplinaDAO.contarAlunosComMediaAcimaOuIgual7NaDisciplinaETurma(idDisciplina, idTurma);
                abaixo7 = disciplinaDAO.contarAlunosComMediaAbaixo7NaDisciplinaETurma(idDisciplina, idTurma);
                ranking = disciplinaDAO.buscarRankingTop5DisciplinaETurma(idDisciplina, idTurma);
                totalObs = disciplinaDAO.contarObservacoesDaDisciplinaETurma(idDisciplina, idTurma);
                ultimasObs = disciplinaDAO.buscarUltimasObservacoesDaDisciplinaETurma(idDisciplina, idTurma, 5);
                topPositivo = disciplinaDAO.buscarAlunoTopObservacoesDisciplinaETurma(idDisciplina, idTurma, 1);
                topNegativo = disciplinaDAO.buscarAlunoTopObservacoesDisciplinaETurma(idDisciplina, idTurma, 2);

            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/professor/disciplinas");
                return;
            }
        }

        request.setAttribute("disciplina", disciplina);
        request.setAttribute("filtroSelecionado", filtro);
        request.setAttribute("turmasDaDisciplina", turmasDaDisciplina);

        request.setAttribute("totalAlunos", totalAlunos);
        request.setAttribute("mediaDisciplina", mediaDisciplina);
        request.setAttribute("acima7", acima7);
        request.setAttribute("abaixo7", abaixo7);

        request.setAttribute("ranking", ranking);
        request.setAttribute("totalObs", totalObs);
        request.setAttribute("ultimasObs", ultimasObs);
        request.setAttribute("topPositivo", topPositivo);
        request.setAttribute("topNegativo", topNegativo);

        request.getRequestDispatcher("/pages/professor/disciplina-detalhe.jsp")
                .forward(request, response);
    }
}