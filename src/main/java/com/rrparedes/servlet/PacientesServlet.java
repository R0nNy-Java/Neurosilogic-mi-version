package com.rrparedes.servlet;

import com.rrparedes.dao.PacienteDAO;
import com.rrparedes.model.Paciente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * NURSELOGIC – PacientesServlet
 *
 * Controlador del módulo de Gestión de Pacientes.
 * Carga la lista de pacientes desde MySQL usando PacienteDAO y reenvía a pacientes.jsp.
 */
@WebServlet("/PacientesServlet")
public class PacientesServlet extends HttpServlet {

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

        // Cargar todos los pacientes registrados desde la base de datos MySQL
        try {
            List<Paciente> lista = pacienteDAO.listarTodos();
            request.setAttribute("listaPacientes", lista);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "⚠ Error al cargar los pacientes desde la Base de Datos: " + e.getMessage());
        }

        request.getRequestDispatcher("/pacientes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
