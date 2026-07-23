<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  /* ── Variables de sesión homologadas ── */
  String rolSesion    = (session != null) ? (String) session.getAttribute("rol")           : "";
  String usuarioSesion= (session != null) ? (String) session.getAttribute("usuario")        : "usuario";
  String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : usuarioSesion;
  if (nombreSesion == null) nombreSesion = usuarioSesion;
  boolean esAdmin  = "ADMINISTRADOR".equals(rolSesion);
  String tituloRol = esAdmin ? "Administrador" : "Enfermero/a";

  String errorMsg = (String) request.getAttribute("errorMsg");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <meta name="description" content="NURSELOGIC - Registro de Nuevo Paciente"/>
  <title>NURSELOGIC | Registro de Nuevo Paciente</title>

  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>

<body class="bg-light" style="font-family:'Inter',sans-serif;">

  <!-- OFFCANVAS SIDEBAR – móvil -->
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
          <a href="${pageContext.request.contextPath}/PacientesServlet" id="nav-pacientes-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
            <i class="bi bi-person-badge"></i>Gestionar Pacientes
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
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
    <div class="row g-0" style="min-height:100vh;">

      <!-- SIDEBAR DESKTOP -->
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

        <!-- TOPBAR DESKTOP -->
        <header id="nl-topbar" class="navbar navbar-dark bg-brand-gradient d-none d-lg-flex shadow-sm px-4" style="min-height:62px;">
          <span class="navbar-brand fw-semibold mb-0 d-flex align-items-center gap-2">
            <i class="bi bi-person-vcard-fill"></i>
            Gestión de Pacientes &middot; <%= tituloRol %>
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

        <!-- ZONA CENTRAL DE TRABAJO -->
        <main class="p-4">
          <!-- Migas de Pan -->
          <div class="small text-muted mb-3 d-flex align-items-center gap-1">
            <span>/ Pacientes</span><span>/</span><span class="text-dark fw-medium">Registrar Nuevo Paciente</span>
          </div>

          <div class="mb-4">
            <h1 class="h4 fw-bold d-flex align-items-center gap-2 mb-1 text-dark">
              <i class="bi bi-person-plus-fill text-success"></i> Registro de Nuevo Paciente
            </h1>
            <p class="text-muted small mb-0">Complete la información básica para la apertura de la ficha clínica</p>
          </div>

          <% if (errorMsg != null) { %>
            <div class="alert alert-danger border-0 rounded-3 py-2 px-4 mb-4" role="alert">
              <i class="bi bi-exclamation-circle-fill me-2"></i><%= errorMsg %>
            </div>
          <% } %>

          <!-- TARJETA DEL FORMULARIO DE REGISTRO -->
          <div class="card border-0 shadow-sm rounded-4">
            <div class="card-header bg-white py-3 border-bottom">
              <h5 class="card-title fw-bold text-dark mb-0 fs-6">
                <i class="bi bi-card-heading text-success me-2"></i>Datos Demográficos del Paciente
              </h5>
            </div>
            <div class="card-body p-4">

              <form action="${pageContext.request.contextPath}/RegistroPacienteServlet" method="POST">

                <div class="row g-3 mb-4">
                  <div class="col-md-6">
                    <label class="form-label fw-semibold text-dark">Cédula de Identidad *</label>
                    <input type="text" name="Cedula" class="form-control form-control-lg" placeholder="Ej. 1723456789" maxlength="10" value="${paramCedula}" required pattern="\d{10}"/>
                    <div class="form-text">Debe contener exactamente 10 dígitos numéricos.</div>
                  </div>

                  <div class="col-md-6">
                    <label class="form-label fw-semibold text-dark">Sexo *</label>
                    <select name="Sexo" class="form-select form-select-lg" required>
                      <option value="">-- Seleccione --</option>
                      <option value="M" ${paramSexo == 'M' ? 'selected' : ''}>Masculino (M)</option>
                      <option value="F" ${paramSexo == 'F' ? 'selected' : ''}>Femenino (F)</option>
                    </select>
                  </div>

                  <div class="col-md-5">
                    <label class="form-label fw-semibold text-dark">Nombres *</label>
                    <input type="text" name="Nombres" class="form-control" placeholder="Nombres completos" value="${paramNombres}" required/>
                  </div>

                  <div class="col-md-5">
                    <label class="form-label fw-semibold text-dark">Apellidos *</label>
                    <input type="text" name="Apellidos" class="form-control" placeholder="Apellidos completos" value="${paramApellidos}" required/>
                  </div>

                  <div class="col-md-2">
                    <label class="form-label fw-semibold text-dark">Edad *</label>
                    <input type="number" name="Edad" class="form-control" placeholder="Ej. 35" min="0" max="120" value="${paramEdad}" required/>
                  </div>
                </div>

                <!-- BOTONES DE ACCIÓN -->
                <div class="d-flex justify-content-end gap-3 border-top pt-4">
                  <a href="${pageContext.request.contextPath}/PacientesServlet" class="btn btn-outline-secondary px-4 py-2 fw-semibold rounded-3">
                    <i class="bi bi-x-circle me-1"></i> Cancelar
                  </a>
                  <button type="submit" class="btn btn-success px-5 py-2 fw-semibold rounded-3 shadow">
                    <i class="bi bi-floppy-fill me-2"></i> GUARDAR Y IR AL PANEL
                  </button>
                </div>

              </form>

            </div>
          </div>

        </main>
      </div>

    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>