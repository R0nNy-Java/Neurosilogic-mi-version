<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rrparedes.model.Paciente, com.rrparedes.model.Medicamento, com.rrparedes.model.AdministracionMedicamento, java.util.List, java.time.format.DateTimeFormatter" %>
<%
    String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
    if (nombreSesion == null) nombreSesion = (session != null) ? (String) session.getAttribute("usuario") : "";
    String rolSesion = (session != null) ? (String) session.getAttribute("rol") : "";
    boolean esAdmin  = "ADMINISTRADOR".equals(rolSesion);
    String tituloRol = esAdmin ? "Administrador" : "Enfermero/a";

    Paciente paciente = (Paciente) request.getAttribute("paciente");
    List<Medicamento> catalogoMedicamentos = (List<Medicamento>) request.getAttribute("catalogoMedicamentos");
    List<AdministracionMedicamento> historial = (List<AdministracionMedicamento>) request.getAttribute("historialAdministracion");

    String modoParam = request.getParameter("modo"); // "libre" | "paciente"
    String cedulaParam = request.getParameter("cedula");
    if (paciente == null && cedulaParam != null && !cedulaParam.trim().isEmpty()) {
        com.rrparedes.dao.PacienteDAO pDao = new com.rrparedes.dao.PacienteDAO();
        paciente = pDao.buscarPorCedula(cedulaParam.trim());
    }

    boolean esModoPaciente = (paciente != null) || ("paciente".equalsIgnoreCase(modoParam));

    if (paciente != null && (historial == null || historial.isEmpty())) {
        com.rrparedes.dao.AdministracionMedicamentoDAO adminDAO = new com.rrparedes.dao.AdministracionMedicamentoDAO();
        historial = adminDAO.obtenerPorPaciente(paciente.getIdPaciente());
    }

    if (catalogoMedicamentos == null || catalogoMedicamentos.isEmpty()) {
        com.rrparedes.dao.MedicamentoDAO medDao = new com.rrparedes.dao.MedicamentoDAO();
        catalogoMedicamentos = medDao.listarTodos();
    }

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
    String mensajeExito = (String) session.getAttribute("mensajeExito");
    if (mensajeExito != null) session.removeAttribute("mensajeExito");
    String errorMsg = (String) request.getAttribute("error");

    String tabActiva = (String) request.getAttribute("tabActiva");
    if (tabActiva == null) tabActiva = "REGULAR_DOSIS";
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | <%= esModoPaciente ? "Administración de Dosis" : "Calcular Dosis" %></title>

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
      <div class="rounded bg-white bg-opacity-10 w-100 py-1.5 px-3 text-center small text-white-50" style="font-size: 0.8rem;">
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
          <a href="${pageContext.request.contextPath}/PacientesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
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
          <a href="${pageContext.request.contextPath}/DosificacionServlet?modo=libre" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 <%= !esModoPaciente ? "active" : "" %>">
            <i class="bi bi-calculator"></i>Calcular Dosis
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/DosificacionServlet?modo=paciente" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 <%= esModoPaciente ? "active" : "" %>">
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
          <div class="rounded bg-white bg-opacity-10 py-1.5 px-3 text-center small text-white-50" style="font-size: 0.8rem;">
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
            <a href="${pageContext.request.contextPath}/PacientesServlet" id="nav-pacientes" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
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
            <a href="${pageContext.request.contextPath}/DosificacionServlet?modo=libre" id="nav-dosificacion-libre" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 <%= !esModoPaciente ? "active" : "" %>">
              <i class="bi bi-calculator"></i><span>Calcular Dosis</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/DosificacionServlet?modo=paciente" id="nav-dosificacion-paciente" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 <%= esModoPaciente ? "active" : "" %>">
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
            <% if (paciente != null) { %>
              <a href="${pageContext.request.contextPath}/PacientesServlet" class="text-white-50 text-decoration-none">Pacientes</a><span>/</span>
              <span class="text-white fw-semibold">Administración de Dosis</span>
            <% } else if (esModoPaciente) { %>
              <a href="${pageContext.request.contextPath}/PacientesServlet" class="text-white-50 text-decoration-none">Pacientes</a><span>/</span>
              <span class="text-white fw-semibold">Administración de Dosis</span>
            <% } else { %>
              <span class="text-white fw-semibold">Calcular Dosis</span>
            <% } %>
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
            <!-- ════════════ MODO 1: ADMINISTRACIÓN DE DOSIS EN FICHA DE PACIENTE ATENDIDO ════════════ -->
            <div class="card border-0 text-white bg-brand-gradient shadow rounded-4 mb-4">
              <div class="card-body d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 py-4 px-4">
                <div class="d-flex align-items-center gap-3">
                  <i class="bi bi-droplet-fill flex-shrink-0" style="font-size:2.2rem;color:rgba(255,255,255,.8);"></i>
                  <div>
                    <h2 class="fs-5 fw-bold mb-1 text-white">
                      Administración de Dosis &middot; Paciente: <strong><%= paciente.getNombres() %> <%= paciente.getApellidos() %></strong>
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

            <!-- FORMULARIO DE SELECCIÓN DE MEDICAMENTO Y CÁLCULO DE DOSIS -->
            <div class="card border-0 shadow-sm rounded-4 mb-4 bg-white">
              <div class="card-header bg-white border-bottom pt-3 pb-3 px-4">
                <h6 class="fw-bold mb-0 text-success d-flex align-items-center gap-2">
                  <i class="bi bi-prescription2"></i> Seleccionar Medicamento del Sistema & Calcular Dosis
                </h6>
              </div>
              <div class="card-body p-4">
                <form action="${pageContext.request.contextPath}/DosificacionServlet" method="POST">
                  <input type="hidden" name="tipoCalculo" value="REGISTRAR_ADMINISTRACION">
                  <input type="hidden" name="cedula" value="<%= paciente.getCedula() %>">

                  <div class="row g-3">
                    <div class="col-md-6">
                      <label for="idMedicamento" class="form-label fw-semibold text-secondary small">Medicamento Disponible en Sistema</label>
                      <select name="idMedicamento" id="idMedicamento" class="form-select rounded-3" required>
                        <option value="" disabled selected>-- Seleccione un medicamento --</option>
                        <% if (catalogoMedicamentos != null) {
                             for (Medicamento med : catalogoMedicamentos) { %>
                              <option value="<%= med.getIdMedicamento() %>">
                                <%= med.getNombreMedicamento() %> (<%= med.getPresentacionCompleta() %>)
                              </option>
                        <%   }
                           } %>
                      </select>
                    </div>

                    <div class="col-md-4">
                      <label for="dosisIndicada" class="form-label fw-semibold text-secondary small">Dosis Indicada por el Médico</label>
                      <input type="number" step="0.01" min="0.01" name="dosisIndicada" id="dosisIndicada" class="form-control rounded-3" placeholder="Ej: 250" required>
                    </div>

                    <div class="col-md-2">
                      <label for="unidadDosis" class="form-label fw-semibold text-secondary small">Unidad</label>
                      <select name="unidadDosis" id="unidadDosis" class="form-select rounded-3">
                        <option value="mg" selected>mg</option>
                        <option value="g">g</option>
                        <option value="mcg">mcg</option>
                      </select>
                    </div>
                  </div>

                  <div class="mt-4 text-end">
                    <button type="submit" class="btn btn-success px-4 py-2 rounded-3 fw-semibold shadow-sm d-inline-flex align-items-center gap-2">
                      <i class="bi bi-check-circle-fill"></i> Calcular mL & Registrar Administración
                    </button>
                  </div>
                </form>
              </div>
            </div>

            <!-- TABLA HISTORIAL DE MEDICAMENTOS ADMINISTRADOS AL PACIENTE -->
            <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
              <div class="card-header bg-white border-bottom pt-3 pb-3 px-4 d-flex justify-content-between align-items-center">
                <h6 class="fw-bold mb-0 text-dark d-flex align-items-center gap-2">
                  <i class="bi bi-clock-history text-success"></i> Historial de Dosis Administradas al Paciente
                </h6>
                <span class="badge bg-success bg-opacity-10 text-success px-3 py-1.5 rounded-pill font-monospace"><%= (historial != null) ? historial.size() : 0 %> registros</span>
              </div>
              <div class="card-body p-0">
                <div class="table-responsive">
                  <table class="table table-hover align-middle mb-0">
                    <thead class="table-light text-secondary small text-uppercase">
                      <tr>
                        <th scope="col" class="ps-4">#</th>
                        <th scope="col">Fecha / Hora</th>
                        <th scope="col">Dosis / Volumen Calculado</th>
                        <th scope="col" class="pe-4">Detalle / Presentación</th>
                      </tr>
                    </thead>
                    <tbody>
                      <% if (historial != null && !historial.isEmpty()) {
                           int count = 1;
                           for (AdministracionMedicamento adm : historial) { %>
                             <tr>
                               <td class="ps-4 fw-bold text-muted"><%= count++ %></td>
                               <td class="small text-nowrap"><%= adm.getHoraAdministracion() != null ? adm.getHoraAdministracion().format(formatter) : "N/D" %></td>
                               <td>
                                 <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 px-3 py-1.5 fs-6 font-monospace fw-bold">
                                   <i class="bi bi-droplet-fill me-1"></i><%= adm.getDosisCalculada() %> mL
                                 </span>
                               </td>
                               <td class="pe-4 text-secondary small"><%= adm.getUnidadResultado() != null ? adm.getUnidadResultado() : "Aplicado" %></td>
                             </tr>
                      <%   }
                         } else { %>
                             <tr>
                               <td colspan="4" class="text-center py-5 text-muted">
                                 <i class="bi bi-info-circle fs-3 d-block mb-2 text-secondary opacity-50"></i>
                                 No hay administraciones de medicamentos registradas para este paciente aún.
                               </td>
                             </tr>
                      <% } %>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>

          <% } else if (esModoPaciente) { %>
            <!-- ════════════ MODO 2: BUSCADOR POR CÉDULA PARA ADMINISTRACIÓN DE DOSIS ════════════ -->
            <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white">
              <div class="mx-auto rounded-circle bg-success bg-opacity-10 d-flex align-items-center justify-content-center mb-3" style="width:72px;height:72px;">
                <i class="bi bi-droplet-fill text-success fs-1"></i>
              </div>
              <h4 class="fw-bold text-dark mb-2">Administración de Dosis a Paciente</h4>
              <p class="text-muted mx-auto mb-4" style="max-width:520px;">
                Por favor ingrese la cédula del paciente para cargar su ficha clínica y registrar la administración de medicamentos.
              </p>

              <form action="${pageContext.request.contextPath}/DosificacionServlet" method="GET" class="mx-auto" style="max-width:460px;">
                <input type="hidden" name="modo" value="paciente">
                <div class="input-group input-group-lg mb-3">
                  <span class="input-group-text bg-light"><i class="bi bi-card-heading text-secondary"></i></span>
                  <input type="text" name="cedula" class="form-control" placeholder="Ingrese número de cédula" required>
                  <button type="submit" class="btn btn-success px-4 fw-semibold">
                    <i class="bi bi-search me-1"></i> Atender
                  </button>
                </div>
              </form>

              <div class="mt-2">
                <a href="${pageContext.request.contextPath}/PacientesServlet" class="btn btn-link text-decoration-none text-muted small">
                  <i class="bi bi-arrow-left me-1"></i> O seleccione el paciente desde el listado general
                </a>
              </div>
            </div>

          <% } else { %>
            <!-- ════════════ MODO 3: CALCULADORA LIBRE DESDE EL SIDEBAR ("Calcular Dosis") ════════════ -->
            <div class="card border-0 text-white bg-brand-gradient shadow rounded-4 mb-4">
              <div class="card-body py-4 px-4">
                <h2 class="fs-5 fw-bold mb-1 text-white d-flex align-items-center gap-2">
                  <i class="bi bi-calculator-fill"></i> Calculadora Clínica de Dosis & Infusiones
                </h2>
                <p class="small mb-0" style="color:rgba(255,255,255,.75);">
                  Herramienta de referencia rápida para el cálculo de regla de tres, volúmenes de administración y goteo por minuto.
                </p>
              </div>
            </div>

            <!-- TABS DE CÁLCULO -->
            <ul class="nav nav-pills mb-4 gap-2" id="calcTabs">
              <li class="nav-item">
                <a class="nav-link rounded-3 fw-semibold px-4 py-2.5 <%= "REGULAR_DOSIS".equals(tabActiva) ? "active bg-success text-white" : "bg-white text-dark shadow-sm" %>" href="#tabDosis" data-bs-toggle="pill">
                  <i class="bi bi-bezier2 me-1"></i>Regla de Tres / Dosis Libre
                </a>
              </li>
              <li class="nav-item">
                <a class="nav-link rounded-3 fw-semibold px-4 py-2.5 <%= "INFUSION_GOTEO".equals(tabActiva) ? "active bg-success text-white" : "bg-white text-dark shadow-sm" %>" href="#tabInfusion" data-bs-toggle="pill">
                  <i class="bi bi-speedometer2 me-1"></i>Infusión y Goteo por Minuto
                </a>
              </li>
            </ul>

            <div class="tab-content">
              <!-- TAB 1: REGLA DE TRES -->
              <div class="tab-pane fade <%= "REGULAR_DOSIS".equals(tabActiva) ? "show active" : "" %>" id="tabDosis">
                <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                  <form action="${pageContext.request.contextPath}/DosificacionServlet" method="POST">
                    <input type="hidden" name="tipoCalculo" value="REGULAR_DOSIS">
                    <div class="row g-3">
                      <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Dosis Indicada</label>
                        <div class="input-group">
                          <input type="number" step="0.01" min="0.01" name="dosisIndicada" class="form-control" value="${dosisIndicada != null ? dosisIndicada : ''}" placeholder="Ej: 250" required>
                          <select name="unidadDosis" class="form-select bg-light">
                            <option value="mg" selected>mg</option>
                            <option value="g">g</option>
                            <option value="mcg">mcg</option>
                          </select>
                        </div>
                      </div>
                      <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Presentación Disponible</label>
                        <div class="input-group">
                          <input type="number" step="0.01" min="0.01" name="presentacion" class="form-control" value="${presentacion != null ? presentacion : ''}" placeholder="Ej: 500" required>
                          <select name="unidadPresentacion" class="form-select bg-light">
                            <option value="mg" selected>mg</option>
                            <option value="g">g</option>
                            <option value="mcg">mcg</option>
                          </select>
                        </div>
                      </div>
                      <div class="col-md-4">
                        <label class="form-label small fw-semibold text-secondary">Diluyente / Ampolla (mL)</label>
                        <input type="number" step="0.01" min="0.01" name="diluyenteMl" class="form-control" value="${diluyenteMl != null ? diluyenteMl : ''}" placeholder="Ej: 10" required>
                      </div>
                    </div>

                    <div class="mt-4 d-flex align-items-center justify-content-between">
                      <button type="submit" class="btn btn-success px-4 py-2 rounded-3 fw-semibold">
                        <i class="bi bi-calculator me-1"></i> Calcular Volumen
                      </button>

                      <% if (request.getAttribute("resultadoVolumen") != null) { %>
                        <div class="bg-success bg-opacity-10 border border-success border-opacity-25 rounded-3 px-4 py-2 text-success fw-bold fs-5">
                          Volumen a Administrar: ${resultadoVolumen} mL
                        </div>
                      <% } %>
                    </div>
                  </form>
                </div>
              </div>

              <!-- TAB 2: INFUSIÓN Y GOTEO -->
              <div class="tab-pane fade <%= "INFUSION_GOTEO".equals(tabActiva) ? "show active" : "" %>" id="tabInfusion">
                <div class="card border-0 shadow-sm rounded-4 bg-white p-4">
                  <form action="${pageContext.request.contextPath}/DosificacionServlet" method="POST">
                    <input type="hidden" name="tipoCalculo" value="INFUSION_GOTEO">
                    <div class="row g-3">
                      <div class="col-md-6">
                        <label class="form-label small fw-semibold text-secondary">Volumen Total (mL)</label>
                        <input type="number" step="0.1" min="0.01" name="volumenTotalMl" class="form-control" value="${volumenTotalMl != null ? volumenTotalMl : ''}" placeholder="Ej: 500" required>
                      </div>
                      <div class="col-md-6">
                        <label class="form-label small fw-semibold text-secondary">Tiempo Total (Horas)</label>
                        <input type="number" step="0.1" min="0.01" name="horasTotales" class="form-control" value="${horasTotales != null ? horasTotales : ''}" placeholder="Ej: 8" required>
                      </div>
                    </div>

                    <div class="mt-4 text-end">
                      <button type="submit" class="btn btn-success px-4 py-2 rounded-3 fw-semibold">
                        <i class="bi bi-calculator me-1"></i> Calcular Goteo
                      </button>
                    </div>

                    <% if (request.getAttribute("gotasPorMinuto") != null) { %>
                      <div class="row g-3 mt-3">
                        <div class="col-md-4">
                          <div class="p-3 bg-light rounded-3 text-center border">
                            <div class="text-muted small">Macrogotas / min</div>
                            <div class="fs-4 fw-bold text-success">${gotasPorMinuto} gotas/min</div>
                          </div>
                        </div>
                        <div class="col-md-4">
                          <div class="p-3 bg-light rounded-3 text-center border">
                            <div class="text-muted small">Microgotas / min</div>
                            <div class="fs-4 fw-bold text-success">${microgotasPorMinuto} microgotas/min</div>
                          </div>
                        </div>
                        <div class="col-md-4">
                          <div class="p-3 bg-light rounded-3 text-center border">
                            <div class="text-muted small">Flujo Horario</div>
                            <div class="fs-4 fw-bold text-success">${mlPorHora} mL/h</div>
                          </div>
                        </div>
                      </div>
                    <% } %>
                  </form>
                </div>
              </div>
            </div>

          <% } %>

        </main>
      </div>

    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

  <% if (paciente != null) { %>
    <script>
      document.addEventListener("DOMContentLoaded", function () {
        const enlacesMenu = document.querySelectorAll('.nl-sidebar a, header a, .navbar a');
        enlacesMenu.forEach(enlace => {
          if (enlace.classList.contains('btn-volver-panel')) {
            return;
          }
          enlace.addEventListener('click', function (e) {
            const confirmar = confirm("Tiene una ficha clínica activa en proceso de atención. ¿Está seguro de que desea salir del módulo?");
            if (!confirmar) {
              e.preventDefault();
            }
          });
        });
      });
    </script>
  <% } %>
</body>
</html>