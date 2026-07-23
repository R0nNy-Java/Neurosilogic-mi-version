<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rrparedes.model.Paciente, com.rrparedes.model.Antecedente, java.util.List" %>
<%
  String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
  if (nombreSesion == null) nombreSesion = (session != null) ? (String) session.getAttribute("usuario") : "";
  String rolSesion = (session != null) ? (String) session.getAttribute("rol") : "";
  boolean esAdmin  = "ADMINISTRADOR".equals(rolSesion);
  String tituloRol = esAdmin ? "Administrador" : "Enfermero/a";

  Paciente p = (Paciente) request.getAttribute("paciente");
  List<Antecedente> antecedentes = (List<Antecedente>) request.getAttribute("antecedentes");

  if (p == null) {
      response.sendRedirect(request.getContextPath() + "/PacientesServlet");
      return;
  }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Panel de Paciente: <%= p.getNombres() %> <%= p.getApellidos() %></title>

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
            <i class="bi bi-droplet"></i>Calcular Dosis
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
          <a href="${pageContext.request.contextPath}/calculadora.jsp" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-calculator"></i>Calculadora IMC
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
              <i class="bi bi-droplet"></i><span>Calcular Dosis</span>
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
            <a href="${pageContext.request.contextPath}/calculadora.jsp" id="nav-imc" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-calculator"></i><span>Calculadora IMC</span>
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
            <span class="text-white fw-semibold">Panel Individual</span>
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
          <!-- BANNER DEL PACIENTE (Estilo Dashboard General index.jsp) -->
          <div class="card border-0 text-white bg-brand-gradient shadow rounded-4 mb-4">
            <div class="card-body d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 py-4 px-4">
              <div class="d-flex align-items-center gap-3">
                <i class="bi bi-heart-pulse flex-shrink-0" style="font-size:2.2rem;color:rgba(255,255,255,.8);"></i>
                <div>
                  <h2 class="fs-5 fw-bold mb-1 text-white">
                    Panel de Enfermería &middot; Paciente: <strong><%= p.getNombres() %> <%= p.getApellidos() %></strong>
                  </h2>
                  <p class="small mb-0" style="color:rgba(255,255,255,.72);">
                    Cédula: <strong><%= p.getCedula() %></strong> &middot; Edad: <strong><%= p.getEdad() %> años</strong> &middot; Sexo: <strong><%= "M".equalsIgnoreCase(p.getSexo()) ? "Masculino" : "Femenino" %></strong>
                  </p>
                </div>
              </div>
              <div>
                <a href="${pageContext.request.contextPath}/RegistroPacienteServlet?cedula=<%= p.getCedula() %>" class="btn btn-light text-success fw-semibold btn-sm py-2 px-3 d-inline-flex align-items-center gap-1 shadow-sm">
                  <i class="bi bi-pencil-square"></i> Editar Ficha Clínica
                </a>
              </div>
            </div>
          </div>

          <!-- RESUMEN CLÍNICO DEL PACIENTE -->
          <div class="row g-3 mb-4">
            <div class="col-md-6">
              <div class="card border-0 shadow-sm rounded-3 h-100 p-3">
                <small class="fw-bold text-uppercase text-muted d-block mb-1" style="font-size:.7rem;letter-spacing:.6px;">Síntomas & Observaciones Actuales</small>
                <div class="text-dark small">
                  <%
                    boolean tieneObs = false;
                    if (antecedentes != null && !antecedentes.isEmpty()) {
                      for (Antecedente ant : antecedentes) {
                        if (ant.getObservacion() != null && !ant.getObservacion().trim().isEmpty()) {
                          tieneObs = true;
                  %>
                          <div class="mb-1">&bull; <%= ant.getObservacion() %></div>
                  <%
                        }
                      }
                    }
                    if (!tieneObs) {
                  %>
                    <span class="text-muted">Sin observaciones de admisión registradas.</span>
                  <% } %>
                </div>
              </div>
            </div>
            <div class="col-md-6">
              <div class="card border-0 shadow-sm rounded-3 h-100 p-3">
                <div class="mb-2">
                  <small class="fw-bold text-uppercase text-muted d-block" style="font-size:.7rem;letter-spacing:.6px;">Alergias & Antecedentes Clínicos</small>
                </div>
                <div class="d-flex flex-wrap gap-2">
                  <%
                    if (antecedentes != null && !antecedentes.isEmpty()) {
                        for (Antecedente ant : antecedentes) {
                          if (!"Ninguna".equalsIgnoreCase(ant.getAlergias()) && !ant.getAlergias().trim().isEmpty()) {
                  %>
                            <span class="badge bg-danger text-white"><i class="bi bi-exclamation-triangle-fill me-1"></i>Alergia: <%= ant.getAlergias() %></span>
                  <%      }
                  %>
                          <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25"><%= ant.getNombreEnfermedad() %></span>
                  <%    }
                    } else { %>
                    <span class="badge bg-secondary bg-opacity-10 text-muted">Sin antecedentes registrados</span>
                  <% } %>
                </div>
              </div>
            </div>
          </div>

          <!-- MÓDULOS DE ATENCIÓN DE PACIENTE (5 Columnas) -->
          <p class="small fw-bold text-uppercase text-muted mb-3 d-flex align-items-center gap-1">
            <i class="bi bi-lightning-fill"></i>Módulos de Atención del Paciente
          </p>

          <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-5 g-3 mb-4">

            <!-- 1. MÓDULO SIGNOS VITALES -->
            <div class="col">
              <a href="${pageContext.request.contextPath}/SignosVitalesServlet?cedula=<%= p.getCedula() %>" id="card-signos-paciente" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-activity text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Signos Vitales</div>
                <div class="text-muted" style="font-size:.78rem;">Registro de PA, Temp, FC, FR, SPO2 y Glicemia con alerta cromática</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Evaluar</div>
              </a>
            </div>

            <!-- 2. MÓDULO ANTECEDENTES Y ALERGIAS -->
            <div class="col">
              <a href="${pageContext.request.contextPath}/AntecedentesServlet?cedula=<%= p.getCedula() %>" id="card-antecedentes-paciente" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-journal-medical text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Antecedentes Clínicos</div>
                <div class="text-muted" style="font-size:.78rem;">Registro de patologías base, alergias conocidas y medicación habitual</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Gestionar</div>
              </a>
            </div>

            <!-- 3. MÓDULO DOSIFICACIÓN Y ADMINISTRACIÓN -->
            <div class="col">
              <a href="${pageContext.request.contextPath}/DosificacionServlet?cedula=<%= p.getCedula() %>" id="card-dosificacion-paciente" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-droplet-fill text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Calcular Dosis</div>
                <div class="text-muted" style="font-size:.78rem;">Regla de tres con conversión de unidades (g/mg/mcg y L/mL)</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Calcular</div>
              </a>
            </div>

            <!-- 4. MÓDULO ESCALA GLASGOW -->
            <div class="col">
              <a href="${pageContext.request.contextPath}/GlasgowServlet?cedula=<%= p.getCedula() %>" id="card-glasgow-paciente" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-clipboard2-data-fill text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Escala Glasgow</div>
                <div class="text-muted" style="font-size:.78rem;">Evaluación de conciencia: Ocular (1-4) + Verbal (1-5) + Motor (1-6)</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Evaluar</div>
              </a>
            </div>

            <!-- 5. MÓDULO CALCULADORA IMC -->
            <div class="col">
              <a href="${pageContext.request.contextPath}/calculadora.jsp?nombre=<%= p.getNombres() + " " + p.getApellidos() %>" id="card-imc-paciente" class="card border rounded-3 text-decoration-none h-100 p-3 d-flex flex-column gap-2">
                <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 flex-shrink-0" style="width:46px;height:46px;">
                  <i class="bi bi-calculator-fill text-success fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Calculadora IMC</div>
                <div class="text-muted" style="font-size:.78rem;">IMC = peso(kg) / estatura(m)² con clasificación cromática</div>
                <div class="text-muted small d-flex align-items-center gap-1 mt-auto"><i class="bi bi-arrow-right-circle"></i>Calcular</div>
              </a>
            </div>

          </div><!-- /.row modulos -->

          <!-- ══ BOTÓN INFERIOR: CERRAR FICHA CLÍNICA (Con fecha, hora y día) ══ -->
          <div class="card border-0 shadow-sm rounded-4 overflow-hidden mt-4">
            <div class="card-body p-4 text-center bg-white">
              <div class="mb-2">
                <span class="badge bg-success bg-opacity-10 text-success px-3 py-2 rounded-pill small fw-semibold">
                  <i class="bi bi-clock-fill me-1"></i><span id="nl-panel-clock">Cargando fecha y hora...</span>
                </span>
              </div>
              <p class="text-muted small mb-3">¿Finalizó la atención del paciente? Cierre la ficha clínica para regresar al listado general.</p>
              <a href="${pageContext.request.contextPath}/PacientesServlet" id="btn-cerrar-ficha-clinica" class="btn-cerrar-ficha btn btn-outline-danger py-3 px-5 fw-semibold d-inline-flex align-items-center justify-content-center gap-2 shadow-sm rounded-3">
                <i class="bi bi-box-arrow-left fs-5"></i>
                <span>Cerrar Ficha Clínica</span>
                <span class="ms-1 border-start border-danger border-opacity-50 ps-2 fw-normal small" id="nl-panel-clock-btn"></span>
              </a>
            </div>
          </div>

        </main>
      </div>

    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
  <script>
    function updateClock() {
      const now = new Date();
      const dias = ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'];
      const meses = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
      const strDate = dias[now.getDay()] + ', ' + String(now.getDate()).padStart(2, '0') + ' ' + meses[now.getMonth()] + ' ' + now.getFullYear() + ' - ' + String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0') + ':' + String(now.getSeconds()).padStart(2, '0');
      const el1 = document.getElementById('nl-panel-clock');
      if (el1) el1.textContent = strDate;
      const el2 = document.getElementById('nl-panel-clock-btn');
      if (el2) el2.textContent = dias[now.getDay()] + ' ' + String(now.getDate()).padStart(2, '0') + ' ' + meses[now.getMonth()] + ', ' + String(now.getHours()).padStart(2, '0') + ':' + String(now.getMinutes()).padStart(2, '0');
    }
    updateClock();
    setInterval(updateClock, 1000);

    // Proteccion de Navegación en el Panel de Paciente
    document.addEventListener("DOMContentLoaded", function () {
      const enlacesMenu = document.querySelectorAll('.nl-sidebar a, header a, .navbar a');
      enlacesMenu.forEach(enlace => {
        // Excluir el botón formal de Cerrar Ficha Clínica
        if (enlace.id === 'btn-cerrar-ficha-clinica' || enlace.classList.contains('btn-cerrar-ficha')) {
          return;
        }

        enlace.addEventListener('click', function (e) {
          const confirmar = confirm("Tiene una ficha clínica activa en proceso de atención. La forma recomendada para finalizar es el botón 'Cerrar Ficha Clínica'. ¿Está seguro de que desea salir del seguimiento del paciente?");
          if (!confirmar) {
            e.preventDefault();
          }
        });
      });
    });
  </script>
</body>
</html>
