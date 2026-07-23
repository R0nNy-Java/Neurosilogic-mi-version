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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/PacientesServlet")
public class PacientesServlet extends HttpServlet {

    private final PacienteDAO pacienteDAO = new PacienteDAO();
    private final CierreFichaDAO cierreFichaDAO = new CierreFichaDAO();
    private final SignosVitalesDAO signosVitalesDAO = new SignosVitalesDAO();
    private final GlasgowDAO glasgowDAO = new GlasgowDAO();
    private final EvaluacionIMCDAO evaluacionIMCDAO = new EvaluacionIMCDAO();
    private final AntecedenteDAO antecedenteDAO = new AntecedenteDAO();
    private final AdministracionMedicamentoDAO administracionDAO = new AdministracionMedicamentoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            List<Paciente> lista = pacienteDAO.listarTodos();
            request.setAttribute("listaPacientes", lista);

            Map<Long, CierreFicha> resumenesMap = new HashMap<>();

            if (lista != null) {
                for (Paciente p : lista) {
                    Long idPac = p.getIdPaciente();
                    CierreFicha cf = cierreFichaDAO.obtenerUltimoPorPaciente(idPac);

                    if (cf == null) {
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

                        String strGlasgow = "Sin evaluación de Glasgow.";
                        try {
                            List<EscalaGlasgow> glasgows = glasgowDAO.listarPorPaciente(idPac);
                            if (glasgows != null && !glasgows.isEmpty()) {
                                EscalaGlasgow g = glasgows.get(0);
                                strGlasgow = "Puntaje Total: " + g.getPuntajeTotal() + "/15 (" + (g.getNivelSeveridad() != null ? g.getNivelSeveridad() : "Evaluado") + ")";
                            }
                        } catch (Exception e) {}

                        String strIMC = "Sin evaluación de IMC.";
                        try {
                            List<EvaluacionIMC> imcs = evaluacionIMCDAO.obtenerPorPaciente(idPac);
                            if (imcs != null && !imcs.isEmpty()) {
                                EvaluacionIMC imc = imcs.get(0);
                                String msgAlerta = imc.getAlerta() != null ? imc.getAlerta().getMensajeAlerta() : imc.getClasificacion();
                                strIMC = "IMC: " + String.format("%.2f", imc.getValorIMC()) + " (Peso: " + imc.getPeso() + "kg, Talla: " + imc.getEstatura() + "m) - " + (msgAlerta != null ? msgAlerta : "");
                            }
                        } catch (Exception e) {}

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
                                if (sb.length() > 0) strAntecedentes = sb.toString();
                            }
                        } catch (Exception e) {}

                        String strDosis = "Sin administración de dosis registrada.";
                        try {
                            List<AdministracionMedicamento> dosisList = administracionDAO.obtenerPorPaciente(idPac);
                            if (dosisList != null && !dosisList.isEmpty()) {
                                AdministracionMedicamento adm = dosisList.get(0);
                                strDosis = "Dosis: " + adm.getDosisCalculada() + " mL - " + (adm.getUnidadResultado() != null ? adm.getUnidadResultado() : "");
                            }
                        } catch (Exception e) {}

                        cf = new CierreFicha(p, null, "Atención en progreso (Sin cierre formal)", strSignos, strGlasgow, strIMC, strAntecedentes, strDosis);
                    }

                    resumenesMap.put(idPac, cf);
                }
            }

            request.setAttribute("resumenesMap", resumenesMap);

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
