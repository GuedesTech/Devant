package com.example.secretariaescolar.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/verificar-codigo")
public class VerificarCodigoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String codigoDigitado = request.getParameter("codigo");
        String codigoSalvo = (String) session.getAttribute("codigoRecuperacao");
        String cargo = (String) session.getAttribute("cargoRecuperacao");

        if (codigoSalvo != null && codigoSalvo.equals(codigoDigitado)) {
            session.setAttribute("codigoValidado", true);
            request.setAttribute("abrirModalNovaSenha", true);
        } else {
            request.setAttribute("erro", "Código inválido.");
            request.setAttribute("abrirModalCodigo", true);
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