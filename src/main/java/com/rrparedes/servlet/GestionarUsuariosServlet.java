package com.rrparedes.servlet;

import com.rrparedes.dao.UsuarioDAO;
import com.rrparedes.model.UserStore;
import com.rrparedes.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Collection;

/**
 * NURSELOGIC – GestionarUsuariosServlet
 *
 * Controlador exclusivo para el rol ADMINISTRADOR.
 * Permite listar y asignar roles / cambiar estados de cuentas en tiempo real (Persistido en MySQL).
 */
@WebServlet("/GestionarUsuariosServlet")
public class GestionarUsuariosServlet extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!esAdmin(request, response)) return;

        // Cargar lista de usuarios desde MySQL / UserStore
        Collection<Usuario> lista = UserStore.getTodos();
        request.setAttribute("listaUsuarios", lista);

        request.getRequestDispatcher("/gestionar_usuarios.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!esAdmin(request, response)) return;

        request.setCharacterEncoding("UTF-8");

        String accion        = request.getParameter("accion");        // "asignarRol" | "bloquear" | "desbloquear"
        String nombreUsuario = request.getParameter("NombreUsuario");

        if (accion != null && nombreUsuario != null) {
            Usuario u = UserStore.buscarPorUsuario(nombreUsuario);
            if (u != null) {
                switch (accion) {

                    case "asignarRol":
                        String nuevoRol = request.getParameter("Rol");
                        if (nuevoRol != null && !nuevoRol.trim().isEmpty()) {
                            u.setRol(nuevoRol.trim());
                            usuarioDAO.guardar(u);
                            request.setAttribute("successMsg",
                                "✔ Rol '" + nuevoRol.trim() + "' asignado exitosamente al usuario: " + u.getNombreUsuario());
                        }
                        break;

                    case "bloquear":
                        UserStore.setBloqueado(nombreUsuario, true);
                        request.setAttribute("successMsg",
                            "✔ Cuenta bloqueada exitosamente: " + u.getNombreUsuario());
                        break;

                    case "desbloquear":
                        UserStore.setBloqueado(nombreUsuario, false);
                        request.setAttribute("successMsg",
                            "✔ Cuenta desbloqueada exitosamente: " + u.getNombreUsuario());
                        break;

                    default:
                        request.setAttribute("errorMsg", "⚠ Acción no reconocida.");
                }
            } else {
                request.setAttribute("errorMsg", "⚠ No se encontró el usuario: " + nombreUsuario);
            }
        }

        // Refrescar lista de usuarios actualizada
        Collection<Usuario> lista = UserStore.getTodos();
        request.setAttribute("listaUsuarios", lista);

        request.getRequestDispatcher("/gestionar_usuarios.jsp").forward(request, response);
    }

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
