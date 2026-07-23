package com.rrparedes.servlet;

import com.rrparedes.dao.AdministracionMedicamentoDAO;
import com.rrparedes.dao.MedicamentoDAO;
import com.rrparedes.dao.PacienteDAO;
import com.rrparedes.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/DosificacionServlet")
public class DosificacionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final PacienteDAO pacienteDAO = new PacienteDAO();
    private final MedicamentoDAO medicamentoDAO = new MedicamentoDAO();
    private final AdministracionMedicamentoDAO administracionDAO = new AdministracionMedicamentoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

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
                paciente = pacienteDAO.buscarPorId(Long.parseLong(idParam.trim()));
            } catch (Exception e) {}
        }

        if (paciente != null) {
            request.setAttribute("paciente", paciente);
            List<AdministracionMedicamento> historial = administracionDAO.obtenerPorPaciente(paciente.getIdPaciente());
            request.setAttribute("historialAdministracion", historial);
        }

        List<Medicamento> catalogoMedicamentos = medicamentoDAO.listarTodos();
        request.setAttribute("catalogoMedicamentos", catalogoMedicamentos);

        request.getRequestDispatcher("/dosificacion.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String tipoCalculo = request.getParameter("tipoCalculo");
        request.setAttribute("tabActiva", tipoCalculo);

        String cedulaParam = request.getParameter("cedula");
        Paciente paciente = null;
        if (cedulaParam != null && !cedulaParam.trim().isEmpty()) {
            paciente = pacienteDAO.buscarPorCedula(cedulaParam.trim());
        }

        try {
            if ("REGISTRAR_ADMINISTRACION".equalsIgnoreCase(tipoCalculo) && paciente != null) {
                String idMedStr = request.getParameter("idMedicamento");
                String dosisIndicadaStr = request.getParameter("dosisIndicada");
                String unidadDosis = request.getParameter("unidadDosis");

                if (idMedStr != null && dosisIndicadaStr != null) {
                    Long idMed = Long.parseLong(idMedStr.trim());
                    double dosisIndicada = Double.parseDouble(dosisIndicadaStr.trim());

                    if (dosisIndicada <= 0) {
                        request.setAttribute("error", "⚠ La dosis indicada debe ser un número positivo mayor a cero.");
                    } else {
                        Medicamento med = medicamentoDAO.buscarPorId(idMed);
                        if (med != null) {
                            double pres = med.getConcentracion() != null ? med.getConcentracion().doubleValue() : 500.0;
                            String unPres = med.getUnidadConcentracion() != null ? med.getUnidadConcentracion() : "mg";
                            double dil = med.getVolumenPresentacion() != null ? med.getVolumenPresentacion().doubleValue() : 10.0;

                            double resultadoVolumen = Dosificacion.calcularVolumenAdministrar(
                                    dosisIndicada, unidadDosis, pres, unPres, dil
                            );
                            resultadoVolumen = Math.round(resultadoVolumen * 100.0) / 100.0;

                            String detallePres = med.getNombreMedicamento() + " (" + med.getPresentacionCompleta() + ")";
                            if (detallePres.length() > 250) {
                                detallePres = detallePres.substring(0, 250);
                            }

                            AdministracionMedicamento adminReg = new AdministracionMedicamento(
                                    null,
                                    paciente,
                                    new BigDecimal(String.valueOf(resultadoVolumen)),
                                    detallePres,
                                    LocalDateTime.now(),
                                    null
                            );

                            boolean ok = administracionDAO.guardar(adminReg);
                            if (ok) {
                                request.getSession().setAttribute("mensajeExito", "Dosis de " + med.getNombreMedicamento() + " (" + resultadoVolumen + " mL) registrada correctamente en la ficha del paciente.");
                            } else {
                                request.getSession().setAttribute("errorMsg", "❌ No se pudo guardar la administración en la base de datos.");
                            }
                        }
                    }
                }

                response.sendRedirect(request.getContextPath() + "/DosificacionServlet?cedula=" + paciente.getCedula() + "&modo=paciente");
                return;

            } else if ("REGULAR_DOSIS".equalsIgnoreCase(tipoCalculo)) {
                String dosisStr = request.getParameter("dosisIndicada");
                String presStr = request.getParameter("presentacion");
                String dilStr = request.getParameter("diluyenteMl");
                String unidadDosis = request.getParameter("unidadDosis");
                String unidadPresentacion = request.getParameter("unidadPresentacion");

                if (dosisStr != null && presStr != null && dilStr != null) {
                    double dosisIndicada = Double.parseDouble(dosisStr);
                    double presentacion = Double.parseDouble(presStr);
                    double diluyenteMl = Double.parseDouble(dilStr);

                    if (dosisIndicada <= 0 || presentacion <= 0 || diluyenteMl <= 0) {
                        request.setAttribute("error", "⚠ Todos los valores para el cálculo de dosis deben ser positivos mayores a cero.");
                    } else {
                        double resultadoVolumen = Dosificacion.calcularVolumenAdministrar(
                                dosisIndicada, unidadDosis, presentacion, unidadPresentacion, diluyenteMl
                        );

                        request.setAttribute("dosisIndicada", dosisStr);
                        request.setAttribute("presentacion", presStr);
                        request.setAttribute("diluyenteMl", dilStr);
                        request.setAttribute("unidadDosis", unidadDosis);
                        request.setAttribute("unidadPresentacion", unidadPresentacion);
                        request.setAttribute("resultadoVolumen", String.format("%.2f", resultadoVolumen));
                    }
                }

            } else if ("INFUSION_GOTEO".equalsIgnoreCase(tipoCalculo)) {
                String volStr = request.getParameter("volumenTotalMl");
                String hrsStr = request.getParameter("horasTotales");

                if (volStr != null && hrsStr != null) {
                    double volumenTotalMl = Double.parseDouble(volStr);
                    double horasTotales = Double.parseDouble(hrsStr);

                    if (volumenTotalMl <= 0 || horasTotales <= 0) {
                        request.setAttribute("error", "⚠ El volumen total y las horas deben ser valores positivos mayores a cero.");
                    } else {
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
            }
        } catch (Exception e) {
            request.setAttribute("error", "Error en el cálculo: " + e.getMessage());
        }

        doGet(request, response);
    }
}