<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  /* ── Variables de sesión ── */
  String rolSesion    = (session != null) ? (String) session.getAttribute("rol")           : "";
  String usuarioSesion= (session != null) ? (String) session.getAttribute("usuario")        : "usuario";
  String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : usuarioSesion;
  if (nombreSesion == null) nombreSesion = usuarioSesion;
  boolean esAdmin  = "ADMINISTRADOR".equals(rolSesion);
  String tituloRol = esAdmin ? "Administrador" : "Enfermero/a";

  /* ── Conteo dinámico desde base de datos MySQL ── */
  int totalPacientes = 0;
  int totalUsuarios = 0;
  try {
      com.rrparedes.dao.PacienteDAO pDAO = new com.rrparedes.dao.PacienteDAO();
      totalPacientes = pDAO.listarTodos().size();
  } catch (Exception e) {
      totalPacientes = 0;
  }

  try {
      com.rrparedes.dao.UsuarioDAO uDAO = new com.rrparedes.dao.UsuarioDAO();
      totalUsuarios = uDAO.listarTodos().size();
  } catch (Exception e) {
      totalUsuarios = 0;
  }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <meta name="description" content="NURSELOGIC - Panel de Control Principal"/>
  <title>NURSELOGIC | Dashboard <%= esAdmin ? "– Administrador" : "– Enfermero" %></title>

  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>

<body class="bg-light" style="font-family:'Inter',sans-serif;">

  <!-- OFFCANVAS SIDEBAR – móvil -->
  <div class="offcanvas offcanvas-start nl-sidebar text-white" id="sidebarMobile" style="width:240px;" tabindex="-1">
    <div class="offcanvas-header border-bottom border-white border-opacity-10 py-3">
      <span class="fw-bold text-white">NURSELOGIC</span>
      <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
    </div>
    <div class="offcanvas-body d-flex flex-column p-0">
      <div class="px-3 pt-3 pb-2">
        <span class="badge w-100 py-2 <%= esAdmin ? "bg-info bg-opacity-25 text-info" : "bg-success bg-opacity-25 text-success" %>" style="font-size:.7rem;">
          <i class="bi bi-<%= esAdmin ? "shield-fill" : "person-fill-check" %> me-1"></i><%= tituloRol %>
        </span>
      </div>
      <div class="px-4 py-1">
        <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">Menu Principal</small>
      </div>
      <ul class="nav flex-column px-2 flex-grow-1 mt-1">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
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
            <i class="bi bi-person-vcard-fill"></i>Gestionar Pacientes
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-activity"></i>Signos Vitales
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/GlasgowServlet" id="nav-glasgow-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-clipboard2-data-fill"></i>Escala Glasgow
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/DosificacionServlet" id="nav-dosificacion-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-droplet-fill"></i>Calcular Dosis
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/AdministracionServlet" id="nav-admin-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-clipboard2-check-fill"></i>Administracion
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/ReportesServlet" id="nav-reportes-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-graph-up-arrow"></i>Reportes
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/calculadora.jsp" id="nav-imc-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-calculator-fill"></i>Calculadora IMC
          </a>
        </li>
        <% } %>
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
        <a href="${pageContext.request.contextPath}/CambioContrasenaServlet" id="nav-cambiopass-m" class="nav-link nl-nav-link d-flex align-items-center gap-2 py-2 px-3 small">
          <i class="bi bi-key"></i>Cambiar contraseña
        </a>
        <a href="${pageContext.request.contextPath}/LogoutServlet" id="nav-logout-m" class="nav-link nl-nav-link d-flex align-items-center gap-2 py-2 px-3 small">
          <i class="bi bi-box-arrow-right"></i>Cerrar sesión
        </a>
      </div>
    </div>
  </div>


  <div class="container-fluid p-0">
    <div class="row g-0" style="min-height:100vh;">

      <!-- SIDEBAR DESKTOP -->
      <nav class="col-auto d-none d-lg-flex flex-column nl-sidebar text-white p-0" id="nl-sidebar" style="width:240px;min-height:100vh;position:sticky;top:0;height:100vh;overflow-y:auto;">
        <a href="${pageContext.request.contextPath}/index.jsp" class="d-flex align-items-center gap-3 p-4 text-white text-decoration-none border-bottom border-white border-opacity-10">
          <div class="rounded-3 bg-success p-2 flex-shrink-0">
            <i class="bi bi-heart-pulse-fill text-white fs-5"></i>
          </div>
          <div>
            <div class="fw-bold small text-white" style="letter-spacing:1px;">NURSELOGIC</div>
            <div style="font-size:.62rem;" class="text-white-50">Gestion Clinica · Ecuador</div>
          </div>
        </a>

        <div class="px-3 pt-3 pb-2">
          <span class="badge w-100 py-2 <%= esAdmin ? "bg-info bg-opacity-25 text-info" : "bg-success bg-opacity-25 text-success" %>" style="font-size:.7rem;">
            <i class="bi bi-<%= esAdmin ? "shield-fill" : "person-fill-check" %> me-1"></i><%= tituloRol %>
          </span>
        </div>

        <div class="px-4 py-1">
          <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">Menu Principal</small>
        </div>

        <ul class="nav flex-column px-2 flex-grow-1 mt-1">
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
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
              <i class="bi bi-person-vcard-fill"></i><span>Gestionar Pacientes</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-activity"></i><span>Signos Vitales</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/GlasgowServlet" id="nav-glasgow" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-clipboard2-data-fill"></i><span>Escala Glasgow</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/DosificacionServlet" id="nav-dosificacion" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-droplet-fill"></i><span>Calcular Dosis</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/AdministracionServlet" id="nav-admin" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-clipboard2-check-fill"></i><span>Administracion</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/ReportesServlet" id="nav-reportes" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-graph-up-arrow"></i><span>Reportes</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/calculadora.jsp" id="nav-imc" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-calculator-fill"></i><span>Calculadora IMC</span>
            </a>
          </li>
          <% } %>
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
          <a href="${pageContext.request.contextPath}/CambioContrasenaServlet" id="nav-cambiopass" class="nav-link nl-nav-link d-flex align-items-center gap-2 py-2 px-3 small">
            <i class="bi bi-key"></i>Cambiar contraseña
          </a>
          <a href="${pageContext.request.contextPath}/LogoutServlet" id="nav-logout" class="nav-link nl-nav-link d-flex align-items-center gap-2 py-2 px-3 small">
            <i class="bi bi-box-arrow-right"></i>Cerrar sesión
          </a>
        </div>
      </nav>

      <!-- CONTENIDO PRINCIPAL -->
      <div class="col">
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
            <i class="bi bi-grid-1x2-fill"></i>
            Dashboard &middot; <%= esAdmin ? "Panel de Administración" : "Panel de Enfermería" %>
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
          <%
            String errParam = request.getParameter("error");
            String infoMsg  = (String) request.getAttribute("infoMsg");
            if (errParam != null && !errParam.isEmpty()) {
          %>
          <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small" role="alert">
            <i class="bi bi-exclamation-circle-fill flex-shrink-0"></i><%= errParam %>
          </div>
          <% } %>
          <% if (infoMsg != null && !infoMsg.isEmpty()) { %>
          <div class="alert alert-warning d-flex align-items-center gap-2 py-2 small" role="alert">
            <i class="bi bi-info-circle-fill flex-shrink-0"></i><%= infoMsg %>
          </div>
          <% } %>

          <% if (esAdmin) { %>
          <!-- DASHBOARD ADMINISTRADOR -->
          <div class="card border-0 text-white bg-brand-gradient shadow rounded-4 mb-4">
            <div class="card-body d-flex align-items-center gap-3 py-4 px-4">
              <i class="bi bi-shield-check flex-shrink-0" style="font-size:2.2rem;color:rgba(255,255,255,.8);"></i>
              <div>
                <h2 class="fs-5 fw-bold mb-1 text-white">Panel de Administración · NURSELOGIC</h2>
                <p class="small mb-0" style="color:rgba(255,255,255,.72);">
                  Bienvenido, <strong><%= nombreSesion %></strong>. Desde aquí gestiona usuarios del sistema y el catálogo de medicamentos.
                </p>
              </div>
            </div>
          </div>

          <div class="mb-4">
            <h1 class="h4 fw-bold d-flex align-items-center gap-2">
              <i class="bi bi-speedometer2 text-success"></i>Resumen del Sistema
            </h1>
            <p class="text-muted small mt-1">Estado general de NURSELOGIC</p>
          </div>

          <div class="row row-cols-2 row-cols-lg-4 g-3 mb-4">
            <div class="col">
              <div class="card border-0 shadow-sm h-100 rounded-3 border-start border-4 border-primary">
                <div class="card-body d-flex align-items-center gap-3 p-3">
                  <div class="rounded-3 d-flex align-items-center justify-content-center icon-blue flex-shrink-0" style="width:52px;height:52px;">
                    <i class="bi bi-people-fill fs-4"></i>
                  </div>
                  <div>
                    <div class="fw-bold lh-1" style="font-size:1.9rem;"><%= totalUsuarios %></div>
                    <div class="text-muted small mt-1">Usuarios Registrados</div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card border-0 shadow-sm h-100 rounded-3 border-start border-4 border-warning">
                <div class="card-body d-flex align-items-center gap-3 p-3">
                  <div class="rounded-3 d-flex align-items-center justify-content-center icon-amber flex-shrink-0" style="width:52px;height:52px;">
                    <i class="bi bi-person-exclamation fs-4"></i>
                  </div>
                  <div>
                    <div class="fw-bold lh-1" style="font-size:1.9rem;">1</div>
                    <div class="text-muted small mt-1">Pendientes de Rol</div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card border-0 shadow-sm h-100 rounded-3 border-start border-4 border-success">
                <div class="card-body d-flex align-items-center gap-3 p-3">
                  <div class="rounded-3 d-flex align-items-center justify-content-center icon-teal flex-shrink-0" style="width:52px;height:52px;">
                    <i class="bi bi-journal-medical fs-4"></i>
                  </div>
                  <div>
                    <div class="fw-bold lh-1" style="font-size:1.9rem;">12</div>
                    <div class="text-muted small mt-1">Medicamentos en Catálogo</div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card border-0 shadow-sm h-100 rounded-3 border-start border-4" style="border-color:#68d391!important;">
                <div class="card-body d-flex align-items-center gap-3 p-3">
                  <div class="rounded-3 d-flex align-items-center justify-content-center icon-green flex-shrink-0" style="width:52px;height:52px;">
                    <i class="bi bi-shield-check fs-4"></i>
                  </div>
                  <div>
                    <div class="fw-bold lh-1" style="font-size:1.9rem;"><%= totalUsuarios %></div>
                    <div class="text-muted small mt-1">Cuentas Activas</div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <% } else { %>
          <!-- DASHBOARD ENFERMERO -->
          <div class="card border-0 text-white bg-brand-gradient shadow rounded-4 mb-4">
            <div class="card-body d-flex align-items-center gap-3 py-4 px-4">
              <i class="bi bi-heart-pulse flex-shrink-0" style="font-size:2.2rem;color:rgba(255,255,255,.8);"></i>
              <div>
                <h2 class="fs-5 fw-bold mb-1 text-white">Panel de Enfermería · NURSELOGIC</h2>
                <p class="small mb-0" style="color:rgba(255,255,255,.72);">
                  Bienvenido/a, <strong><%= nombreSesion %></strong>. Registre pacientes y gestione sus signos vitales.
                </p>
              </div>
            </div>
          </div>

          <div class="mb-4">
            <h1 class="h4 fw-bold d-flex align-items-center gap-2">
              <i class="bi bi-speedometer2 text-success"></i>Resumen de Actividad
            </h1>
            <p class="text-muted small mt-1">Estado actual del servicio de enfermería</p>
          </div>

          <div class="row row-cols-2 row-cols-lg-4 g-3 mb-4">
            <div class="col">
              <div class="card border-0 shadow-sm h-100 rounded-3 border-start border-4 border-success">
                <div class="card-body d-flex align-items-center gap-3 p-3">
                  <div class="rounded-3 d-flex align-items-center justify-content-center icon-teal flex-shrink-0" style="width:52px;height:52px;">
                    <i class="bi bi-person-vcard-fill fs-4"></i>
                  </div>
                  <div>
                    <div class="fw-bold lh-1" style="font-size:1.9rem;"><%= totalPacientes %></div>
                    <div class="text-muted small mt-1">Pacientes Registrados</div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card border-0 shadow-sm h-100 rounded-3 border-start border-4 border-primary">
                <div class="card-body d-flex align-items-center gap-3 p-3">
                  <div class="rounded-3 d-flex align-items-center justify-content-center icon-blue flex-shrink-0" style="width:52px;height:52px;">
                    <i class="bi bi-activity fs-4"></i>
                  </div>
                  <div>
                    <div class="fw-bold lh-1" style="font-size:1.9rem;">0</div>
                    <div class="text-muted small mt-1">Signos Vitales Hoy</div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card border-0 shadow-sm h-100 rounded-3 border-start border-4 border-danger">
                <div class="card-body d-flex align-items-center gap-3 p-3">
                  <div class="rounded-3 d-flex align-items-center justify-content-center icon-red flex-shrink-0" style="width:52px;height:52px;">
                    <i class="bi bi-exclamation-triangle-fill fs-4"></i>
                  </div>
                  <div>
                    <div class="fw-bold lh-1" style="font-size:1.9rem;">0</div>
                    <div class="text-muted small mt-1">Alertas Activas</div>
                  </div>
                </div>
              </div>
            </div>
            <div class="col">
              <div class="card border-0 shadow-sm h-100 rounded-3 border-start border-4" style="border-color:#68d391!important;">
                <div class="card-body d-flex align-items-center gap-3 p-3">
                  <div class="rounded-3 d-flex align-items-center justify-content-center icon-green flex-shrink-0" style="width:52px;height:52px;">
                    <i class="bi bi-clipboard2-check-fill fs-4"></i>
                  </div>
                  <div>
                    <div class="fw-bold lh-1" style="font-size:1.9rem;">0</div>
                    <div class="text-muted small mt-1">Administraciones Hoy</div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <p class="small fw-bold text-uppercase text-muted mb-3 d-flex align-items-center gap-1">
            <i class="bi bi-lightning-fill"></i>Módulos de Enfermería
          </p>
          <div class="row row-cols-2 row-cols-lg-4 g-3">
            <div class="col">
              <a href="${pageContext.request.contextPath}/PacientesServlet" id="card-pacientes" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-person-vcard-fill text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Gestionar Pacientes</div>
                <div class="text-muted" style="font-size:.78rem;">Ficha clínica digital con antecedentes y alergias</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Ir al módulo</div>
              </a>
            </div>
            <div class="col">
              <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="card-signos" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-activity text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Signos Vitales</div>
                <div class="text-muted" style="font-size:.78rem;">Registro con alertas cromáticas ROJO/AZUL automáticas</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Ir al módulo</div>
              </a>
            </div>
            <div class="col">
              <a href="${pageContext.request.contextPath}/GlasgowServlet" id="card-glasgow" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-clipboard2-data-fill text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Escala Glasgow</div>
                <div class="text-muted" style="font-size:.78rem;">Evaluación de conciencia: Ocular + Verbal + Motor</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Ir al módulo</div>
              </a>
            </div>
            <div class="col">
              <a href="${pageContext.request.contextPath}/DosificacionServlet" id="card-dosis" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-droplet-fill text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Calcular Dosis</div>
                <div class="text-muted" style="font-size:.78rem;">Regla de tres con conversión g/mg/mcg y L/mL</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Ir al módulo</div>
              </a>
            </div>
            <div class="col">
              <a href="${pageContext.request.contextPath}/AdministracionServlet" id="card-admin" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-clipboard2-check-fill text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Administracion</div>
                <div class="text-muted" style="font-size:.78rem;">Registro de administración de medicamentos y trazabilidad</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Ir al módulo</div>
              </a>
            </div>
            <div class="col">
              <a href="${pageContext.request.contextPath}/ReportesServlet" id="card-reportes" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-graph-up-arrow text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Reportes</div>
                <div class="text-muted" style="font-size:.78rem;">Tendencias de signos vitales con filtro por turno</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Ir al módulo</div>
              </a>
            </div>
            <div class="col">
              <a href="${pageContext.request.contextPath}/calculadora.jsp" id="card-imc" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-calculator-fill text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Calculadora IMC</div>
                <div class="text-muted" style="font-size:.78rem;">IMC = peso(kg) / estatura(m)² con clasificación cromática</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Calcular</div>
              </a>
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
