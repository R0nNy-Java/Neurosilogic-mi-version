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
import java.util.List;

/**
 * NURSELOGIC – RegistroPacienteServlet
 *
 * Procesa el formulario de Apertura de Ficha Clínica (registro_paciente.jsp).
 * Soporta creación y actualización (edición por Cédula) evitando duplicación de pacientes.
 * Al guardar exitosamente, redirige directamente al Panel Individual del Paciente.
 */
@WebServlet("/RegistroPacienteServlet")
public class RegistroPacienteServlet extends HttpServlet {

    private final PacienteDAO pacienteDAO = new PacienteDAO();

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

        // Preservar valores ingresados en el request en caso de error de validación
        request.setAttribute("paramNombres", nombres);
        request.setAttribute("paramApellidos", apellidos);
        request.setAttribute("paramCedula", cedula);
        request.setAttribute("paramEdad", edadStr);
        request.setAttribute("paramSexo", sexo);
        request.setAttribute("paramGlicemia", glicemiaStr);
        request.setAttribute("paramOtrosTexto", otrosTexto);
        request.setAttribute("paramSintomas", sintomasActuales);
        request.setAttribute("paramAlergias", alergias);
        request.setAttribute("paramDispositivos", dispositivosMedicos);

        // 2. Validar campos demográficos obligatorios
        if (estaVacio(nombres) || estaVacio(apellidos) || estaVacio(cedula)
                || estaVacio(edadStr) || estaVacio(sexo)) {
            request.setAttribute("errorMsg", "⚠ Los campos Nombres, Apellidos, Cédula, Edad y Sexo son obligatorios.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        // 3. Validar cédula (10 dígitos numéricos)
        if (!cedula.trim().matches("\\d{10}")) {
            request.setAttribute("errorMsg", "⚠ La cédula debe contener exactamente 10 dígitos numéricos.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        // 4. Validar edad
        int edad;
        try {
            edad = Integer.parseInt(edadStr.trim());
            if (edad < 19 || edad > 60) {
                request.setAttribute("errorMsg", "⚠ La edad debe estar entre 19 y 60 años.");
                request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
                return;
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMsg", "⚠ El campo Edad debe ser un número válido.");
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
            return;
        }

        try {
            // 5. Verificar si el paciente ya existe por Cédula (Reusar / Actualizar si ya existe)
            String cedulaLimpia = cedula.trim();
            Paciente pacienteExistente = pacienteDAO.buscarPorCedula(cedulaLimpia);

            if (pacienteExistente != null) {
                // Actualizar paciente existente
                pacienteExistente.setNombres(nombres.trim());
                pacienteExistente.setApellidos(apellidos.trim());
                pacienteExistente.setEdad(edad);
                pacienteExistente.setSexo(sexo.trim());
                pacienteExistente.setSintomasActuales(sintomasActuales != null ? sintomasActuales.trim() : "");
                pacienteExistente.setAlergias(alergias != null ? alergias.trim() : "");
                pacienteExistente.setDispositivosMedicos(dispositivosMedicos != null ? dispositivosMedicos.trim() : "");
                pacienteDAO.actualizar(pacienteExistente);
            } else {
                // Crear nuevo paciente
                Paciente pacienteNuevo = new Paciente(
                    nombres.trim(),
                    apellidos.trim(),
                    cedulaLimpia,
                    edad,
                    sexo.trim(),
                    sintomasActuales != null ? sintomasActuales.trim() : "",
                    alergias != null ? alergias.trim() : "",
                    dispositivosMedicos != null ? dispositivosMedicos.trim() : "",
                    "A"
                );
                pacienteDAO.guardar(pacienteNuevo);
                pacienteExistente = pacienteNuevo;
            }

            // 6. Guardar / actualizar antecedentes clínicos
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
                        Antecedente a = new Antecedente(pacienteExistente, detalle, LocalDateTime.now());
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

            // 7. Redirigir directamente al Panel Individual del Paciente
            response.sendRedirect(request.getContextPath() + "/PanelPacienteServlet?cedula=" + cedulaLimpia);
            return;

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMsg", "❌ Error al guardar en la Base de Datos: " + e.getMessage());
            request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("usuario") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Si viene un parámetro 'cedula' en GET, prellenar datos para edición
        String cedula = request.getParameter("cedula");
        if (cedula != null && !cedula.trim().isEmpty()) {
            Paciente p = pacienteDAO.buscarPorCedula(cedula.trim());
            if (p != null) {
                request.setAttribute("paramNombres", p.getNombres());
                request.setAttribute("paramApellidos", p.getApellidos());
                request.setAttribute("paramCedula", p.getCedula());
                request.setAttribute("paramEdad", String.valueOf(p.getEdad()));
                request.setAttribute("paramSexo", p.getSexo());
                request.setAttribute("paramSintomas", p.getSintomasActuales());
                request.setAttribute("paramAlergias", p.getAlergias());
                request.setAttribute("paramDispositivos", p.getDispositivosMedicos());
            }
        }

        request.getRequestDispatcher("/registro_paciente.jsp").forward(request, response);
    }

    private boolean estaVacio(String s) {
        return s == null || s.trim().isEmpty();
    }
}
