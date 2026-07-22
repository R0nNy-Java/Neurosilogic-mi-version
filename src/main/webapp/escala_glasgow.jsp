<%--
  NURSELOGIC - Escala de Glasgow
  Formulario clínico para el registro del componente ocular, verbal y motor,
  cálculo del puntaje total (3-15) y clasificación del nivel de severidad.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rrparedes.dao.PacienteDAO, com.rrparedes.model.Paciente" %>
<%@ page import="com.rrparedes.model.EscalaGlasgow, java.util.List" %>
<%
    /* ── Variables de sesión y rol ── */
    String rolSesion    = (session != null) ? (String) session.getAttribute("rol")           : "";
    String usuarioSesion= (session != null) ? (String) session.getAttribute("usuario")        : "usuario";
    String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : usuarioSesion;
    if (nombreSesion == null) nombreSesion = usuarioSesion;
    boolean esAdmin  = "ADMINISTRADOR".equals(rolSesion);
    String tituloRol = esAdmin ? "Administrador" : "Enfermero/a";

    /* ── Lógica de búsqueda de paciente ── */
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
    Integer total = (Integer) request.getAttribute("totalGlasgowResult");
    String nivel  = (String) request.getAttribute("nivelResult");

    String nivelBadgeClass = "bg-secondary";
    if (nivel != null) {
        if (nivel.equals("Leve")) nivelBadgeClass = "bg-success";
        else if (nivel.equals("Moderado")) nivelBadgeClass = "bg-warning text-dark";
        else if (nivel.equals("Grave")) nivelBadgeClass = "bg-danger";
    }

    /* ── Historial de la escala ── */
    List<EscalaGlasgow> historialGlasgow = (List<EscalaGlasgow>) request.getAttribute("historialGlasgow");
    boolean yaTienePrueba = (historialGlasgow != null && !historialGlasgow.isEmpty());
    EscalaGlasgow ultimaPrueba = yaTienePrueba ? historialGlasgow.get(0) : null;

    String ultimoNivel = null;
    String ultimoBadgeClass = "bg-secondary";
    if (ultimaPrueba != null) {
        ultimoNivel = ultimaPrueba.getNivelSeveridad();
        if (ultimoNivel == null && ultimaPrueba.getPuntajeTotal() != null) {
            int t = ultimaPrueba.getPuntajeTotal();
            ultimoNivel = t >= 13 ? "Leve" : t >= 9 ? "Moderado" : "Grave";
        }
        if ("Leve".equals(ultimoNivel)) ultimoBadgeClass = "bg-success";
        else if ("Moderado".equals(ultimoNivel)) ultimoBadgeClass = "bg-warning text-dark";
        else if ("Grave".equals(ultimoNivel)) ultimoBadgeClass = "bg-danger";
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>NURSELOGIC | Escala de Glasgow</title>
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
        <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
          <i class="bi bi-activity"></i>Signos Vitales
        </a>
      </li>
      <li class="nav-item">
        <a href="${pageContext.request.contextPath}/GlasgowServlet" id="nav-glasgow-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
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
              <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
                <i class="bi bi-activity"></i><span>Signos Vitales</span>
              </a>
            </li>
            <li class="nav-item">
              <a href="${pageContext.request.contextPath}/GlasgowServlet" id="nav-glasgow" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
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

        <!-- CONTENIDO PRINCIPAL -->
        <div class="col nl-main-col">
            <!-- ======================================================================= -->
            <!-- 3. TOPBARS – MÓVIL Y ESCRITORIO                                         -->
            <!-- ======================================================================= -->
            <!-- Topbar móvil -->
            <nav class="navbar navbar-dark bg-brand-gradient d-lg-none shadow-sm px-3">
              <div class="container-fluid px-0">
                <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMobile">
                  <span class="navbar-toggler-icon"></span>
                </button>
                <span class="navbar-brand fw-bold mb-0">NURSELOGIC</span>
              </div>
            </nav>

            <!-- Topbar Escritorio Estilo Plantilla Base -->
            <header id="nl-topbar" class="navbar navbar-dark bg-brand-gradient d-none d-lg-flex shadow-sm px-4" style="min-height:62px;">
              <span class="navbar-brand fw-semibold mb-0 d-flex align-items-center gap-2">
                <i class="bi bi-file-earmark-bar-graph-fill"></i>
                Escala de Glasgow &middot; <%= tituloRol %>
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

            <main class="p-4" style="background:#f4f7f6;">
                <!-- ENCABEZADO TÍTULO MÓDULO + BOTÓN VOLVER AL PANEL -->
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h1 class="h4 fw-bold mb-0 text-dark d-flex align-items-center gap-2">
                            <i class="bi bi-clipboard2-pulse-fill text-success"></i> Escala de Glasgow
                        </h1>
                        <p class="text-muted small mb-0">Valoración neurológica del paciente</p>
                    </div>
                    <div>
                        <% if (cedulaParam != null && !cedulaParam.trim().isEmpty()) { %>
                        <a href="${pageContext.request.contextPath}/PanelPacienteServlet?cedula=<%= cedulaParam.trim() %>" class="btn btn-white btn-sm shadow-sm border text-secondary d-flex align-items-center gap-2 px-3 py-2 rounded-3 fw-medium">
                            <i class="bi bi-arrow-left-short fs-5 text-muted"></i> Volver al Panel
                        </a>
                        <% } else { %>
                        <button type="button" onclick="history.back()" class="btn btn-white btn-sm shadow-sm border text-secondary d-flex align-items-center gap-2 px-3 py-2 rounded-3 fw-medium">
                            <i class="bi bi-arrow-left-short fs-5 text-muted"></i> Volver
                        </button>
                        <% } %>
                    </div>
                </div>

                <% if (!tienePaciente) { %>
                <!-- ══════════ BUSCADOR POR CÉDULA ══════════ -->
                <div class="row justify-content-center">
                    <div class="col-lg-5 col-md-8">
                        <div class="text-center mb-4">
                            <div class="mx-auto rounded-circle bg-success bg-opacity-10 d-flex align-items-center justify-content-center mb-3" style="width:72px;height:72px;">
                                <i class="bi bi-search text-success" style="font-size:1.8rem;"></i>
                            </div>
                            <h2 class="h5 fw-bold text-dark mb-1">Buscar Paciente</h2>
                            <p class="text-muted small">Ingresa la cédula para cargar la ficha clínica y registrar la escala.</p>
                        </div>
                        <div class="card border-0 shadow-sm rounded-4">
                            <div class="card-body p-4">
                                <% if (pacienteNoEncontrado) { %>
                                <div class="alert alert-danger d-flex align-items-center gap-2 mb-3" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill"></i>
                                    <span>No se encontró ningún paciente con la cédula <b><%= cedulaParam.trim() %></b>.</span>
                                </div>
                                <% } %>
                                <form action="${pageContext.request.contextPath}/GlasgowServlet" method="GET">
                                    <div class="input-group input-group-lg">
                                        <span class="input-group-text bg-white border-end-0"><i class="bi bi-person-vcard text-muted"></i></span>
                                        <input type="text" name="cedula" class="form-control border-start-0" placeholder="Número de cédula" maxlength="10" pattern="[0-9]{10}" inputmode="numeric" value="<%= cedulaParam != null ? cedulaParam.trim() : "" %>" required autofocus/>
                                    </div>
                                    <button type="submit" class="btn btn-success w-100 mt-3 py-2 fw-semibold">
                                        <i class="bi bi-search me-1"></i> Buscar Paciente
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <% } else { %>

                <!-- BANNER PACIENTE -->
                <div class="rounded-4 mb-4 p-4 text-white d-flex align-items-center gap-3 flex-wrap"
                     style="background:linear-gradient(120deg,#0f5b4c,#159a7a 60%,#1fb88f); shadow-sm">
                    <div class="rounded-circle bg-white bg-opacity-25 d-flex align-items-center justify-content-center fw-bold fs-4 flex-shrink-0" style="width:56px;height:56px;">
                        <%= nombreParam.trim().substring(0,1).toUpperCase() %>
                    </div>
                    <div class="flex-grow-1">
                        <div class="fw-bold fs-5"><%= nombreParam %></div>
                        <div class="text-white-50 small"><i class="bi bi-clipboard2-data me-1"></i>Evaluación de Escala de Glasgow</div>
                    </div>
                    <% if (yaTienePrueba) { %>
                    <div class="text-center px-3 border-start border-white border-opacity-25">
                        <div class="text-white-50" style="font-size:.65rem;text-transform:uppercase;letter-spacing:.5px;">Última</div>
                        <div class="fw-bold fs-5"><%= ultimaPrueba.getPuntajeTotal() %>/15</div>
                        <span class="badge <%= ultimoBadgeClass %> rounded-pill px-2"><%= ultimoNivel %></span>
                    </div>
                    <% } %>
                </div>

                <div class="row g-4">

                    <!-- ══════════ COLUMNA IZQUIERDA: FORMULARIO ══════════ -->
                    <div class="col-lg-7">

                        <!-- ALERTAS -->
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

                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                            <div class="card-body p-4">

                                <form action="${pageContext.request.contextPath}/GlasgowServlet" method="POST" novalidate id="glasgowForm">
                                    <input type="hidden" name="cedula" value="<%= cedulaParam != null ? cedulaParam.trim() : "" %>"/>
                                    <input type="hidden" name="Paciente" value="<%= nombreParam %>"/>

                                    <!-- Score circular + Fecha -->
                                    <div class="d-flex align-items-center gap-4 mb-4 flex-wrap">
                                        <div class="position-relative flex-shrink-0" style="width:110px;height:110px;">
                                            <svg width="110" height="110" viewBox="0 0 110 110">
                                                <circle cx="55" cy="55" r="47" fill="none" stroke="#e9ecef" stroke-width="10"/>
                                                <circle id="scoreRing" cx="55" cy="55" r="47" fill="none" stroke="#adb5bd" stroke-width="10"
                                                        stroke-linecap="round" stroke-dasharray="295.3" stroke-dashoffset="295.3"
                                                        transform="rotate(-90 55 55)" style="transition:stroke-dashoffset .3s, stroke .3s;"/>
                                            </svg>
                                            <div class="position-absolute top-50 start-50 translate-middle text-center">
                                                <div id="scoreNumber" class="fw-bold text-dark" style="font-size:1.6rem;line-height:1;">--</div>
                                                <div class="text-muted" style="font-size:.65rem;">/ 15</div>
                                            </div>
                                        </div>
                                        <div class="flex-grow-1" style="min-width:200px;">
                                            <label class="form-label small fw-semibold text-uppercase text-muted" for="FechaHora">Fecha y Hora *</label>
                                            <input type="datetime-local" id="FechaHora" name="FechaHora" class="form-control form-control-lg" required/>
                                            <div id="nivelTexto" class="small fw-semibold mt-2 text-muted">Complete los 3 componentes para ver el resultado</div>
                                        </div>
                                    </div>

                                    <hr class="text-muted opacity-25"/>

                                    <!-- RESPUESTA OCULAR -->
                                    <div class="mb-4">
                                        <label class="form-label small fw-semibold text-uppercase text-muted d-flex align-items-center gap-2">
                                            <i class="bi bi-eye-fill"></i> Respuesta Ocular
                                        </label>
                                        <div class="btn-group w-100 nl-glasgow-group" role="group">
                                            <input type="radio" class="btn-check nl-glasgow-input" name="Ocular" id="oc4" value="4" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="oc4">4<br><small>Espontánea</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Ocular" id="oc3" value="3" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="oc3">3<br><small>Al hablarle</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Ocular" id="oc2" value="2" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="oc2">2<br><small>Al dolor</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Ocular" id="oc1" value="1" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="oc1">1<br><small>Ninguna</small></label>
                                        </div>
                                    </div>

                                    <!-- RESPUESTA VERBAL -->
                                    <div class="mb-4">
                                        <label class="form-label small fw-semibold text-uppercase text-muted d-flex align-items-center gap-2">
                                            <i class="bi bi-chat-dots-fill"></i> Respuesta Verbal
                                        </label>
                                        <div class="btn-group w-100 nl-glasgow-group" role="group">
                                            <input type="radio" class="btn-check nl-glasgow-input" name="Verbal" id="ve5" value="5" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="ve5">5<br><small>Orientada</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Verbal" id="ve4" value="4" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="ve4">4<br><small>Confusa</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Verbal" id="ve3" value="3" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="ve3">3<br><small>Inapropiada</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Verbal" id="ve2" value="2" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="ve2">2<br><small>Incompren.</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Verbal" id="ve1" value="1" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="ve1">1<br><small>Ninguna</small></label>
                                        </div>
                                    </div>

                                    <!-- RESPUESTA MOTORA -->
                                    <div class="mb-4">
                                        <label class="form-label small fw-semibold text-uppercase text-muted d-flex align-items-center gap-2">
                                            <i class="bi bi-hand-index-thumb-fill"></i> Respuesta Motor
                                        </label>
                                        <div class="btn-group w-100 nl-glasgow-group flex-wrap" role="group">
                                            <input type="radio" class="btn-check nl-glasgow-input" name="Motor" id="mo6" value="6" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="mo6">6<br><small>Obedece</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Motor" id="mo5" value="5" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="mo5">5<br><small>Localiza</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Motor" id="mo4" value="4" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="mo4">4<br><small>Retira</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Motor" id="mo3" value="3" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="mo3">3<br><small>Flexión</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Motor" id="mo2" value="2" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="mo2">2<br><small>Extensión</small></label>

                                            <input type="radio" class="btn-check nl-glasgow-input" name="Motor" id="mo1" value="1" autocomplete="off">
                                            <label class="btn btn-outline-success py-2" for="mo1">1<br><small>Ninguna</small></label>
                                        </div>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label small fw-semibold text-uppercase text-muted" for="Observacion">Observaciones</label>
                                        <textarea id="Observacion" name="Observacion" class="form-control" rows="3" placeholder="Observaciones clínicas adicionales (opcional)"></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2 shadow-sm">
                                        <i class="bi bi-clipboard2-check"></i> Registrar Escala Glasgow
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- ══════════ COLUMNA DERECHA: HISTORIAL (TIMELINE) ══════════ -->
                    <div class="col-lg-5">
                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden" style="position:sticky;top:1rem;">
                            <div class="card-header bg-white p-3 border-bottom d-flex align-items-center gap-2">
                                <i class="bi bi-clock-history text-success fs-5"></i>
                                <div>
                                    <h2 class="h6 fw-bold mb-0 text-dark">Línea de Tiempo</h2>
                                    <p class="text-muted mb-0" style="font-size:.72rem;">
                                        <% if (yaTienePrueba) { %>
                                        <%= historialGlasgow.size() %> evaluación<%= historialGlasgow.size() != 1 ? "es" : "" %> registrada<%= historialGlasgow.size() != 1 ? "s" : "" %>
                                        <% } else { %>
                                        Sin evaluaciones previas
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                            <div class="card-body p-4" style="max-height:720px;overflow-y:auto;">
                                <% if (!yaTienePrueba) { %>
                                <div class="text-center text-muted py-5">
                                    <i class="bi bi-inbox fs-1 d-block mb-2 opacity-50"></i>
                                    <span class="small">Este paciente no tiene evaluaciones de Glasgow registradas todavía.</span>
                                </div>
                                <% } else { %>
                                <div class="nl-timeline">
                                    <% for (EscalaGlasgow registro : historialGlasgow) {
                                        String nivelReg = registro.getNivelSeveridad();
                                        if (nivelReg == null && registro.getPuntajeTotal() != null) {
                                            int t = registro.getPuntajeTotal();
                                            nivelReg = t >= 13 ? "Leve" : t >= 9 ? "Moderado" : "Grave";
                                        }
                                        String dotColor = "#6c757d";
                                        String badgeReg = "bg-secondary";
                                        if ("Leve".equals(nivelReg)) { dotColor = "#198754"; badgeReg = "bg-success"; }
                                        else if ("Moderado".equals(nivelReg)) { dotColor = "#ffc107"; badgeReg = "bg-warning text-dark"; }
                                        else if ("Grave".equals(nivelReg)) { dotColor = "#dc3545"; badgeReg = "bg-danger"; }
                                    %>
                                    <div class="nl-timeline-item">
                                        <span class="nl-timeline-dot" style="background:<%= dotColor %>;"></span>
                                        <div class="nl-timeline-content">
                                            <div class="d-flex justify-content-between align-items-start gap-2 mb-1">
                                                <span class="small fw-semibold text-dark">
                                                  <%= registro.getFechaHora() != null ? registro.getFechaHora().toString().replace("T", " ") : "-" %>
                                                </span>
                                                <span class="badge <%= badgeReg %> rounded-pill px-2 py-1"><%= nivelReg %></span>
                                            </div>
                                            <div class="d-flex align-items-center justify-content-between">
                                                <div class="small text-muted">
                                                    O:<b class="text-dark"><%= registro.getRespuestaOcular() %></b>
                                                    &nbsp;V:<b class="text-dark"><%= registro.getRespuestaVerbal() %></b>
                                                    &nbsp;M:<b class="text-dark"><%= registro.getRespuestaMotora() %></b>
                                                </div>
                                                <div class="fw-bold text-dark"><%= registro.getPuntajeTotal() %><span class="text-muted fw-normal">/15</span></div>
                                            </div>
                                            <% if (registro.getObservacion() != null && !registro.getObservacion().trim().isEmpty()) { %>
                                            <div class="small text-muted fst-italic mt-1" style="font-size:.75rem;">
                                                <i class="bi bi-chat-left-quote me-1"></i><%= registro.getObservacion() %>
                                            </div>
                                            <% } %>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>

                </div>
                <% } %>
            </main>
        </div>

    </div>
</div>

<style>
    .nl-glasgow-group label { font-size:.78rem; line-height:1.3; }
    .nl-glasgow-group label small { font-weight:400; opacity:.75; font-size:.68rem; }
    .nl-timeline { position:relative; padding-left:26px; }
    .nl-timeline::before {
        content:''; position:absolute; left:6px; top:6px; bottom:6px; width:2px; background:#e9ecef;
    }
    .nl-timeline-item { position:relative; margin-bottom:1.25rem; }
    .nl-timeline-item:last-child { margin-bottom:0; }
    .nl-timeline-dot {
        position:absolute; left:-26px; top:4px; width:14px; height:14px; border-radius:50%;
        border:3px solid #fff; box-shadow:0 0 0 2px #e9ecef;
    }
    .nl-timeline-content {
        background:#f8f9fa; border-radius:.75rem; padding:.85rem 1rem;
    }
    .btn-white {
        background-color: #fff;
        color: #6c757d;
        border-color: #dee2e6;
    }
    .btn-white:hover {
        background-color: #f8f9fa;
        color: #495057;
        border-color: #cde2e6;
    }
</style>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
    (function () {
        var inputs = document.querySelectorAll('.nl-glasgow-input');
        var ring = document.getElementById('scoreRing');
        var scoreNumber = document.getElementById('scoreNumber');
        var nivelTexto = document.getElementById('nivelTexto');
        var CIRCUNFERENCIA = 295.3; // 2 * PI * 47

        // Preseleccionar fecha y hora actual local por defecto si está vacío
        var dtInput = document.getElementById('FechaHora');
        if (dtInput && !dtInput.value) {
            var ahora = new Date();
            var offset = ahora.getTimezoneOffset() * 60000;
            var localISOTime = (new Date(ahora - offset)).toISOString().slice(0, 16);
            dtInput.value = localISOTime;
        }

        function actualizar() {
            var ocular = document.querySelector('input[name="Ocular"]:checked');
            var verbal = document.querySelector('input[name="Verbal"]:checked');
            var motor  = document.querySelector('input[name="Motor"]:checked');

            if (ocular && verbal && motor) {
                var total = parseInt(ocular.value, 10) + parseInt(verbal.value, 10) + parseInt(motor.value, 10);
                var nivel = total >= 13 ? 'Leve' : total >= 9 ? 'Moderado' : 'Grave';
                var color = nivel === 'Leve' ? '#198754' : nivel === 'Moderado' ? '#ffc107' : '#dc3545';

                scoreNumber.textContent = total;
                nivelTexto.textContent = 'Puntaje total: ' + total + '/15 — ' + nivel;
                nivelTexto.style.color = color;

                var offset = CIRCUNFERENCIA - (total / 15) * CIRCUNFERENCIA;
                ring.style.strokeDashoffset = offset;
                ring.style.stroke = color;
            } else {
                scoreNumber.textContent = '--';
                nivelTexto.textContent = 'Complete los 3 componentes para ver el resultado';
                nivelTexto.style.color = '';
                ring.style.strokeDashoffset = CIRCUNFERENCIA;
                ring.style.stroke = '#adb5bd';
            }
        }

        inputs.forEach(function (el) { el.addEventListener('change', actualizar); });
        actualizar();
    })();
</script>
</body>
</html>