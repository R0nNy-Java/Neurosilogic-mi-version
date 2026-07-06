package rrparedes.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * NURSELOGIC – LogoutServlet
 *
 * Cierra la sesión activa del usuario de forma segura:
 *  1. Invalida el objeto HttpSession (elimina todos los atributos)
 *  2. Redirige al login con mensaje de confirmación
 */
@WebServlet("/LogoutServlet")
public class
LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        cerrarSesion(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        cerrarSesion(request, response);
    }

    private void cerrarSesion(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        // Obtener sesión existente sin crear una nueva
        HttpSession session = request.getSession(false);

        if (session != null) {
            // Eliminar todos los atributos y cerrar la sesión
            session.invalidate();
        }

        // Redirigir al login con mensaje informativo
        response.sendRedirect(request.getContextPath()
            + "/login.jsp?msg=Sesion+cerrada+correctamente.+Hasta+pronto.");
    }
}
