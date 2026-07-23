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

/**
 * NURSELOGIC – RegistroPacienteServlet
 *
 * Procesa el formulario básico de Registro de Paciente (registro_paciente.jsp).
 * Al guardar exitosamente, redirige directamente al Panel Individual del Paciente.
 */
@WebServlet("/RegistroPacienteServlet")
public class RegistroPacienteServlet extends HttpServlet {

    private final PacienteDAO pacienteDAO = new PacienteDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Control de sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 1. Recoger parámetros básicos
        String cedula    = request.getParameter("Cedula");
        String nombres   = request.getParameter("Nombres");
        String apellidos = request.getParameter("Apellidos");
        String edadStr   = request.getParameter("Edad");
        String sexo      = request.getParameter("Sexo");

        // Preservar en caso de error
        request.setAttribute("paramCedula", cedula);
        request.setAttribute("paramNombres", nombres);
        request.setAttribute("paramApellidos", apellidos);
        request.setAttribute("paramEdad", edadStr);
        request.setAttribute("paramSexo", sexo);

        // 2. Validaciones
        if (estaVacio(cedula) || estaVacio(nombres) || estaVacio(apellidos)
                || estaVacio(edadStr) || estaVacio(sexo)) {
            request.setAttribute("errorMsg", "⚠ Cédula, Nombres, Apellidos, Edad y Sexo son campos obligatorios.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        if (!cedula.trim().matches("\\d{10}")) {
            request.setAttribute("errorMsg", "⚠ La cédula debe contener exactamente 10 dígitos numéricos.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        int edad;
        try {
            edad = Integer.parseInt(edadStr.trim());
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "⚠ La edad debe ser un número entero válido.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        try {
            String cedulaLimpia = cedula.trim();
            Paciente p = pacienteDAO.buscarPorCedula(cedulaLimpia);

            if (p != null) {
                p.setNombres(nombres.trim());
                p.setApellidos(apellidos.trim());
                p.setEdad(edad);
                p.setSexo(sexo.trim());
                pacienteDAO.actualizar(p);
            } else {
                p = new Paciente(cedulaLimpia, nombres.trim(), apellidos.trim(), edad, sexo.trim(), "A");
                pacienteDAO.guardar(p);
            }

            // 3. Redirigir al Panel del Paciente
            response.sendRedirect(request.getContextPath() + "/PanelPacienteServlet?cedula=" + cedulaLimpia);
            return;

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "❌ Error al guardar en la Base de Datos: " + e.getMessage());
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String cedula = request.getParameter("cedula");
        if (cedula != null && !cedula.trim().isEmpty()) {
            Paciente p = pacienteDAO.buscarPorCedula(cedula.trim());
            if (p != null) {
                request.setAttribute("paramCedula", p.getCedula());
                request.setAttribute("paramNombres", p.getNombres());
                request.setAttribute("paramApellidos", p.getApellidos());
                request.setAttribute("paramEdad", String.valueOf(p.getEdad()));
                request.setAttribute("paramSexo", p.getSexo());
            }
        }

        request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
    }

    private boolean estaVacio(String s) {
        return s == null || s.trim().isEmpty();
    }
}