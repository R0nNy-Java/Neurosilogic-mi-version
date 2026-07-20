<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rrparedes.dao.PacienteDAO, com.rrparedes.model.Paciente" %>
<%
  String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
  if (nombreSesion == null) nombreSesion = (session != null) ? (String) session.getAttribute("usuario") : "";

  String cedulaParam = request.getParameter("cedula");
  String nombreParam = request.getParameter("nombre");

  if ((nombreParam == null || nombreParam.trim().isEmpty()) && cedulaParam != null && !cedulaParam.trim().isEmpty()) {
      PacienteDAO pDao = new PacienteDAO();
      Paciente p = pDao.buscarPorCedula(cedulaParam.trim());
      if (p != null) {
          nombreParam = p.getNombres() + " " + p.getApellidos();
      }
  }

  boolean tienePaciente = (nombreParam != null && !nombreParam.trim().isEmpty());
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Calculadora IMC</title>
  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>
<body class="bg-light" style="font-family:'Inter',sans-serif;">

  <!-- OFFCANVAS SIDEBAR (móvil) -->
  <div class="offcanvas offcanvas-start nl-sidebar text-white" id="sidebarMobile" style="width:240px;" tabindex="-1">
    <div class="offcanvas-header border-bottom border-white border-opacity-10 py-3">
      <span class="fw-bold text-white">NURSELOGIC</span>
      <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
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
            <i class="bi bi-person-vcard-fill"></i>Pacientes
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/SignosVitalesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-activity"></i>Signos Vitales
          </a>
        </li>
      </ul>
    </div>
  </div>

  <div class="container-fluid p-0">
    <div class="row g-0 min-vh-100">

      <!-- SIDEBAR DESKTOP -->
      <nav class="col-auto d-none d-lg-flex flex-column nl-sidebar text-white p-0" id="nl-sidebar" style="width:240px;min-height:100vh;position:sticky;top:0;height:100vh;overflow-y:auto;">
        <a href="${pageContext.request.contextPath}/index.jsp" class="d-flex align-items-center gap-3 p-4 text-white text-decoration-none border-bottom border-white border-opacity-10">
          <div class="rounded-3 bg-success p-2 flex-shrink-0">
            <i class="bi bi-heart-pulse-fill text-white fs-5"></i>
          </div>
          <div>
            <div class="fw-bold small text-white" style="letter-spacing:1px;">NURSELOGIC</div>
            <div style="font-size:.62rem;" class="text-white-50">Gestión Clínica</div>
          </div>
        </a>
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
              <i class="bi bi-person-vcard-fill"></i><span>Pacientes</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-activity"></i><span>Signos Vitales</span>
            </a>
          </li>
        </ul>
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
            <i class="bi bi-house-fill"></i><span>/</span><span>Herramientas</span><span>/</span>
            <span class="text-white fw-semibold">Calculadora IMC</span>
          </div>

          <div class="ms-auto d-flex align-items-center gap-2">
            <% if (cedulaParam != null && !cedulaParam.trim().isEmpty()) { %>
              <a href="${pageContext.request.contextPath}/PanelPacienteServlet?cedula=<%= cedulaParam %>" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-arrow-left"></i> Volver al Panel del Paciente
              </a>
            <% } else { %>
              <button type="button" onclick="history.back()" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                <i class="bi bi-arrow-left"></i> Volver
              </button>
            <% } %>
          </div>
        </header>

        <main class="p-4">
          <!-- BOTÓN VOLVER PROMINENTE -->
          <div class="d-flex align-items-center justify-content-between mb-4 mx-auto" style="max-width:560px;">
            <div>
              <h1 class="h4 fw-bold mb-0 text-dark d-flex align-items-center gap-2">
                <i class="bi bi-calculator-fill text-success"></i> Calculadora IMC
              </h1>
              <p class="text-muted small mb-0">Evaluación antropométrica rápida</p>
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

          <div class="card border-0 shadow-sm rounded-4 mx-auto overflow-hidden" style="max-width:560px;">
            <div class="card-header bg-brand-gradient text-white p-4 border-0 d-flex align-items-center gap-3">
              <div class="rounded-3 bg-white bg-opacity-25 p-2 d-flex align-items-center justify-content-center" style="width:44px;height:44px;">
                <i class="bi bi-calculator-fill fs-4 text-white"></i>
              </div>
              <div>
                <h2 class="h5 fw-bold mb-0 text-white">Calculadora de IMC</h2>
                <p class="text-white-50 small mb-0">
                  <%= tienePaciente ? "Paciente: " + nombreParam : "Índice de Masa Corporal del paciente" %>
                </p>
              </div>
            </div>
            <div class="card-body p-4">
              <form action="${pageContext.request.contextPath}/calcular" method="POST" novalidate>
                <% if (cedulaParam != null && !cedulaParam.trim().isEmpty()) { %>
                  <input type="hidden" name="cedula" value="<%= cedulaParam.trim() %>"/>
                <% } %>

                <div class="mb-3">
                  <label class="form-label small fw-semibold text-uppercase text-muted" for="nombre">Nombre del Paciente</label>
                  <input type="text" id="nombre" name="nombre" class="form-control py-2 <%= tienePaciente ? "bg-light text-dark fw-semibold" : "" %>" placeholder="Ingrese el nombre" value="<%= nombreParam != null ? nombreParam : "" %>" <%= tienePaciente ? "readonly" : "required" %>/>
                  <% if (tienePaciente) { %>
                    <div class="form-text text-success" style="font-size:.73rem;">
                      <i class="bi bi-check-circle-fill me-1"></i>Nombre precargado automáticamente desde la Ficha Clínica.
                    </div>
                  <% } %>
                </div>

                <div class="mb-3">
                  <label class="form-label small fw-semibold text-uppercase text-muted" for="peso">Peso (kg) *</label>
                  <input type="number" id="peso" name="peso" class="form-control py-2" step="0.1" placeholder="Ej: 70.5" required/>
                </div>

                <div class="mb-4">
                  <label class="form-label small fw-semibold text-uppercase text-muted" for="altura">Altura (metros) *</label>
                  <input type="number" id="altura" name="altura" class="form-control py-2" step="0.01" placeholder="Ej: 1.75" required/>
                </div>

                <button type="submit" class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2 shadow-sm">
                  <i class="bi bi-calculator"></i> Calcular IMC
                </button>
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
