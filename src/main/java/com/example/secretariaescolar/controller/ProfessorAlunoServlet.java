package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.dao.DisciplinaDAO;
import com.example.secretariaescolar.dao.ObservacaoDAO;
import com.example.secretariaescolar.dao.ProfessorDAO;
import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Observacao;
import com.example.secretariaescolar.model.Professor;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/professor/aluno")
public class ProfessorAlunoServlet extends HttpServlet {

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

        int idAluno = parseInt(request.getParameter("id_aluno"));
        if (idAluno <= 0) {
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
            request.getRequestDispatcher("/pages/professor/aluno-observacoes.jsp").forward(request, response);
            return;
        }

        ObservacaoDAO observacaoDAO = new ObservacaoDAO();
        List<Observacao> observacoes = observacaoDAO.listarPorAlunoEDisciplina(idAluno,
                disciplinaAtual.getId_disciplina());

        int totalObs = observacaoDAO.contarTotalPorAlunoEDisciplina(idAluno, disciplinaAtual.getId_disciplina());
        int totalElogios = observacaoDAO.contarPorAlunoETipoEDisciplina(idAluno, 1, disciplinaAtual.getId_disciplina());
        int totalPdm = observacaoDAO.contarPorAlunoETipoEDisciplina(idAluno, 2, disciplinaAtual.getId_disciplina());

        request.setAttribute("aluno", aluno);
        request.setAttribute("disciplinaAtual", disciplinaAtual);
        request.setAttribute("observacoes", observacoes);
        request.setAttribute("totalObs", totalObs);
        request.setAttribute("totalElogios", totalElogios);
        request.setAttribute("totalPdm", totalPdm);
        request.setAttribute("ok", request.getParameter("ok"));
        request.setAttribute("okEdicao", request.getParameter("okEdicao"));
        request.setAttribute("erro", request.getParameter("erro"));

        request.getRequestDispatcher("/pages/professor/aluno-observacoes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

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

        int idAluno = parseInt(request.getParameter("id_aluno"));
        int tipo = parseInt(request.getParameter("tipo"));
        int idDisciplina = parseInt(request.getParameter("id_disciplina"));
        String mensagem = request.getParameter("mensagem");

        if (idAluno <= 0) {
            response.sendRedirect(request.getContextPath() + "/professor/alunos");
            return;
        }

        if (mensagem == null || mensagem.isBlank()) {
            redirectErro(response, request, idAluno, "Preencha a mensagem da observação.");
            return;
        }

        if (tipo != 1 && tipo != 2) {
            redirectErro(response, request, idAluno, "Tipo de observação inválido.");
            return;
        }

        DisciplinaDAO disciplinaDAO = new DisciplinaDAO();
        Disciplina disciplinaProfessor = disciplinaDAO.buscarDisciplinaDoProfessorPorIdUser(usuario.getId_user());
        if (disciplinaProfessor == null) {
            redirectErro(response, request, idAluno, "Disciplina do professor não encontrada.");
            return;
        }

        if (idDisciplina != disciplinaProfessor.getId_disciplina()) {
            redirectErro(response, request, idAluno, "Você só pode lançar observações da sua própria disciplina.");
            return;
        }

        ProfessorDAO professorDAO = new ProfessorDAO();
        Professor professor = professorDAO.buscaPorUsuario(usuario.getId_user());
        if (professor == null) {
            redirectErro(response, request, idAluno, "Professor não encontrado.");
            return;
        }

        Observacao observacao = new Observacao();
        observacao.setMensagem(mensagem.trim());
        observacao.setData(LocalDate.now());
        observacao.setId_aluno(idAluno);
        observacao.setId_professor(professor.getId_professor());
        observacao.setId_disciplina(idDisciplina);
        observacao.setTipo(tipo);

        ObservacaoDAO observacaoDAO = new ObservacaoDAO();
        boolean salvou = observacaoDAO.salvar(observacao);

        if (!salvou) {
            redirectErro(response, request, idAluno, "Não foi possível salvar a observação.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/professor/aluno?id_aluno=" + idAluno + "&ok=1");
    }

    private int parseInt(String valor) {
        try {
            return Integer.parseInt(valor);
        } catch (Exception e) {
            return -1;
        }
    }

    private void redirectErro(HttpServletResponse response, HttpServletRequest request, int idAluno, String msg)
            throws IOException {
        response.sendRedirect(
                request.getContextPath()
                        + "/professor/aluno?id_aluno="
                        + idAluno
                        + "&erro="
                        + URLEncoder.encode(msg, StandardCharsets.UTF_8));
    }
}