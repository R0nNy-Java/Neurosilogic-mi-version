<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rrparedes.model.Paciente, com.rrparedes.model.EvaluacionIMC, com.rrparedes.model.AlertaClinica, java.util.List, java.time.format.DateTimeFormatter" %>
<%
    String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
    if (nombreSesion == null) nombreSesion = (session != null) ? (String) session.getAttribute("usuario") : "";
    String rolSesion = (session != null) ? (String) session.getAttribute("rol") : "";
    boolean esAdmin  = "ADMINISTRADOR".equals(rolSesion);
    String tituloRol = esAdmin ? "Administrador" : "Enfermero/a";

    Paciente paciente = (Paciente) request.getAttribute("paciente");
    List<EvaluacionIMC> historialIMC = (List<EvaluacionIMC>) request.getAttribute("historialIMC");

    String cedulaParam = request.getParameter("cedula");
    if (paciente == null && cedulaParam != null && !cedulaParam.trim().isEmpty()) {
        com.rrparedes.dao.PacienteDAO pDao = new com.rrparedes.dao.PacienteDAO();
        paciente = pDao.buscarPorCedula(cedulaParam.trim());
    }

    if (paciente != null && (historialIMC == null || historialIMC.isEmpty())) {
        com.rrparedes.dao.EvaluacionIMCDAO imcDAO = new com.rrparedes.dao.EvaluacionIMCDAO();
        historialIMC = imcDAO.obtenerPorPaciente(paciente.getIdPaciente());
    }

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    String mensajeExito = (String) session.getAttribute("mensajeExito");
    if (mensajeExito != null) session.removeAttribute("mensajeExito");
    String errorMsg = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Evaluación IMC</title>

  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>
<body class="bg-light" style="font-family:'Inter',sans-serif;">

  <!-- OFFCANVAS SIDEBAR (móvil) -->
  <div class="offcanvas offcanvas-start nl-sidebar text-white" id="sidebarMobile" style="width:240px;" tabindex="-1">
    <div class="offcanvas-header border-bottom border-white border-opacity-10 py-3 flex-column align-items-start gap-2">
      <div class="d-flex w-100 justify-content-between align-items-center">
        <span class="fw-bold text-white">NURSELOGIC</span>
        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
      </div>
      <div class="rounded bg-white bg-opacity-10 w-100 py-1.5 px-3 text-center small text-white-50" style="font-size: 0.8rem; letter-spacing: 0.5px;">
        <i class="bi bi-person-badge me-1"></i><%= tituloRol %>
      </div>
    </div>
    <div class="offcanvas-body d-flex flex-column p-0">
      <div class="px-4 py-3">
        <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">Navegación Principal</small>
      </div>
      <ul class="nav flex-column px-2 flex-grow-1">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-grid-1x2-fill"></i>Dashboard
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/PacientesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
            <i class="bi bi-person-badge"></i>Gestionar Pacientes
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/SignosVitalesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-activity"></i>Signos Vitales
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/GlasgowServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-file-earmark-bar-graph"></i>Escala Glasgow
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/DosificacionServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-droplet"></i>Administración de Dosis
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/AdministracionServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-clipboard-check"></i>Administración
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/ReportesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-graph-up"></i>Reportes
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/IMCServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-calculator"></i>IMC
          </a>
        </li>
      </ul>
      <div class="border-top border-white border-opacity-10 p-3 mt-auto">
        <div class="d-flex align-items-center gap-2 mb-3">
          <div class="rounded-circle bg-success d-flex align-items-center justify-content-center flex-shrink-0" style="width:36px;height:36px;">
            <i class="bi bi-person-fill text-white small"></i>
          </div>
          <div class="overflow-hidden">
            <div class="text-white small fw-semibold text-truncate"><%= nombreSesion %></div>
            <div style="font-size:.7rem;" class="text-white-50"><%= tituloRol %></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <div class="container-fluid p-0">
    <div class="row g-0 min-vh-100">

      <!-- SIDEBAR DESKTOP -->
      <nav class="col-auto d-none d-lg-flex flex-column nl-sidebar text-white p-0" id="nl-sidebar" style="width:240px;min-height:100vh;position:sticky;top:0;height:100vh;overflow-y:auto;">
        <div class="p-4 border-bottom border-white border-opacity-10">
          <a href="${pageContext.request.contextPath}/index.jsp" class="d-flex align-items-center gap-3 text-white text-decoration-none mb-3">
            <div class="rounded-3 bg-success p-2 flex-shrink-0">
              <i class="bi bi-heart-pulse-fill text-white fs-5"></i>
            </div>
            <div>
              <div class="fw-bold small text-white" style="letter-spacing:1px;">NURSELOGIC</div>
              <div style="font-size:.62rem;" class="text-white-50">Gestión Clínica · Ecuador</div>
            </div>
          </a>
          <div class="rounded bg-white bg-opacity-10 py-1.5 px-3 text-center small text-white-50" style="font-size: 0.8rem; letter-spacing: 0.5px;">
            <i class="bi bi-person-badge me-1"></i><%= tituloRol %>
          </div>
        </div>

        <div class="px-4 py-3">
          <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">Navegación Principal</small>
        </div>

        <ul class="nav flex-column px-2 flex-grow-1">
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/PacientesServlet" id="nav-pacientes" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
              <i class="bi bi-person-badge"></i><span>Gestionar Pacientes</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-activity"></i><span>Signos Vitales</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/GlasgowServlet" id="nav-glasgow" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-file-earmark-bar-graph"></i><span>Escala Glasgow</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/DosificacionServlet" id="nav-dosificacion" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-droplet"></i><span>Administración de Dosis</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/AdministracionServlet" id="nav-admin" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-clipboard-check"></i><span>Administración</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/ReportesServlet" id="nav-reportes" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-graph-up"></i><span>Reportes</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/IMCServlet" id="nav-imc" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-calculator"></i><span>IMC</span>
            </a>
          </li>
        </ul>

        <div class="border-top border-white border-opacity-10 p-3 mt-auto">
          <div class="d-flex align-items-center gap-2 mb-2">
            <div class="rounded-circle bg-success d-flex align-items-center justify-content-center flex-shrink-0" style="width:36px;height:36px;">
              <i class="bi bi-person-fill text-white small"></i>
            </div>
            <div class="overflow-hidden">
              <div class="text-white small fw-semibold text-truncate"><%= nombreSesion %></div>
              <div style="font-size:.7rem;" class="text-white-50"><%= tituloRol %></div>
            </div>
          </div>
        </div>
      </nav>

      <!-- CONTENIDO PRINCIPAL -->
      <div class="col nl-main-col">
        <!-- Topbar móvil -->
        <nav class="navbar navbar-dark bg-brand-gradient d-lg-none shadow-sm px-3">
          <div class="container-fluid px-0">
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMobile">
              <span class="navbar-toggler-icon"></span>
            </button>
            <span class="navbar-brand fw-bold mb-0">NURSELOGIC</span>
          </div>
        </nav>

        <!-- Topbar desktop -->
        <header class="navbar navbar-dark bg-brand-gradient d-none d-lg-flex shadow-sm px-4" style="min-height:62px;">
          <div class="small text-white-50 d-flex align-items-center gap-2">
            <i class="bi bi-house-fill"></i><span>/</span>
            <a href="${pageContext.request.contextPath}/PacientesServlet" class="text-white-50 text-decoration-none">Pacientes</a><span>/</span>
            <span class="text-white fw-semibold">Evaluación IMC</span>
          </div>
          <div class="d-flex align-items-center gap-3 ms-auto">
            <span class="text-white-50 small d-flex align-items-center gap-1">
              <i class="bi bi-person-circle"></i><%= nombreSesion %>
            </span>
            <a href="${pageContext.request.contextPath}/LogoutServlet" id="btnLogout" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
              <i class="bi bi-box-arrow-right"></i>Salir
            </a>
          </div>
        </header>

        <main class="p-4">

          <% if (mensajeExito != null) { %>
            <div class="alert alert-success alert-dismissible fade show rounded-3 shadow-sm" role="alert">
              <i class="bi bi-check-circle-fill me-2"></i><%= mensajeExito %>
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          <% } %>

          <% if (errorMsg != null) { %>
            <div class="alert alert-danger alert-dismissible fade show rounded-3 shadow-sm" role="alert">
              <i class="bi bi-exclamation-triangle-fill me-2"></i><%= errorMsg %>
              <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
          <% } %>

          <% if (paciente != null) { %>
            <!-- BANNER DEL PACIENTE (Estilo Dashboard General) -->
            <div class="card border-0 text-white bg-brand-gradient shadow rounded-4 mb-4">
              <div class="card-body d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 py-4 px-4">
                <div class="d-flex align-items-center gap-3">
                  <i class="bi bi-calculator flex-shrink-0" style="font-size:2.2rem;color:rgba(255,255,255,.8);"></i>
                  <div>
                    <h2 class="fs-5 fw-bold mb-1 text-white">
                      Evaluación IMC &middot; Paciente: <strong><%= paciente.getNombres() %> <%= paciente.getApellidos() %></strong>
                    </h2>
                    <p class="small mb-0" style="color:rgba(255,255,255,.72);">
                      Cédula: <strong><%= paciente.getCedula() %></strong> &middot; Edad: <strong><%= paciente.getEdad() != null ? paciente.getEdad() + " años" : "N/D" %></strong> &middot; Sexo: <strong><%= "M".equalsIgnoreCase(paciente.getSexo()) ? "Masculino" : "Femenino" %></strong>
                    </p>
                  </div>
                </div>
                <div>
                  <a href="${pageContext.request.contextPath}/PanelPacienteServlet?cedula=<%= paciente.getCedula() %>" class="btn btn-light text-success fw-semibold btn-sm py-2 px-3 d-inline-flex align-items-center gap-1 shadow-sm rounded-3 btn-volver-panel">
                    <i class="bi bi-arrow-left"></i> Volver al Panel
                  </a>
                </div>
              </div>
            </div>

            <!-- FORMULARIO DE EVALUACIÓN IMC -->
            <div class="card border-0 shadow-sm rounded-4 mb-4 bg-white">
              <div class="card-header bg-white border-bottom pt-3 pb-3 px-4">
                <h6 class="fw-bold mb-0 text-success d-flex align-items-center gap-2">
                  <i class="bi bi-plus-circle-fill"></i> Registrar Medición de Peso y Estatura
                </h6>
              </div>
              <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/IMCServlet" method="POST">
                  <input type="hidden" name="cedula" value="<%= paciente.getCedula() %>">
                  <input type="hidden" name="idPaciente" value="<%= paciente.getIdPaciente() %>">

                  <div class="row g-3">
                    <div class="col-md-6">
                      <label for="peso" class="form-label fw-semibold text-secondary small">Peso del Paciente (en kg)</label>
                      <div class="input-group">
                        <input type="number" step="0.1" name="peso" id="peso" class="form-control rounded-start-3" placeholder="Ej: 70.5" required>
                        <span class="input-group-text bg-light text-muted">kg</span>
                      </div>
                    </div>

                    <div class="col-md-6">
                      <label for="estatura" class="form-label fw-semibold text-secondary small">Estatura / Talla (en metros o cm)</label>
                      <div class="input-group">
                        <input type="number" step="0.01" name="estatura" id="estatura" class="form-control rounded-start-3" placeholder="Ej: 1.70 o 170" required>
                        <span class="input-group-text bg-light text-muted">m / cm</span>
                      </div>
                    </div>
                  </div>

                  <div class="mt-4 text-end">
                    <button type="submit" class="btn btn-success px-4 py-2 rounded-3 fw-semibold shadow-sm d-inline-flex align-items-center gap-2">
                      <i class="bi bi-calculator-fill"></i> Calcular IMC y Guardar
                    </button>
                  </div>
                </form>
              </div>
            </div>

            <!-- TABLA DE HISTORIAL IMC -->
            <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
              <div class="card-header bg-white border-bottom pt-3 pb-3 px-4 d-flex justify-content-between align-items-center">
                <h6 class="fw-bold mb-0 text-dark d-flex align-items-center gap-2">
                  <i class="bi bi-list-task text-success"></i> Historial de Evaluaciones IMC
                </h6>
                <span class="badge bg-success bg-opacity-10 text-success px-3 py-1.5 rounded-pill font-monospace"><%= (historialIMC != null) ? historialIMC.size() : 0 %> evaluaciones</span>
              </div>
              <div class="card-body p-0">
                <div class="table-responsive">
                  <table class="table table-hover align-middle mb-0">
                    <thead class="table-light text-secondary small text-uppercase">
                      <tr>
                        <th scope="col" class="ps-4">#</th>
                        <th scope="col">Fecha / Hora</th>
                        <th scope="col">Peso (kg)</th>
                        <th scope="col">Estatura (m)</th>
                        <th scope="col">Valor IMC</th>
                        <th scope="col" class="pe-4">Alerta Clínica & Clasificación</th>
                      </tr>
                    </thead>
                    <tbody>
                      <% if (historialIMC != null && !historialIMC.isEmpty()) {
                           int count = 1;
                           for (EvaluacionIMC imc : historialIMC) {
                             AlertaClinica alt = imc.getAlerta();
                             String colorBadge = alt != null ? alt.getColorCodigo() : "secondary";
                             String msgAlerta = alt != null ? alt.getMensajeAlerta() : imc.getClasificacion();
                      %>
                             <tr>
                               <td class="ps-4 fw-bold text-muted"><%= count++ %></td>
                               <td class="small text-nowrap"><%= imc.getFechaRegistro() != null ? imc.getFechaRegistro().format(formatter) : "N/D" %></td>
                               <td class="fw-semibold text-dark"><%= String.format("%.1f kg", imc.getPeso()) %></td>
                               <td class="fw-semibold text-dark"><%= String.format("%.2f m", imc.getEstatura()) %></td>
                               <td>
                                 <span class="badge bg-light text-dark border fs-6 px-3 py-1.5 font-monospace fw-bold">
                                   <%= String.format("%.2f", imc.getValorIMC()) %>
                                 </span>
                               </td>
                               <td class="pe-4">
                                 <span class="badge bg-<%= colorBadge %> text-white px-3 py-1.5 rounded-pill fw-medium">
                                   <i class="bi bi-shield-exclamation me-1"></i><%= msgAlerta %>
                                 </span>
                               </td>
                             </tr>
                      <%   }
                         } else { %>
                             <tr>
                               <td colspan="6" class="text-center py-5 text-muted">
                                 <i class="bi bi-info-circle fs-3 d-block mb-2 text-secondary opacity-50"></i>
                                 No hay evaluaciones IMC registradas para este paciente aún.
                               </td>
                             </tr>
                      <% } %>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>

          <% } else { %>
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white">
              <i class="bi bi-person-x text-warning display-4 mb-3"></i>
              <h4 class="fw-bold">No se ha seleccionado ningún paciente</h4>
              <p class="text-muted">Por favor seleccione un paciente desde el listado general para realizar la evaluación de IMC.</p>
              <div>
                <a href="${pageContext.request.contextPath}/PacientesServlet" class="btn btn-success rounded-3 px-4">Ir a Listado de Pacientes</a>
              </div>
            </div>
          <% } %>

        </main>
      </div>

    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
  <script>
    document.addEventListener("DOMContentLoaded", function () {
      const enlacesMenu = document.querySelectorAll('.nl-sidebar a, header a, .navbar a');
      enlacesMenu.forEach(enlace => {
        if (enlace.classList.contains('btn-volver-panel')) {
          return;
        }
        enlace.addEventListener('click', function (e) {
          const confirmar = confirm("Tiene una ficha clínica activa en proceso de atención. ¿Está seguro de que desea salir del módulo del paciente?");
          if (!confirmar) {
            e.preventDefault();
          }
        });
      });
    });
  </script>
</body>
</html>
