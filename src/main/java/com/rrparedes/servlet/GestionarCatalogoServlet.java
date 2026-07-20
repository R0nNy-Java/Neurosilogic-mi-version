package com.rrparedes.servlet;

import com.rrparedes.dao.MedicamentoDAO;
import com.rrparedes.model.Medicamento;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * NURSELOGIC – GestionarCatalogoServlet
 *
 * Controlador exclusivo para el rol ADMINISTRADOR.
 * Permite listar, agregar y eliminar medicamentos del catálogo en tiempo real (Persistido en MySQL vía MedicamentoDAO).
 */
@WebServlet("/GestionarCatalogoServlet")
public class GestionarCatalogoServlet extends HttpServlet {

    private final MedicamentoDAO medicamentoDAO = new MedicamentoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!esAdmin(request, response)) return;

        cargarYPrecargarSiEsNecesario(request);

        request.getRequestDispatcher("/gestionar_catalogo.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!esAdmin(request, response)) return;

        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion"); // "agregar" | "eliminar"

        if (accion != null) {
            switch (accion) {

                case "agregar":
                    String nombre   = request.getParameter("NombreMedicamento");
                    String concStr  = request.getParameter("Concentracion");
                    String unConc   = request.getParameter("UnidadConcentracion");
                    String volStr   = request.getParameter("VolumenPresentacion");
                    String unVol    = request.getParameter("UnidadVolumen");
                    String presComp = request.getParameter("PresentacionCompleta");

                    if (nombre == null || nombre.trim().isEmpty()) {
                        request.setAttribute("errorMsg", "⚠ El nombre del medicamento es obligatorio.");
                    } else {
                        try {
                            BigDecimal concentracion = (concStr != null && !concStr.trim().isEmpty()) ? new BigDecimal(concStr.trim()) : BigDecimal.ZERO;
                            BigDecimal volumen = (volStr != null && !volStr.trim().isEmpty()) ? new BigDecimal(volStr.trim()) : BigDecimal.ZERO;

                            String presentacion = (presComp != null && !presComp.trim().isEmpty()) 
                                    ? presComp.trim() 
                                    : (nombre.trim() + " " + concentracion + (unConc != null ? unConc : ""));

                            Medicamento m = new Medicamento(
                                nombre.trim(),
                                concentracion,
                                unConc != null ? unConc.trim() : "mg",
                                volumen,
                                unVol != null ? unVol.trim() : "mL",
                                presentacion
                            );

                            medicamentoDAO.guardar(m);
                            request.setAttribute("successMsg",
                                "✔ Medicamento '" + nombre.trim() + "' guardado en la Base de Datos correctamente.");
                        } catch (Exception e) {
                            e.printStackTrace();
                            request.setAttribute("errorMsg", "❌ Error al guardar medicamento: " + e.getMessage());
                        }
                    }
                    break;

                case "eliminar":
                    String idStr = request.getParameter("idMedicamento");
                    if (idStr != null && !idStr.trim().isEmpty()) {
                        try {
                            Long id = Long.parseLong(idStr.trim());
                            medicamentoDAO.eliminar(id);
                            request.setAttribute("successMsg",
                                "✔ Medicamento eliminado del catálogo correctamente.");
                        } catch (Exception e) {
                            e.printStackTrace();
                            request.setAttribute("errorMsg", "❌ Error al eliminar medicamento: " + e.getMessage());
                        }
                    }
                    break;

                default:
                    request.setAttribute("errorMsg", "⚠ Acción no reconocida.");
            }
        }

        cargarYPrecargarSiEsNecesario(request);

        request.getRequestDispatcher("/gestionar_catalogo.jsp").forward(request, response);
    }

    private void cargarYPrecargarSiEsNecesario(HttpServletRequest request) {
        try {
            List<Medicamento> lista = medicamentoDAO.listarTodos();
            if (lista.isEmpty()) {
                // Precarga inicial en MySQL
                medicamentoDAO.guardar(new Medicamento("Paracetamol", new BigDecimal("500.00"), "mg", new BigDecimal("1.00"), "tab", "Paracetamol 500mg Comprimido"));
                medicamentoDAO.guardar(new Medicamento("Ibuprofeno", new BigDecimal("400.00"), "mg", new BigDecimal("1.00"), "tab", "Ibuprofeno 400mg Comprimido"));
                medicamentoDAO.guardar(new Medicamento("Amoxicilina", new BigDecimal("500.00"), "mg", new BigDecimal("1.00"), "cap", "Amoxicilina 500mg Cápsula"));
                medicamentoDAO.guardar(new Medicamento("Suero Fisiológico 0.9%", new BigDecimal("0.90"), "%", new BigDecimal("500.00"), "mL", "Suero Fisiológico 0.9% 500mL IV"));
                medicamentoDAO.guardar(new Medicamento("Metformina", new BigDecimal("850.00"), "mg", new BigDecimal("1.00"), "tab", "Metformina 850mg Comprimido"));
                lista = medicamentoDAO.listarTodos();
            }
            request.setAttribute("listaMedicamentos", lista);
        } catch (Exception e) {
            e.printStackTrace();
        }
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
