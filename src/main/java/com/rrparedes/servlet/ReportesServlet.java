package com.rrparedes.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * NURSELOGIC – ReportesServlet
 * Módulo: Reportes de Evolución de Signos Vitales
 * GET  → muestra formulario y tabla de reportes (reportes.jsp)
 * POST → aplica filtros (paciente, rango fechas, turno) y devuelve datos
 * Filtros: Paciente, FechaDesde, FechaHasta, Turno (MAÑANA/TARDE/NOCHE)
 * TODO Fase 2: consultar SignosVitalesDAO con filtros dinámicos
 */
@WebServlet("/ReportesServlet")
public class ReportesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!verificarSesion(request, response)) return;
        request.getRequestDispatcher("/reportes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarSesion(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        // Recoger filtros
        String paciente    = request.getParameter("Paciente");
        String fechaDesde  = request.getParameter("FechaDesde");
        String fechaHasta  = request.getParameter("FechaHasta");
        String turno       = request.getParameter("Turno"); // MAÑANA, TARDE, NOCHE, TODOS

        // Pasar filtros de vuelta a la vista para mostrar en el formulario
        request.setAttribute("filtPaciente",   paciente);
        request.setAttribute("filtFechaDesde", fechaDesde);
        request.setAttribute("filtFechaHasta", fechaHasta);
        request.setAttribute("filtTurno",      turno);

        // TODO Fase 2: List<SignosVitales> datos = SignosVitalesDAO.buscarConFiltros(...);
        //              request.setAttribute("datosReporte", datos);

        // Por ahora se muestran datos demo visuales en el JSP
        request.setAttribute("infoMsg",
            "Mostrando datos de ejemplo · Filtros: Turno=" + (turno != null ? turno : "TODOS"));

        request.getRequestDispatcher("/reportes.jsp").forward(request, response);
    }

    private boolean verificarSesion(HttpServletRequest req, HttpServletResponse res)
            throws IOException {
        HttpSession s = req.getSession(false);
        if (s == null || s.getAttribute("usuario") == null) {
            res.sendRedirect(req.getContextPath() + "/login.jsp");
            return false;
        }
        return true;
    }
}
