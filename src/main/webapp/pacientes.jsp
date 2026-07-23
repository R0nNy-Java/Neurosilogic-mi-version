<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rrparedes.model.Paciente, java.util.List" %>
<%
  /* ── Variables de sesión homologadas ── */
  String rolSesion    = (session != null) ? (String) session.getAttribute("rol")           : "";
  String usuarioSesion= (session != null) ? (String) session.getAttribute("usuario")        : "usuario";
  String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : usuarioSesion;
  if (nombreSesion == null) nombreSesion = usuarioSesion;
  boolean esAdmin  = "ADMINISTRADOR".equals(rolSesion);
  String tituloRol = esAdmin ? "Administrador" : "Enfermero/a";

  List<Paciente> listaPacientes = (List<Paciente>) request.getAttribute("listaPacientes");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Gestión de Pacientes</title>

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

        <!-- TOPBAR DESKTOP CORREGIDA (Eliminada la barra morada inconsistente) -->
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

        <main class="p-4">
          <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-4">
            <div>
              <h1 class="h4 fw-bold mb-1 d-flex align-items-center gap-2">
                <i class="bi bi-person-badge text-success"></i>Fichas Clínicas Digitales
              </h1>
              <p class="text-muted small mb-0">Listado de pacientes registrados en el sistema (Base de Datos MySQL)</p>
            </div>
            <div>
              <a href="${pageContext.request.contextPath}/RegistroPacienteServlet" class="btn btn-success py-2 px-3 fw-semibold d-inline-flex align-items-center gap-2 shadow-sm">
                <i class="bi bi-person-plus-fill fs-5"></i> Registrar Nuevo Paciente
              </a>
            </div>
          </div>

          <!-- FILA DE KPIs REFORMADA CON EL ESTILO COMPACTO Y BORDE LATERAL -->
          <div class="row mb-4">
            <div class="col-12 col-sm-6 col-md-4 col-lg-3">
              <div class="card border-0 shadow-sm h-100 rounded-3 border-start border-4 border-success">
                <div class="card-body d-flex align-items-center gap-3 p-3">
                  <div class="rounded-3 d-flex align-items-center justify-content-center bg-success bg-opacity-10 text-success flex-shrink-0" style="width:48px;height:48px;">
                    <i class="bi bi-people-fill fs-4"></i>
                  </div>
                  <div>
                    <div class="fw-bold lh-1 fs-3"><%= listaPacientes != null ? listaPacientes.size() : 0 %></div>
                    <div class="text-muted small mt-1">Pacientes Registrados</div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- TABLA DE PACIENTES -->
          <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-brand-gradient text-white p-4 border-0 d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3">
              <div class="d-flex align-items-center gap-3">
                <div class="rounded-3 bg-white bg-opacity-25 p-2 d-flex align-items-center justify-content-center" style="width:44px;height:44px;">
                  <i class="bi bi-folder-fill fs-4 text-white"></i>
                </div>
                <div>
                  <h2 class="h5 fw-bold mb-0 text-white">Pacientes en Base de Datos</h2>
                  <p class="text-white-50 small mb-0">
                    Total activos: <strong><%= listaPacientes != null ? listaPacientes.size() : 0 %></strong>
                  </p>
                </div>
              </div>
              <div style="min-width: 250px;">
                <input type="text" id="inputBuscarPaciente" class="form-control form-control-sm bg-white text-dark border-0 shadow-sm" placeholder="🔍 Buscar por Cédula o Nombre..."/>
              </div>
            </div>

            <div class="card-body p-0">
              <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="tablaPacientes">
                  <thead class="bg-light text-muted small text-uppercase" style="letter-spacing:.6px;">
                    <tr>
                      <th class="ps-4">#</th>
                      <th>Cédula</th>
                      <th>Nombre Completo</th>
                      <th>Edad / Sexo</th>
                      <th>Estado</th>
                      <th class="pe-4 text-end">Acciones</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%
                      if (listaPacientes != null && !listaPacientes.isEmpty()) {
                          int count = 1;
                          for (Paciente p : listaPacientes) {
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
                          <a href="${pageContext.request.contextPath}/PanelPacienteServlet?cedula=<%= p.getCedula() %>" class="btn btn-sm btn-success d-inline-flex align-items-center gap-1 py-1 px-3">
                            <i class="bi bi-grid-3x3-gap-fill"></i> Panel Paciente
                          </a>
                          <button type="button" class="btn btn-sm btn-outline-info d-inline-flex align-items-center gap-1 py-1 px-3" onclick="verDetalles('<%= p.getNombres() + " " + p.getApellidos() %>', '<%= p.getCedula() %>', '<%= p.getEdad() %>', '<%= p.getSexo() %>')">
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

  <!-- MODAL FICHA COMPLETA -->
  <div class="modal fade" id="modalFicha" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
      <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
        <div class="modal-header bg-brand-gradient text-white p-4 border-0">
          <div class="d-flex align-items-center gap-3">
            <div class="rounded-3 bg-white bg-opacity-25 p-2 d-flex align-items-center justify-content-center" style="width:40px;height:40px;">
              <i class="bi bi-person-vcard-fill fs-4 text-white"></i>
            </div>
            <div>
              <h5 class="modal-title fw-bold text-white mb-0" id="mNombre">Ficha Clínica</h5>
              <small class="text-white-50" id="mCedula">Cédula: -</small>
            </div>
          </div>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Cerrar"></button>
        </div>
        <div class="modal-body p-4">
          <div class="row g-3 mb-3">
            <div class="col-md-6">
              <div class="p-3 bg-light rounded-3 border">
                <small class="fw-semibold text-uppercase text-muted d-block mb-1">Edad y Sexo</small>
                <span id="mEdadSexo" class="fw-bold text-dark fs-6">-</span>
              </div>
            </div>
            <div class="col-md-6">
              <div class="p-3 bg-light rounded-3 border">
                <small class="fw-semibold text-uppercase text-muted d-block mb-1">Estado de Ficha</small>
                <span class="badge bg-success px-3 py-2 rounded-pill">Activo</span>
              </div>
            </div>
          </div>

        </div>
        <div class="modal-footer bg-light border-0 p-3">
          <button type="button" class="btn btn-secondary px-4" data-bs-dismiss="modal">Cerrar</button>
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

    function verDetalles(nombre, cedula, edad) {
      document.getElementById('mNombre').textContent = nombre;
      document.getElementById('mCedula').textContent = 'Cédula: ' + cedula;
      document.getElementById('mEdadSexo').textContent = edad + ' años (' + (sexo === 'M' ? 'Masculino' : 'Femenino') + ')';
      const modal = new bootstrap.Modal(document.getElementById('modalFicha'));
      modal.show();
    }
  </script>
</body>
</html>