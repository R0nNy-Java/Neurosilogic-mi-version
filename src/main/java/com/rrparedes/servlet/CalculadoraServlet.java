package com.rrparedes.servlet;

import com.rrparedes.dao.PacienteDAO;
import com.rrparedes.model.Paciente;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/calcular")
public class CalculadoraServlet extends HttpServlet {

    private final PacienteDAO pacienteDAO = new PacienteDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String accion = request.getParameter("accion");
        String cedula = request.getParameter("cedula");
        String nombre = request.getParameter("nombre");

        // Acción: Guardar en Ficha Clínica del Paciente en MySQL
        if ("guardar".equalsIgnoreCase(accion) && cedula != null && !cedula.trim().isEmpty()) {
            try {
                String imcVal = request.getParameter("imc");
                String catVal = request.getParameter("categoria");
                String pesoVal = request.getParameter("peso");
                String altVal  = request.getParameter("altura");

                Paciente p = pacienteDAO.buscarPorCedula(cedula.trim());
                if (p != null) {
                    String notaIMC = "[IMC: " + imcVal + " kg/m² - " + catVal + " (Peso: " + pesoVal + "kg, Altura: " + altVal + "m)]";
                    String obsActual = p.getSintomasActuales();
                    if (obsActual == null || obsActual.trim().isEmpty()) {
                        p.setSintomasActuales(notaIMC);
                    } else if (!obsActual.contains(notaIMC)) {
                        p.setSintomasActuales(obsActual + " | " + notaIMC);
                    }
                    pacienteDAO.actualizar(p);
                }

                response.sendRedirect(request.getContextPath() + "/PanelPacienteServlet?cedula=" + cedula.trim());
                return;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        try {
            // 1. Obtener los parámetros del formulario
            double peso   = Double.parseDouble(request.getParameter("peso"));
            double altura = Double.parseDouble(request.getParameter("altura"));

            // 2. Realizar los cálculos
            double imc = peso / (altura * altura);
            String categoria = obtenerCategoria(imc);

            // 3. Guardar los resultados en el request para el jsp
            request.setAttribute("cedula", cedula);
            request.setAttribute("nombre", nombre);
            request.setAttribute("peso", peso);
            request.setAttribute("altura", altura);
            request.setAttribute("imc", String.format("%.2f", imc));
            request.setAttribute("categoria", categoria);

            // 4. Redirigir al jsp de resultados
            request.getRequestDispatcher("/resultado.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private String obtenerCategoria(double imc){
        if (imc < 18.5) return "Bajo peso";
        else if (imc < 25) return "Peso normal";
        else if (imc < 30) return "Sobrepeso";
        else return "Obesidad";
    }
}
