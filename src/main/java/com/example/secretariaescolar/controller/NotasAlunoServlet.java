package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.dao.NotaDAO;
import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.model.MediaDisciplina;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.*;

@WebServlet("/aluno/notas")
public class NotasAlunoServlet extends HttpServlet {

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
        Aluno aluno = alunoDAO.buscarPorIdUser(usuario.getId_user());

        if (aluno == null) {
            request.setAttribute("erro", "Aluno não encontrado.");
            request.getRequestDispatcher("/pages/aluno/notas-aluno.jsp").forward(request, response);
            return;
        }

        NotaDAO notaDAO = new NotaDAO();

        List<MediaDisciplina> mediasGeral = notaDAO.listarMediasPorDisciplina(aluno.getId_aluno());
        List<MediaDisciplina> mediasS1 = notaDAO.listarMediasPorDisciplinaPorSemestre(aluno.getId_aluno(), "1");
        List<MediaDisciplina> mediasS2 = notaDAO.listarMediasPorDisciplinaPorSemestre(aluno.getId_aluno(), "2");

        int acima7 = notaDAO.contarDisciplinasAcimaOuIgual7(aluno.getId_aluno());
        int abaixo7 = notaDAO.contarDisciplinasAbaixo7(aluno.getId_aluno());
        double mediaGeralAluno = notaDAO.calcularMediaGeral(aluno.getId_aluno());

        MediaDisciplina destaque = null;
        MediaDisciplina atencao = null;

        for (MediaDisciplina md : mediasGeral) {
            if (destaque == null || md.getMedia() > destaque.getMedia())
                destaque = md;
            if (atencao == null || md.getMedia() < atencao.getMedia())
                atencao = md;
        }

        Map<String, Double> mapS1 = new HashMap<>();
        for (MediaDisciplina md : mediasS1)
            mapS1.put(md.getDisciplina(), md.getMedia());

        Map<String, Double> mapS2 = new HashMap<>();
        for (MediaDisciplina md : mediasS2)
            mapS2.put(md.getDisciplina(), md.getMedia());

        String discMaiorEvolucao = null;
        double maiorEvolucao = Double.NEGATIVE_INFINITY;

        String discMaiorRegressao = null;
        double maiorRegressao = Double.POSITIVE_INFINITY;

        for (String disc : mapS1.keySet()) {
            if (!mapS2.containsKey(disc))
                continue;

            double delta = mapS2.get(disc) - mapS1.get(disc);

            if (delta > maiorEvolucao) {
                maiorEvolucao = delta;
                discMaiorEvolucao = disc;
            }
            if (delta < maiorRegressao) {
                maiorRegressao = delta;
                discMaiorRegressao = disc;
            }
        }

        request.setAttribute("aluno", aluno);

        request.setAttribute("mediasGeral", mediasGeral);
        request.setAttribute("mediasS1", mediasS1);
        request.setAttribute("mediasS2", mediasS2);

        request.setAttribute("acima7", acima7);
        request.setAttribute("abaixo7", abaixo7);
        request.setAttribute("mediaGeral", mediaGeralAluno);

        request.setAttribute("cardDestaque", destaque);
        request.setAttribute("cardAtencao", atencao);

        request.setAttribute("discMaiorEvolucao", discMaiorEvolucao);
        request.setAttribute("maiorEvolucao", maiorEvolucao);

        request.setAttribute("discMaiorRegressao", discMaiorRegressao);
        request.setAttribute("maiorRegressao", maiorRegressao);

        request.getRequestDispatcher("/pages/aluno/notas-aluno.jsp").forward(request, response);
    }
}