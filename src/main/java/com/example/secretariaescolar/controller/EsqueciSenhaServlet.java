package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.UsuarioDAO;
import com.example.secretariaescolar.model.Usuario;
import com.example.secretariaescolar.util.EmailUtil;
import jakarta.mail.MessagingException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/esqueci-senha")
public class EsqueciSenhaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String login = request.getParameter("login");
        String cargo = request.getParameter("cargo");

        UsuarioDAO usuarioDAO = new UsuarioDAO();
        Usuario usuario = usuarioDAO.buscarPorLogin(login);

        if (usuario == null) {
            request.setAttribute("erro", "Login não encontrado.");
            voltarTelaLogin(cargo, request, response);
            return;
        }

       int numero = (int) (Math.random() * 9000) + 1000;
       String codigo = String.valueOf(numero);

        HttpSession session = request.getSession();
        session.setAttribute("codigoRecuperacao", codigo);
        session.setAttribute("loginRecuperacao", login);
        session.setAttribute("cargoRecuperacao", cargo);

        try {
            EmailUtil.enviarCodigo(login, codigo);
            request.setAttribute("sucesso", "Código enviado para o email.");
            request.setAttribute("abrirModalCodigo", true);
        } catch (MessagingException e) {
            e.printStackTrace();
            request.setAttribute("erro", "Não foi possível enviar o email.");
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