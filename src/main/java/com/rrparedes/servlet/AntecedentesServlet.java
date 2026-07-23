package com.rrparedes.servlet;

import com.rrparedes.dao.AntecedenteDAO;
import com.rrparedes.dao.EnfermedadDAO;
import com.rrparedes.dao.PacienteDAO;
import com.rrparedes.model.Antecedente;
import com.rrparedes.model.Enfermedad;
import com.rrparedes.model.Paciente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/AntecedentesServlet")
public class AntecedentesServlet extends HttpServlet {

    private final AntecedenteDAO antecedenteDAO = new AntecedenteDAO();
    private final EnfermedadDAO enfermedadDAO = new EnfermedadDAO();
    private final PacienteDAO pacienteDAO = new PacienteDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cedulaParam = request.getParameter("cedula");
        String idParam = request.getParameter("idPaciente");
        if (idParam == null || idParam.trim().isEmpty()) {
            idParam = request.getParameter("id");
        }

        Paciente paciente = null;

        if (cedulaParam != null && !cedulaParam.trim().isEmpty()) {
            paciente = pacienteDAO.buscarPorCedula(cedulaParam.trim());
        }

        if (paciente == null && idParam != null && !idParam.trim().isEmpty()) {
            try {
                Long idPaciente = Long.parseLong(idParam.trim());
                paciente = pacienteDAO.buscarPorId(idPaciente);
            } catch (NumberFormatException e) {
                request.setAttribute("error", "ID de paciente inválido.");
            }
        }

        if (paciente != null) {
            request.setAttribute("paciente", paciente);
            List<Antecedente> listaAntecedentes = antecedenteDAO.obtenerPorPaciente(paciente.getIdPaciente());
            request.setAttribute("listaAntecedentes", listaAntecedentes);
        }

        List<Enfermedad> catalogoEnfermedades = enfermedadDAO.listarTodas();
        request.setAttribute("catalogoEnfermedades", catalogoEnfermedades);

        request.getRequestDispatcher("/antecedentes.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String cedulaParam = request.getParameter("cedula");
        String idPacienteStr = request.getParameter("idPaciente");
        if (idPacienteStr == null || idPacienteStr.trim().isEmpty()) {
            idPacienteStr = request.getParameter("id");
        }

        String[] idsEnfermedades = request.getParameterValues("idEnfermedades");
        if (idsEnfermedades == null || idsEnfermedades.length == 0) {
            String singleId = request.getParameter("idEnfermedad");
            if (singleId != null && !singleId.trim().isEmpty()) {
                idsEnfermedades = new String[]{ singleId };
            }
        }

        String alergias = request.getParameter("alergias");
        String medicamentosActuales = request.getParameter("medicamentosActuales");
        String observacion = request.getParameter("observacion");

        Paciente paciente = null;
        if (cedulaParam != null && !cedulaParam.trim().isEmpty()) {
            paciente = pacienteDAO.buscarPorCedula(cedulaParam.trim());
        }
        if (paciente == null && idPacienteStr != null && !idPacienteStr.trim().isEmpty()) {
            try {
                Long idPaciente = Long.parseLong(idPacienteStr.trim());
                paciente = pacienteDAO.buscarPorId(idPaciente);
            } catch (Exception e) {
                // Ignore
            }
        }

        if (paciente != null) {
            try {
                if (idsEnfermedades != null && idsEnfermedades.length > 0) {
                    for (String idEnfStr : idsEnfermedades) {
                        if (idEnfStr != null && !idEnfStr.trim().isEmpty()) {
                            Long idEnfermedad = Long.parseLong(idEnfStr.trim());
                            Enfermedad enfermedad = enfermedadDAO.buscarPorId(idEnfermedad);

                            Antecedente antecedente = new Antecedente(
                                    paciente,
                                    enfermedad,
                                    alergias != null ? alergias.trim() : "",
                                    medicamentosActuales != null ? medicamentosActuales.trim() : "",
                                    observacion != null ? observacion.trim() : ""
                            );
                            antecedenteDAO.guardar(antecedente);
                        }
                    }
                } else {
                    Antecedente antecedente = new Antecedente(
                            paciente,
                            null,
                            alergias != null ? alergias.trim() : "",
                            medicamentosActuales != null ? medicamentosActuales.trim() : "",
                            observacion != null ? observacion.trim() : ""
                    );
                    antecedenteDAO.guardar(antecedente);
                }

                request.getSession().setAttribute("mensajeExito", "Antecedente(s) registrado(s) correctamente.");
                response.sendRedirect(request.getContextPath() + "/AntecedentesServlet?cedula=" + paciente.getCedula());
                return;
            } catch (Exception e) {
                request.setAttribute("error", "Error al guardar el antecedente: " + e.getMessage());
            }
        }

        doGet(request, response);
    }
}
