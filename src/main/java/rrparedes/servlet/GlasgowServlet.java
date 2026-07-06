package rrparedes.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * NURSELOGIC – GlasgowServlet
 * Módulo: Escala de Glasgow (Respuesta Ocular 1-4, Verbal 1-5, Motora 1-6)
 * GET  → muestra formulario escala_glasgow.jsp
 * POST → valida los tres componentes, calcula el total y reenvía con resultado
 * TODO Fase 2: persistir en BD (GlasgowDAO)
 */
@WebServlet("/GlasgowServlet")
public class GlasgowServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        verificarSesion(request, response);
        request.getRequestDispatcher("/escala_glasgow.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarSesion(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String paciente    = request.getParameter("Paciente");
        String fechaHoraStr= request.getParameter("FechaHora");
        String ocularStr   = request.getParameter("Ocular");
        String verbalStr   = request.getParameter("Verbal");
        String motorStr    = request.getParameter("Motor");
        String observacion = request.getParameter("Observacion");

        // Validar campos obligatorios
        if (estaVacio(paciente) || estaVacio(ocularStr)
                || estaVacio(verbalStr) || estaVacio(motorStr)) {
            request.setAttribute("errorMsg",
                "⚠ Debe seleccionar paciente y todos los componentes de la escala.");
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

            int total = ocular + verbal + motor; // Rango: 3-15
            String nivel = total >= 13 ? "Leve" : total >= 9 ? "Moderado" : "Grave";

            // TODO Fase 2: GlasgowDAO.guardar(new RegistroGlasgow(...));
            request.setAttribute("successMsg",
                "✔ Escala de Glasgow registrada. Puntaje total: " + total + " – " + nivel);
            request.setAttribute("totalGlasgowResult", total);
            request.setAttribute("nivelResult", nivel);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "⚠ Valores de escala inválidos. Verifique los campos.");
        }

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
