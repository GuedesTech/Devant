package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.LoginDAO;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String login = request.getParameter("username");
        String senha = request.getParameter("password");
        String cargo = request.getParameter("cargo");

        LoginDAO loginDAO = new LoginDAO();
        Usuario usuario = loginDAO.autenticar(login, senha);

        HttpSession session = request.getSession();

        if (usuario != null) {

            int tipo = usuario.getId_tipo_user();

            if (
                    ("aluno".equals(cargo) && tipo == 1) ||
                            ("professor".equals(cargo) && tipo == 2) ||
                            ("adm".equals(cargo) && tipo == 3)
            ) {

                session.setAttribute("usuario", usuario);

                if (tipo == 1) {
                    session.removeAttribute("tentativasAluno");
                }

                if (tipo == 1) {
                    response.sendRedirect(request.getContextPath() + "/aluno/perfil");
                } else if (tipo == 2) {
                    response.sendRedirect(request.getContextPath() + "/professor/turmas");
                } else {
                    response.sendRedirect(request.getContextPath() + "/adm/perfil");
                }

                return;
            }
        }

        if ("aluno".equals(cargo)) {

            Integer tentativas = (Integer) session.getAttribute("tentativasAluno");

            if (tentativas == null) {
                tentativas = 0;
            }

            tentativas++;
            session.setAttribute("tentativasAluno", tentativas);

            if (tentativas >= 3) {
                request.setAttribute("erro",
                        "Você errou 3 vezes. Talvez seja necessário validar sua matrícula antes de cadastrar seu login e senha. Clique em 'Cadastre-se'.");
            } else {
                request.setAttribute("erro", "Usuário ou senha inválidos.");
            }

        } else {
            request.setAttribute("erro", "Usuário ou senha inválidos.");
        }

        if ("adm".equals(cargo)) {
            request.getRequestDispatcher("/pages/login/login_adm.jsp").forward(request, response);
        } else if ("professor".equals(cargo)) {
            request.getRequestDispatcher("/pages/login/login_prof.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/pages/login/index.jsp")
                    .forward(request, response);
        }
    }
}