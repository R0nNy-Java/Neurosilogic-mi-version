package com.rrparedes.servlet;

import com.rrparedes.model.UserStore;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * NURSELOGIC – DashboardServlet
 *
 * Punto de entrada al panel de control principal.
 * Verifica sesión activa antes de mostrar el Dashboard.
 */
@WebServlet("/DashboardServlet")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        long pendientesRol = UserStore.getTodos().stream()
                .filter(u -> u.getRol() == null || u.getRol().trim().isEmpty() || "PENDIENTE".equalsIgnoreCase(u.getRol().trim()))
                .count();
        request.setAttribute("pendientesRol", pendientesRol);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
