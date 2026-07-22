<%--
  NURSELOGIC - Signos Vitales
  Formulario de monitorización de signos vitales con generación de alertas
  cromáticas (ROJO = sobre rango, AZUL = bajo rango) según parámetros clínicos.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rrparedes.dao.PacienteDAO, com.rrparedes.model.Paciente" %>
<%
    String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
    if (nombreSesion == null) nombreSesion = (session != null) ? (String) session.getAttribute("usuario") : "";

    // Simulación o recuperación de variables de rol para la nueva plantilla global
    boolean esAdmin = (session != null) && "ADMIN".equals(session.getAttribute("rol"));
    String tituloRol = (String) (session != null ? session.getAttribute("rolDescripcion") : "Personal de Enfermería");
    if (tituloRol == null) tituloRol = "Personal Clínico";

    String cedulaParam  = request.getParameter("cedula");
    String nombreParam  = request.getParameter("Paciente");

    if ((nombreParam == null || nombreParam.trim().isEmpty()) && cedulaParam != null && !cedulaParam.trim().isEmpty()) {
        PacienteDAO pDao = new PacienteDAO();
        Paciente p = pDao.buscarPorCedula(cedulaParam.trim());
        if (p != null) {
            nombreParam = p.getNombres() + " " + p.getApellidos();
        }
    }

    boolean tienePaciente = (nombreParam != null && !nombreParam.trim().isEmpty());
    boolean cedulaProvista = (cedulaParam != null && !cedulaParam.trim().isEmpty());
    boolean pacienteNoEncontrado = (cedulaProvista && !tienePaciente);

    String errorMsg   = (String) request.getAttribute("errorMsg");
    String successMsg = (String) request.getAttribute("successMsg");
    String alertasGeneradas = (String) request.getAttribute("alertasGeneradas");
    Integer numAlertas = (Integer) request.getAttribute("numAlertas");

    String[] alertas = (alertasGeneradas != null && !alertasGeneradas.trim().isEmpty())
            ? alertasGeneradas.split("\\|") : new String[0];
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>NURSELOGIC | Signos Vitales</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>
<body class="bg-light" style="font-family:'Inter',sans-serif;">

<!-- ======================================================================= -->
<!-- 1. OFFCANVAS SIDEBAR – VISTA MÓVIL                                      -->
<!-- ======================================================================= -->
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
      <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">MENU PRINCIPAL</small>
    </div>
    <ul class="nav flex-column px-2 flex-grow-1">
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
          <i class="bi bi-grid-1x2-fill"></i>Dashboard
        </a>
      </li>
      <% if (esAdmin) { %>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/GestionarUsuariosServlet" id="nav-usuarios-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
          <i class="bi bi-people-fill"></i>Gestionar Usuarios
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/GestionarCatalogoServlet" id="nav-catalogo-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
          <i class="bi bi-journal-medical"></i>Catalogo Medicamentos
        </a>
      </li>
      <% } else { %>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/PacientesServlet" id="nav-pacientes-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
          <i class="bi bi-person-badge"></i>Gestionar Pacientes
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
          <i class="bi bi-activity"></i>Signos Vitales
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/GlasgowServlet" id="nav-glasgow-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
          <i class="bi bi-file-earmark-bar-graph"></i>Escala Glasgow
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/DosificacionServlet" id="nav-dosificacion-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
          <i class="bi bi-droplet"></i>Calcular Dosis
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/AdministracionServlet" id="nav-admin-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
          <i class="bi bi-clipboard-check"></i>Administracion
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/ReportesServlet" id="nav-reportes-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
          <i class="bi bi-graph-up"></i>Reportes
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/calculadora.jsp" id="nav-imc-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
          <i class="bi bi-calculator"></i>Calculadora IMC
        </a>
      </li>
      <% } %>
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
      <ul class="nav flex-column gap-1 p-0 small">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/CambioContrasenaServlet" id="nav-cambiopass-m" class="nav-link text-white-50 p-1 d-flex align-items-center gap-2" style="font-size: 0.8rem;">
            <i class="bi bi-key"></i> Cambiar contraseña
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/LogoutServlet" id="nav-logout-m" class="nav-link text-white-50 p-1 d-flex align-items-center gap-2" style="font-size: 0.8rem;">
            <i class="bi bi-box-arrow-right"></i> Cerrar sesión
          </a>
        </li>
      </ul>
    </div>
  </div>
</div>

<div class="container-fluid p-0">
    <div class="row g-0 min-vh-100">

        <!-- ======================================================================= -->
        <!-- 2. SIDEBAR – VISTA ESCRITORIO (PC)                                      -->
        <!-- ======================================================================= -->
        <nav class="col-auto d-none d-lg-flex flex-column nl-sidebar text-white p-0" id="nl-sidebar" style="width:240px;min-height:100vh;position:sticky;top:0;height:100vh;overflow-y:auto;">
          <div class="p-4 border-bottom border-white border-opacity-10">
            <a href="${pageContext.request.contextPath}/index.jsp" class="d-flex align-items-center gap-3 text-white text-decoration-none mb-3">
              <div class="rounded-3 bg-success p-2 flex-shrink-0">
                <i class="bi bi-heart-pulse-fill text-white fs-5"></i>
              </div>
              <div>
                <div class="fw-bold small text-white" style="letter-spacing:1px;">NURSELOGIC</div>
                <div style="font-size:.62rem;" class="text-white-50">Gestion Clinica · Ecuador</div>
              </div>
            </a>
            <div class="rounded bg-white bg-opacity-10 py-1.5 px-3 text-center small text-white-50" style="font-size: 0.8rem; letter-spacing: 0.5px;">
              <i class="bi bi-person-badge me-1"></i><%= tituloRol %>
            </div>
          </div>

          <div class="px-4 py-3">
            <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">MENU PRINCIPAL</small>
          </div>

          <ul class="nav flex-column px-2 flex-grow-1">
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
                <i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span>
              </a>
            </li>
            <% if (esAdmin) { %>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/GestionarUsuariosServlet" id="nav-usuarios" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
                <i class="bi bi-people-fill"></i><span>Gestionar Usuarios</span>
              </a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/GestionarCatalogoServlet" id="nav-catalogo" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
                <i class="bi bi-journal-medical"></i><span>Catalogo Medicamentos</span>
              </a>
            </li>
            <% } else { %>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/PacientesServlet" id="nav-pacientes" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
                <i class="bi bi-person-badge"></i><span>Gestionar Pacientes</span>
              </a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
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
                <i class="bi bi-droplet"></i><span>Calcular Dosis</span>
              </a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/AdministracionServlet" id="nav-admin" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
                <i class="bi bi-clipboard-check"></i><span>Administracion</span>
              </a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/ReportesServlet" id="nav-reportes" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
                <i class="bi bi-graph-up"></i><span>Reportes</span>
              </a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/calculadora.jsp" id="nav-imc" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
                <i class="bi bi-calculator"></i><span>Calculadora IMC</span>
              </a>
            </li>
            <% } %>
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
            <ul class="nav flex-column gap-1 p-0 small">
              <li class="nav-item">
                <a href="${pageContext.request.contextPath}/CambioContrasenaServlet" id="nav-cambiopass" class="nav-link text-white-50 p-1 d-flex align-items-center gap-2" style="font-size: 0.8rem;">
                  <i class="bi bi-key"></i> Cambiar contraseña
                </a>
              </li>
              <li class="nav-item">
                <a href="${pageContext.request.contextPath}/LogoutServlet" id="nav-logout" class="nav-link text-white-50 p-1 d-flex align-items-center gap-2" style="font-size: 0.8rem;">
                  <i class="bi bi-box-arrow-right"></i> Cerrar sesión
                </a>
              </li>
            </ul>
          </div>
        </nav>

        <!-- ======================================================================= -->
        <!-- 3. CONTENIDO PRINCIPAL Y TOPBARS                                        -->
        <!-- ======================================================================= -->
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

            <!-- Topbar Escritorio -->
            <header id="nl-topbar" class="navbar navbar-dark bg-brand-gradient d-none d-lg-flex shadow-sm px-4" style="min-height:62px;">
              <span class="navbar-brand fw-semibold mb-0 d-flex align-items-center gap-2" style="font-size: 0.95rem;">
                <i class="bi bi-activity"></i>
                Gestión de Signos Vitales &middot; <%= tituloRol %>
              </span>
              <div class="d-flex align-items-center gap-3 ms-auto">
                <span class="text-white-50 small d-flex align-items-center gap-1">
                  <i class="bi bi-person-circle"></i><%= nombreSesion %>
                </span>
                <a href="${pageContext.request.contextPath}/LogoutServlet" id="btnLogoutTop" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                  <i class="bi bi-box-arrow-right"></i>Salir
                </a>
              </div>
            </header>

            <main class="p-4">
                <!-- ENCABEZADO INTERNO -->
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h1 class="h4 fw-bold mb-0 text-dark d-flex align-items-center gap-2">
                            <i class="bi bi-activity text-success"></i> Signos Vitales
                        </h1>
                        <p class="text-muted small mb-0">Monitorización con alertas cromáticas por rango clínico</p>
                    </div>
                    <% if (cedulaParam != null && !cedulaParam.trim().isEmpty()) { %>
                    <a href="${pageContext.request.contextPath}/PanelPacienteServlet?cedula=<%= cedulaParam %>" class="btn btn-outline-secondary btn-sm d-inline-flex align-items-center gap-1">
                        <i class="bi bi-arrow-left-circle"></i> Volver al Panel
                    </a>
                    <% } else { %>
                    <button type="button" onclick="history.back()" class="btn btn-outline-secondary btn-sm d-inline-flex align-items-center gap-1">
                        <i class="bi bi-arrow-left-circle"></i> Volver
                    </button>
                    <% } %>
                </div>

                <% if (!tienePaciente) { %>
                <!-- ══════════ BUSCADOR POR CÉDULA ══════════ -->
                <div class="row justify-content-center">
                    <div class="col-lg-6 col-md-8">
                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                            <div class="card-header bg-brand-gradient text-white p-4 border-0 d-flex align-items-center gap-3">
                                <div class="rounded-3 bg-white bg-opacity-25 p-2 d-flex align-items-center justify-content-center" style="width:44px;height:44px;">
                                    <i class="bi bi-search fs-4 text-white"></i>
                                </div>
                                <div>
                                    <h2 class="h5 fw-bold mb-0 text-white">Buscar Paciente</h2>
                                    <p class="text-white-50 small mb-0">Ingrese la cédula para cargar la ficha clínica</p>
                                </div>
                            </div>
                            <div class="card-body p-4">
                                <% if (pacienteNoEncontrado) { %>
                                <div class="alert alert-danger d-flex align-items-center gap-2 mb-3" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill"></i>
                                    <span>No se encontró ningún paciente con la cédula <b><%= cedulaParam.trim() %></b>.</span>
                                </div>
                                <% } %>
                                <form action="${pageContext.request.contextPath}/SignosVitalesServlet" method="GET">
                                    <label class="form-label small fw-semibold text-uppercase text-muted" for="cedulaBusqueda">Cédula del Paciente *</label>
                                    <div class="input-group">
                                        <input type="text" id="cedulaBusqueda" name="cedula" class="form-control py-2" placeholder="Ej: 1712345678" maxlength="10" pattern="[0-9]{10}" inputmode="numeric" value="<%= cedulaParam != null ? cedulaParam.trim() : "" %>" required autofocus/>
                                        <button type="submit" class="btn btn-success d-flex align-items-center gap-2 px-4">
                                            <i class="bi bi-search"></i> Buscar
                                        </button>
                                    </div>
                                    <div class="form-text" style="font-size:.73rem;">
                                        También puede acceder directamente desde el Panel del Paciente, donde el nombre y la cédula ya vienen precargados.
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <% } else { %>

                <div class="row g-4">
                    <!-- ══════════ COLUMNA IZQUIERDA: FORMULARIO ══════════ -->
                    <div class="col-lg-7">
                        <% if (errorMsg != null) { %>
                        <div class="alert alert-danger d-flex align-items-center gap-2" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i><span><%= errorMsg %></span>
                        </div>
                        <% } %>
                        <% if (successMsg != null) { %>
                        <div class="alert alert-success d-flex align-items-center gap-2" role="alert">
                            <i class="bi bi-check-circle-fill"></i><span><%= successMsg %></span>
                        </div>
                        <% } %>

                        <!-- RESULTADO: ALERTAS CLÍNICAS -->
                        <% if (alertas.length > 0) { %>
                        <div class="card border-0 shadow-sm rounded-4 mb-4 overflow-hidden">
                            <div class="card-body p-4">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <span class="text-uppercase text-muted small fw-semibold">Alertas Detectadas</span>
                                    <span class="badge bg-dark rounded-pill px-3 py-2"><%= numAlertas != null ? numAlertas : alertas.length %></span>
                                </div>
                                <% for (String a : alertas) {
                                    if (a == null || a.trim().isEmpty()) continue;
                                    boolean esRoja = a.contains("[ROJO]");
                                    boolean esAzul = a.contains("[AZUL]");
                                    String texto = a.replace("[ROJO]", "").replace("[AZUL]", "").trim();
                                    String badgeClass = esRoja ? "bg-danger" : (esAzul ? "bg-primary" : "bg-secondary");
                                    String icono = esRoja ? "bi-arrow-up-circle-fill" : (esAzul ? "bi-arrow-down-circle-fill" : "bi-info-circle-fill");
                                %>
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="badge <%= badgeClass %> rounded-pill p-2"><i class="bi <%= icono %>"></i></span>
                                    <span class="small text-dark"><%= texto %></span>
                                </div>
                                <% } %>
                            </div>
                        </div>
                        <% } %>

                        <!-- FORMULARIO -->
                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                            <div class="card-header bg-brand-gradient text-white p-4 border-0 d-flex align-items-center gap-3">
                                <div class="rounded-3 bg-white bg-opacity-25 p-2 d-flex align-items-center justify-content-center" style="width:44px;height:44px;">
                                    <i class="bi bi-activity fs-4 text-white"></i>
                                </div>
                                <div>
                                    <h2 class="h5 fw-bold mb-0 text-white">Registro de Signos Vitales</h2>
                                    <p class="text-white-50 small mb-0">
                                        <%= tienePaciente ? "Paciente: " + nombreParam : "Monitorización clínica del paciente" %>
                                    </p>
                                </div>
                            </div>
                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/SignosVitalesServlet" method="POST" novalidate>
                                    <% if (cedulaParam != null && !cedulaParam.trim().isEmpty()) { %>
                                    <input type="hidden" name="cedula" value="<%= cedulaParam.trim() %>"/>
                                    <% } %>

                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold text-uppercase text-muted" for="Paciente">Paciente *</label>
                                        <input type="text" id="Paciente" name="Paciente" class="form-control py-2 <%= tienePaciente ? "bg-light text-dark fw-semibold" : "" %>" placeholder="Ingrese el nombre del paciente" value="<%= nombreParam != null ? nombreParam : "" %>" <%= tienePaciente ? "readonly" : "required" %>/>
                                        <% if (tienePaciente) { %>
                                        <div class="form-text text-success" style="font-size:.73rem;">
                                            <i class="bi bi-check-circle-fill me-1"></i>Nombre precargado automáticamente desde la Ficha Clínica.
                                        </div>
                                        <% } %>
                                    </div>

                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold text-uppercase text-muted" for="Turno">Turno *</label>
                                            <select id="Turno" name="Turno" class="form-select py-2" required>
                                                <option value="" selected disabled>Seleccione un turno</option>
                                                <option value="MAÑANA">Mañana</option>
                                                <option value="TARDE">Tarde</option>
                                                <option value="NOCHE">Noche</option>
                                            </select>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold text-uppercase text-muted" for="Temperatura">Temperatura (°C) *</label>
                                            <input type="number" step="0.1" id="Temperatura" name="Temperatura" class="form-control py-2" placeholder="36.5" required/>
                                            <div class="form-text" style="font-size:.7rem;">Rango normal: 36.0 – 37.5 °C</div>
                                        </div>
                                    </div>

                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold text-uppercase text-muted" for="Sistolica">Presión Sistólica (mmHg) *</label>
                                            <input type="number" id="Sistolica" name="Sistolica" class="form-control py-2" placeholder="120" required/>
                                            <div class="form-text" style="font-size:.7rem;">Rango normal: 90 – 139 mmHg</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold text-uppercase text-muted" for="Diastolica">Presión Diastólica (mmHg) *</label>
                                            <input type="number" id="Diastolica" name="Diastolica" class="form-control py-2" placeholder="80" required/>
                                            <div class="form-text" style="font-size:.7rem;">Rango normal: 60 – 89 mmHg</div>
                                        </div>
                                    </div>

                                    <div class="row g-3 mb-3">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold text-uppercase text-muted" for="FrecCardiaca">Frecuencia Cardiaca (lpm) *</label>
                                            <input type="number" id="FrecCardiaca" name="FrecCardiaca" class="form-control py-2" placeholder="75" required/>
                                            <div class="form-text" style="font-size:.7rem;">Rango normal: 60 – 100 lpm</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold text-uppercase text-muted" for="FrecRespiratoria">Frecuencia Respiratoria (rpm) *</label>
                                            <input type="number" id="FrecRespiratoria" name="FrecRespiratoria" class="form-control py-2" placeholder="16" required/>
                                            <div class="form-text" style="font-size:.7rem;">Rango normal: 12 – 20 rpm</div>
                                        </div>
                                    </div>

                                    <div class="row g-3 mb-4">
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold text-uppercase text-muted" for="SaturacionO2">Saturación O₂ (%) *</label>
                                            <input type="number" id="SaturacionO2" name="SaturacionO2" class="form-control py-2" placeholder="98" required/>
                                            <div class="form-text" style="font-size:.7rem;">Rango normal: 95 – 100 %</div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label small fw-semibold text-uppercase text-muted" for="Glicemia">Glicemia (mg/dL)</label>
                                            <input type="number" id="Glicemia" name="Glicemia" class="form-control py-2" placeholder="90"/>
                                            <div class="form-text" style="font-size:.7rem;">Rango normal: 70 – 100 mg/dL</div>
                                        </div>
                                    </div>

                                    <button type="submit" class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2 shadow-sm">
                                        <i class="bi bi-clipboard2-check"></i> Registrar Signos Vitales
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- ══════════ COLUMNA DERECHA: REFERENCIA DE RANGOS ══════════ -->
                    <div class="col-lg-5">
                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden" style="position:sticky; top:1rem;">
                            <div class="card-header bg-white p-3 d-flex align-items-center gap-2 border-bottom">
                                <div class="rounded-3 bg-success bg-opacity-10 p-2 d-flex align-items-center justify-content-center" style="width:38px;height:38px;">
                                    <i class="bi bi-info-circle-fill text-success fs-5"></i>
                                </div>
                                <div>
                                    <h2 class="h6 fw-bold mb-0 text-dark">Rangos de Referencia</h2>
                                    <p class="text-muted mb-0" style="font-size:.72rem;">Adultos 19 – 60 años</p>
                                </div>
                            </div>
                            <div class="card-body p-3">
                                <div class="d-flex align-items-center justify-content-between border-bottom py-2">
                                    <span class="small text-muted"><i class="bi bi-thermometer-half me-2 text-danger"></i>Temperatura</span>
                                    <span class="small fw-semibold text-dark">36.0 – 37.5 °C</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between border-bottom py-2">
                                    <span class="small text-muted"><i class="bi bi-heart-pulse me-2 text-danger"></i>Presión Sistólica</span>
                                    <span class="small fw-semibold text-dark">90 – 139 mmHg</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between border-bottom py-2">
                                    <span class="small text-muted"><i class="bi bi-heart-pulse me-2 text-danger"></i>Presión Diastólica</span>
                                    <span class="small fw-semibold text-dark">60 – 89 mmHg</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between border-bottom py-2">
                                    <span class="small text-muted"><i class="bi bi-activity me-2 text-danger"></i>Frec. Cardiaca</span>
                                    <span class="small fw-semibold text-dark">60 – 100 lpm</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between border-bottom py-2">
                                    <span class="small text-muted"><i class="bi bi-lungs-fill me-2 text-danger"></i>Frec. Respiratoria</span>
                                    <span class="small fw-semibold text-dark">12 – 20 rpm</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between border-bottom py-2">
                                    <span class="small text-muted"><i class="bi bi-droplet-half me-2 text-danger"></i>Saturación O₂</span>
                                    <span class="small fw-semibold text-dark">95 – 100 %</span>
                                </div>
                                <div class="d-flex align-items-center justify-content-between py-2">
                                    <span class="small text-muted"><i class="bi bi-droplet-fill me-2 text-danger"></i>Glicemia</span>
                                    <span class="small fw-semibold text-dark">70 – 100 mg/dL</span>
                                </div>
                                <hr class="my-3"/>
                                <div class="d-flex align-items-center gap-2 mb-2">
                                    <span class="badge bg-danger rounded-pill p-2"><i class="bi bi-arrow-up-circle-fill"></i></span>
                                    <span class="small text-muted">Rojo: valor sobre lo normal</span>
                                </div>
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge bg-primary rounded-pill p-2"><i class="bi bi-arrow-down-circle-fill"></i></span>
                                    <span class="small text-muted">Azul: valor bajo lo normal</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </main>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>