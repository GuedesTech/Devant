package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.DisciplinaDAO;
import com.example.secretariaescolar.dao.ObservacaoDAO;
import com.example.secretariaescolar.dao.ProfessorDAO;
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

@WebServlet("/professor/observacao/editar")
public class ProfessorEditarObservacaoServlet extends HttpServlet {

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

        int idObservacao = parseInt(request.getParameter("id_observacao"));
        int idAluno = parseInt(request.getParameter("id_aluno"));
        int tipo = parseInt(request.getParameter("tipo"));
        String mensagem = request.getParameter("mensagem");

        if (idObservacao <= 0 || idAluno <= 0) {
            redirectErro(response, request, idAluno, "Observação inválida.");
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

        ProfessorDAO professorDAO = new ProfessorDAO();
        Professor professor = professorDAO.buscaPorUsuario(usuario.getId_user());
        if (professor == null) {
            redirectErro(response, request, idAluno, "Professor não encontrado.");
            return;
        }

        ObservacaoDAO observacaoDAO = new ObservacaoDAO();
        Observacao existente = observacaoDAO.buscarPorIdDoProfessor(
                idObservacao,
                professor.getId_professor(),
                disciplinaProfessor.getId_disciplina());

        if (existente == null) {
            redirectErro(response, request, idAluno, "Você só pode editar observações da sua própria disciplina.");
            return;
        }

        if (existente.getId_aluno() != idAluno) {
            redirectErro(response, request, idAluno, "Observação não pertence a esse aluno.");
            return;
        }

        existente.setMensagem(mensagem.trim());
        existente.setTipo(tipo);

        boolean atualizou = observacaoDAO.atualizar(existente);

        if (!atualizou) {
            redirectErro(response, request, idAluno, "Não foi possível atualizar a observação.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/professor/aluno?id_aluno=" + idAluno + "&okEdicao=1");
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