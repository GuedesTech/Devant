package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoDAO;
import com.example.secretariaescolar.dao.DisciplinaDAO;
import com.example.secretariaescolar.dao.ObservacaoAdmDAO;
import com.example.secretariaescolar.model.Aluno;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.ObservacaoAdmView;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/adm/observacoes")
public class AdmObservacoesServlet extends HttpServlet {

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

        String q = request.getParameter("q");
        if (q != null) {
            q = q.trim();
            if (q.isEmpty()) q = null;
        }

        ObservacaoAdmDAO dao = new ObservacaoAdmDAO();
        AlunoDAO alunoDAO = new AlunoDAO();
        DisciplinaDAO disciplinaDAO = new DisciplinaDAO();

        List<ObservacaoAdmView> observacoes = dao.listar(q);
        List<Aluno> alunos = alunoDAO.listarTodosComFoto();
        List<Disciplina> disciplinas = disciplinaDAO.listarTodas();

        request.setAttribute("observacoes", observacoes);
        request.setAttribute("alunos", alunos);
        request.setAttribute("disciplinas", disciplinas);
        request.setAttribute("totalObservacoes", observacoes.size());
        request.setAttribute("q", q == null ? "" : q);

        request.getRequestDispatcher("/pages/adm/observacoes-adm.jsp").forward(request, response);
    }
}