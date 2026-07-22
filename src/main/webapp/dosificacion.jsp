<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false" %>
<%
  // Recuperar las variables exactamente como están configuradas en la sesión de tu aplicación
  String nombreSesion = (session.getAttribute("nombreSesion") != null) ? session.getAttribute("nombreSesion").toString() : "María Fernanda Lopez";
  String tituloRol = (session.getAttribute("tituloRol") != null) ? session.getAttribute("tituloRol").toString() : "Enfermero/a";

  Boolean esAdminObj = (Boolean) session.getAttribute("esAdmin");
  boolean esAdmin = (esAdminObj != null) ? esAdminObj : false;

  // Lógica del Módulo de Dosificación
  String tabActiva = (String) request.getAttribute("tabActiva");
  if (tabActiva == null) tabActiva = "REGULAR_DOSIS";

  String error = (String) request.getAttribute("error");

  // Recuperar valores del Request
  String dosisIndicadaVal = (request.getAttribute("dosisIndicada") != null) ? request.getAttribute("dosisIndicada").toString() : "";
  String presentacionVal = (request.getAttribute("presentacion") != null) ? request.getAttribute("presentacion").toString() : "";
  String diluyenteMlVal = (request.getAttribute("diluyenteMl") != null) ? request.getAttribute("diluyenteMl").toString() : "";

  String unidadDosis = (String) request.getAttribute("unidadDosis");
  if (unidadDosis == null) unidadDosis = "mg";

  String unidadPresentacion = (String) request.getAttribute("unidadPresentacion");
  if (unidadPresentacion == null) unidadPresentacion = "mg";

  String resultadoVolumen = (String) request.getAttribute("resultadoVolumen");

  // Módulo de infusión
  String volumenTotalMlVal = (request.getAttribute("volumenTotalMl") != null) ? request.getAttribute("volumenTotalMl").toString() : "";
  String horasTotalesVal = (request.getAttribute("horasTotales") != null) ? request.getAttribute("horasTotales").toString() : "";

  String gotasPorMinuto = (String) request.getAttribute("gotasPorMinuto");
  String microgotasPorMinuto = (String) request.getAttribute("microgotasPorMinuto");
  String mlPorHora = (String) request.getAttribute("mlPorHora");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Dosificación</title>
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
          <a href="${pageContext.request.contextPath}/GlasgowServlet" id="nav-glasgow-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-file-earmark-bar-graph"></i>Escala Glasgow
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/DosificacionServlet" id="nav-dosificacion-m" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
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

  <!-- Contenedor Principal de la Aplicación -->
  <div class="container-fluid p-0">
    <div class="row g-0" style="min-height:100vh;">

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
            <a href="${pageContext.request.contextPath}/GlasgowServlet" id="nav-glasgow" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-file-earmark-bar-graph"></i><span>Escala Glasgow</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/DosificacionServlet" id="nav-dosificacion" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
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
      <!-- 3. ÁREA DE CONTENIDO Y TOPBARS                                         -->
      <!-- ======================================================================= -->
      <div class="col min-vh-100 d-flex flex-column">

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
          <span class="navbar-brand fw-semibold mb-0 d-flex align-items-center gap-2">
            <i class="bi bi-calculator-fill"></i>
            Módulo de Dosificación & Infusiones &middot; <%= tituloRol %>
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

        <!-- MAIN CONTENT -->
        <main class="p-4 flex-grow-1">
          <% if (error != null) { %>
            <div class="row justify-content-center mb-3">
              <div class="col-md-6"><div class="alert alert-danger border-0 rounded-3 shadow-sm"><%= error %></div></div>
            </div>
          <% } %>

          <!-- PESTAÑAS CENTRADAS -->
          <div class="row justify-content-center mb-4">
            <div class="col-md-6">
              <ul class="nav nav-tabs justify-content-center" id="dosificacionTabs" role="tablist">
                <li class="nav-item">
                  <button class="nav-link <%= "REGULAR_DOSIS".equals(tabActiva) ? "active fw-bold text-success" : "text-secondary" %>" id="dosis-tab" data-bs-toggle="tab" data-bs-target="#dosisPanel" type="button">
                    <i class="bi bi-capsule"></i> Cálculo de Dosis
                  </button>
                </li>
                <li class="nav-item">
                  <button class="nav-link <%= "INFUSION_GOTEO".equals(tabActiva) ? "active fw-bold text-success" : "text-secondary" %>" id="infusion-tab" data-bs-toggle="tab" data-bs-target="#infusionPanel" type="button">
                    <i class="bi bi-droplet-half"></i> Cálculo de Infusión
                  </button>
                </li>
              </ul>
            </div>
          </div>

          <div class="tab-content" id="dosificacionTabsContent">

            <!-- PANEL 1: REGLA DE TRES -->
            <div class="tab-pane fade <%= "REGULAR_DOSIS".equals(tabActiva) ? "show active" : "" %>" id="dosisPanel">
              <div class="row justify-content-center">
                <div class="col-md-6">
                  <div class="card border-0 shadow-sm rounded-3 p-4">
                    <form action="${pageContext.request.contextPath}/DosificacionServlet" method="POST">
                      <input type="hidden" name="tipoCalculo" value="REGULAR_DOSIS">

                      <div class="mb-3">
                        <label class="form-label small fw-bold">Dosis Indicada / Solicitada *</label>
                        <div class="input-group">
                          <input type="number" step="0.001" name="dosisIndicada" class="form-control" required value="<%= dosisIndicadaVal %>">
                          <select name="unidadDosis" class="form-select text-center" style="max-width: 90px;">
                            <option value="mg" <%= "mg".equals(unidadDosis) ? "selected" : "" %>>mg</option>
                            <option value="g" <%= "g".equals(unidadDosis) ? "selected" : "" %>>g</option>
                            <option value="mcg" <%= "mcg".equals(unidadDosis) ? "selected" : "" %>>mcg</option>
                          </select>
                        </div>
                      </div>

                      <div class="mb-3">
                        <label class="form-label small fw-bold">Presentación del Fármaco *</label>
                        <div class="input-group">
                          <input type="number" step="0.001" name="presentacion" class="form-control" required value="<%= presentacionVal %>">
                          <select name="unidadPresentacion" class="form-select text-center" style="max-width: 90px;">
                            <option value="mg" <%= "mg".equals(unidadPresentacion) ? "selected" : "" %>>mg</option>
                            <option value="g" <%= "g".equals(unidadPresentacion) ? "selected" : "" %>>g</option>
                            <option value="mcg" <%= "mcg".equals(unidadPresentacion) ? "selected" : "" %>>mcg</option>
                          </select>
                        </div>
                      </div>

                      <div class="mb-3">
                        <label class="form-label small fw-bold">Diluyente / Volumen Total (ml) *</label>
                        <input type="number" step="0.01" name="diluyenteMl" class="form-control" required value="<%= diluyenteMlVal %>">
                      </div>

                      <button type="submit" class="btn btn-success w-100 py-2 fw-semibold mt-2">
                        <i class="bi bi-lightning-fill"></i> Calcular Volumen a Administrar
                      </button>
                    </form>

                    <!-- RESPUESTA -->
                    <% if (resultadoVolumen != null) { %>
                      <div class="mt-4 bg-success bg-opacity-10 p-4 rounded-3 text-center border border-success border-opacity-20 shadow-sm">
                        <span class="text-success small d-block mb-1 text-uppercase fw-bold">Volumen Resultante</span>
                        <h2 class="display-6 fw-bold text-success mb-0"><%= resultadoVolumen %> <small class="fs-4">ml</small></h2>
                      </div>
                    <% } %>

                  </div>
                </div>
              </div>
            </div>

            <!-- PANEL 2: INFUSIÓN Y GOTEO -->
            <div class="tab-pane fade <%= "INFUSION_GOTEO".equals(tabActiva) ? "show active" : "" %>" id="infusionPanel">
              <div class="row justify-content-center">
                <div class="col-md-6">
                  <div class="card border-0 shadow-sm rounded-3 p-4">
                    <form action="${pageContext.request.contextPath}/DosificacionServlet" method="POST">
                      <input type="hidden" name="tipoCalculo" value="INFUSION_GOTEO">

                      <div class="mb-3">
                        <label class="form-label small fw-bold">Volumen Total (ml) *</label>
                        <input type="number" step="0.01" name="volumenTotalMl" class="form-control" required value="<%= volumenTotalMlVal %>">
                      </div>

                      <div class="mb-3">
                        <label class="form-label small fw-bold">Tiempo de Infusión (Horas) *</label>
                        <input type="number" step="0.01" name="horasTotales" class="form-control" required value="<%= horasTotalesVal %>">
                      </div>

                      <button type="submit" class="btn btn-success w-100 py-2 fw-semibold mt-2">
                        <i class="bi bi-speedometer2"></i> Calcular Flujo e Infusión
                      </button>
                    </form>

                    <!-- RESPUESTA DEL GOTEO -->
                    <% if (gotasPorMinuto != null) { %>
                      <div class="mt-4 p-3 bg-light rounded-3 border shadow-sm">
                        <div class="row g-2 mb-2">
                          <div class="col-6">
                            <div class="bg-white p-3 rounded text-center border">
                              <span class="text-muted d-block small fw-bold">Macrogotas</span>
                              <h4 class="fw-bold text-primary mb-0"><%= gotasPorMinuto %> <small class="fs-6">gtt/min</small></h4>
                            </div>
                          </div>
                          <div class="col-6">
                            <div class="bg-white p-3 rounded text-center border">
                              <span class="text-muted d-block small fw-bold">Microgotas</span>
                              <h4 class="fw-bold text-success mb-0"><%= microgotasPorMinuto %> <small class="fs-6">ugtt/min</small></h4>
                            </div>
                          </div>
                        </div>
                        <div class="bg-dark text-white p-3 rounded text-center">
                          <span class="text-white-50 d-block small fw-bold">Bomba de Infusión</span>
                          <h3 class="fw-bold text-warning mb-0"><%= mlPorHora %> <small class="fs-5">ml/hr</small></h3>
                        </div>
                      </div>
                    <% } %>

                  </div>
                </div>
              </div>
            </div>

          </div>
        </main>
      </div>

    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>