package rrparedes.servlet;

import com.rrparedes.model.UserStore;
import com.rrparedes.model.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * NURSELOGIC – RecuperarUsuarioServlet
 *
 * Flujo de recuperación de nombre de usuario:
 *   GET  → muestra el formulario recuperar_usuario.jsp
 *   POST → busca usuario por NombreCompleto + Email → muestra el username
 *
 * En Fase 2 (con BD): enviar el nombre de usuario al correo registrado.
 */
@WebServlet("/RecuperarUsuarioServlet")
public class RecuperarUsuarioServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/recuperar_usuario.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String nombreCompleto = request.getParameter("NombreCompleto");
        String email          = request.getParameter("Email");

        // Validar campos
        if (estaVacio(nombreCompleto) || estaVacio(email)) {
            request.setAttribute("errorMsg",
                "⚠ Ingrese su nombre completo y correo electrónico.");
            request.getRequestDispatcher("/recuperar_usuario.jsp").forward(request, response);
            return;
        }

        // Buscar en todos los usuarios por nombre + email
        Usuario encontrado = null;
        for (Usuario u : UserStore.getTodos()) {
            boolean coincideEmail  = u.getEmail().equalsIgnoreCase(email.trim());
            boolean coincideNombre = u.getNombreCompleto()
                                      .equalsIgnoreCase(nombreCompleto.trim());
            if (coincideEmail && coincideNombre) {
                encontrado = u;
                break;
            }
        }

        if (encontrado == null) {
            request.setAttribute("errorMsg",
                "❌ No se encontró ninguna cuenta con ese nombre y correo electrónico.");
            request.getRequestDispatcher("/recuperar_usuario.jsp").forward(request, response);
            return;
        }

        // Mostrar el username encontrado
        request.setAttribute("exitoso",           true);
        request.setAttribute("usuarioRecuperado", encontrado.getNombreUsuario());
        request.setAttribute("rolUsuario",        encontrado.getRol());
        request.getRequestDispatcher("/recuperar_usuario.jsp").forward(request, response);
    }

    private boolean estaVacio(String s) {
        return s == null || s.trim().isEmpty();
    }
}
