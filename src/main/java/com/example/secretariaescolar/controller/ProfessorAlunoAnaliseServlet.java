package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.dao.DisciplinaDAO;
import com.example.secretariaescolar.dao.NotaDAO;
import com.example.secretariaescolar.dao.ObservacaoDAO;
import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.MediaDisciplina;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/professor/aluno/analise")
public class ProfessorAlunoAnaliseServlet extends HttpServlet {

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

        int idAluno;
        try {
            idAluno = Integer.parseInt(request.getParameter("id_aluno"));
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/professor/alunos");
            return;
        }

        AlunoDAO alunoDAO = new AlunoDAO();
        Aluno aluno = alunoDAO.buscarPorIdAluno(idAluno);

        if (aluno == null) {
            response.sendRedirect(request.getContextPath() + "/professor/alunos");
            return;
        }

        DisciplinaDAO disciplinaDAO = new DisciplinaDAO();
        Disciplina disciplinaAtual = disciplinaDAO.buscarDisciplinaDoProfessorPorIdUser(usuario.getId_user());

        if (disciplinaAtual == null) {
            request.setAttribute("erro", "Não foi possível identificar a disciplina do professor logado.");
            request.getRequestDispatcher("/pages/professor/aluno-analise.jsp").forward(request, response);
            return;
        }

        NotaDAO notaDAO = new NotaDAO();
        ObservacaoDAO observacaoDAO = new ObservacaoDAO();

        MediaDisciplina nota1Obj = notaDAO.buscarMediaDaDisciplinaPorAlunoESemestre(
                idAluno, disciplinaAtual.getId_disciplina(), "1");

        MediaDisciplina nota2Obj = notaDAO.buscarMediaDaDisciplinaPorAlunoESemestre(
                idAluno, disciplinaAtual.getId_disciplina(), "2");

        MediaDisciplina mediaObj = notaDAO.buscarMediaDaDisciplinaPorAluno(
                idAluno, disciplinaAtual.getId_disciplina());

        List<MediaDisciplina> mediasS1 = new ArrayList<>();
        List<MediaDisciplina> mediasS2 = new ArrayList<>();
        List<MediaDisciplina> mediasGeral = new ArrayList<>();

        if (nota1Obj != null)
            mediasS1.add(nota1Obj);
        if (nota2Obj != null)
            mediasS2.add(nota2Obj);
        if (mediaObj != null)
            mediasGeral.add(mediaObj);

        double nota1 = nota1Obj != null ? nota1Obj.getMedia() : 0.0;
        double nota2 = nota2Obj != null ? nota2Obj.getMedia() : 0.0;
        double mediaGeral = mediaObj != null ? mediaObj.getMedia() : 0.0;

        int totalObs = observacaoDAO.contarTotalPorAlunoEDisciplina(idAluno, disciplinaAtual.getId_disciplina());
        int totalElogios = observacaoDAO.contarPorAlunoETipoEDisciplina(idAluno, 1, disciplinaAtual.getId_disciplina());
        int totalPdm = observacaoDAO.contarPorAlunoETipoEDisciplina(idAluno, 2, disciplinaAtual.getId_disciplina());

        request.setAttribute("aluno", aluno);
        request.setAttribute("disciplinaAtual", disciplinaAtual);

        request.setAttribute("nota1", nota1);
        request.setAttribute("nota2", nota2);
        request.setAttribute("mediaGeral", mediaGeral);

        request.setAttribute("mediasS1", mediasS1);
        request.setAttribute("mediasS2", mediasS2);
        request.setAttribute("mediasGeral", mediasGeral);

        request.setAttribute("totalObs", totalObs);
        request.setAttribute("totalElogios", totalElogios);
        request.setAttribute("totalPdm", totalPdm);

        request.getRequestDispatcher("/pages/professor/aluno-analise.jsp").forward(request, response);
    }
}