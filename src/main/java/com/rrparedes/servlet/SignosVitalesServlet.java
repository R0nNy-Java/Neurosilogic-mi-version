package com.rrparedes.servlet;

import com.rrparedes.dao.PacienteDAO;
import com.rrparedes.dao.SignosVitalesDAO;
import com.rrparedes.model.Paciente;
import com.rrparedes.model.SignoVital;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * NURSELOGIC – SignosVitalesServlet
 * Módulo: Monitorización de Signos Vitales con Alertas Cromáticas
 * Usa la entidad SignoVital (tabla signovital) EXACTAMENTE como ya existía
 * en el proyecto — no se modifica el esquema de base de datos.
 * GET  → muestra formulario signos_vitales.jsp (soporta ?cedula= para precargar paciente)
 * POST → valida rangos, genera alertas (ROJO/AZUL) y PERSISTE el registro
 *        en la tabla signovital, asociado al Paciente por cédula.
 *        El campo "Turno" del formulario NO se guarda en BD (esa columna no
 *        existe en la tabla original) — solo se usa para el mensaje en pantalla.
 *        El detalle de alertas tampoco se persiste completo: AlertaGenerada es
 *        CHAR(1) en la tabla original, así que se guarda 'R' (rojo), 'A' (azul)
 *        o 'N' (normal) según la severidad más alta detectada.
 * Rangos normales adultos 19-60 años:
 *   Temperatura:    36.0 – 37.5 °C
 *   Sistólica:      90  – 139 mmHg
 *   Diastólica:     60  – 89  mmHg
 *   Frec. Cardiaca: 60  – 100 lpm
 *   Frec. Respirat: 12  – 20  rpm
 *   Saturación O2:  95  – 100 %
 *   Glicemia:       70  – 100 mg/dL
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

    private final PacienteDAO pacienteDAO = new PacienteDAO();
    private final SignosVitalesDAO signosDAO = new SignosVitalesDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!verificarSesion(request, response)) return;
        cargarHistorial(request);
        request.getRequestDispatcher("/signos_vitales.jsp").forward(request, response);
    }

    private void cargarHistorial(HttpServletRequest request) {
        String cedula = request.getParameter("cedula");
        if (estaVacio(cedula)) return;

        Paciente pacienteEntidad = pacienteDAO.buscarPorCedula(cedula.trim());
        if (pacienteEntidad == null) return;

        request.setAttribute("historialSignos",
                signosDAO.listarPorPaciente(pacienteEntidad.getIdPaciente()));
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarSesion(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        // Leer parámetros (deben coincidir con los "name" del formulario en signos_vitales.jsp)
        String cedula    = request.getParameter("cedula");
        String paciente  = request.getParameter("Paciente");
        String turno     = request.getParameter("Turno");   // solo se usa para el mensaje, no se persiste
        String tempStr   = request.getParameter("Temperatura");
        String sisStr    = request.getParameter("Sistolica");
        String diaStr    = request.getParameter("Diastolica");
        String fcStr     = request.getParameter("FrecCardiaca");
        String frStr     = request.getParameter("FrecRespiratoria");
        String satStr    = request.getParameter("SaturacionO2");
        String glicStr   = request.getParameter("Glicemia");

        if (estaVacio(paciente)) {
            request.setAttribute("errorMsg", "⚠ Debe seleccionar un paciente.");
            request.getRequestDispatcher("/signos_vitales.jsp").forward(request, response);
            return;
        }

        if (estaVacio(turno)) {
            request.setAttribute("errorMsg", "⚠ Debe seleccionar el turno de registro.");
            request.getRequestDispatcher("/signos_vitales.jsp").forward(request, response);
            return;
        }

        // El registro clínico requiere un paciente ya existente en la BD (FK obligatoria)
        if (estaVacio(cedula)) {
            request.setAttribute("errorMsg",
                    "⚠ No se pudo identificar al paciente. Ingrese a este formulario desde " +
                            "la Ficha Clínica del paciente (Pacientes → Panel del Paciente → Signos Vitales).");
            request.getRequestDispatcher("/signos_vitales.jsp").forward(request, response);
            return;
        }

        Paciente pacienteEntidad = pacienteDAO.buscarPorCedula(cedula.trim());
        if (pacienteEntidad == null) {
            request.setAttribute("errorMsg",
                    "⚠ El paciente indicado (cédula " + cedula.trim() + ") no existe en el sistema.");
            request.getRequestDispatcher("/signos_vitales.jsp").forward(request, response);
            return;
        }

        // Generar alertas detalladas (solo para mostrar en pantalla) + severidad global (para BD)
        StringBuilder alertas = new StringBuilder();
        int alertCount = 0;
        boolean hayRojo = false, hayAzul = false;

        alertCount += verificarAlerta(tempStr, TEMP_MIN, TEMP_MAX, "Temperatura", "°C", alertas);
        alertCount += verificarAlertaInt(sisStr, SIS_MIN, SIS_MAX, "Presión Sistólica", "mmHg", alertas);
        alertCount += verificarAlertaInt(diaStr, DIA_MIN, DIA_MAX, "Presión Diastólica", "mmHg", alertas);
        alertCount += verificarAlertaInt(fcStr,  FC_MIN,  FC_MAX,  "Frec. Cardiaca", "lpm", alertas);
        alertCount += verificarAlertaInt(frStr,  FR_MIN,  FR_MAX,  "Frec. Respiratoria", "rpm", alertas);
        alertCount += verificarAlertaInt(satStr, SAT_MIN, SAT_MAX, "Saturación O₂", "%", alertas);
        alertCount += verificarAlertaInt(glicStr,GLIC_MIN,GLIC_MAX,"Glicemia", "mg/dL", alertas);

        if (alertas.indexOf("[ROJO]") >= 0) hayRojo = true;
        if (alertas.indexOf("[AZUL]") >= 0) hayAzul = true;
        String alertaBd = hayRojo ? "R" : (hayAzul ? "A" : "N"); // se guarda en la columna CHAR(1)

        try {
            BigDecimal temperatura = parseBigDecimalSeguro(tempStr);
            Integer sistolica      = parseIntSeguro(sisStr);
            Integer diastolica     = parseIntSeguro(diaStr);
            Integer frecCardiaca   = parseIntSeguro(fcStr);
            Integer frecRespiratoria = parseIntSeguro(frStr);
            Integer saturacionO2   = parseIntSeguro(satStr);
            BigDecimal glicemia    = parseBigDecimalSeguro(glicStr);

            SignoVital registro = new SignoVital(
                    pacienteEntidad, LocalDateTime.now().withNano(0),
                    temperatura, sistolica, diastolica, frecCardiaca, frecRespiratoria,
                    saturacionO2, glicemia, alertaBd);

            signosDAO.guardar(registro);

            request.setAttribute("alertasGeneradas", alertas.toString());
            request.setAttribute("numAlertas", alertCount);
            request.setAttribute("successMsg",
                    "✔ Signos vitales guardados (turno " + turno + "). " + alertCount + " alerta(s) detectada(s).");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "⚠ Ocurrió un error al guardar el registro. Intente nuevamente.");
        }

        request.setAttribute("historialSignos",
                signosDAO.listarPorPaciente(pacienteEntidad.getIdPaciente()));
        request.getRequestDispatcher("/signos_vitales.jsp").forward(request, response);
    }

    /**
     * Verifica un valor contra el rango y arma la alerta en formato [ROJO]/[AZUL] para pantalla.
     * @return 1 si hay alerta, 0 si está en rango o vacío/no numérico.
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

    private BigDecimal parseBigDecimalSeguro(String s) {
        if (estaVacio(s)) return null;
        try {
            return new BigDecimal(s.replace(",", "."));
        } catch (NumberFormatException e) {
            return null;
        }
    }

    private Integer parseIntSeguro(String s) {
        if (estaVacio(s)) return null;
        try {
            return (int) Math.round(Double.parseDouble(s.replace(",", ".")));
        } catch (NumberFormatException e) {
            return null;
        }
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