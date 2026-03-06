package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.DisciplinaDAO;
import com.example.secretariaescolar.dao.NotaDAO;
import com.example.secretariaescolar.dao.ProfessorDAO;
import com.example.secretariaescolar.dto.NotasAlunoDTO;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/adm/aluno/desempenho")
public class AdmAlunoDesempenhoServlet extends HttpServlet {

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

        String idAlunoStr = request.getParameter("id_aluno");
        if (idAlunoStr == null || idAlunoStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/adm/alunos");
            return;
        }
        int idAluno = Integer.parseInt(idAlunoStr);

        DisciplinaDAO ddao = new DisciplinaDAO();
        List<Disciplina> disciplinas = ddao.listarTodas();
        request.setAttribute("disciplinas", disciplinas);
        request.setAttribute("idAluno", idAluno);

        String idDiscStr = request.getParameter("id_disciplina");
        if (idDiscStr != null && !idDiscStr.isBlank()) {
            int idDisc = Integer.parseInt(idDiscStr);

            NotaDAO notaDAO = new NotaDAO();
            NotasAlunoDTO notas = notaDAO.buscarN1N2(idAluno, idDisc);

            request.setAttribute("idDisciplina", idDisc);
            request.setAttribute("notas", notas);
        }

        request.getRequestDispatcher("/pages/adm/aluno-desempenho.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        int idAluno = Integer.parseInt(request.getParameter("id_aluno"));
        int idDisciplina = Integer.parseInt(request.getParameter("id_disciplina"));

        double n1 = parseDoubleSafe(request.getParameter("n1"));
        double n2 = parseDoubleSafe(request.getParameter("n2"));

        ProfessorDAO pdao = new ProfessorDAO();
        Integer idProfessor = pdao.buscarPrimeiroProfessorDaDisciplina(idDisciplina);

        if (idProfessor == null) {
            response.sendRedirect(request.getContextPath() + "/adm/aluno/desempenho?id_aluno=" + idAluno + "&id_disciplina=" + idDisciplina + "&erro=sem_prof");
            return;
        }

        NotaDAO notaDAO = new NotaDAO();
        notaDAO.salvarOuAtualizarN1N2(idAluno, idDisciplina, idProfessor, n1, n2);

        response.sendRedirect(request.getContextPath() + "/adm/aluno/desempenho?id_aluno=" + idAluno + "&id_disciplina=" + idDisciplina + "&ok=1");
    }

    private double parseDoubleSafe(String s) {
        try {
            if (s == null || s.isBlank()) return 0.0;
            return Double.parseDouble(s.replace(",", "."));
        } catch (Exception e) {
            return 0.0;
        }
    }
}