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
 * NURSELOGIC – NuevaCuentaServlet
 *
 * Procesa el formulario de creación de nueva cuenta de usuario.
 * Validaciones:
 *  - Campos obligatorios completos
 *  - Contraseñas coincidentes y mínimo 6 caracteres
 *  - Nombre de usuario no duplicado
 */
@WebServlet("/NuevaCuentaServlet")
public class NuevaCuentaServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Recoger parámetros
        String nombreCompleto   = request.getParameter("NombreCompleto");
        String nombreUsuario    = request.getParameter("NombreUsuario");
        String email            = request.getParameter("Email");
        String contrasena       = request.getParameter("Contrasena");
        String confirmar        = request.getParameter("ConfirmarContrasena");
        // El rol NO es elegido por el usuario: lo asigna el Administrador.
        // Se registra como "PENDIENTE" hasta que el admin lo asigne.
        String rol = "PENDIENTE";

        // 2. Validar campos obligatorios (Rol ya no viene del formulario)
        if (estaVacio(nombreCompleto) || estaVacio(nombreUsuario)
                || estaVacio(contrasena) || estaVacio(confirmar)) {
            request.setAttribute("errorMsg",
                "⚠ Todos los campos obligatorios (*) deben completarse.");
            reenviar(request, response);
            return;
        }

        // 3. Validar formato del nombre de usuario (solo letras, números, guiones)
        if (!nombreUsuario.trim().matches("[a-zA-Z0-9_\\-]{4,20}")) {
            request.setAttribute("errorMsg",
                "⚠ El nombre de usuario debe tener entre 4 y 20 caracteres "
                + "(letras, números, _ o -).");
            reenviar(request, response);
            return;
        }

        // 4. Verificar que el usuario no exista ya
        if (UserStore.existe(nombreUsuario)) {
            request.setAttribute("errorMsg",
                "⚠ El nombre de usuario '" + nombreUsuario.trim() + "' ya está en uso. Elija otro.");
            reenviar(request, response);
            return;
        }

        // 5. Validar contraseña
        if (contrasena.length() < 6) {
            request.setAttribute("errorMsg",
                "⚠ La contraseña debe tener al menos 6 caracteres.");
            reenviar(request, response);
            return;
        }

        // 6. Verificar coincidencia de contraseñas
        if (!contrasena.equals(confirmar)) {
            request.setAttribute("errorMsg",
                "⚠ La contraseña y su confirmación no coinciden.");
            reenviar(request, response);
            return;
        }

        // 7. Crear y registrar el usuario
        Usuario nuevo = new Usuario(
            nombreUsuario.trim().toLowerCase(),
            contrasena,
            rol,
            nombreCompleto.trim(),
            email != null ? email.trim() : "",
            false  // no bloqueado por defecto
        );

        boolean registrado = UserStore.agregarUsuario(nuevo);

        if (!registrado) {
            // Condición de carrera: otro hilo registró el mismo nombre antes
            request.setAttribute("errorMsg",
                "⚠ Error al registrar. El nombre de usuario ya existe.");
            reenviar(request, response);
            return;
        }

        // 8. Éxito: redirigir al login con mensaje
        response.sendRedirect(request.getContextPath()
            + "/login.jsp?msg=Cuenta+creada+exitosamente.+Inicie+sesion+con+sus+credenciales.");
    }

    /** Redirige GET a la vista de nueva cuenta. */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/nueva_cuenta.jsp").forward(request, response);
    }

    private void reenviar(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {
        req.getRequestDispatcher("/nueva_cuenta.jsp").forward(req, res);
    }

    private boolean estaVacio(String s) {
        return s == null || s.trim().isEmpty();
    }
}
