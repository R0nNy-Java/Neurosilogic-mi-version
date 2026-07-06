<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
  if (nombreSesion == null) nombreSesion = (session != null) ? (String) session.getAttribute("usuario") : "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Gestionar Usuarios</title>
  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
  <style>
    :root { --nl-primary:#1a6b5e; --nl-primary-dark:#134f45; --nl-primary-light:#2a9d8a; --nl-accent:#e9f5f3; --nl-text:#1e2d2b; --nl-muted:#6c8c87; --nl-border:#d0e8e4; --nl-sidebar-bg:#0f3831; --nl-topbar-bg:#134f45; --nl-body-bg:#f0f7f6; --sidebar-width:240px; }
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    body { font-family:'Inter',sans-serif; background:var(--nl-body-bg); min-height:100vh; }

    /* SIDEBAR */
    #nl-sidebar { position:fixed; top:0; left:0; width:var(--sidebar-width); height:100vh; background:var(--nl-sidebar-bg); display:flex; flex-direction:column; z-index:1000; }
    .nl-sidebar-brand { display:flex; align-items:center; gap:12px; padding:22px 20px; border-bottom:1px solid rgba(255,255,255,0.08); text-decoration:none; }
    .nl-sidebar-brand-icon { width:38px; height:38px; background:var(--nl-primary-light); border-radius:10px; display:flex; align-items:center; justify-content:center; flex-shrink:0; }
    .nl-sidebar-brand-icon i { font-size:1.1rem; color:#fff; }
    .nl-sidebar-brand-text { font-size:1.05rem; font-weight:700; color:#fff; letter-spacing:1px; }
    .nl-sidebar-brand-sub  { font-size:0.62rem; color:rgba(255,255,255,0.45); }
    .nl-role-badge { margin:12px 16px 4px; padding:6px 12px; border-radius:20px; font-size:0.7rem; font-weight:700; text-align:center; background:rgba(99,179,237,0.18); color:#90cdf4; border:1px solid rgba(99,179,237,0.3); }
    .nl-nav-label { font-size:0.65rem; font-weight:600; color:rgba(255,255,255,0.3); text-transform:uppercase; letter-spacing:1px; padding:14px 20px 6px; }
    .nl-nav { list-style:none; padding:8px 12px; flex:1; }
    .nl-nav li { margin-bottom:4px; }
    .nl-nav a { display:flex; align-items:center; gap:12px; padding:11px 14px; border-radius:10px; text-decoration:none; color:rgba(255,255,255,0.65); font-size:0.88rem; font-weight:500; transition:background 0.18s,color 0.18s; }
    .nl-nav a:hover, .nl-nav a.active { background:var(--nl-primary); color:#fff; }
    .nl-nav a i { font-size:1rem; flex-shrink:0; }
    .nl-sidebar-footer { padding:16px; border-top:1px solid rgba(255,255,255,0.08); }
    .nl-sidebar-user { display:flex; align-items:center; gap:10px; }
    .nl-sidebar-avatar { width:36px; height:36px; background:var(--nl-primary); border-radius:50%; display:flex; align-items:center; justify-content:center; }
    .nl-sidebar-avatar i { font-size:1rem; color:#fff; }
    .nl-sidebar-username { font-size:0.82rem; font-weight:600; color:rgba(255,255,255,0.9); }
    .nl-sidebar-role { font-size:0.7rem; color:rgba(255,255,255,0.45); }
    .nl-sidebar-logout { display:flex; align-items:center; gap:8px; margin-top:10px; padding:8px 12px; border-radius:8px; text-decoration:none; color:rgba(255,255,255,0.55); font-size:0.8rem; transition:background 0.15s; }
    .nl-sidebar-logout:hover { background:rgba(255,255,255,0.08); color:rgba(255,255,255,0.9); }

    /* TOPBAR */
    #nl-topbar { position:fixed; top:0; left:var(--sidebar-width); right:0; height:62px; background:var(--nl-topbar-bg); display:flex; align-items:center; justify-content:space-between; padding:0 28px; z-index:999; box-shadow:0 2px 10px rgba(0,0,0,0.2); }
    .nl-topbar-title { font-size:1rem; font-weight:600; color:rgba(255,255,255,0.9); display:flex; align-items:center; gap:10px; }
    .nl-topbar-right { display:flex; align-items:center; gap:14px; }
    .nl-topbar-user  { font-size:0.82rem; color:rgba(255,255,255,0.7); display:flex; align-items:center; gap:7px; }
    .nl-btn-topbar   { background:rgba(255,255,255,0.12); border:1px solid rgba(255,255,255,0.2); color:rgba(255,255,255,0.85); font-size:0.82rem; font-family:'Inter',sans-serif; padding:7px 16px; border-radius:8px; cursor:pointer; display:flex; align-items:center; gap:6px; text-decoration:none; transition:background 0.15s; }
    .nl-btn-topbar:hover { background:rgba(255,255,255,0.22); color:#fff; }

    /* CONTENT */
    #nl-content { margin-left:var(--sidebar-width); padding-top:62px; }
    .nl-page-inner { padding:28px 30px 40px; }
    .nl-page-header { margin-bottom:24px; }
    .nl-page-title  { font-size:1.35rem; font-weight:700; color:var(--nl-text); display:flex; align-items:center; gap:10px; }
    .nl-page-subtitle { font-size:0.83rem; color:var(--nl-muted); margin-top:4px; }

    /* ALERTS */
    .nl-alert-success { background:#e9f5f3; border:1px solid #b2ddd6; border-radius:10px; color:#145c50; padding:11px 14px; margin-bottom:18px; font-size:0.83rem; display:flex; align-items:center; gap:8px; }
    .nl-alert-error   { background:#fff1f1; border:1px solid #f5c6c6; border-radius:10px; color:#a02020; padding:11px 14px; margin-bottom:18px; font-size:0.83rem; display:flex; align-items:center; gap:8px; }

    /* TABLE CARD */
    .nl-card { background:#fff; border-radius:14px; box-shadow:0 2px 14px rgba(26,107,94,0.09); overflow:hidden; margin-bottom:24px; }
    .nl-card-head { background:linear-gradient(135deg,#134f45,#2a9d8a); padding:18px 24px; display:flex; align-items:center; justify-content:space-between; }
    .nl-card-head-title { font-size:1rem; font-weight:700; color:#fff; display:flex; align-items:center; gap:10px; }
    .nl-card-head-sub   { font-size:0.76rem; color:rgba(255,255,255,0.7); margin-top:3px; }
    .nl-card-body { padding:0; }

    /* TABLE */
    .nl-table { width:100%; border-collapse:collapse; }
    .nl-table thead th { padding:12px 18px; font-size:0.75rem; font-weight:700; color:var(--nl-muted); text-transform:uppercase; letter-spacing:0.5px; background:#f7fcfb; border-bottom:2px solid var(--nl-border); text-align:left; }
    .nl-table tbody td { padding:14px 18px; font-size:0.88rem; color:var(--nl-text); border-bottom:1px solid #f0f7f6; vertical-align:middle; }
    .nl-table tbody tr:last-child td { border-bottom:none; }
    .nl-table tbody tr:hover { background:#f7fcfb; }

    /* BADGES */
    .badge-rol { display:inline-block; padding:4px 12px; border-radius:20px; font-size:0.72rem; font-weight:700; }
    .badge-admin     { background:#dbeafe; color:#1d4ed8; }
    .badge-enfermero { background:#d1fae5; color:#065f46; }
    .badge-pendiente { background:#fef3c7; color:#92400e; }

    .badge-estado { display:inline-block; padding:4px 10px; border-radius:20px; font-size:0.72rem; font-weight:700; }
    .badge-activo   { background:#d1fae5; color:#065f46; }
    .badge-bloqueado { background:#fee2e2; color:#991b1b; }

    /* BUTTONS inline */
    .nl-btn-sm { padding:6px 14px; border-radius:8px; font-size:0.78rem; font-weight:600; font-family:'Inter',sans-serif; border:none; cursor:pointer; display:inline-flex; align-items:center; gap:5px; transition:opacity 0.15s; }
    .nl-btn-sm:hover { opacity:0.85; }
    .nl-btn-primary { background:var(--nl-primary); color:#fff; }
    .nl-btn-warning { background:#f59e0b; color:#fff; }
    .nl-btn-danger  { background:#ef4444; color:#fff; }
    .nl-btn-success { background:#10b981; color:#fff; }

    /* Formulario inline de asignación de rol */
    .nl-inline-form { display:flex; align-items:center; gap:8px; }
    .nl-select-sm { padding:6px 10px; border:1.5px solid var(--nl-border); border-radius:8px; font-size:0.8rem; font-family:'Inter',sans-serif; color:var(--nl-text); background:#fff; outline:none; }
    .nl-select-sm:focus { border-color:var(--nl-primary-light); }
  </style>
</head>
<body>

  <!-- SIDEBAR -->
  <nav id="nl-sidebar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="nl-sidebar-brand">
      <div class="nl-sidebar-brand-icon"><i class="bi bi-heart-pulse-fill"></i></div>
      <div><div class="nl-sidebar-brand-text">NURSELOGIC</div><div class="nl-sidebar-brand-sub">Gestion Clinica</div></div>
    </a>
    <div class="nl-role-badge"><i class="bi bi-shield-fill me-1"></i>Administrador</div>
    <div class="nl-nav-label">Menu Principal</div>
    <ul class="nl-nav">
      <li><a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard"><i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span></a></li>
      <li><a href="${pageContext.request.contextPath}/GestionarUsuariosServlet" id="nav-usuarios" class="active"><i class="bi bi-people-fill"></i><span>Gestionar Usuarios</span></a></li>
      <li><a href="${pageContext.request.contextPath}/GestionarCatalogoServlet" id="nav-catalogo"><i class="bi bi-journal-medical"></i><span>Catalogo Medicamentos</span></a></li>
    </ul>
    <div class="nl-sidebar-footer">
      <div class="nl-sidebar-user">
        <div class="nl-sidebar-avatar"><i class="bi bi-person-fill"></i></div>
        <div>
          <div class="nl-sidebar-username"><%= nombreSesion %></div>
          <div class="nl-sidebar-role">Administrador</div>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" id="nav-logout" class="nl-sidebar-logout">
        <i class="bi bi-box-arrow-right"></i> Cerrar sesión
      </a>
    </div>
  </nav>

  <!-- TOPBAR -->
  <header id="nl-topbar">
    <div class="nl-topbar-title"><i class="bi bi-people-fill"></i> Gestión de Usuarios</div>
    <div class="nl-topbar-right">
      <span class="nl-topbar-user"><i class="bi bi-person-circle"></i> <%= nombreSesion %></span>
      <a href="${pageContext.request.contextPath}/LogoutServlet" id="btnLogoutTop" class="nl-btn-topbar"><i class="bi bi-box-arrow-right"></i> Salir</a>
    </div>
  </header>

  <!-- CONTENT -->
  <main id="nl-content">
    <div class="nl-page-inner">

      <div class="nl-page-header">
        <h1 class="nl-page-title"><i class="bi bi-people-fill" style="color:var(--nl-primary);"></i> Gestión de Usuarios</h1>
        <p class="nl-page-subtitle">Asigne roles, bloquee o desbloquee cuentas de acceso al sistema</p>
      </div>

      <%-- Mensajes del servlet --%>
      <%
        String successMsg = (String) request.getAttribute("successMsg");
        String errorMsg   = (String) request.getAttribute("errorMsg");
        if (successMsg != null && !successMsg.isEmpty()) {
      %>
      <div class="nl-alert-success"><i class="bi bi-check-circle-fill"></i><%= successMsg %></div>
      <% } %>
      <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="nl-alert-error"><i class="bi bi-exclamation-circle-fill"></i><%= errorMsg %></div>
      <% } %>

      <!-- TABLA DE USUARIOS -->
      <div class="nl-card">
        <div class="nl-card-head">
          <div>
            <div class="nl-card-head-title"><i class="bi bi-table"></i> Lista de Usuarios del Sistema</div>
            <div class="nl-card-head-sub">Gestione los accesos y roles de cada cuenta registrada</div>
          </div>
        </div>
        <div class="nl-card-body">
          <table class="nl-table" id="tablaUsuarios">
            <thead>
              <tr>
                <th>#</th>
                <th>Nombre Completo</th>
                <th>Usuario</th>
                <th>Correo</th>
                <th>Rol Actual</th>
                <th>Estado</th>
                <th>Asignar Rol</th>
                <th>Acciones</th>
              </tr>
            </thead>
            <tbody>

              <%-- ══ FILA DEMO 1: admin ══ --%>
              <tr id="row-admin">
                <td>1</td>
                <td><strong>Administrador del Sistema</strong></td>
                <td><code>admin</code></td>
                <td>admin@nurselogic.ec</td>
                <td><span class="badge-rol badge-admin">ADMINISTRADOR</span></td>
                <td><span class="badge-estado badge-activo">Activo</span></td>
                <td>
                  <form action="${pageContext.request.contextPath}/GestionarUsuariosServlet"
                        method="POST" class="nl-inline-form" id="formRol-admin">
                    <input type="hidden" name="accion" value="asignarRol"/>
                    <input type="hidden" name="NombreUsuario" value="admin"/>
                    <select name="Rol" class="nl-select-sm">
                      <option value="ADMINISTRADOR" selected>Administrador</option>
                      <option value="ENFERMERO">Enfermero</option>
                    </select>
                    <button type="submit" class="nl-btn-sm nl-btn-primary" id="btnRol-admin">
                      <i class="bi bi-check2"></i> Asignar
                    </button>
                  </form>
                </td>
                <td>
                  <form action="${pageContext.request.contextPath}/GestionarUsuariosServlet"
                        method="POST" style="display:inline;" id="formBlq-admin">
                    <input type="hidden" name="accion" value="bloquear"/>
                    <input type="hidden" name="NombreUsuario" value="admin"/>
                    <button type="submit" class="nl-btn-sm nl-btn-danger" id="btnBlq-admin">
                      <i class="bi bi-lock-fill"></i> Bloquear
                    </button>
                  </form>
                </td>
              </tr>

              <%-- ══ FILA DEMO 2: enfermero1 ══ --%>
              <tr id="row-enfermero1">
                <td>2</td>
                <td><strong>Maria Fernanda Lopez</strong></td>
                <td><code>enfermero1</code></td>
                <td>mlopez@nurselogic.ec</td>
                <td><span class="badge-rol badge-enfermero">ENFERMERO</span></td>
                <td><span class="badge-estado badge-activo">Activo</span></td>
                <td>
                  <form action="${pageContext.request.contextPath}/GestionarUsuariosServlet"
                        method="POST" class="nl-inline-form" id="formRol-enfermero1">
                    <input type="hidden" name="accion" value="asignarRol"/>
                    <input type="hidden" name="NombreUsuario" value="enfermero1"/>
                    <select name="Rol" class="nl-select-sm">
                      <option value="ADMINISTRADOR">Administrador</option>
                      <option value="ENFERMERO" selected>Enfermero</option>
                    </select>
                    <button type="submit" class="nl-btn-sm nl-btn-primary" id="btnRol-enfermero1">
                      <i class="bi bi-check2"></i> Asignar
                    </button>
                  </form>
                </td>
                <td>
                  <form action="${pageContext.request.contextPath}/GestionarUsuariosServlet"
                        method="POST" style="display:inline;" id="formBlq-enfermero1">
                    <input type="hidden" name="accion" value="bloquear"/>
                    <input type="hidden" name="NombreUsuario" value="enfermero1"/>
                    <button type="submit" class="nl-btn-sm nl-btn-danger" id="btnBlq-enfermero1">
                      <i class="bi bi-lock-fill"></i> Bloquear
                    </button>
                  </form>
                </td>
              </tr>

              <%-- ══ FILA DEMO 3: enfermero2 ══ --%>
              <tr id="row-enfermero2">
                <td>3</td>
                <td><strong>Carlos Eduardo Vega</strong></td>
                <td><code>enfermero2</code></td>
                <td>cvega@nurselogic.ec</td>
                <td><span class="badge-rol badge-enfermero">ENFERMERO</span></td>
                <td><span class="badge-estado badge-activo">Activo</span></td>
                <td>
                  <form action="${pageContext.request.contextPath}/GestionarUsuariosServlet"
                        method="POST" class="nl-inline-form" id="formRol-enfermero2">
                    <input type="hidden" name="accion" value="asignarRol"/>
                    <input type="hidden" name="NombreUsuario" value="enfermero2"/>
                    <select name="Rol" class="nl-select-sm">
                      <option value="ADMINISTRADOR">Administrador</option>
                      <option value="ENFERMERO" selected>Enfermero</option>
                    </select>
                    <button type="submit" class="nl-btn-sm nl-btn-primary" id="btnRol-enfermero2">
                      <i class="bi bi-check2"></i> Asignar
                    </button>
                  </form>
                </td>
                <td>
                  <form action="${pageContext.request.contextPath}/GestionarUsuariosServlet"
                        method="POST" style="display:inline;" id="formBlq-enfermero2">
                    <input type="hidden" name="accion" value="bloquear"/>
                    <input type="hidden" name="NombreUsuario" value="enfermero2"/>
                    <button type="submit" class="nl-btn-sm nl-btn-danger" id="btnBlq-enfermero2">
                      <i class="bi bi-lock-fill"></i> Bloquear
                    </button>
                  </form>
                </td>
              </tr>

              <%-- ══ FILA DEMO 4: usuario PENDIENTE (recién registrado) ══ --%>
              <tr id="row-pendiente1" style="background:#fffdf0;">
                <td>4</td>
                <td><strong>Ana Lucia Moreno</strong></td>
                <td><code>amoreno</code></td>
                <td>amoreno@nurselogic.ec</td>
                <td><span class="badge-rol badge-pendiente">⏳ PENDIENTE</span></td>
                <td><span class="badge-estado badge-activo">Activo</span></td>
                <td>
                  <form action="${pageContext.request.contextPath}/GestionarUsuariosServlet"
                        method="POST" class="nl-inline-form" id="formRol-amoreno">
                    <input type="hidden" name="accion" value="asignarRol"/>
                    <input type="hidden" name="NombreUsuario" value="amoreno"/>
                    <select name="Rol" class="nl-select-sm">
                      <option value="" disabled selected>-- Asignar --</option>
                      <option value="ADMINISTRADOR">Administrador</option>
                      <option value="ENFERMERO">Enfermero</option>
                    </select>
                    <button type="submit" class="nl-btn-sm nl-btn-warning" id="btnRol-amoreno">
                      <i class="bi bi-check2"></i> Asignar
                    </button>
                  </form>
                </td>
                <td>
                  <form action="${pageContext.request.contextPath}/GestionarUsuariosServlet"
                        method="POST" style="display:inline;" id="formBlq-amoreno">
                    <input type="hidden" name="accion" value="bloquear"/>
                    <input type="hidden" name="NombreUsuario" value="amoreno"/>
                    <button type="submit" class="nl-btn-sm nl-btn-danger" id="btnBlq-amoreno">
                      <i class="bi bi-lock-fill"></i> Bloquear
                    </button>
                  </form>
                </td>
              </tr>

            </tbody>
          </table>
        </div>
      </div><!-- /.nl-card tabla -->

    </div><!-- /.nl-page-inner -->
  </main>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
