package com.rrparedes.servlet;

import com.rrparedes.dao.AlertaClinicaDAO;
import com.rrparedes.dao.EvaluacionIMCDAO;
import com.rrparedes.dao.PacienteDAO;
import com.rrparedes.model.AlertaClinica;
import com.rrparedes.model.EvaluacionIMC;
import com.rrparedes.model.Paciente;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/IMCServlet")
public class IMCServlet extends HttpServlet {

    private final PacienteDAO pacienteDAO = new PacienteDAO();
    private final EvaluacionIMCDAO evaluacionIMCDAO = new EvaluacionIMCDAO();
    private final AlertaClinicaDAO alertaClinicaDAO = new AlertaClinicaDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String cedulaParam = request.getParameter("cedula");
        Paciente paciente = null;

        if (cedulaParam != null && !cedulaParam.trim().isEmpty()) {
            paciente = pacienteDAO.buscarPorCedula(cedulaParam.trim());
        }

        if (paciente != null) {
            request.setAttribute("paciente", paciente);
            List<EvaluacionIMC> historialIMC = evaluacionIMCDAO.obtenerPorPaciente(paciente.getIdPaciente());
            request.setAttribute("historialIMC", historialIMC);
        }

        request.getRequestDispatcher("/evaluacion_imc.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String cedulaParam = request.getParameter("cedula");
        String pesoStr = request.getParameter("peso");
        String estaturaStr = request.getParameter("estatura");

        Paciente paciente = null;
        if (cedulaParam != null && !cedulaParam.trim().isEmpty()) {
            paciente = pacienteDAO.buscarPorCedula(cedulaParam.trim());
        }

        if (paciente != null && pesoStr != null && estaturaStr != null) {
            try {
                double peso = Double.parseDouble(pesoStr.trim());
                double estatura = Double.parseDouble(estaturaStr.trim());

                if (estatura > 3.0) estatura = estatura / 100.0;

                if (peso > 0 && estatura > 0) {
                    double valorIMC = peso / (estatura * estatura);
                    valorIMC = Math.round(valorIMC * 100.0) / 100.0;

                    AlertaClinica alerta = alertaClinicaDAO.obtenerAlertaIMC(valorIMC);
                    String clasificacion = alerta != null ? alerta.getMensajeAlerta() : "Calculado";

                    EvaluacionIMC evaluacion = new EvaluacionIMC(
                            paciente, peso, estatura, valorIMC, clasificacion, alerta
                    );

                    evaluacionIMCDAO.guardar(evaluacion);
                    request.getSession().setAttribute("mensajeExito", "Evaluación IMC registrada correctamente.");
                }
                response.sendRedirect(request.getContextPath() + "/IMCServlet?cedula=" + paciente.getCedula());
                return;
            } catch (Exception e) {
                request.setAttribute("errorMsg", "⚠ Ingrese datos numéricos válidos.");
            }
        }
        doGet(request, response);
    }
}