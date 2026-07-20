<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rrparedes.model.Usuario, com.rrparedes.model.UserStore, java.util.Collection" %>
<%
  String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
  if (nombreSesion == null) nombreSesion = (session != null) ? (String) session.getAttribute("usuario") : "";

  Collection<Usuario> listaUsuarios = (Collection<Usuario>) request.getAttribute("listaUsuarios");
  if (listaUsuarios == null) {
      listaUsuarios = UserStore.getTodos();
  }
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Gestionar Usuarios</title>
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
      <div class="px-3 pt-3 pb-2">
        <span class="badge w-100 py-2 bg-info bg-opacity-25 text-info" style="font-size:.7rem;">
          <i class="bi bi-shield-fill me-1"></i>Administrador
        </span>
      </div>
      <div class="px-4 py-1">
        <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">Menú Principal</small>
      </div>
      <ul class="nav flex-column px-2 flex-grow-1 mt-1">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-grid-1x2-fill"></i>Dashboard
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/GestionarUsuariosServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
            <i class="bi bi-people-fill"></i>Gestionar Usuarios
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/GestionarCatalogoServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-journal-medical"></i>Catálogo Medicamentos
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
        <div class="px-3 pt-3 pb-2">
          <span class="badge w-100 py-2 bg-info bg-opacity-25 text-info" style="font-size:.7rem;">
            <i class="bi bi-shield-fill me-1"></i>Administrador
          </span>
        </div>
        <div class="px-4 py-1">
          <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">Menú Principal</small>
        </div>
        <ul class="nav flex-column px-2 flex-grow-1 mt-1">
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/GestionarUsuariosServlet" id="nav-usuarios" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
              <i class="bi bi-people-fill"></i><span>Gestionar Usuarios</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/GestionarCatalogoServlet" id="nav-catalogo" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-journal-medical"></i><span>Catálogo Medicamentos</span>
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
              <div style="font-size:.7rem;" class="text-white-50">Administrador</div>
            </div>
          </div>
          <a href="${pageContext.request.contextPath}/LogoutServlet" id="nav-logout" class="nav-link nl-nav-link d-flex align-items-center gap-2 py-2 px-3 small">
            <i class="bi bi-box-arrow-right"></i>Cerrar sesión
          </a>
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
            <i class="bi bi-house-fill"></i><span>/</span><span>Administración</span><span>/</span>
            <span class="text-white fw-semibold">Gestionar Usuarios</span>
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
          <div class="mb-4">
            <h1 class="h4 fw-bold d-flex align-items-center gap-2">
              <i class="bi bi-people-fill text-success"></i>Gestión de Usuarios del Sistema
            </h1>
            <p class="text-muted small mt-1">Asignación de roles y control de acceso (Persistido en MySQL)</p>
          </div>

          <%-- Mensajes de feedback --%>
          <%
            String successMsg = (String) request.getAttribute("successMsg");
            String errorMsg   = (String) request.getAttribute("errorMsg");
            if (successMsg != null && !successMsg.isEmpty()) {
          %>
          <div class="alert alert-success d-flex align-items-center gap-2 py-2 small mb-4" role="alert">
            <i class="bi bi-check-circle-fill flex-shrink-0"></i><strong><%= successMsg %></strong>
          </div>
          <% } %>
          <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
          <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small mb-4" role="alert">
            <i class="bi bi-exclamation-circle-fill flex-shrink-0"></i><strong><%= errorMsg %></strong>
          </div>
          <% } %>

          <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
            <div class="card-header bg-brand-gradient text-white p-4 border-0 d-flex align-items-center justify-content-between">
              <div class="d-flex align-items-center gap-3">
                <div class="rounded-3 bg-white bg-opacity-25 p-2 d-flex align-items-center justify-content-center" style="width:44px;height:44px;">
                  <i class="bi bi-shield-lock-fill fs-4 text-white"></i>
                </div>
                <div>
                  <h2 class="h5 fw-bold mb-0 text-white">Lista de Cuentas Registradas</h2>
                  <p class="text-white-50 small mb-0">Gestión en tiempo real sincronizada con MySQL</p>
                </div>
              </div>
            </div>

            <div class="card-body p-0">
              <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                  <thead class="bg-light text-muted small text-uppercase" style="letter-spacing:.6px;">
                    <tr>
                      <th class="ps-4">#</th>
                      <th>Nombre Completo</th>
                      <th>Usuario</th>
                      <th>Correo Electrónico</th>
                      <th>Rol Asignado</th>
                      <th>Estado</th>
                      <th>Asignar Nuevo Rol</th>
                      <th class="pe-4">Acción Estado</th>
                    </tr>
                  </thead>
                  <tbody>
                    <%
                      int i = 1;
                      for (Usuario u : listaUsuarios) {
                          String r = u.getRol() != null ? u.getRol().trim() : "PENDIENTE";
                          boolean esPendiente = "PENDIENTE".equalsIgnoreCase(r) || r.isEmpty();
                          boolean esBloqueado = u.isBloqueado();
                    %>
                    <tr class="<%= esPendiente ? "table-warning" : "" %>">
                      <td class="ps-4"><%= i++ %></td>
                      <td><strong><%= u.getNombreCompleto() %></strong></td>
                      <td><code><%= u.getNombreUsuario() %></code></td>
                      <td><%= u.getEmail().isEmpty() ? "—" : u.getEmail() %></td>
                      <td>
                        <% if ("ADMINISTRADOR".equalsIgnoreCase(r)) { %>
                          <span class="badge bg-primary px-3 py-2 rounded-pill">ADMINISTRADOR</span>
                        <% } else if ("ENFERMERO".equalsIgnoreCase(r)) { %>
                          <span class="badge bg-success px-3 py-2 rounded-pill">ENFERMERO</span>
                        <% } else { %>
                          <span class="badge bg-warning text-dark px-3 py-2 rounded-pill">⏳ PENDIENTE</span>
                        <% } %>
                      </td>
                      <td>
                        <% if (esBloqueado) { %>
                          <span class="badge bg-danger px-3 py-2 rounded-pill">Bloqueado</span>
                        <% } else { %>
                          <span class="badge bg-success px-3 py-2 rounded-pill">Activo</span>
                        <% } %>
                      </td>
                      <td>
                        <form action="${pageContext.request.contextPath}/GestionarUsuariosServlet" method="POST" class="d-flex align-items-center gap-2">
                          <input type="hidden" name="accion" value="asignarRol"/>
                          <input type="hidden" name="NombreUsuario" value="<%= u.getNombreUsuario() %>"/>
                          <select name="Rol" class="form-select form-select-sm" style="width: auto;" required>
                            <option value="ADMINISTRADOR" <%= "ADMINISTRADOR".equalsIgnoreCase(r) ? "selected" : "" %>>Administrador</option>
                            <option value="ENFERMERO" <%= "ENFERMERO".equalsIgnoreCase(r) ? "selected" : "" %>>Enfermero</option>
                          </select>
                          <button type="submit" class="btn btn-sm btn-success d-inline-flex align-items-center gap-1">
                            <i class="bi bi-check2"></i> Asignar
                          </button>
                        </form>
                      </td>
                      <td class="pe-4">
                        <% if (esBloqueado) { %>
                        <form action="${pageContext.request.contextPath}/GestionarUsuariosServlet" method="POST" class="d-inline">
                          <input type="hidden" name="accion" value="desbloquear"/>
                          <input type="hidden" name="NombreUsuario" value="<%= u.getNombreUsuario() %>"/>
                          <button type="submit" class="btn btn-sm btn-outline-success d-inline-flex align-items-center gap-1">
                            <i class="bi bi-unlock-fill"></i> Desbloquear
                          </button>
                        </form>
                        <% } else { %>
                        <form action="${pageContext.request.contextPath}/GestionarUsuariosServlet" method="POST" class="d-inline">
                          <input type="hidden" name="accion" value="bloquear"/>
                          <input type="hidden" name="NombreUsuario" value="<%= u.getNombreUsuario() %>"/>
                          <button type="submit" class="btn btn-sm btn-danger d-inline-flex align-items-center gap-1">
                            <i class="bi bi-lock-fill"></i> Bloquear
                          </button>
                        </form>
                        <% } %>
                      </td>
                    </tr>
                    <% } %>
                  </tbody>
                </table>
              </div>
            </div>

            <div class="card-footer bg-light p-3 small text-muted border-0">
              <i class="bi bi-info-circle-fill me-1"></i>
              Los cambios de rol y bloqueos se aplican y guardan en MySQL inmediatamente en tiempo real.
            </div>
          </div>
        </main>
      </div>

    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
