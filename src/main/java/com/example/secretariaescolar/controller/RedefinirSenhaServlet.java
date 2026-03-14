package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.UsuarioDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/redefinir-senha")
public class RedefinirSenhaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Boolean codigoValidado = (Boolean) session.getAttribute("codigoValidado");
        String login = (String) session.getAttribute("loginRecuperacao");
        String cargo = (String) session.getAttribute("cargoRecuperacao");

        String novaSenha = request.getParameter("novaSenha");

        if (codigoValidado == null || !codigoValidado || login == null) {
            request.setAttribute("erro", "Valide o código antes de trocar a senha.");
            voltarTelaLogin(cargo, request, response);
            return;
        }

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        boolean ok = usuarioDAO.atualizarSenhaPorLogin(login, novaSenha);

        if (ok) {
            session.removeAttribute("codigoRecuperacao");
            session.removeAttribute("loginRecuperacao");
            session.removeAttribute("cargoRecuperacao");
            session.removeAttribute("codigoValidado");

            request.setAttribute("sucesso", "Senha redefinida com sucesso.");
        } else {
            request.setAttribute("erro", "Não foi possível redefinir a senha.");
        }

        voltarTelaLogin(cargo, request, response);
    }

    private void voltarTelaLogin(String cargo, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if ("professor".equals(cargo)) {
            request.getRequestDispatcher("/pages/login/login_prof.jsp").forward(request, response);
        } else if ("adm".equals(cargo)) {
            request.getRequestDispatcher("/pages/login/login_adm.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/pages/login/index.jsp").forward(request, response);
        }
    }
}