package rrparedes.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * NURSELOGIC – SignosVitalesServlet
 * Módulo: Monitorización de Signos Vitales con Alertas Cromáticas
 * GET  → muestra formulario signos_vitales.jsp
 * POST → valida rangos, genera alertas (ROJO/AZUL/NORMAL) y reenvía
 * Rangos normales adultos 19-60 años:
 *   Temperatura:    36.0 – 37.5 °C
 *   Sistólica:      90  – 139 mmHg
 *   Diastólica:     60  – 89  mmHg
 *   Frec. Cardiaca: 60  – 100 lpm
 *   Frec. Respirat: 12  – 20  rpm
 *   Saturación O2:  95  – 100 %
 *   Glicemia:       70  – 100 mg/dL
 * TODO Fase 2: persistir con SignosVitalesDAO (múltiples registros por día)
 */
@WebServlet("/SignosVitalesServlet")
public class SignosVitalesServlet extends HttpServlet {

    // ── Rangos normales (adultos 19-60) ──
    private static final double TEMP_MIN    = 36.0, TEMP_MAX    = 37.5;
    private static final int    SIS_MIN     = 90,   SIS_MAX     = 139;
    private static final int    DIA_MIN     = 60,   DIA_MAX     = 89;
    private static final int    FC_MIN      = 60,   FC_MAX      = 100;
    private static final int    FR_MIN      = 12,   FR_MAX      = 20;
    private static final int    SAT_MIN     = 95,   SAT_MAX     = 100;
    private static final int    GLIC_MIN    = 70,   GLIC_MAX    = 100;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!verificarSesion(request, response)) return;
        request.getRequestDispatcher("/signos_vitales.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarSesion(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        // Leer parámetros
        String paciente  = request.getParameter("Paciente");
        String tempStr   = request.getParameter("Temperatura");
        String sisStr    = request.getParameter("Sistolica");
        String diaStr    = request.getParameter("Diastolica");
        String fcStr     = request.getParameter("FrecCardiaca");
        String frStr     = request.getParameter("FrecRespiratoria");
        String satStr    = request.getParameter("SaturacionO2");
        String glicStr   = request.getParameter("Glicemia");
        String turno     = request.getParameter("Turno");

        if (estaVacio(paciente)) {
            request.setAttribute("errorMsg", "⚠ Debe seleccionar un paciente.");
            request.getRequestDispatcher("/signos_vitales.jsp").forward(request, response);
            return;
        }

        // Generar alertas por comparación con rangos
        StringBuilder alertas = new StringBuilder();
        int alertCount = 0;

        alertCount += verificarAlerta(tempStr, TEMP_MIN, TEMP_MAX, "Temperatura", "°C", alertas);
        alertCount += verificarAlertaInt(sisStr, SIS_MIN, SIS_MAX, "Presión Sistólica", "mmHg", alertas);
        alertCount += verificarAlertaInt(diaStr, DIA_MIN, DIA_MAX, "Presión Diastólica", "mmHg", alertas);
        alertCount += verificarAlertaInt(fcStr,  FC_MIN,  FC_MAX,  "Frec. Cardiaca", "lpm", alertas);
        alertCount += verificarAlertaInt(frStr,  FR_MIN,  FR_MAX,  "Frec. Respiratoria", "rpm", alertas);
        alertCount += verificarAlertaInt(satStr, SAT_MIN, SAT_MAX, "Saturación O₂", "%", alertas);
        alertCount += verificarAlertaInt(glicStr,GLIC_MIN,GLIC_MAX,"Glicemia", "mg/dL", alertas);

        // TODO Fase 2: SignosVitalesDAO.guardar(new SignosVitales(...));
        request.setAttribute("alertasGeneradas", alertas.toString());
        request.setAttribute("numAlertas", alertCount);
        request.setAttribute("successMsg",
            "✔ Signos vitales registrados. " + alertCount + " alerta(s) detectada(s).");
        request.getRequestDispatcher("/signos_vitales.jsp").forward(request, response);
    }

    /**
     * Verifica un valor double contra el rango.
     * @return 1 si hay alerta, 0 si está en rango o vacío.
     */
    private int verificarAlerta(String valStr, double min, double max,
                                String nombre, String unidad, StringBuilder sb) {
        if (estaVacio(valStr)) return 0;
        try {
            double val = Double.parseDouble(valStr.replace(",", "."));
            if (val < min) {
                sb.append("[AZUL] ").append(nombre).append(": ").append(val)
                  .append(" ").append(unidad).append(" (bajo lo normal: <").append(min).append(")|");
                return 1;
            } else if (val > max) {
                sb.append("[ROJO] ").append(nombre).append(": ").append(val)
                  .append(" ").append(unidad).append(" (sobre lo normal: >").append(max).append(")|");
                return 1;
            }
        } catch (NumberFormatException ignored) {}
        return 0;
    }

    private int verificarAlertaInt(String valStr, int min, int max,
                                   String nombre, String unidad, StringBuilder sb) {
        return verificarAlerta(valStr, min, max, nombre, unidad, sb);
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
