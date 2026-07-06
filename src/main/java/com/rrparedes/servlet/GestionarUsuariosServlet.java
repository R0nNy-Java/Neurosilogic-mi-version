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
 * NURSELOGIC – GestionarUsuariosServlet
 *
 * Controlador exclusivo para el rol ADMINISTRADOR.
 * Permite:
 *  GET  → muestra la lista de usuarios (gestionar_usuarios.jsp)
 *  POST → procesa acciones: asignarRol, bloquear, desbloquear
 *
 * TODO Fase 2: integrar con BD (UsuarioDAO).
 */
@WebServlet("/GestionarUsuariosServlet")
public class GestionarUsuariosServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Solo ADMINISTRADOR puede acceder
        if (!esAdmin(request, response)) return;

        // TODO Fase 2: cargar lista desde BD
        // request.setAttribute("listaUsuarios", UsuarioDAO.obtenerTodos());

        request.getRequestDispatcher("/gestionar_usuarios.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!esAdmin(request, response)) return;

        request.setCharacterEncoding("UTF-8");

        String accion        = request.getParameter("accion");        // "asignarRol" | "bloquear" | "desbloquear"
        String nombreUsuario = request.getParameter("NombreUsuario");

        if (accion == null || nombreUsuario == null) {
            response.sendRedirect(request.getContextPath() + "/GestionarUsuariosServlet");
            return;
        }

        switch (accion) {

            case "asignarRol":
                String nuevoRol = request.getParameter("Rol");
                if (nuevoRol != null && !nuevoRol.isEmpty()) {
                    Usuario u = UserStore.buscarPorUsuario(nombreUsuario);
                    if (u != null) u.setRol(nuevoRol);
                    request.setAttribute("successMsg",
                        "✔ Rol '" + nuevoRol + "' asignado al usuario: " + nombreUsuario);
                }
                break;

            case "bloquear":
                UserStore.setBloqueado(nombreUsuario, true);
                request.setAttribute("successMsg",
                    "✔ Cuenta bloqueada: " + nombreUsuario);
                break;

            case "desbloquear":
                UserStore.setBloqueado(nombreUsuario, false);
                request.setAttribute("successMsg",
                    "✔ Cuenta desbloqueada: " + nombreUsuario);
                break;

            default:
                request.setAttribute("errorMsg", "⚠ Acción no reconocida.");
        }

        request.getRequestDispatcher("/gestionar_usuarios.jsp").forward(request, response);
    }

    /** Verifica que el usuario tenga rol ADMINISTRADOR. Si no, redirige. */
    private boolean esAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMINISTRADOR".equals(session.getAttribute("rol"))) {
            response.sendRedirect(request.getContextPath()
                + "/index.jsp?error=Acceso+restringido+a+Administradores.");
            return false;
        }
        return true;
    }
}
