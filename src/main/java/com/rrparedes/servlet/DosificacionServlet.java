package com.rrparedes.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * NURSELOGIC – DosificacionServlet
 * Módulo: Cálculo de Dosificación de Medicamentos
 * Aplica regla de tres con conversión de unidades (g↔mg, L↔mL).
 * Fórmula: Volumen a administrar = (Dosis prescrita / Concentración disponible) × Volumen presentación
 * GET  → muestra formulario dosificacion.jsp
 * POST → calcula y devuelve el volumen en mL
 * TODO Fase 2: guardar cálculo vinculado al paciente (DosificacionDAO)
 */
@WebServlet("/DosificacionServlet")
public class DosificacionServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!verificarSesion(request, response)) return;
        request.getRequestDispatcher("/dosificacion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!verificarSesion(request, response)) return;
        request.setCharacterEncoding("UTF-8");

        String medicamento      = request.getParameter("Medicamento");
        String dosisPrescStr    = request.getParameter("DosisPrescrita");
        String unidadPrescrita  = request.getParameter("UnidadPrescrita");  // mg, g, mcg
        String concStr          = request.getParameter("Concentracion");
        String unidadConc       = request.getParameter("UnidadConcentracion");
        String volPresStr       = request.getParameter("VolumenPresentacion");

        if (estaVacio(dosisPrescStr) || estaVacio(concStr) || estaVacio(volPresStr)) {
            request.setAttribute("errorMsg", "⚠ Todos los campos de cálculo son obligatorios.");
            request.getRequestDispatcher("/dosificacion.jsp").forward(request, response);
            return;
        }

        try {
            double dosisPrescrita = Double.parseDouble(dosisPrescStr);
            double concentracion  = Double.parseDouble(concStr);
            double volPresent     = Double.parseDouble(volPresStr);

            // Convertir todo a mg para uniformidad
            double dosisMg = convertirAMg(dosisPrescrita, unidadPrescrita);
            double concMg  = convertirAMg(concentracion,  unidadConc);

            if (concMg <= 0) throw new ArithmeticException("Concentración no puede ser cero.");

            // Regla de tres: V_admin = (Dosis_prescrita / Concentración) × Volumen_presentación
            double volAdmin = (dosisMg / concMg) * volPresent;

            // Truncar a 2 decimales
            volAdmin = Math.floor(volAdmin * 100) / 100;

            request.setAttribute("volumenCalculado", volAdmin);
            request.setAttribute("medicamentoCalc",  medicamento);
            request.setAttribute("successMsg",
                "✔ Volumen a administrar: " + volAdmin + " mL de " + medicamento);

        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "⚠ Ingrese valores numéricos válidos.");
        } catch (ArithmeticException e) {
            request.setAttribute("errorMsg", "⚠ " + e.getMessage());
        }

        request.getRequestDispatcher("/dosificacion.jsp").forward(request, response);
    }

    /** Convierte dosis a miligramos para cálculo uniforme. */
    private double convertirAMg(double valor, String unidad) {
        if (unidad == null) return valor;
        return switch (unidad) {
            case "g"   -> valor * 1000;
            case "mcg" -> valor / 1000;
            case "L"   -> valor * 1000; // para líquidos: L→mL
            default    -> valor;        // mg o mL sin conversión
        };
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
