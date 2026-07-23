package com.rrparedes.servlet;

import com.rrparedes.dao.*;
import com.rrparedes.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/CerrarFichaServlet")
public class CerrarFichaServlet extends HttpServlet {

    private final PacienteDAO pacienteDAO = new PacienteDAO();
    private final SignosVitalesDAO signosVitalesDAO = new SignosVitalesDAO();
    private final GlasgowDAO glasgowDAO = new GlasgowDAO();
    private final EvaluacionIMCDAO evaluacionIMCDAO = new EvaluacionIMCDAO();
    private final AntecedenteDAO antecedenteDAO = new AntecedenteDAO();
    private final AdministracionMedicamentoDAO administracionDAO = new AdministracionMedicamentoDAO();
    private final CierreFichaDAO cierreFichaDAO = new CierreFichaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String cedulaParam = request.getParameter("cedula");
        if (cedulaParam == null || cedulaParam.trim().isEmpty()) {
            cedulaParam = request.getParameter("idPaciente");
        }

        Paciente paciente = null;
        if (cedulaParam != null && !cedulaParam.trim().isEmpty()) {
            paciente = pacienteDAO.buscarPorCedula(cedulaParam.trim());
        }

        if (paciente == null && cedulaParam != null && !cedulaParam.trim().isEmpty()) {
            try {
                paciente = pacienteDAO.buscarPorId(Long.parseLong(cedulaParam.trim()));
            } catch (Exception e) {}
        }

        if (paciente == null) {
            List<Paciente> todos = pacienteDAO.listarTodos();
            if (todos != null && !todos.isEmpty()) {
                paciente = todos.get(0);
            }
        }

        if (paciente != null) {
            Long idPac = paciente.getIdPaciente();

            // 1. Obtener último Signo Vital
            String strSignos = "Sin registro de signos vitales.";
            try {
                List<SignoVital> signos = signosVitalesDAO.listarPorPaciente(idPac);
                if (signos != null && !signos.isEmpty()) {
                    SignoVital sv = signos.get(0);
                    strSignos = "PA: " + (sv.getPresionSistolica() != null ? sv.getPresionSistolica() : "-") + "/" + (sv.getPresionDiastolica() != null ? sv.getPresionDiastolica() : "-") + " mmHg | "
                            + "Temp: " + (sv.getTemperatura() != null ? sv.getTemperatura() + "°C" : "-") + " | "
                            + "FC: " + (sv.getFrecuenciaCardiaca() != null ? sv.getFrecuenciaCardiaca() + " bpm" : "-") + " | "
                            + "SPO2: " + (sv.getSaturacionO2() != null ? sv.getSaturacionO2() + "%" : "-");
                }
            } catch (Exception e) {}

            // 2. Obtener última Escala Glasgow
            String strGlasgow = "Sin evaluación de Glasgow.";
            try {
                List<EscalaGlasgow> glasgows = glasgowDAO.listarPorPaciente(idPac);
                if (glasgows != null && !glasgows.isEmpty()) {
                    EscalaGlasgow g = glasgows.get(0);
                    strGlasgow = "Puntaje Total: " + g.getPuntajeTotal() + "/15 (" + (g.getNivelSeveridad() != null ? g.getNivelSeveridad() : "Evaluado") + ")";
                }
            } catch (Exception e) {}

            // 3. Obtener última Evaluación IMC
            String strIMC = "Sin evaluación de IMC.";
            try {
                List<EvaluacionIMC> imcs = evaluacionIMCDAO.obtenerPorPaciente(idPac);
                if (imcs != null && !imcs.isEmpty()) {
                    EvaluacionIMC imc = imcs.get(0);
                    String msgAlerta = imc.getAlerta() != null ? imc.getAlerta().getMensajeAlerta() : imc.getClasificacion();
                    strIMC = "IMC: " + String.format("%.2f", imc.getValorIMC()) + " (Peso: " + imc.getPeso() + "kg, Talla: " + imc.getEstatura() + "m) - " + (msgAlerta != null ? msgAlerta : "");
                }
            } catch (Exception e) {}

            // 4. Obtener últimos Antecedentes y Alergias
            String strAntecedentes = "Sin antecedentes registrados.";
            try {
                List<Antecedente> antecedentes = antecedenteDAO.obtenerPorPaciente(idPac);
                if (antecedentes != null && !antecedentes.isEmpty()) {
                    StringBuilder sb = new StringBuilder();
                    for (Antecedente a : antecedentes) {
                        if (a.getNombreEnfermedad() != null && !a.getNombreEnfermedad().isEmpty()) {
                            if (sb.length() > 0) sb.append(", ");
                            sb.append(a.getNombreEnfermedad());
                        }
                        if (a.getAlergias() != null && !a.getAlergias().trim().isEmpty() && !"Ninguna".equalsIgnoreCase(a.getAlergias())) {
                            sb.append(" (Alergia: ").append(a.getAlergias()).append(")");
                        }
                    }
                    if (sb.length() > 0) {
                        strAntecedentes = sb.toString();
                    }
                }
            } catch (Exception e) {}

            // 5. Obtener última Administración de Dosis
            String strDosis = "Sin administración de dosis registrada.";
            try {
                List<AdministracionMedicamento> dosisList = administracionDAO.obtenerPorPaciente(idPac);
                if (dosisList != null && !dosisList.isEmpty()) {
                    AdministracionMedicamento adm = dosisList.get(0);
                    strDosis = "Dosis: " + adm.getDosisCalculada() + " mL - " + (adm.getUnidadResultado() != null ? adm.getUnidadResultado() : "");
                }
            } catch (Exception e) {}

            // 6. Obtener nombre del Enfermero/a responsable
            HttpSession session = request.getSession(false);
            String nombreEnfermero = "Enfermero/a Responsable";
            if (session != null) {
                String n = (String) session.getAttribute("nombreCompleto");
                if (n == null || n.trim().isEmpty()) n = (String) session.getAttribute("usuario");
                if (n != null && !n.trim().isEmpty()) nombreEnfermero = n;
            }

            // 7. Crear y guardar el registro de Cierre de Ficha en MySQL
            CierreFicha cierre = new CierreFicha(
                    paciente,
                    null,
                    nombreEnfermero,
                    strSignos,
                    strGlasgow,
                    strIMC,
                    strAntecedentes,
                    strDosis
            );

            boolean ok = cierreFichaDAO.guardar(cierre);
            System.out.println(">>> Guardando CierreFicha para paciente ID=" + idPac + " por " + nombreEnfermero + " -> Exito=" + ok);

            request.getSession().setAttribute("mensajeExito", "✔ Ficha clínica de " + paciente.getNombres() + " " + paciente.getApellidos() + " cerrada y consolidada correctamente por " + nombreEnfermero + ".");
        }

        response.sendRedirect(request.getContextPath() + "/PacientesServlet");
    }
}
