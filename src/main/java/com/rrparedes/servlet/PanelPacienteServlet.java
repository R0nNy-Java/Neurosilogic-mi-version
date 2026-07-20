package com.rrparedes.servlet;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.dao.PacienteDAO;
import com.rrparedes.model.Antecedente;
import com.rrparedes.model.Paciente;
import jakarta.persistence.EntityManager;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * NURSELOGIC – PanelPacienteServlet
 *
 * Controlador del Panel Individual del Paciente (panel_paciente.jsp).
 * Carga el paciente por su Cédula o ID desde MySQL y presenta su panel de módulos de atención.
 */
@WebServlet("/PanelPacienteServlet")
public class PanelPacienteServlet extends HttpServlet {

    private final PacienteDAO pacienteDAO = new PacienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Control de sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String cedula = request.getParameter("cedula");
        String idStr  = request.getParameter("id");

        Paciente paciente = null;

        if (cedula != null && !cedula.trim().isEmpty()) {
            paciente = pacienteDAO.buscarPorCedula(cedula.trim());
        } else if (idStr != null && !idStr.trim().isEmpty()) {
            try {
                paciente = pacienteDAO.buscarPorId(Long.parseLong(idStr.trim()));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        if (paciente == null) {
            response.sendRedirect(request.getContextPath() + "/PacientesServlet?error=Paciente+no+encontrado");
            return;
        }

        // Cargar antecedentes asociados
        try {
            EntityManager em = JPAUtil.getEntityManager();
            List<Antecedente> antecedentes = em.createQuery(
                "SELECT a FROM Antecedente a WHERE a.paciente.idPaciente = :idPac", Antecedente.class)
                .setParameter("idPac", paciente.getIdPaciente())
                .getResultList();
            em.close();
            request.setAttribute("antecedentes", antecedentes);
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("paciente", paciente);
        request.getRequestDispatcher("/panel_paciente.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
