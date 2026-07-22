package com.rrparedes.servlet;


import com.rrparedes.model.Dosificacion;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DosificacionServlet")
public class DosificacionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/dosificacion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String tipoCalculo = request.getParameter("tipoCalculo");
        request.setAttribute("tabActiva", tipoCalculo);

        try {
            if ("REGULAR_DOSIS".equalsIgnoreCase(tipoCalculo)) {
                // 1. Recibir los datos del formulario
                String dosisStr = request.getParameter("dosisIndicada");
                String presStr = request.getParameter("presentacion");
                String dilStr = request.getParameter("diluyenteMl");

                String unidadDosis = request.getParameter("unidadDosis");
                String unidadPresentacion = request.getParameter("unidadPresentacion");

                // 2. Validar que no vengan vacíos
                if (dosisStr != null && presStr != null && dilStr != null) {
                    double dosisIndicada = Double.parseDouble(dosisStr);
                    double presentacion = Double.parseDouble(presStr);
                    double diluyenteMl = Double.parseDouble(dilStr);

                    // 3. Calcular
                    double resultadoVolumen = Dosificacion.calcularVolumenAdministrar(
                            dosisIndicada, unidadDosis, presentacion, unidadPresentacion, diluyenteMl
                    );

                    // 4. Devolver TODO al JSP (para que no se borren los campos y muestre el resultado)
                    request.setAttribute("dosisIndicada", dosisStr);
                    request.setAttribute("presentacion", presStr);
                    request.setAttribute("diluyenteMl", dilStr);
                    request.setAttribute("unidadDosis", unidadDosis);
                    request.setAttribute("unidadPresentacion", unidadPresentacion);
                    request.setAttribute("resultadoVolumen", String.format("%.2f", resultadoVolumen));
                }

            } else if ("INFUSION_GOTEO".equalsIgnoreCase(tipoCalculo)) {
                String volStr = request.getParameter("volumenTotalMl");
                String hrsStr = request.getParameter("horasTotales");

                if (volStr != null && hrsStr != null) {
                    double volumenTotalMl = Double.parseDouble(volStr);
                    double horasTotales = Double.parseDouble(hrsStr);

                    double gotasPorMinuto = Dosificacion.calcularGotasPorMinuto(volumenTotalMl, horasTotales);
                    double microgotasPorMinuto = Dosificacion.calcularMicrogotasPorMinuto(volumenTotalMl, horasTotales);
                    double mlPorHora = Dosificacion.calcularMlPorHora(volumenTotalMl, horasTotales);

                    request.setAttribute("volumenTotalMl", volStr);
                    request.setAttribute("horasTotales", hrsStr);
                    request.setAttribute("gotasPorMinuto", String.format("%.1f", gotasPorMinuto));
                    request.setAttribute("microgotasPorMinuto", String.format("%.1f", microgotasPorMinuto));
                    request.setAttribute("mlPorHora", String.format("%.1f", mlPorHora));
                }
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error en el cálculo: " + e.getMessage());
        }

        // Volvemos a la misma página
        request.getRequestDispatcher("/dosificacion.jsp").forward(request, response);
    }
}