<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rrparedes.model.Paciente, com.rrparedes.model.CierreFicha, java.util.List, java.util.Map, java.time.format.DateTimeFormatter" %>
<%
    String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
    if (nombreSesion == null) nombreSesion = (session != null) ? (String) session.getAttribute("usuario") : "";
    String rolSesion = (session != null) ? (String) session.getAttribute("rol") : "";
    boolean esAdmin  = "ADMINISTRADOR".equals(rolSesion);
    String tituloRol = esAdmin ? "Administrador" : "Enfermero/a";

    List<Paciente> listaPacientes = (List<Paciente>) request.getAttribute("listaPacientes");
    if (listaPacientes == null) {
        com.rrparedes.dao.PacienteDAO pDao = new com.rrparedes.dao.PacienteDAO();
        listaPacientes = pDao.listarTodos();
    }

    Map<Long, CierreFicha> resumenesMap = (Map<Long, CierreFicha>) request.getAttribute("resumenesMap");
    DateTimeFormatter fmt = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");

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
  <title>NURSELOGIC | Fichas Clínicas Digitales</title>

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
          <a href="${pageContext.request.contextPath}/DosificacionServlet?modo=libre" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-calculator"></i>Calcular Dosis
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/DosificacionServlet?modo=paciente" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
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
            <a href="${pageContext.request.contextPath}/DosificacionServlet?modo=libre" id="nav-dosificacion-libre" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-calculator"></i><span>Calcular Dosis</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/DosificacionServlet?modo=paciente" id="nav-dosificacion-paciente" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
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
        <header id="nl-topbar" class="navbar navbar-dark bg-brand-gradient d-none d-lg-flex shadow-sm px-4" style="min-height:62px;">
          <span class="navbar-brand fw-semibold mb-0 d-flex align-items-center gap-2">
            <i class="bi bi-person-vcard-fill"></i>
            Gestión de Pacientes &middot; <%= tituloRol %>
          </span>
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

          <!-- ENCABEZADO DE SECCIÓN Y BOTÓN REGISTRAR -->
          <div class="d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3 mb-4">
            <div>
              <h2 class="fs-4 fw-bold text-dark mb-1 d-flex align-items-center gap-2">
                <i class="bi bi-journal-medical text-success"></i> Fichas Clínicas Digitales
              </h2>
              <p class="text-muted small mb-0">Listado de pacientes registrados en el sistema (Base de Datos MySQL)</p>
            </div>
            <div>
              <a href="${pageContext.request.contextPath}/RegistroPacienteServlet" class="btn btn-success fw-semibold px-4 py-2 rounded-3 shadow-sm d-inline-flex align-items-center gap-2">
                <i class="bi bi-person-plus-fill"></i> Registrar Nuevo Paciente
              </a>
            </div>
          </div>

          <!-- TARJETA CONTENEDORA DE PACIENTES -->
          <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden">
            <div class="card-header bg-brand-gradient text-white p-3 border-0 d-flex flex-column flex-md-row justify-content-between align-items-md-center gap-3">
              <div class="d-flex align-items-center gap-2">
                <i class="bi bi-folder-fill fs-5"></i>
                <span class="fw-bold">Pacientes en Base de Datos</span>
                <span class="badge bg-white bg-opacity-20 text-white rounded-pill ms-2 font-monospace">Total: <%= (listaPacientes != null) ? listaPacientes.size() : 0 %></span>
              </div>
              <div style="max-width:320px;" class="w-100">
                <div class="input-group input-group-sm">
                  <span class="input-group-text bg-white text-muted border-0"><i class="bi bi-search"></i></span>
                  <input type="text" id="inputBuscarPaciente" class="form-control border-0" placeholder="Buscar por Cédula o Nombre...">
                </div>
              </div>
            </div>

            <div class="card-body p-0">
              <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="tablaPacientes">
                  <thead class="table-light text-secondary small text-uppercase">
                    <tr>
                      <th scope="col" class="ps-4">#</th>
                      <th scope="col">Cédula</th>
                      <th scope="col">Nombre Completo</th>
                      <th scope="col">Edad / Sexo</th>
                      <th scope="col">Estado</th>
                      <th scope="col" class="pe-4 text-end">Acciones</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%
                      if (listaPacientes != null && !listaPacientes.isEmpty()) {
                          int count = 1;
                          for (Paciente p : listaPacientes) {
                              Long idPac = p.getIdPaciente();
                              CierreFicha cf = (resumenesMap != null) ? resumenesMap.get(idPac) : null;
                              String nEnfermero = (cf != null && cf.getNombreEnfermero() != null) ? cf.getNombreEnfermero() : "Atención en progreso (Sin cierre formal)";
                              String fCierre = (cf != null && cf.getFechaCierre() != null) ? cf.getFechaCierre().format(fmt) : "En atención";
                              String svStr = (cf != null) ? cf.getUltimosSignosVitales() : "Sin registro de signos vitales.";
                              String gStr = (cf != null) ? cf.getUltimoGlasgow() : "Sin evaluación de Glasgow.";
                              String imcStr = (cf != null) ? cf.getUltimoIMC() : "Sin evaluación de IMC.";
                              String antStr = (cf != null) ? cf.getUltimosAntecedentes() : "Sin antecedentes registrados.";
                              String dosStr = (cf != null) ? cf.getUltimaDosis() : "Sin administración de dosis registrada.";
                    %>
                    <tr>
                      <td class="ps-4"><%= count++ %></td>
                      <td><code><%= p.getCedula() %></code></td>
                      <td><strong><%= p.getNombres() + " " + p.getApellidos() %></strong></td>
                      <td><%= p.getEdad() %> años (<%= "M".equalsIgnoreCase(p.getSexo()) ? "Masculino" : "Femenino" %>)</td>
                      <td>
                        <span class="badge bg-success px-3 py-2 rounded-pill">Activo</span>
                      </td>
                      <td class="pe-4 text-end text-nowrap">
                        <div class="d-inline-flex align-items-center gap-2">
                          <a href="${pageContext.request.contextPath}/PanelPacienteServlet?cedula=<%= p.getCedula() %>" class="btn btn-sm btn-success d-inline-flex align-items-center gap-1 py-1.5 px-3 rounded-3 shadow-sm">
                            <i class="bi bi-grid-3x3-gap-fill"></i> Panel Paciente
                          </a>
                          <button type="button" class="btn btn-sm btn-outline-info d-inline-flex align-items-center gap-1 py-1.5 px-3 rounded-3 shadow-sm"
                                  onclick="verFichaConsolidada('<%= p.getNombres() + " " + p.getApellidos() %>', '<%= p.getCedula() %>', '<%= p.getEdad() %>', '<%= p.getSexo() %>', '<%= nEnfermero.replace("'", "\\'") %>', '<%= fCierre %>', '<%= svStr.replace("'", "\\'") %>', '<%= gStr.replace("'", "\\'") %>', '<%= imcStr.replace("'", "\\'") %>', '<%= antStr.replace("'", "\\'") %>', '<%= dosStr.replace("'", "\\'") %>')">
                            <i class="bi bi-eye-fill"></i> Ver Ficha
                          </button>
                        </div>
                      </td>
                    </tr>
                    <%    }
                      } else { %>
                    <tr>
                      <td colspan="6" class="text-center py-5 text-muted">
                        <i class="bi bi-inbox fs-1 d-block mb-2 text-secondary"></i>
                        No hay pacientes registrados aún en la Base de Datos MySQL.<br/>
                        <a href="${pageContext.request.contextPath}/RegistroPacienteServlet" class="btn btn-success btn-sm mt-3">
                          <i class="bi bi-person-plus-fill me-1"></i> Registrar Primer Paciente
                        </a>
                      </td>
                    </tr>
                    <% } %>
                  </tbody>
                </table>
              </div>
            </div>

            <div class="card-footer bg-light p-3 small text-muted border-0">
              <i class="bi bi-shield-check me-1 text-success"></i>
              Información clínica confidencial protegida por roles de usuario NURSELOGIC.
            </div>
          </div>
        </main>
      </div>

    </div>
  </div>

  <!-- MODAL FICHA COMPLETA CON RESUMEN CONSOLIDADO DE CIERRE -->
  <div class="modal fade" id="modalFicha" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
      <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
        <div class="modal-header bg-brand-gradient text-white p-4 border-0">
          <div class="d-flex align-items-center gap-3">
            <div class="rounded-3 bg-white bg-opacity-25 p-2 d-flex align-items-center justify-content-center" style="width:42px;height:42px;">
              <i class="bi bi-person-vcard-fill fs-4 text-white"></i>
            </div>
            <div>
              <h5 class="modal-title fw-bold text-white mb-0" id="mNombre">Ficha Clínica</h5>
              <small class="text-white-50" id="mCedula">Cédula: -</small>
            </div>
          </div>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
        </div>

        <div class="modal-body p-4 bg-light">

          <!-- BANNER ENFERMERO Y FECHA DE CIERRE -->
          <div class="card border-0 bg-success bg-opacity-10 border-start border-4 border-success p-3 mb-3 rounded-3">
            <div class="d-flex flex-column flex-sm-row justify-content-between align-items-sm-center gap-2">
              <div class="d-flex align-items-center gap-2 text-success fw-bold small">
                <i class="bi bi-person-check-fill fs-5"></i>
                <span>Enfermero/a Responsable del Cierre: <span id="mEnfermero" class="text-dark fw-semibold">-</span></span>
              </div>
              <div class="text-muted font-monospace" style="font-size:.78rem;">
                <i class="bi bi-clock-history me-1"></i><span id="mFechaCierre">-</span>
              </div>
            </div>
          </div>

          <!-- PANEL COMPACTO DE REGISTROS CON LETRA PEQUEÑA -->
          <div class="row g-2">
            <!-- 1. SIGNOS VITALES -->
            <div class="col-12">
              <div class="p-2.5 bg-white rounded-3 border shadow-sm">
                <small class="fw-bold text-uppercase text-success d-block mb-1" style="font-size:.72rem;">
                  <i class="bi bi-activity me-1"></i>Últimos Signos Vitales Registrados
                </small>
                <div id="mSignos" class="text-dark font-monospace fw-semibold" style="font-size:.82rem;">-</div>
              </div>
            </div>

            <!-- 2. ESCALA GLASGOW -->
            <div class="col-md-6">
              <div class="p-2.5 bg-white rounded-3 border shadow-sm h-100">
                <small class="fw-bold text-uppercase text-success d-block mb-1" style="font-size:.72rem;">
                  <i class="bi bi-file-earmark-bar-graph me-1"></i>Última Escala Glasgow
                </small>
                <div id="mGlasgow" class="text-dark fw-medium" style="font-size:.82rem;">-</div>
              </div>
            </div>

            <!-- 3. EVALUACIÓN IMC -->
            <div class="col-md-6">
              <div class="p-2.5 bg-white rounded-3 border shadow-sm h-100">
                <small class="fw-bold text-uppercase text-success d-block mb-1" style="font-size:.72rem;">
                  <i class="bi bi-calculator me-1"></i>Última Evaluación IMC & Alerta
                </small>
                <div id="mIMC" class="text-dark fw-medium" style="font-size:.82rem;">-</div>
              </div>
            </div>

            <!-- 4. ANTECEDENTES Y ALERGIAS -->
            <div class="col-12">
              <div class="p-2.5 bg-white rounded-3 border shadow-sm">
                <small class="fw-bold text-uppercase text-success d-block mb-1" style="font-size:.72rem;">
                  <i class="bi bi-journal-medical me-1"></i>Últimos Antecedentes Clínicos & Alergias
                </small>
                <div id="mAntecedentes" class="text-dark fw-medium" style="font-size:.82rem;">-</div>
              </div>
            </div>

            <!-- 5. ÚLTIMA DOSIS ADMINISTRADA -->
            <div class="col-12">
              <div class="p-2.5 bg-white rounded-3 border shadow-sm">
                <small class="fw-bold text-uppercase text-success d-block mb-1" style="font-size:.72rem;">
                  <i class="bi bi-droplet-fill me-1"></i>Última Administración de Dosis
                </small>
                <div id="mDosis" class="text-dark fw-medium" style="font-size:.82rem;">-</div>
              </div>
            </div>
          </div>

        </div>
        <div class="modal-footer bg-white border-0 p-3">
          <button type="button" class="btn btn-secondary px-4 py-2 rounded-3 small fw-semibold" data-bs-dismiss="modal">Cerrar Ficha</button>
        </div>
      </div>
    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
  <script>
    document.getElementById('inputBuscarPaciente').addEventListener('input', function() {
      const q = this.value.toLowerCase().trim();
      const filas = document.querySelectorAll('#tablaPacientes tbody tr');
      filas.forEach(f => {
        const txt = f.textContent.toLowerCase();
        f.style.display = txt.includes(q) ? '' : 'none';
      });
    });

    function verFichaConsolidada(nombre, cedula, edad, sexo, enfermero, fechaCierre, signos, glasgow, imc, antecedentes, dosis) {
      document.getElementById('mNombre').textContent = nombre;
      document.getElementById('mCedula').textContent = 'Cédula: ' + cedula + ' | Edad: ' + edad + ' años (' + (sexo === 'M' ? 'Masculino' : 'Femenino') + ')';
      document.getElementById('mEnfermero').textContent = enfermero;
      document.getElementById('mFechaCierre').textContent = fechaCierre;
      document.getElementById('mSignos').textContent = signos;
      document.getElementById('mGlasgow').textContent = glasgow;
      document.getElementById('mIMC').textContent = imc;
      document.getElementById('mAntecedentes').textContent = antecedentes;
      document.getElementById('mDosis').textContent = dosis;

      const modal = new bootstrap.Modal(document.getElementById('modalFicha'));
      modal.show();
    }
  </script>
</body>
</html>