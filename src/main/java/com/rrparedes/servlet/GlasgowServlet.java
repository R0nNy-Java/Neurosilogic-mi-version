package com.rrparedes.servlet;

import com.rrparedes.dao.GlasgowDAO;
import com.rrparedes.dao.PacienteDAO;
import com.rrparedes.model.EscalaGlasgow;
import com.rrparedes.model.Paciente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeParseException;

/**
 * NURSELOGIC – GlasgowServlet
 * Módulo: Escala de Glasgow (Respuesta Ocular 1-4, Verbal 1-5, Motora 1-6)
 * GET  → muestra formulario escala_glasgow.jsp
 * POST → valida los tres componentes, calcula el total y persiste el
 *        registro en la tabla escalaglasgow, asociado al Paciente por cédula.
 */
@WebServlet("/GlasgowServlet")
public class GlasgowServlet extends HttpServlet {

    private final PacienteDAO pacienteDAO = new PacienteDAO();
    private final GlasgowDAO glasgowDAO = new GlasgowDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!verificarSesion(request, response)) return;
        cargarHistorial(request);
        request.getRequestDispatcher("/escala_glasgow.jsp").forward(request, response);
    }
    private void cargarHistorial(HttpServletRequest request) {
        String cedula = request.getParameter("cedula");
        if (estaVacio(cedula)) return;

        Paciente pacienteEntidad = pacienteDAO.buscarPorCedula(cedula.trim());
        if (pacienteEntidad == null) return;

        request.setAttribute("historialGlasgow",
                glasgowDAO.listarPorPaciente(pacienteEntidad.getIdPaciente()));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarSesion(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String cedula       = request.getParameter("cedula");
        String paciente      = request.getParameter("Paciente");
        String fechaHoraStr  = request.getParameter("FechaHora");
        String ocularStr     = request.getParameter("Ocular");
        String verbalStr     = request.getParameter("Verbal");
        String motorStr      = request.getParameter("Motor");
        String observacion   = request.getParameter("Observacion");

        // Validar campos obligatorios
        if (estaVacio(paciente) || estaVacio(fechaHoraStr) || estaVacio(ocularStr)
                || estaVacio(verbalStr) || estaVacio(motorStr)) {
            request.setAttribute("errorMsg",
                    "⚠ Debe seleccionar paciente, fecha/hora y todos los componentes de la escala.");
            request.getRequestDispatcher("/escala_glasgow.jsp").forward(request, response);
            return;
        }

        // El registro clínico requiere un paciente ya existente en la BD (FK obligatoria)
        if (estaVacio(cedula)) {
            request.setAttribute("errorMsg",
                    "⚠ No se pudo identificar al paciente. Ingrese a este formulario desde " +
                            "la Ficha Clínica del paciente (Pacientes → Panel del Paciente → Escala Glasgow).");
            request.getRequestDispatcher("/escala_glasgow.jsp").forward(request, response);
            return;
        }

        Paciente pacienteEntidad = pacienteDAO.buscarPorCedula(cedula.trim());
        if (pacienteEntidad == null) {
            request.setAttribute("errorMsg",
                    "⚠ El paciente indicado (cédula " + cedula.trim() + ") no existe en el sistema.");
            request.getRequestDispatcher("/escala_glasgow.jsp").forward(request, response);
            return;
        }

        try {
            int ocular = Integer.parseInt(ocularStr);
            int verbal = Integer.parseInt(verbalStr);
            int motor  = Integer.parseInt(motorStr);

            // Validar rangos
            if (ocular < 1 || ocular > 4) throw new NumberFormatException("Ocular fuera de rango");
            if (verbal < 1 || verbal > 5) throw new NumberFormatException("Verbal fuera de rango");
            if (motor  < 1 || motor  > 6) throw new NumberFormatException("Motor fuera de rango");

            LocalDateTime fechaHora = LocalDateTime.parse(fechaHoraStr); // formato datetime-local: yyyy-MM-ddTHH:mm

            int total = ocular + verbal + motor; // Rango: 3-15
            String nivel = total >= 13 ? "Leve" : total >= 9 ? "Moderado" : "Grave";

            EscalaGlasgow registro = new EscalaGlasgow(
                    pacienteEntidad, fechaHora, ocular, verbal, motor, total, nivel,
                    estaVacio(observacion) ? null : observacion.trim());

            glasgowDAO.guardar(registro);

            request.setAttribute("successMsg",
                    "✔ Escala de Glasgow registrada y guardada. Puntaje total: " + total + " – " + nivel);
            request.setAttribute("totalGlasgowResult", total);
            request.setAttribute("nivelResult", nivel);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "⚠ Valores de escala inválidos. Verifique los campos.");
        } catch (DateTimeParseException e) {
            request.setAttribute("errorMsg", "⚠ Fecha y hora inválidas. Verifique el campo.");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "⚠ Ocurrió un error al guardar el registro. Intente nuevamente.");
        }

        request.setAttribute("historialGlasgow",
                glasgowDAO.listarPorPaciente(pacienteEntidad.getIdPaciente()));
        request.getRequestDispatcher("/escala_glasgow.jsp").forward(request, response);
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