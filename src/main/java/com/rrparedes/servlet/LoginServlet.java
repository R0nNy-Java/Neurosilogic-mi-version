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
import java.util.HashMap;
import java.util.Map;

/**
 * NURSELOGIC – LoginServlet
 *
 * Gestiona el módulo de seguridad de acceso:
 *  ✔ Login exitoso     → crea sesión y redirige al Dashboard
 *  ✔ Rol pendiente     → deniega el acceso indicando "Usuario Aún no asignado"
 *  ✔ Login fallido     → muestra error y cuenta intentos
 *  ✔ Bloqueo temporal  → 3 intentos fallidos → bloqueo de 5 minutos
 *  ✔ Bloqueo permanente→ cuenta deshabilitada por administrador
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    private static final int  MAX_INTENTOS     = 3;
    private static final long DURACION_BLOQUEO = 5 * 60 * 1000L; // 5 minutos

    /** Seguimiento de intentos: usuario → [contador, timestampBloqueo] */
    private final Map<String, long[]> intentos = new HashMap<>();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Leer usuario y contraseña
        String nombreUsuario = request.getParameter("NombreUsuario");
        String contrasena    = request.getParameter("Contrasena");

        // 2. Campos vacíos
        if (estaVacio(nombreUsuario) || estaVacio(contrasena)) {
            reenviarConError(request, response,
                "⚠ Ingrese su nombre de usuario y contraseña.", null);
            return;
        }

        final String usuario = nombreUsuario.trim().toLowerCase();

        // 3. Bloqueo temporal por intentos fallidos
        if (estaBloqueadoTemporalmente(usuario)) {
            long min = minutosRestantes(usuario);
            reenviarConError(request, response,
                "🔒 Cuenta bloqueada temporalmente. Intente nuevamente en "
                + min + " minuto(s).", "BLOQUEADO_TEMP");
            return;
        }

        // 4. Buscar usuario en el almacén
        Usuario u = UserStore.buscarPorUsuario(usuario);

        // 5. Bloqueo permanente por administrador
        if (u != null && u.isBloqueado()) {
            reenviarConError(request, response,
                "🚫 Su cuenta ha sido deshabilitada. Contacte al administrador del sistema.",
                "BLOQUEADO_PERM");
            return;
        }

        // 6. Validar credenciales (usuario + contraseña)
        boolean credencialesOk = u != null && u.getContrasena().equals(contrasena);

        if (credencialesOk) {

            // 7. VERIFICACIÓN DE ROL: Si aún no tiene rol asignado (PENDIENTE / NULO)
            String rol = u.getRol();
            if (estaVacio(rol) || "PENDIENTE".equalsIgnoreCase(rol.trim()) || "AUN NO ASIGNADO".equalsIgnoreCase(rol.trim())) {
                reenviarConError(request, response,
                    "⏳ Usuario Aún no asignado. Su cuenta está pendiente de asignación de rol por un Administrador.",
                    "SIN_ROL");
                return;
            }

            // ═══════════════════════════════
            //   ✔ LOGIN EXITOSO
            // ═══════════════════════════════
            limpiarIntentos(usuario);

            HttpSession session = request.getSession(true);
            session.setAttribute("usuario",        u.getNombreUsuario());
            session.setAttribute("rol",            u.getRol());
            session.setAttribute("nombreCompleto", u.getNombreCompleto());
            session.setAttribute("sesionIniciada", true);
            session.setMaxInactiveInterval(30 * 60); // 30 min inactividad

            // Redirigir al Dashboard principal
            response.sendRedirect(request.getContextPath() + "/index.jsp");

        } else {
            // ═══════════════════════════════
            //   ✖ LOGIN FALLIDO
            // ═══════════════════════════════
            registrarIntentoFallido(usuario);
            int restantes = MAX_INTENTOS - getContadorIntentos(usuario);

            String mensaje;
            if (restantes <= 0) {
                mensaje = "🔒 Demasiados intentos fallidos. Cuenta bloqueada por "
                        + (DURACION_BLOQUEO / 60000) + " minutos.";
            } else {
                mensaje = "❌ Usuario o contraseña incorrectos. "
                        + "Intentos restantes: " + restantes + ".";
            }
            reenviarConError(request, response, mensaje, null);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }

    // ── Helpers ─────────────────────────────────────────────────────

    private void reenviarConError(HttpServletRequest req, HttpServletResponse res,
                                  String mensaje, String tipo)
            throws ServletException, IOException {
        req.setAttribute("errorMsg",  mensaje);
        if (tipo != null) req.setAttribute("errorTipo", tipo);
        req.getRequestDispatcher("/login.jsp").forward(req, res);
    }

    private boolean estaVacio(String s) {
        return s == null || s.trim().isEmpty();
    }

    private synchronized void registrarIntentoFallido(String usuario) {
        long[] info = intentos.getOrDefault(usuario, new long[]{0, 0});
        info[0]++;
        if (info[0] >= MAX_INTENTOS) info[1] = System.currentTimeMillis();
        intentos.put(usuario, info);
    }

    private synchronized boolean estaBloqueadoTemporalmente(String usuario) {
        long[] info = intentos.get(usuario);
        if (info == null || info[0] < MAX_INTENTOS) return false;
        if (System.currentTimeMillis() - info[1] >= DURACION_BLOQUEO) {
            limpiarIntentos(usuario);
            return false;
        }
        return true;
    }

    private synchronized long minutosRestantes(String usuario) {
        long[] info = intentos.get(usuario);
        if (info == null) return 0;
        return Math.max(1, (DURACION_BLOQUEO - (System.currentTimeMillis() - info[1])) / 60000 + 1);
    }

    private synchronized int getContadorIntentos(String usuario) {
        long[] info = intentos.get(usuario);
        return info == null ? 0 : (int) info[0];
    }

    private synchronized void limpiarIntentos(String usuario) {
        intentos.remove(usuario);
    }
}
