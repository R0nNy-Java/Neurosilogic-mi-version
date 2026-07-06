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
 * esté autenticado antes de acceder a recursos protegidos.
 *
 * Rutas públicas (sin sesión requerida):
 *  - /login.jsp, /LoginServlet
 *  - /nueva_cuenta.jsp, /NuevaCuentaServlet
 *  - Recursos estáticos: /css/, /js/, /images/, favicon
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
        // No se requiere inicialización adicional
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
        // Ruta relativa al contexto de la aplicación
        String ruta        = uri.substring(contextPath.length());

        // 1. Permitir siempre recursos estáticos (CSS, JS, imágenes, favicon)
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
            // Sesión nula o expirada → redirigir al login con aviso
            response.sendRedirect(contextPath
                + "/login.jsp?msg=Sesion+expirada+o+no+iniciada.+Inicie+sesion.");
            return;
        }

        // 4. Sesión válida → continuar con la petición
        chain.doFilter(servletRequest, servletResponse);
    }

    @Override
    public void destroy() {
        // Nada que liberar
    }

    /** Verifica si la ruta corresponde a un recurso estático del cliente. */
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
