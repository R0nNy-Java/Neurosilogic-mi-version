package rrparedes.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * NURSELOGIC – AdministracionServlet
 * Módulo: Registro de Administración de Medicamentos + Trazabilidad
 * GET  → muestra formulario administracion.jsp
 * POST → registrar administración | anular administración con justificación
 * Reglas:
 *  - Los registros NO pueden eliminarse.
 *  - La anulación requiere justificación y queda en registro de auditoría.
 *  - Se registra enfermero responsable desde la sesión activa.
 * TODO Fase 2: persistir con AdministracionDAO + AuditoriaDAO
 */
@WebServlet("/AdministracionServlet")
public class AdministracionServlet extends HttpServlet {
//hola
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!verificarSesion(request, response)) return;
        request.getRequestDispatcher("/administracion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarSesion(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion"); // "registrar" | "anular"

        if ("anular".equals(accion)) {
            // ── ANULACIÓN de administración ──
            String idAdmin     = request.getParameter("IdAdministracion");
            String justificacion = request.getParameter("Justificacion");

            if (estaVacio(justificacion)) {
                request.setAttribute("errorMsg",
                    "⚠ La justificación es obligatoria para anular un registro.");
                request.getRequestDispatcher("/administracion.jsp").forward(request, response);
                return;
            }

            // TODO Fase 2: AdministracionDAO.anular(idAdmin, justificacion, usuarioSesion, now)
            //              AuditoriaDAO.registrar(...)
            request.setAttribute("successMsg",
                "✔ Registro ID-" + idAdmin + " anulado correctamente. "
                + "Acción guardada en el registro de auditoría.");

        } else {
            // ── REGISTRAR nueva administración ──
            String paciente     = request.getParameter("Paciente");
            String medicamento  = request.getParameter("Medicamento");
            String dosis        = request.getParameter("DosisCalculada");
            String fechaHora    = request.getParameter("FechaHoraAdmin");

            HttpSession session = request.getSession(false);
            String enfermero = session != null
                ? (String) session.getAttribute("nombreCompleto") : "Desconocido";
            if (enfermero == null) enfermero = (String) session.getAttribute("usuario");

            if (estaVacio(paciente) || estaVacio(medicamento) || estaVacio(dosis)) {
                request.setAttribute("errorMsg",
                    "⚠ Paciente, medicamento y dosis son obligatorios.");
                request.getRequestDispatcher("/administracion.jsp").forward(request, response);
                return;
            }

            // TODO Fase 2: AdministracionDAO.guardar(new Administracion(...))
            request.setAttribute("successMsg",
                "✔ Administración registrada: " + dosis + " mL de " + medicamento
                + " al paciente " + paciente + ". Responsable: " + enfermero);
        }

        request.getRequestDispatcher("/administracion.jsp").forward(request, response);
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

    private boolean estaVacio(String s) { return s == null || s.trim().isEmpty(); }
}
