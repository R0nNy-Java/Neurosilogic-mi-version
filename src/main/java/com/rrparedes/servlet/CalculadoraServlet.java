package com.rrparedes.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/calcular")
public class CalculadoraServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. Obtener los parametros del formulario
            String nombre = request.getParameter("nombre");
            double peso =
                    Double.parseDouble(request.getParameter("peso"));
            double altura =
                    Double.parseDouble(request.getParameter("altura"));
            //2. Realizar los calculos
            double imc = peso / (altura * altura);
            String categoria = obtenerCategoria(imc);
            //3. Guardar los resultados en el request para el jsp
            request.setAttribute("nombre", nombre);
            request.setAttribute("peso", peso);
            request.setAttribute("altura", altura);
            request.setAttribute("imc", String.format("%.2f", imc));
            request.setAttribute("categoria", categoria);
            //4. redirigir al jsp de resultados
            request.getRequestDispatcher("/resultado.jsp").forward(request,
                    response);
        } catch (NumberFormatException e) {
            // en caso de error ir a la pagina de error jsp
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        } catch (Exception e) {
            request.getRequestDispatcher("error.jsp").forward(request,
                    response);
        }
    }
    private String obtenerCategoria(double imc){
        if (imc < 18.5) return "Bajo peso";
        else if (imc < 25) return "Peso normal";
        else if (imc < 30) return "Sobrepeso";
        else return "Obesidad";
    }
}

