package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AlunoAdmDAO;
import com.example.secretariaescolar.dao.DisciplinaDAO;
import com.example.secretariaescolar.dao.TurmaDAO;
import com.example.secretariaescolar.model.AlunoAdmView;
import com.example.secretariaescolar.model.Disciplina;
import com.example.secretariaescolar.model.Turma;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/adm/alunos")
public class AdmAlunosServlet extends HttpServlet {

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

        AlunoAdmDAO alunoDao = new AlunoAdmDAO();
        TurmaDAO turmaDao = new TurmaDAO();
        DisciplinaDAO disciplinaDao = new DisciplinaDAO();

        List<AlunoAdmView> alunos = alunoDao.listar(q);
        List<Turma> turmas = turmaDao.listarTodas();
        List<Disciplina> disciplinas = disciplinaDao.listarTodas();

        request.setAttribute("alunos", alunos);
        request.setAttribute("totalAlunos", alunos.size());
        request.setAttribute("q", (q == null ? "" : q));

        request.setAttribute("turmas", turmas);
        request.setAttribute("disciplinas", disciplinas);

        request.getRequestDispatcher("/pages/adm/alunos-adm.jsp").forward(request, response);
    }
}