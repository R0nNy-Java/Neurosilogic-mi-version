package com.rrparedes.servlet;

import com.rrparedes.model.UserStore;
import com.rrparedes.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * NURSELOGIC – CambioContrasenaServlet
 *
 * Permite a un usuario autenticado cambiar su contraseña.
 * Validaciones:
 *  - Sesión activa (control de sesión)
 *  - Contraseña actual correcta
 *  - Nueva contraseña mínimo 6 caracteres
 *  - Confirmación coincidente
 *  - Nueva contraseña distinta a la actual
 * Al finalizar: cierra la sesión (re-autenticación obligatoria).
 */
@WebServlet("/CambioContrasenaServlet")
public class CambioContrasenaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Control de sesión: solo usuarios autenticados
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath()
                + "/login.jsp?msg=Debe+iniciar+sesion+para+cambiar+su+contrasena.");
            return;
        }

        String usuarioSesion    = (String) session.getAttribute("usuario");

        // 2. Recoger parámetros
        String contrasenaActual = request.getParameter("ContrasenaActual");
        String nuevaContrasena  = request.getParameter("NuevaContrasena");
        String confirmar        = request.getParameter("ConfirmarContrasena");

        // 3. Validar campos vacíos
        if (estaVacio(contrasenaActual) || estaVacio(nuevaContrasena) || estaVacio(confirmar)) {
            request.setAttribute("errorMsg", "⚠ Todos los campos son obligatorios.");
            reenviar(request, response);
            return;
        }

        // 4. Verificar contraseña actual
        Usuario u = UserStore.buscarPorUsuario(usuarioSesion);
        if (u == null || !u.getContrasena().equals(contrasenaActual)) {
            request.setAttribute("errorMsg", "❌ La contraseña actual es incorrecta.");
            reenviar(request, response);
            return;
        }

        // 5. Nueva contraseña != actual
        if (nuevaContrasena.equals(contrasenaActual)) {
            request.setAttribute("errorMsg",
                "⚠ La nueva contraseña no puede ser igual a la contraseña actual.");
            reenviar(request, response);
            return;
        }

        // 6. Longitud mínima
        if (nuevaContrasena.length() < 6) {
            request.setAttribute("errorMsg",
                "⚠ La nueva contraseña debe tener al menos 6 caracteres.");
            reenviar(request, response);
            return;
        }

        // 7. Confirmación coincide
        if (!nuevaContrasena.equals(confirmar)) {
            request.setAttribute("errorMsg",
                "⚠ La nueva contraseña y su confirmación no coinciden.");
            reenviar(request, response);
            return;
        }

        // 8. Aplicar el cambio
        UserStore.cambiarContrasena(usuarioSesion, nuevaContrasena);

        // 9. Cerrar sesión (re-autenticación obligatoria por seguridad)
        session.invalidate();

        response.sendRedirect(request.getContextPath()
            + "/login.jsp?msg=Contrasena+actualizada+exitosamente.+Inicie+sesion+nuevamente.");
    }

    /** GET: mostrar formulario (solo si hay sesión activa). */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.getRequestDispatcher("/cambio_contrasena.jsp").forward(request, response);
    }

    private void reenviar(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/cambio_contrasena.jsp").forward(req, res);
    }

    private boolean estaVacio(String s) {
        return s == null || s.trim().isEmpty();
    }
}
