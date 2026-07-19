package com.rrparedes.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * NURSELOGIC – SessionFilter
 *
 * Filtro global de control de sesión.
 * Intercepta TODAS las peticiones (/*) y verifica que el usuario
 * esté autenticado y TENGA UN ROL ASIGNADO antes de acceder.
 */
@WebFilter("/*")
public class SessionFilter implements Filter {

    /** URLs accesibles sin autenticación. */
    private static final List<String> RUTAS_PUBLICAS = Arrays.asList(
        "/login.jsp",
        "/LoginServlet",
        "/nueva_cuenta.jsp",
        "/NuevaCuentaServlet",
        "/olvido_contrasena.jsp",
        "/OlvidoContrasenaServlet",
        "/recuperar_usuario.jsp",
        "/RecuperarUsuarioServlet"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest servletRequest,
                         ServletResponse servletResponse,
                         FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  request  = (HttpServletRequest)  servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;

        String contextPath = request.getContextPath();
        String uri         = request.getRequestURI();
        String ruta        = uri.substring(contextPath.length());

        // 1. Permitir siempre recursos estáticos (CSS, JS, imágenes)
        if (esRecursoEstatico(ruta)) {
            chain.doFilter(servletRequest, servletResponse);
            return;
        }

        // 2. Permitir rutas públicas definidas
        for (String publica : RUTAS_PUBLICAS) {
            if (ruta.equals(publica) || ruta.startsWith(publica + "?")) {
                chain.doFilter(servletRequest, servletResponse);
                return;
            }
        }

        // 3. Verificar sesión activa
        HttpSession session   = request.getSession(false);
        boolean sesionActiva  = session != null
                             && Boolean.TRUE.equals(session.getAttribute("sesionIniciada"));

        if (!sesionActiva) {
            response.sendRedirect(contextPath
                + "/login.jsp?msg=Sesion+expirada+o+no+iniciada.+Inicie+sesion.");
            return;
        }

        // 4. Verificar que el rol no sea PENDIENTE
        String rol = (String) session.getAttribute("rol");
        if (rol == null || "PENDIENTE".equalsIgnoreCase(rol.trim()) || "AUN NO ASIGNADO".equalsIgnoreCase(rol.trim())) {
            session.invalidate();
            response.sendRedirect(contextPath
                + "/login.jsp?msg=Usuario+Aun+no+asignado.+Contacte+al+Administrador.");
            return;
        }

        // 5. Sesión y rol válidos → continuar
        chain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {
    }

    private boolean esRecursoEstatico(String ruta) {
        return ruta.startsWith("/css/")
            || ruta.startsWith("/js/")
            || ruta.startsWith("/images/")
            || ruta.startsWith("/fonts/")
            || ruta.endsWith(".ico")
            || ruta.endsWith(".png")
            || ruta.endsWith(".jpg")
            || ruta.endsWith(".svg")
            || ruta.endsWith(".woff2")
            || ruta.endsWith(".woff");
    }
}
