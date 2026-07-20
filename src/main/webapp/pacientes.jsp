<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rrparedes.model.Paciente, java.util.List" %>
<%
  String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
  if (nombreSesion == null) nombreSesion = (session != null) ? (String) session.getAttribute("usuario") : "";
  String rolSesion = (session != null) ? (String) session.getAttribute("rol") : "";

  List<Paciente> listaPacientes = (List<Paciente>) request.getAttribute("listaPacientes");
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Listado de Pacientes</title>

  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
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
          <a href="${pageContext.request.contextPath}/PacientesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
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
            <a href="${pageContext.request.contextPath}/PacientesServlet" id="nav-pacientes" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
              <i class="bi bi-person-vcard-fill"></i><span>Pacientes</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-activity"></i><span>Signos Vitales</span>
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
              <div style="font-size:.7rem;" class="text-white-50"><%= rolSesion %></div>
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
            <i class="bi bi-house-fill"></i><span>/</span><span>Pacientes</span><span>/</span>
            <span class="text-white fw-semibold">Listado General</span>
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
          <div class="d-flex flex-column flex-md-row align-items-md-center justify-content-between gap-3 mb-4">
            <div>
              <h1 class="h4 fw-bold mb-1 d-flex align-items-center gap-2">
                <i class="bi bi-person-vcard-fill text-success"></i>Gestión de Pacientes
              </h1>
              <p class="text-muted small mb-0">Listado de fichas clínicas registradas en el sistema (Persistido en MySQL)</p>
            </div>
            <div>
              <a href="${pageContext.request.contextPath}/RegistroPacienteServlet" class="btn btn-success py-2 px-3 fw-semibold d-inline-flex align-items-center gap-2 shadow-sm">
                <i class="bi bi-person-plus-fill fs-5"></i> Registrar Nuevo Paciente
              </a>
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
                    Total registrados: <strong><%= listaPacientes != null ? listaPacientes.size() : 0 %></strong>
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
                      <th>Síntomas Actuales</th>
                      <th>Alergias</th>
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
                      <td class="small text-muted" style="max-width:180px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis;">
                        <%= (p.getSintomasActuales() != null && !p.getSintomasActuales().isEmpty()) ? p.getSintomasActuales() : "Sin observaciones" %>
                      </td>
                      <td style="max-width:180px;">
                        <% if (p.getAlergias() != null && !p.getAlergias().trim().isEmpty()) { %>
                          <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-2 py-1 text-truncate d-inline-block" style="max-width:170px;" title="<%= p.getAlergias() %>"><i class="bi bi-exclamation-triangle-fill me-1"></i><%= p.getAlergias() %></span>
                        <% } else { %>
                          <span class="badge bg-secondary bg-opacity-10 text-muted px-2 py-1">Ninguna</span>
                        <% } %>
                      </td>
                      <td>
                        <span class="badge bg-success px-3 py-2 rounded-pill">Activo</span>
                      </td>
                      <td class="pe-4 text-end text-nowrap">
                        <div class="d-inline-flex align-items-center gap-2">
                          <a href="${pageContext.request.contextPath}/PanelPacienteServlet?cedula=<%= p.getCedula() %>" class="btn btn-sm btn-success d-inline-flex align-items-center gap-1 py-1 px-3">
                            <i class="bi bi-grid-3x3-gap-fill"></i> Panel Paciente
                          </a>
                          <button type="button" class="btn btn-sm btn-outline-info d-inline-flex align-items-center gap-1 py-1 px-3" onclick="verDetalles('<%= p.getNombres() + " " + p.getApellidos() %>', '<%= p.getCedula() %>', '<%= p.getEdad() %>', '<%= p.getSexo() %>', '<%= p.getSintomasActuales() != null ? p.getSintomasActuales().replace("'", "\\'") : "" %>', '<%= p.getAlergias() != null ? p.getAlergias().replace("'", "\\'") : "" %>', '<%= p.getDispositivosMedicos() != null ? p.getDispositivosMedicos().replace("'", "\\'") : "" %>')">
                            <i class="bi bi-eye-fill"></i> Ver Ficha
                          </button>
                        </div>
                      </td>
                    </tr>
                    <%    }
                      } else { %>
                    <tr>
                      <td colspan="8" class="text-center py-5 text-muted">
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
          <div class="mb-3">
            <small class="fw-semibold text-uppercase text-muted d-block mb-1">Síntomas Actuales</small>
            <div class="p-3 bg-light rounded-3 border text-dark" id="mSintomas">-</div>
          </div>
          <div class="row g-3">
            <div class="col-md-6">
              <small class="fw-semibold text-uppercase text-muted d-block mb-1">Alergias Conocidas</small>
              <div class="p-3 bg-light rounded-3 border text-danger fw-semibold" id="mAlergias">-</div>
            </div>
            <div class="col-md-6">
              <small class="fw-semibold text-uppercase text-muted d-block mb-1">Dispositivos Médicos</small>
              <div class="p-3 bg-light rounded-3 border text-dark" id="mDispositivos">-</div>
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

    function verDetalles(nombre, cedula, edad, sexo, sintomas, alergias, dispositivos) {
      document.getElementById('mNombre').textContent = nombre;
      document.getElementById('mCedula').textContent = 'Cédula: ' + cedula;
      document.getElementById('mEdadSexo').textContent = edad + ' años (' + (sexo === 'M' ? 'Masculino' : 'Femenino') + ')';
      document.getElementById('mSintomas').textContent = sintomas || 'Sin síntomas registrados';
      document.getElementById('mAlergias').textContent = alergias || 'Ninguna alergia conocida';
      document.getElementById('mDispositivos').textContent = dispositivos || 'Ninguno';

      const modal = new bootstrap.Modal(document.getElementById('modalFicha'));
      modal.show();
    }
  </script>
</body>
</html>
