package com.rrparedes.servlet;

import com.rrparedes.model.UserStore;
import com.rrparedes.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * NURSELOGIC – OlvidoContrasenaServlet
 *
 * Flujo de recuperación de contraseña (sin base de datos ni email):
 *   GET  → muestra el formulario olvido_contrasena.jsp
 *   POST → valida usuario + email → asigna contraseña temporal → muestra en pantalla
 *
 * En Fase 2 (con BD): enviar contraseña temporal al correo del usuario.
 */
@WebServlet("/OlvidoContrasenaServlet")
public class OlvidoContrasenaServlet extends HttpServlet {

    private static final String CONTRASENA_TEMPORAL = "Temporal2025!";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Mostrar el formulario
        request.getRequestDispatcher("/olvido_contrasena.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombreUsuario = request.getParameter("NombreUsuario");
        String email         = request.getParameter("Email");

        // Validar campos vacíos
        if (estaVacio(nombreUsuario) || estaVacio(email)) {
            request.setAttribute("errorMsg", "⚠ Ingrese su nombre de usuario y correo electrónico.");
            request.getRequestDispatcher("/olvido_contrasena.jsp").forward(request, response);
            return;
        }

        // Buscar usuario
        Usuario u = UserStore.buscarPorUsuario(nombreUsuario.trim());

        // Validar que el email coincida
        if (u == null || !u.getEmail().equalsIgnoreCase(email.trim())) {
            request.setAttribute("errorMsg",
                "❌ No se encontró ninguna cuenta con ese usuario y correo electrónico.");
            request.getRequestDispatcher("/olvido_contrasena.jsp").forward(request, response);
            return;
        }

        // Verificar que la cuenta no esté bloqueada
        if (u.isBloqueado()) {
            request.setAttribute("errorMsg",
                "🚫 Su cuenta está deshabilitada. Contacte al administrador.");
            request.getRequestDispatcher("/olvido_contrasena.jsp").forward(request, response);
            return;
        }

        // Asignar contraseña temporal
        UserStore.cambiarContrasena(u.getNombreUsuario(), CONTRASENA_TEMPORAL);

        // Mostrar resultado con contraseña temporal
        request.setAttribute("exitoso",           true);
        request.setAttribute("usuarioRecuperado", u.getNombreUsuario());
        request.setAttribute("contrasenaTemp",    CONTRASENA_TEMPORAL);
        request.getRequestDispatcher("/olvido_contrasena.jsp").forward(request, response);
    }

    private boolean estaVacio(String s) {
        return s == null || s.trim().isEmpty();
    }
}
