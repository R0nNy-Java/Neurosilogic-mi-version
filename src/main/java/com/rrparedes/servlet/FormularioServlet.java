package com.rrparedes.servlet;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
@WebServlet("/formulario")
public class FormularioServlet extends HttpServlet {
    // Metodo GET: para mostrar el formulario y luego enviar conmetodo post
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response) throws IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>Formulario de Contacto</h1>");
        out.println("<form action='formulario' method='POST'>");
        out.println(" <label>Nombre:</label><br>");
        out.println(" <input type='text' name='nombre' required><br><br>");
                out.println(" <label>Email:</label><br>");
        out.println(" <input type='email' name='email' required><br><br>");
                out.println(" <label>Mensaje:</label><br>");
        out.println(" <textarea name='mensaje' rows='4' cols='30'></textarea><br><br>");
                out.println(" <input type='submit' value='Enviar'>");
        out.println("</form>");
        out.println("</body></html>");
        out.close();
    }
    //Motodo POST: Procesa los datos del formulacion
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response) throws IOException{
        // optener los parametros enviados desde el formulario
        String nombre = request.getParameter("nombre");
        String email = request.getParameter("email");
        String mensaje = request.getParameter("mensaje");
        //Generar la respuesta html
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        out.println("<html><body>");
        out.println("<h1>¡Datos Recibidos!</h1>");
        out.println("<p><strong>Nombre:</strong> " + nombre +
                "</p>");
        out.println("<p><strong>Email:</strong> " + email +
                "</p>");
        out.println("<p><strong>Mensaje:</strong> " + mensaje +
                "</p>");
        out.println("<br>");
        out.println("<a href='formulario'>Volver al formulario</a>");
                out.println("</body></html>");
        out.close();

    }
}