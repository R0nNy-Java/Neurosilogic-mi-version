package rrparedes.servlet;

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
 * Procesa el formulario de Apertura de Ficha Clínica (registro_paciente.jsp).
 * Valida los datos demográficos obligatorios y almacena en sesión
 * (pendiente de integración con BD en Fase 2).
 */
@WebServlet("/RegistroPacienteServlet")
public class RegistroPacienteServlet extends HttpServlet {

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

        // 1. Recoger parámetros del formulario
        String nombres              = request.getParameter("Nombres");
        String apellidos            = request.getParameter("Apellidos");
        String cedula               = request.getParameter("Cedula");
        String edadStr              = request.getParameter("Edad");
        String sexo                 = request.getParameter("Sexo");
        String[] antecedentes       = request.getParameterValues("Antecedentes");
        String sintomasActuales     = request.getParameter("SintomasActuales");
        String alergias             = request.getParameter("Alergias");
        String dispositivosMedicos  = request.getParameter("DispositivosMedicos");

        // 2. Validar campos demográficos obligatorios
        if (estaVacio(nombres) || estaVacio(apellidos) || estaVacio(cedula)
                || estaVacio(edadStr) || estaVacio(sexo)) {
            request.setAttribute("errorMsg",
                "⚠ Los campos Nombres, Apellidos, Cédula, Edad y Sexo son obligatorios.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        // 3. Validar cédula (10 dígitos numéricos)
        if (!cedula.trim().matches("\\d{10}")) {
            request.setAttribute("errorMsg",
                "⚠ La cédula debe contener exactamente 10 dígitos numéricos.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        // 4. Validar edad
        int edad;
        try {
            edad = Integer.parseInt(edadStr.trim());
            if (edad < 19 || edad > 60) {
                request.setAttribute("errorMsg",
                    "⚠ La edad debe estar entre 19 y 60 años.");
                request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "⚠ El campo Edad debe ser un número válido.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        // 5. TODO (Fase 2): Persistir en base de datos mediante PacienteDAO
        //    PacienteDAO.guardar(new Paciente(nombres, apellidos, cedula, edad, sexo, ...));

        // 6. Preparar datos de confirmación para la vista
        request.setAttribute("nombrePaciente",  nombres.trim() + " " + apellidos.trim());
        request.setAttribute("cedula",          cedula.trim());
        request.setAttribute("registroExitoso", true);

        // Por ahora, reenviar al mismo formulario con mensaje de éxito
        request.setAttribute("successMsg",
            "✔ Ficha clínica registrada correctamente para: "
            + nombres.trim() + " " + apellidos.trim());
        request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
    }

    private boolean estaVacio(String s) {
        return s == null || s.trim().isEmpty();
    }
}
