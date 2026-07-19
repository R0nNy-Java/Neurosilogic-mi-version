package com.rrparedes.servlet;

import com.rrparedes.config.JPAUtil;
import com.rrparedes.dao.PacienteDAO;
import com.rrparedes.model.Antecedente;
import com.rrparedes.model.Paciente;
import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityTransaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;

/**
 * NURSELOGIC – RegistroPacienteServlet
 *
 * Procesa el formulario de Apertura de Ficha Clínica (registro_paciente.jsp)
 * y persiste el paciente y sus antecedentes directamente en MySQL usando JPA (PacienteDAO).
 */
@WebServlet("/RegistroPacienteServlet")
public class RegistroPacienteServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // Control de sesión
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // 1. Recoger parámetros del formulario
        String nombres              = request.getParameter("Nombres");
        String apellidos            = request.getParameter("Apellidos");
        String cedula               = request.getParameter("Cedula");
        String edadStr              = request.getParameter("Edad");
        String sexo                 = request.getParameter("Sexo");
        String[] antecedentes       = request.getParameterValues("Antecedentes");
        String glicemiaStr          = request.getParameter("GlicemiaInicial");
        String otrosTexto           = request.getParameter("OtrosAntecedentesTexto");
        String sintomasActuales     = request.getParameter("SintomasActuales");
        String alergias             = request.getParameter("Alergias");
        String dispositivosMedicos  = request.getParameter("DispositivosMedicos");

        // 2. Validar campos demográficos obligatorios
        if (estaVacio(nombres) || estaVacio(apellidos) || estaVacio(cedula)
                || estaVacio(edadStr) || estaVacio(sexo)) {
            request.setAttribute("errorMsg",
                "⚠ Los campos Nombres, Apellidos, Cédula, Edad y Sexo son obligatorios.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        // 3. Validar cédula (10 dígitos numéricos)
        if (!cedula.trim().matches("\\d{10}")) {
            request.setAttribute("errorMsg",
                "⚠ La cédula debe contener exactamente 10 dígitos numéricos.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        // 4. Validar edad
        int edad;
        try {
            edad = Integer.parseInt(edadStr.trim());
            if (edad < 19 || edad > 60) {
                request.setAttribute("errorMsg",
                    "⚠ La edad debe estar entre 19 y 60 años.");
                request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "⚠ El campo Edad debe ser un número válido.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        try {
            // 5. Persistir en la base de datos MySQL mediante PacienteDAO
            Paciente paciente = new Paciente(
                nombres.trim(),
                apellidos.trim(),
                cedula.trim(),
                edad,
                sexo.trim(),
                sintomasActuales != null ? sintomasActuales.trim() : "",
                alergias != null ? alergias.trim() : "",
                dispositivosMedicos != null ? dispositivosMedicos.trim() : "",
                "A"
            );

            PacienteDAO pacienteDAO = new PacienteDAO();
            pacienteDAO.guardar(paciente);

            // 6. Guardar antecedentes clínicos asociados
            if (antecedentes != null && antecedentes.length > 0) {
                EntityManager em = JPAUtil.getEntityManager();
                EntityTransaction tx = em.getTransaction();
                try {
                    tx.begin();
                    for (String ant : antecedentes) {
                        String detalle = ant;
                        if ("DIABETES".equalsIgnoreCase(ant) && !estaVacio(glicemiaStr)) {
                            detalle = "DIABETES (Glicemia: " + glicemiaStr.trim() + " mg/dL)";
                        } else if ("OTROS".equalsIgnoreCase(ant) && !estaVacio(otrosTexto)) {
                            detalle = "OTROS: " + otrosTexto.trim();
                        }
                        Antecedente a = new Antecedente(paciente, detalle, LocalDateTime.now());
                        em.persist(a);
                    }
                    tx.commit();
                } catch (Exception ex) {
                    if (tx.isActive()) tx.rollback();
                    ex.printStackTrace();
                } finally {
                    em.close();
                }
            }

            // 7. Preparar respuesta exitosa
            request.setAttribute("nombrePaciente", nombres.trim() + " " + apellidos.trim());
            request.setAttribute("cedula", cedula.trim());
            request.setAttribute("registroExitoso", true);
            request.setAttribute("successMsg",
                "✔ Ficha clínica registrada en la Base de Datos correctamente para: "
                + nombres.trim() + " " + apellidos.trim());

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg",
                "❌ Error al guardar en la Base de Datos: " + e.getMessage());
        }

        request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
    }

    private boolean estaVacio(String s) {
        return s == null || s.trim().isEmpty();
    }
}
