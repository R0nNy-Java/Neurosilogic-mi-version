<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  /* ── Variables de sesión homologadas ── */
  String rolSesion    = (session != null) ? (String) session.getAttribute("rol")           : "";
  String usuarioSesion= (session != null) ? (String) session.getAttribute("usuario")        : "usuario";
  String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : usuarioSesion;
  if (nombreSesion == null) nombreSesion = usuarioSesion;
  boolean esAdmin  = "ADMINISTRADOR".equals(rolSesion);
  String tituloRol = esAdmin ? "Administrador" : "Enfermero/a";
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

  <style>
    /* Estilos para las tarjetas internas del módulo */
    .nl-card-modulo {
      background-color: #f4f7f6 !important;
      border: 1px solid rgba(0,0,0,0.05) !important;
      border-radius: 12px !important;
      transition: transform 0.2s ease, box-shadow 0.2s ease;
    }
    .nl-card-modulo:hover {
      transform: translateY(-2px);
      box-shadow: 0 4px 12px rgba(0,0,0,0.05) !important;
    }
    .nl-icon-container {
      background-color: #e1ede9 !important;
      color: #2d7a67 !important;
      width: 46px;
      height: 46px;
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 8px;
    }
    .nl-link-modulo {
      color: #6c757d;
      font-size: 0.78rem;
      text-decoration: none;
    }
    .nl-link-modulo:hover {
      color: #2d7a67;
    }
  </style>
</head>

<body class="bg-light" style="font-family:'Inter',sans-serif;">

  <!-- OFFCANVAS SIDEBAR – móvil (Idéntico a index) -->
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

      <!-- SIDEBAR DESKTOP (Idéntico a index) -->
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

        <!-- TOPBAR DESKTOP CORREGIDA (Idéntica a index) -->
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
            <p class="text-muted small mb-0">Complete la información clínica del paciente</p>
          </div>

          <!-- Banner de Advertencia -->
          <div class="alert alert-warning border-0 rounded-3 py-2 px-4 d-flex align-items-center gap-3 mb-4" style="background-color: #fff9e6;" role="alert">
            <i class="bi bi-exclamation-triangle-fill text-warning fs-5"></i>
            <div class="text-dark small fw-medium">
              Asegúrese de llenar correctamente todos los campos obligatorios (*)
            </div>
          </div>

          <!-- SUBMÓDULOS EN CUADRÍCULA -->
          <div class="row g-3 mb-4">

            <!-- Tarjeta 1: Gestionar Pacientes -->
            <div class="col-6 col-lg-4">
              <div class="card h-100 nl-card-modulo p-3 d-flex flex-column gap-2">
                <div class="nl-icon-container">
                  <i class="bi bi-person-vcard-fill fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Gestionar Pacientes</div>
                <div class="text-muted" style="font-size:.78rem;">Ficha clínica digital con antecedentes y alergias</div>
                <a href="datos_personales.jsp" class="nl-link-modulo d-flex align-items-center gap-1 mt-auto">
                  <i class="bi bi-arrow-right-circle"></i> Ir al módulo
                </a>
              </div>
            </div>

            <!-- Tarjeta 2: Antecedentes -->
            <div class="col-6 col-lg-4">
              <div class="card h-100 nl-card-modulo p-3 d-flex flex-column gap-2">
                <div class="nl-icon-container">
                  <i class="bi bi-file-earmark-medical fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Antecedentes</div>
                <div class="text-muted" style="font-size:.78rem;">Historial médico y antecedentes clínicos</div>
                <a href="antecedentes.jsp" class="nl-link-modulo d-flex align-items-center gap-1 mt-auto">
                  <i class="bi bi-arrow-right-circle"></i> Ir al módulo
                </a>
              </div>
            </div>

            <!-- Tarjeta 3: Signos Vitales -->
            <div class="col-6 col-lg-4">
              <div class="card h-100 nl-card-modulo p-3 d-flex flex-column gap-2">
                <div class="nl-icon-container">
                  <i class="bi bi-activity fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Signos Vitales</div>
                <div class="text-muted" style="font-size:.78rem;">Registro con alertas cromáticas ROJO/AZUL automáticas</div>
                <a href="signos_vitales.jsp" class="nl-link-modulo d-flex align-items-center gap-1 mt-auto">
                  <i class="bi bi-arrow-right-circle"></i> Ir al módulo
                </a>
              </div>
            </div>

            <!-- Tarjeta 4: Calculadora IMC -->
            <div class="col-6 col-lg-4">
              <div class="card h-100 nl-card-modulo p-3 d-flex flex-column gap-2">
                <div class="nl-icon-container">
                  <i class="bi bi-calculator fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Calculadora IMC</div>
                <div class="text-muted" style="font-size:.78rem;">Cálculo del Índice de Masa Corporal</div>
                <a href="imc.jsp" class="nl-link-modulo d-flex align-items-center gap-1 mt-auto">
                  <i class="bi bi-arrow-right-circle"></i> Ir al módulo
                </a>
              </div>
            </div>

            <!-- Tarjeta 5: Escala Glasgow -->
            <div class="col-6 col-lg-4">
              <div class="card h-100 nl-card-modulo p-3 d-flex flex-column gap-2">
                <div class="nl-icon-container">
                  <i class="bi bi-file-earmark-bar-graph fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Escala Glasgow</div>
                <div class="text-muted" style="font-size:.78rem;">Evaluación de conciencia: Ocular + Verbal + Motor</div>
                <a href="escala_glasgow.jsp" class="nl-link-modulo d-flex align-items-center gap-1 mt-auto">
                  <i class="bi bi-arrow-right-circle"></i> Ir al módulo
                </a>
              </div>
            </div>

            <!-- Tarjeta 6: Medicación -->
            <div class="col-6 col-lg-4">
              <div class="card h-100 nl-card-modulo p-3 d-flex flex-column gap-2">
                <div class="nl-icon-container">
                  <i class="bi bi-capsule fs-5"></i>
                </div>
                <div class="fw-bold text-dark small">Medicación</div>
                <div class="text-muted" style="font-size:.78rem;">Medicamentos actuales y control de dosis del paciente</div>
                <a href="medicacion.jsp" class="nl-link-modulo d-flex align-items-center gap-1 mt-auto">
                  <i class="bi bi-arrow-right-circle"></i> Ir al módulo
                </a>
              </div>
            </div>

          </div>

          <!-- Reloj de Atención Inferior y Acciones finales -->
          <div class="text-center mt-4">
            <div class="d-inline-flex align-items-center gap-2 bg-light px-3 py-1.5 rounded-pill mb-3 border text-secondary" style="font-size: 0.82rem;">
              <i class="bi bi-clock-fill text-success"></i>
              <span id="nl-attention-clock">--:--:--</span>
            </div>

            <p class="text-muted mb-3" style="font-size: 0.85rem;">¿Finalizó la atención del paciente? Cierre la ficha clínica para regresar al listado general.</p>

            <div class="d-flex justify-content-center mb-4">
              <button type="button" class="btn btn-outline-danger px-4 py-2 rounded-3 d-inline-flex align-items-center gap-2" style="font-size: 0.88rem; font-weight: 500;">
                <i class="bi bi-box-arrow-left"></i> Cerrar Ficha Clínica <span class="text-muted opacity-75 ms-1" style="font-size: 0.78rem;">| Mar 21 Jul, 11:20</span>
              </button>
            </div>

            <!-- Botones de Acción Global -->
            <div class="d-flex justify-content-center gap-3 border-top pt-4">
              <button type="button" id="btnConceptoGuardar" class="btn btn-success px-5 py-2.5 fw-semibold rounded-3 d-flex align-items-center gap-2 shadow">
                <i class="bi bi-floppy-fill"></i> GUARDAR
              </button>
              <button type="button" id="btnConceptoRegresar" class="btn btn-outline-secondary px-5 py-2.5 fw-semibold rounded-3 d-flex align-items-center gap-2">
                <i class="bi bi-arrow-left"></i> Regresar
              </button>
            </div>
          </div>
        </main>
      </div>

    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

  <script>
    function updateTime() {
      const now = new Date();
      const elClock = document.getElementById('nl-attention-clock');
      if (elClock) {
        const timeOpts = { weekday: 'short', day: '2-digit', month: 'short', year: 'numeric', hour: '2-digit', minute: '2-digit', second: '2-digit' };
        elClock.textContent = now.toLocaleDateString('es-EC', timeOpts).replace(/\./g, '');
      }
    }
    updateTime();
    setInterval(updateTime, 1000);

    document.getElementById('btnConceptoRegresar').addEventListener('click', function (e) {
      if (confirm('¿Desea regresar al listado de pacientes?')) {
        window.location.href = '${pageContext.request.contextPath}/PacientesServlet';
      }
    });

    // Variable que controla si hay cambios sin guardar o una ficha activa
    let fichaActiva = true;

    // Función para proteger la navegación
    function protegerNavegacion() {
      // Seleccionamos todos los enlaces de los sidebars (escritorio y móvil) y topbar
      const enlacesMenu = document.querySelectorAll('.nl-sidebar .nav-link, .nl-sidebar a, #nl-topbar a, .navbar-brand');

      enlacesMenu.forEach(enlace => {
        enlace.addEventListener('click', function(e) {
          // Ignoramos los enlaces que son para cerrar sesión o cambiar contraseña si prefieres,
          // pero por seguridad, protegemos cualquier salida inesperada.
          if (fichaActiva) {
            const confirmar = confirm("Tiene una ficha clínica activa en proceso de registro. Si sale ahora, podría perder los cambios no consolidados. ¿Está seguro de que desea salir?");

            if (!confirmar) {
              // Si el usuario cancela, detenemos el redireccionamiento del enlace
              e.preventDefault();
            }
          }
        });
      });
    }

    // Ejecutar la protección al cargar la página
    document.addEventListener("DOMContentLoaded", function() {
      protegerNavegacion();

      // Si el usuario hace clic en el botón GUARDAR global, desactivamos la alerta para que viaje al servlet sin trabas
      const btnGuardar = document.getElementById('btnConceptoGuardar');
      if (btnGuardar) {
        btnGuardar.addEventListener('click', function() {
          fichaActiva = false; // Desactivar alerta porque ya va a guardar formalmente
        });
      }
    });
  </script>
</body>
</html>