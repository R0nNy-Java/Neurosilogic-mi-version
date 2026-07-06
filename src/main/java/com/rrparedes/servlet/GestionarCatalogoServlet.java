package com.rrparedes.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * NURSELOGIC – GestionarCatalogoServlet
 *
 * Controlador exclusivo para el rol ADMINISTRADOR.
 * Permite gestionar el catálogo de medicamentos del sistema.
 *  GET  → muestra la lista de medicamentos (gestionar_catalogo.jsp)
 *  POST → procesa acciones: agregar, editar, eliminar medicamento
 *
 * TODO Fase 2: integrar con BD (MedicamentoDAO) y persistencia real.
 */
@WebServlet("/GestionarCatalogoServlet")
public class GestionarCatalogoServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!esAdmin(request, response)) return;

        // TODO Fase 2: cargar catálogo desde BD
        // List<Medicamento> catalogo = MedicamentoDAO.obtenerTodos();
        // request.setAttribute("catalogo", catalogo);

        request.getRequestDispatcher("/gestionar_catalogo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!esAdmin(request, response)) return;

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion"); // "agregar" | "editar" | "eliminar"

        if (accion == null) {
            response.sendRedirect(request.getContextPath() + "/GestionarCatalogoServlet");
            return;
        }

        switch (accion) {

            case "agregar":
                // Recoger datos del medicamento
                String nombre      = request.getParameter("NombreMedicamento");
                String codigo      = request.getParameter("Codigo");
                String descripcion = request.getParameter("Descripcion");
                String unidad      = request.getParameter("Unidad");
                String stockStr    = request.getParameter("Stock");

                if (nombre == null || nombre.trim().isEmpty()) {
                    request.setAttribute("errorMsg", "⚠ El nombre del medicamento es obligatorio.");
                } else {
                    // TODO Fase 2: MedicamentoDAO.guardar(new Medicamento(...));
                    request.setAttribute("successMsg",
                        "✔ Medicamento '" + nombre.trim() + "' agregado al catálogo.");
                }
                break;

            case "eliminar":
                String codigoElim = request.getParameter("Codigo");
                if (codigoElim != null && !codigoElim.isEmpty()) {
                    // TODO Fase 2: MedicamentoDAO.eliminar(codigoElim);
                    request.setAttribute("successMsg",
                        "✔ Medicamento con código " + codigoElim + " eliminado del catálogo.");
                }
                break;

            default:
                request.setAttribute("errorMsg", "⚠ Acción no reconocida.");
        }

        request.getRequestDispatcher("/gestionar_catalogo.jsp").forward(request, response);
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
