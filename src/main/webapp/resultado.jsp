<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>NURSELOGIC | Resultado IMC</title>
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
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/PacientesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-person-vcard-fill"></i><span>Pacientes</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/SignosVitalesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-activity"></i><span>Signos Vitales</span>
            </a>
          </li>
        </ul>
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
        <header class="navbar navbar-dark bg-brand-gradient d-none d-lg-flex shadow-sm px-4" style="min-height:62px;">
          <div class="small text-white-50 d-flex align-items-center gap-2">
            <i class="bi bi-house-fill"></i><span>/</span><span>Herramientas</span><span>/</span>
            <span class="text-white fw-semibold">Resultado IMC</span>
          </div>
          <a href="${pageContext.request.contextPath}/calculadora.jsp" class="btn btn-outline-light btn-sm ms-auto d-flex align-items-center gap-1">
            <i class="bi bi-arrow-left"></i>Volver
          </a>
        </header>

        <main class="p-4">
          <div class="card border-0 shadow-sm rounded-4 mx-auto overflow-hidden" style="max-width:520px;">
            <div class="card-header bg-brand-gradient text-white p-4 text-center border-0">
              <i class="bi bi-clipboard2-data-fill fs-1 text-white d-block mb-2"></i>
              <h1 class="h5 fw-bold mb-0 text-white">Resultado del Cálculo IMC</h1>
            </div>
            <div class="card-body p-4">
              <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                <span class="small fw-semibold text-uppercase text-muted">Paciente</span>
                <span class="fw-semibold text-dark"><%= request.getAttribute("nombre") %></span>
              </div>
              <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                <span class="small fw-semibold text-uppercase text-muted">Peso</span>
                <span class="fw-semibold text-dark"><%= request.getAttribute("peso") %> kg</span>
              </div>
              <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                <span class="small fw-semibold text-uppercase text-muted">Altura</span>
                <span class="fw-semibold text-dark"><%= request.getAttribute("altura") %> m</span>
              </div>
              <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                <span class="small fw-semibold text-uppercase text-muted">IMC Calculado</span>
                <span class="fw-bold text-success fs-5"><%= request.getAttribute("imc") %></span>
              </div>
              <div class="d-flex justify-content-between align-items-center py-2 border-bottom mb-4">
                <span class="small fw-semibold text-uppercase text-muted">Clasificación</span>
                <span class="nl-categoria-badge <%= request.getAttribute("categoria") != null ? request.getAttribute("categoria").toString().toLowerCase().replace(" ", "-") : "" %>">
                  <%= request.getAttribute("categoria") %>
                </span>
              </div>
              <a href="${pageContext.request.contextPath}/calculadora.jsp" class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2">
                <i class="bi bi-arrow-left-circle"></i> Calcular otro IMC
              </a>
            </div>
          </div>
        </main>
      </div>

    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>