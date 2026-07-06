package com.rrparedes.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * NURSELOGIC – PacientesServlet
 *
 * Controlador del módulo de Pacientes.
 * GET  → muestra formulario de nuevo registro (registro_paciente.jsp)
 * POST → delega en RegistroPacienteServlet (futuro: listar, buscar, editar)
 *
 * TODO Fase 2: Agregar lógica de listado y búsqueda con BD.
 */
@WebServlet("/PacientesServlet")
public class PacientesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Control de sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // TODO Fase 2: cargar lista de pacientes
        // List<Paciente> lista = PacienteDAO.obtenerTodos();
        // request.setAttribute("listaPacientes", lista);

        request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
