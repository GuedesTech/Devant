package com.example.secretariaescolar.controller;

import com.example.secretariaescolar.dao.AdmPerfilDAO;
import com.example.secretariaescolar.model.AdmPerfilView;
import com.example.secretariaescolar.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

@WebServlet("/adm/perfil")
public class AdmPerfilServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        Usuario usuarioLogado = (Usuario) session.getAttribute("usuario");

        if (usuarioLogado.getId_tipo_user() != 3) {
            response.sendRedirect(request.getContextPath() + "/pages/login/index.jsp");
            return;
        }

        AdmPerfilDAO dao = new AdmPerfilDAO();

        AdmPerfilView admLogado = dao.buscarPorIdUser(usuarioLogado.getId_user());
        List<AdmPerfilView> outrosAdms = dao.listarOutrosAdms(usuarioLogado.getId_user());

        request.setAttribute("adm", admLogado);
        request.setAttribute("outrosAdms", outrosAdms);

        request.getRequestDispatcher("/pages/adm/perfil-adm.jsp").forward(request, response);
    }
}