package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.dao.NotaDAO;
import com.example.secretariaescolar.dao.ObservacaoDAO;
import com.example.secretariaescolar.dao.ProfessorDAO;
import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.MediaDisciplina;
import com.example.secretariaescolar.model.Usuario;
import com.example.secretariaescolar.dto.NotasAlunoDTO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/professor/aluno/analise")
public class ProfessorAlunoDetalheServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        Usuario usuario = (Usuario) session.getAttribute("usuario");

        String idAlunoStr = request.getParameter("id_aluno");
        if (idAlunoStr == null || idAlunoStr.isBlank()) {
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        int idAluno;
        try {
            idAluno = Integer.parseInt(idAlunoStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        AlunoDAO alunoDAO = new AlunoDAO();
        NotaDAO notaDAO = new NotaDAO();
        ObservacaoDAO observacaoDAO = new ObservacaoDAO();
        ProfessorDAO professorDAO = new ProfessorDAO();

        Aluno aluno = alunoDAO.buscarPorIdAluno(idAluno);
        if (aluno == null) {
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        Integer idProfessor = professorDAO.buscarIdProfessorPorIdUser(usuario.getId_user());
        if (idProfessor == null) {
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        Disciplina disciplinaProfessor = professorDAO.getDisciplina(idProfessor);
        if (disciplinaProfessor == null) {
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        int idDisciplinaProfessor = disciplinaProfessor.getId_disciplina();

        NotasAlunoDTO notasProfessor = notaDAO.buscarN1N2(idAluno, idDisciplinaProfessor);
        if (notasProfessor == null) {
            notasProfessor = new NotasAlunoDTO();
            notasProfessor.setN1(0.0);
            notasProfessor.setN2(0.0);
        }

        int totalObs = observacaoDAO.contarTotalPorAlunoEDisciplina(idAluno, idDisciplinaProfessor);
        int totalElogios = observacaoDAO.contarPorAlunoETipoEDisciplina(idAluno, 1, idDisciplinaProfessor);
        int totalPdm = observacaoDAO.contarPorAlunoETipoEDisciplina(idAluno, 2, idDisciplinaProfessor);

        List<MediaDisciplina> mediasGeral = notaDAO.listarMediasPorDisciplina(idAluno);
        List<MediaDisciplina> mediasS1 = notaDAO.listarMediasPorDisciplinaPorSemestre(idAluno, "1");
        List<MediaDisciplina> mediasS2 = notaDAO.listarMediasPorDisciplinaPorSemestre(idAluno, "2");

        if (mediasGeral == null) mediasGeral = new ArrayList<>();
        if (mediasS1 == null) mediasS1 = new ArrayList<>();
        if (mediasS2 == null) mediasS2 = new ArrayList<>();

        request.setAttribute("aluno", aluno);
        request.setAttribute("disciplinaProfessor", disciplinaProfessor);
        request.setAttribute("notasProfessor", notasProfessor);
        request.setAttribute("totalObs", totalObs);
        request.setAttribute("totalElogios", totalElogios);
        request.setAttribute("totalPdm", totalPdm);

        request.setAttribute("mediasGeral", mediasGeral);
        request.setAttribute("mediasS1", mediasS1);
        request.setAttribute("mediasS2", mediasS2);

        request.getRequestDispatcher("/pages/professor/aluno-analise.jsp")
                .forward(request, response);
    }
}