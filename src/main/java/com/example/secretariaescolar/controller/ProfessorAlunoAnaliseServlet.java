package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.dao.BoletimDAO;
import com.example.secretariaescolar.dao.DisciplinaDAO;
import com.example.secretariaescolar.dao.NotaDAO;
import com.example.secretariaescolar.dao.ObservacaoDAO;
import com.example.secretariaescolar.dto.NotasAlunoDTO;
import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.MediaDisciplina;
import com.example.secretariaescolar.model.Observacao;
import com.example.secretariaescolar.model.Usuario;
import com.example.secretariaescolar.util.Conexao;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.Connection;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        AlunoDAO alunoDAO = new AlunoDAO();
        Aluno aluno = alunoDAO.buscarPorIdAluno(idAluno);

        if (aluno == null) {
            response.sendRedirect(request.getContextPath() + "/professor/turmas");
            return;
        }

        DisciplinaDAO disciplinaDAO = new DisciplinaDAO();
        NotaDAO notaDAO = new NotaDAO();
        ObservacaoDAO observacaoDAO = new ObservacaoDAO();

        List<Disciplina> disciplinas = disciplinaDAO.listarTodas();
        if (disciplinas == null) disciplinas = new ArrayList<>();

        Integer idDisciplina = null;
        String idDisciplinaStr = request.getParameter("id_disciplina");

        if (idDisciplinaStr != null && !idDisciplinaStr.isBlank()) {
            try {
                idDisciplina = Integer.parseInt(idDisciplinaStr);
            } catch (Exception ignored) {
            }
        }

        if (idDisciplina == null && !disciplinas.isEmpty()) {
            idDisciplina = disciplinas.get(0).getId_disciplina();
        }

        Disciplina disciplinaAtual = null;
        if (idDisciplina != null) {
            for (Disciplina d : disciplinas) {
                if (d.getId_disciplina() == idDisciplina) {
                    disciplinaAtual = d;
                    break;
                }
            }
        }

        // ===== MAPA DE NOTAS POR DISCIPLINA =====
        Map<String, NotasAlunoDTO> notasMap = new HashMap<>();

        // ===== MAPA DE TOTAIS DE OBSERVAÇÃO POR DISCIPLINA =====
        Map<String, Integer> totalObsMap = new HashMap<>();
        Map<String, Integer> totalElogiosMap = new HashMap<>();
        Map<String, Integer> totalPdmMap = new HashMap<>();

        // ===== MAPA DE OBSERVAÇÕES POR DISCIPLINA =====
        Map<String, List<Observacao>> observacoesMap = new HashMap<>();

        try (Connection conn = Conexao.conectar()) {
            BoletimDAO boletimDAO = new BoletimDAO(conn);

            for (Disciplina d : disciplinas) {
                int idDisc = d.getId_disciplina();
                String chave = String.valueOf(idDisc);

                NotasAlunoDTO notas = notaDAO.buscarN1N2(idAluno, idDisc);
                if (notas == null) {
                    notas = new NotasAlunoDTO();
                    notas.setN1(0.0);
                    notas.setN2(0.0);
                    notas.getMedia();
                }
                notasMap.put(chave, notas);

                int totalObs = observacaoDAO.contarTotalPorAlunoEDisciplina(idAluno, idDisc);
                int totalElogios = observacaoDAO.contarPorAlunoETipoEDisciplina(idAluno, 1, idDisc);
                int totalPdm = observacaoDAO.contarPorAlunoETipoEDisciplina(idAluno, 2, idDisc);

                totalObsMap.put(chave, totalObs);
                totalElogiosMap.put(chave, totalElogios);
                totalPdmMap.put(chave, totalPdm);

                List<Observacao> observacoes = boletimDAO.listarObservacoesDaDisciplina(idAluno, idDisc);
                if (observacoes == null) observacoes = new ArrayList<>();
                observacoesMap.put(chave, observacoes);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        // ===== GRÁFICO =====
        List<MediaDisciplina> mediasGeral = notaDAO.listarMediasPorDisciplina(idAluno);
        List<MediaDisciplina> mediasS1 = notaDAO.listarMediasPorDisciplinaPorSemestre(idAluno, "1");
        List<MediaDisciplina> mediasS2 = notaDAO.listarMediasPorDisciplinaPorSemestre(idAluno, "2");

        if (mediasGeral == null) mediasGeral = new ArrayList<>();
        if (mediasS1 == null) mediasS1 = new ArrayList<>();
        if (mediasS2 == null) mediasS2 = new ArrayList<>();

        request.setAttribute("aluno", aluno);
        request.setAttribute("disciplinas", disciplinas);
        request.setAttribute("disciplinaAtual", disciplinaAtual);
        request.setAttribute("idDisciplina", idDisciplina);

        request.setAttribute("notasMap", notasMap);
        request.setAttribute("totalObsMap", totalObsMap);
        request.setAttribute("totalElogiosMap", totalElogiosMap);
        request.setAttribute("totalPdmMap", totalPdmMap);
        request.setAttribute("observacoesMap", observacoesMap);

        request.setAttribute("mediasGeral", mediasGeral);
        request.setAttribute("mediasS1", mediasS1);
        request.setAttribute("mediasS2", mediasS2);

        request.getRequestDispatcher("/pages/professor/aluno-analise.jsp").forward(request, response);
    }
}