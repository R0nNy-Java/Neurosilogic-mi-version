<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  /* ── Determinar el rol del usuario en sesión ── */
  String rolSesion    = (session != null) ? (String) session.getAttribute("rol")            : "";
  String usuarioSesion= (session != null) ? (String) session.getAttribute("usuario")         : "usuario";
  String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto")  : usuarioSesion;
  if (nombreSesion == null) nombreSesion = usuarioSesion;

  boolean esAdmin = "ADMINISTRADOR".equals(rolSesion);
  String  tituloRol = esAdmin ? "Administrador" : "Enfermero/a";
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <meta name="description" content="NURSELOGIC - Panel de Control Principal"/>
  <title>NURSELOGIC | Dashboard <%= esAdmin ? "– Administrador" : "– Enfermero" %></title>

  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>

  <style>
    :root {
      --nl-primary:       #1a6b5e;
      --nl-primary-dark:  #134f45;
      --nl-primary-light: #2a9d8a;
      --nl-accent:        #e9f5f3;
      --nl-text:          #1e2d2b;
      --nl-muted:         #6c8c87;
      --nl-border:        #d0e8e4;
      --nl-sidebar-bg:    #0f3831;
      --nl-topbar-bg:     #134f45;
      --nl-body-bg:       #f0f7f6;
      --sidebar-width:    240px;
    }
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: 'Inter', sans-serif; background: var(--nl-body-bg); color: var(--nl-text); min-height: 100vh; }

    /* ── SIDEBAR ── */
    #nl-sidebar {
      position: fixed; top: 0; left: 0;
      width: var(--sidebar-width); height: 100vh;
      background: var(--nl-sidebar-bg);
      display: flex; flex-direction: column; z-index: 1000;
    }
    .nl-sidebar-brand {
      display: flex; align-items: center; gap: 12px;
      padding: 22px 20px; border-bottom: 1px solid rgba(255,255,255,0.08);
      text-decoration: none;
    }
    .nl-sidebar-brand-icon {
      width: 38px; height: 38px; background: var(--nl-primary-light);
      border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;
    }
    .nl-sidebar-brand-icon i { font-size: 1.1rem; color: #fff; }
    .nl-sidebar-brand-text { font-size: 1.05rem; font-weight: 700; color: #fff; letter-spacing: 1px; }
    .nl-sidebar-brand-sub  { font-size: 0.62rem; color: rgba(255,255,255,0.45); }

    /* Rol badge en sidebar */
    .nl-role-badge {
      margin: 12px 16px 4px;
      padding: 6px 12px; border-radius: 20px; font-size: 0.7rem; font-weight: 700;
      text-align: center; letter-spacing: 0.5px;
    }
    .nl-role-admin { background: rgba(99,179,237,0.18); color: #90cdf4; border: 1px solid rgba(99,179,237,0.3); }
    .nl-role-enfermero { background: rgba(42,157,138,0.18); color: #81e6d9; border: 1px solid rgba(42,157,138,0.3); }

    .nl-nav-label { font-size: 0.65rem; font-weight: 600; color: rgba(255,255,255,0.3); text-transform: uppercase; letter-spacing: 1px; padding: 14px 20px 6px; }
    .nl-nav { list-style: none; padding: 8px 12px; flex: 1; }
    .nl-nav li { margin-bottom: 4px; }
    .nl-nav a {
      display: flex; align-items: center; gap: 12px; padding: 11px 14px;
      border-radius: 10px; text-decoration: none; color: rgba(255,255,255,0.65);
      font-size: 0.88rem; font-weight: 500; transition: background 0.18s, color 0.18s;
    }
    .nl-nav a:hover, .nl-nav a.active { background: var(--nl-primary); color: #fff; }
    .nl-nav a i { font-size: 1rem; flex-shrink: 0; }

    /* Sidebar footer */
    .nl-sidebar-footer { padding: 16px; border-top: 1px solid rgba(255,255,255,0.08); }
    .nl-sidebar-user { display: flex; align-items: center; gap: 10px; }
    .nl-sidebar-avatar { width: 36px; height: 36px; background: var(--nl-primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
    .nl-sidebar-avatar i { font-size: 1rem; color: #fff; }
    .nl-sidebar-username { font-size: 0.82rem; font-weight: 600; color: rgba(255,255,255,0.9); white-space: nowrap; overflow: hidden; text-overflow: ellipsis; max-width: 140px; }
    .nl-sidebar-role { font-size: 0.7rem; color: rgba(255,255,255,0.45); margin-top: 2px; }
    .nl-sidebar-logout { display: flex; align-items: center; gap: 8px; margin-top: 10px; padding: 8px 12px; border-radius: 8px; text-decoration: none; color: rgba(255,255,255,0.55); font-size: 0.8rem; transition: background 0.15s; }
    .nl-sidebar-logout:hover { background: rgba(255,255,255,0.08); color: rgba(255,255,255,0.9); }

    /* ── TOPBAR ── */
    #nl-topbar {
      position: fixed; top: 0; left: var(--sidebar-width); right: 0; height: 62px;
      background: var(--nl-topbar-bg); display: flex; align-items: center;
      justify-content: space-between; padding: 0 28px; z-index: 999;
      box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    }
    .nl-topbar-title { font-size: 1rem; font-weight: 600; color: rgba(255,255,255,0.9); display: flex; align-items: center; gap: 10px; }
    .nl-topbar-title i { font-size: 1.1rem; }
    .nl-topbar-right  { display: flex; align-items: center; gap: 14px; }
    .nl-topbar-user   { font-size: 0.82rem; color: rgba(255,255,255,0.7); display: flex; align-items: center; gap:7px; }
    .nl-btn-topbar    { background: rgba(255,255,255,0.12); border: 1px solid rgba(255,255,255,0.2); color: rgba(255,255,255,0.85); font-size: 0.82rem; font-family: 'Inter',sans-serif; padding: 7px 16px; border-radius: 8px; cursor: pointer; display: flex; align-items: center; gap: 6px; text-decoration: none; transition: background 0.15s; }
    .nl-btn-topbar:hover { background: rgba(255,255,255,0.22); color: #fff; }

    /* ── CONTENT ── */
    #nl-content { margin-left: var(--sidebar-width); padding-top: 62px; }
    .nl-page-inner { padding: 28px 30px 40px; }

    /* ── PAGE HEADER ── */
    .nl-page-header { margin-bottom: 28px; }
    .nl-page-title  { font-size: 1.4rem; font-weight: 700; color: var(--nl-text); display: flex; align-items: center; gap: 10px; }
    .nl-page-subtitle { font-size: 0.83rem; color: var(--nl-muted); margin-top: 5px; }

    /* ── STAT CARDS ── */
    .nl-stats-grid { display: grid; gap: 18px; margin-bottom: 30px; }
    .nl-stats-grid.cols-3 { grid-template-columns: repeat(3, 1fr); }
    .nl-stats-grid.cols-4 { grid-template-columns: repeat(4, 1fr); }

    .nl-stat-card {
      background: #fff; border-radius: 14px; padding: 22px 20px;
      box-shadow: 0 2px 14px rgba(26,107,94,0.08);
      display: flex; align-items: center; gap: 16px;
      border-left: 4px solid transparent;
      transition: transform 0.2s, box-shadow 0.2s;
    }
    .nl-stat-card:hover { transform: translateY(-3px); box-shadow: 0 8px 24px rgba(26,107,94,0.14); }
    .nl-stat-icon { width: 52px; height: 52px; border-radius: 12px; display: flex; align-items: center; justify-content: center; flex-shrink: 0; }
    .nl-stat-icon i { font-size: 1.4rem; }
    .nl-stat-value { font-size: 1.9rem; font-weight: 700; color: var(--nl-text); line-height: 1; }
    .nl-stat-label { font-size: 0.78rem; color: var(--nl-muted); margin-top: 4px; font-weight: 500; }
    .nl-stat-badge { display: inline-block; font-size: 0.68rem; font-weight: 600; padding: 2px 8px; border-radius: 10px; margin-top: 5px; }

    /* Color temas */
    .theme-teal   { border-color: #2a9d8a; } .theme-teal   .nl-stat-icon { background: #e9f5f3; color: #1a6b5e; }
    .theme-blue   { border-color: #4299e1; } .theme-blue   .nl-stat-icon { background: #ebf8ff; color: #2b6cb0; }
    .theme-amber  { border-color: #f6ad55; } .theme-amber  .nl-stat-icon { background: #fffaf0; color: #c05621; }
    .theme-red    { border-color: #fc8181; } .theme-red    .nl-stat-icon { background: #fff5f5; color: #c53030; }
    .theme-purple { border-color: #b794f4; } .theme-purple .nl-stat-icon { background: #faf5ff; color: #6b46c1; }
    .theme-green  { border-color: #68d391; } .theme-green  .nl-stat-icon { background: #f0fff4; color: #276749; }

    /* ── QUICK ACTIONS ── */
    .nl-section-title { font-size: 0.75rem; font-weight: 700; color: var(--nl-muted); text-transform: uppercase; letter-spacing: 0.7px; margin-bottom: 14px; }
    .nl-actions-grid  { display: grid; gap: 14px; }
    .nl-actions-grid.cols-2 { grid-template-columns: 1fr 1fr; }
    .nl-actions-grid.cols-3 { grid-template-columns: repeat(3, 1fr); }

    .nl-action-card {
      background: #fff; border-radius: 14px; padding: 22px 20px;
      box-shadow: 0 2px 14px rgba(26,107,94,0.07);
      display: flex; flex-direction: column; align-items: flex-start; gap: 12px;
      text-decoration: none; color: var(--nl-text);
      border: 1.5px solid var(--nl-border);
      transition: all 0.2s;
    }
    .nl-action-card:hover { border-color: var(--nl-primary-light); background: var(--nl-accent); color: var(--nl-primary); transform: translateY(-2px); box-shadow: 0 8px 22px rgba(26,107,94,0.13); }
    .nl-action-icon { width: 46px; height: 46px; background: var(--nl-accent); border-radius: 12px; display: flex; align-items: center; justify-content: center; }
    .nl-action-icon i { font-size: 1.3rem; color: var(--nl-primary); }
    .nl-action-card:hover .nl-action-icon { background: var(--nl-primary); }
    .nl-action-card:hover .nl-action-icon i { color: #fff; }
    .nl-action-title { font-size: 0.95rem; font-weight: 700; }
    .nl-action-desc  { font-size: 0.78rem; color: var(--nl-muted); margin-top: -6px; }
    .nl-action-arrow { margin-top: auto; font-size: 0.78rem; color: var(--nl-muted); display: flex; align-items: center; gap: 4px; }

    /* ── INFO BANNER ── */
    .nl-info-banner {
      background: linear-gradient(135deg, #134f45, #1a6b5e);
      border-radius: 14px; padding: 22px 26px; margin-bottom: 26px;
      display: flex; align-items: center; gap: 18px;
      box-shadow: 0 4px 16px rgba(19,79,69,0.25);
    }
    .nl-info-banner-icon { font-size: 2.2rem; color: rgba(255,255,255,0.8); }
    .nl-info-banner h2   { font-size: 1.15rem; font-weight: 700; color: #fff; margin-bottom: 4px; }
    .nl-info-banner p    { font-size: 0.82rem; color: rgba(255,255,255,0.72); }

    /* ── ALERT INFO en content ── */
    .nl-content-alert { border-radius: 10px; padding: 12px 16px; margin-bottom: 20px; font-size: 0.83rem; display: flex; align-items: center; gap: 10px; }
    .nl-content-alert.warn { background: #fff8e1; border: 1px solid #ffe082; color: #795548; }
    .nl-content-alert.err  { background: #fff1f1; border: 1px solid #f5c6c6; color: #a02020; }
  </style>
</head>
<body>

  <!-- ══════════════════════════════════════════════════
       SIDEBAR  –  contenido diferente según ROL
       ══════════════════════════════════════════════════ -->
  <nav id="nl-sidebar">

    <a href="${pageContext.request.contextPath}/index.jsp" class="nl-sidebar-brand">
      <div class="nl-sidebar-brand-icon"><i class="bi bi-heart-pulse-fill"></i></div>
      <div>
        <div class="nl-sidebar-brand-text">NURSELOGIC</div>
        <div class="nl-sidebar-brand-sub">Gestion Clinica · Ecuador</div>
      </div>
    </a>

    <!-- Badge de rol -->
    <div class="nl-role-badge <%= esAdmin ? "nl-role-admin" : "nl-role-enfermero" %>">
      <i class="bi bi-<%= esAdmin ? "shield-fill" : "person-fill-check" %> me-1"></i>
      <%= tituloRol %>
    </div>

    <div class="nl-nav-label">Menu Principal</div>

    <ul class="nl-nav">
      <!-- Item común: Dashboard -->
      <li>
        <a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard" class="active">
          <i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span>
        </a>
      </li>

      <%-- ── Menú ADMINISTRADOR ── --%>
      <% if (esAdmin) { %>
      <li>
        <a href="${pageContext.request.contextPath}/GestionarUsuariosServlet" id="nav-usuarios">
          <i class="bi bi-people-fill"></i><span>Gestionar Usuarios</span>
        </a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/GestionarCatalogoServlet" id="nav-catalogo">
          <i class="bi bi-journal-medical"></i><span>Catalogo Medicamentos</span>
        </a>
      </li>

      <%-- ── Menú ENFERMERO (8 módulos) ── --%>
      <% } else { %>
      <li>
        <a href="${pageContext.request.contextPath}/PacientesServlet" id="nav-pacientes">
          <i class="bi bi-person-vcard-fill"></i><span>Gestionar Pacientes</span>
        </a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos">
          <i class="bi bi-activity"></i><span>Signos Vitales</span>
        </a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/GlasgowServlet" id="nav-glasgow">
          <i class="bi bi-clipboard2-data-fill"></i><span>Escala Glasgow</span>
        </a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/DosificacionServlet" id="nav-dosificacion">
          <i class="bi bi-droplet-fill"></i><span>Calcular Dosis</span>
        </a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/AdministracionServlet" id="nav-admin">
          <i class="bi bi-clipboard2-check-fill"></i><span>Administracion</span>
        </a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/ReportesServlet" id="nav-reportes">
          <i class="bi bi-graph-up-arrow"></i><span>Reportes</span>
        </a>
      </li>
      <li>
        <a href="${pageContext.request.contextPath}/calculadora.jsp" id="nav-imc">
          <i class="bi bi-calculator-fill"></i><span>Calculadora IMC</span>
        </a>
      </li>
      <% } %>
    </ul>

    <!-- Footer del sidebar -->
    <div class="nl-sidebar-footer">
      <div class="nl-sidebar-user">
        <div class="nl-sidebar-avatar"><i class="bi bi-person-fill"></i></div>
        <div>
          <div class="nl-sidebar-username"><%= nombreSesion %></div>
          <div class="nl-sidebar-role"><%= tituloRol %></div>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/CambioContrasenaServlet"
         id="nav-cambiopass" class="nl-sidebar-logout">
        <i class="bi bi-key"></i> Cambiar contraseña
      </a>
      <a href="${pageContext.request.contextPath}/LogoutServlet"
         id="nav-logout" class="nl-sidebar-logout">
        <i class="bi bi-box-arrow-right"></i> Cerrar sesión
      </a>
    </div>

  </nav><!-- /#nl-sidebar -->


  <!-- ══ TOPBAR ══ -->
  <header id="nl-topbar">
    <div class="nl-topbar-title">
      <i class="bi bi-grid-1x2-fill"></i>
      Dashboard · <%= esAdmin ? "Panel de Administración" : "Panel de Enfermería" %>
    </div>
    <div class="nl-topbar-right">
      <span class="nl-topbar-user">
        <i class="bi bi-person-circle"></i> <%= nombreSesion %>
      </span>
      <a href="${pageContext.request.contextPath}/LogoutServlet"
         id="btnLogoutTop" class="nl-btn-topbar">
        <i class="bi bi-box-arrow-right"></i> Salir
      </a>
    </div>
  </header>


  <!-- ══════════════════════════════════════════════════
       CONTENT  –  diferente según ROL
       ══════════════════════════════════════════════════ -->
  <main id="nl-content">
    <div class="nl-page-inner">

      <%-- Alerta de error genérico (desde redirect ?error=...) --%>
      <%
        String errParam = request.getParameter("error");
        String infoMsg  = (String) request.getAttribute("infoMsg");
        if (errParam != null && !errParam.isEmpty()) {
      %>
      <div class="nl-content-alert err"><i class="bi bi-exclamation-circle-fill"></i><%= errParam %></div>
      <% } %>
      <% if (infoMsg != null && !infoMsg.isEmpty()) { %>
      <div class="nl-content-alert warn"><i class="bi bi-info-circle-fill"></i><%= infoMsg %></div>
      <% } %>


      <%-- ══════════════════════════════════════════════
           DASHBOARD ADMINISTRADOR
           ══════════════════════════════════════════════ --%>
      <% if (esAdmin) { %>

      <!-- Banner de bienvenida -->
      <div class="nl-info-banner">
        <i class="bi bi-shield-check nl-info-banner-icon"></i>
        <div>
          <h2>Panel de Administración · NURSELOGIC</h2>
          <p>Bienvenido, <strong><%= nombreSesion %></strong>. Desde aquí gestiona usuarios del sistema y el catálogo de medicamentos.</p>
        </div>
      </div>

      <!-- Page header -->
      <div class="nl-page-header">
        <h1 class="nl-page-title">
          <i class="bi bi-speedometer2" style="color:var(--nl-primary);"></i>
          Resumen del Sistema
        </h1>
        <p class="nl-page-subtitle">Estado general de NURSELOGIC</p>
      </div>

      <!-- Stats Admin -->
      <div class="nl-stats-grid cols-4">
        <div class="nl-stat-card theme-blue">
          <div class="nl-stat-icon"><i class="bi bi-people-fill"></i></div>
          <div>
            <div class="nl-stat-value">3</div>
            <div class="nl-stat-label">Usuarios Registrados</div>
          </div>
        </div>
        <div class="nl-stat-card theme-amber">
          <div class="nl-stat-icon"><i class="bi bi-person-exclamation"></i></div>
          <div>
            <div class="nl-stat-value">1</div>
            <div class="nl-stat-label">Pendientes de Rol</div>
            <span class="nl-stat-badge" style="background:#fff8e1;color:#c05621;">Requiere acción</span>
          </div>
        </div>
        <div class="nl-stat-card theme-teal">
          <div class="nl-stat-icon"><i class="bi bi-journal-medical"></i></div>
          <div>
            <div class="nl-stat-value">12</div>
            <div class="nl-stat-label">Medicamentos en Catálogo</div>
          </div>
        </div>
        <div class="nl-stat-card theme-green">
          <div class="nl-stat-icon"><i class="bi bi-shield-check"></i></div>
          <div>
            <div class="nl-stat-value">2</div>
            <div class="nl-stat-label">Cuentas Activas</div>
          </div>
        </div>
      </div>

      <!-- Acciones rápidas Admin -->
      <p class="nl-section-title"><i class="bi bi-lightning-fill me-1"></i>Acciones Rápidas</p>
      <div class="nl-actions-grid cols-2">

        <a href="${pageContext.request.contextPath}/GestionarUsuariosServlet"
           id="card-gestUsuarios" class="nl-action-card">
          <div class="nl-action-icon"><i class="bi bi-people-fill"></i></div>
          <div class="nl-action-title">Gestionar Usuarios</div>
          <div class="nl-action-desc">Asignar roles, bloquear o desbloquear cuentas de acceso</div>
          <div class="nl-action-arrow"><i class="bi bi-arrow-right-circle"></i> Ir al módulo</div>
        </a>

        <a href="${pageContext.request.contextPath}/GestionarCatalogoServlet"
           id="card-gestCatalogo" class="nl-action-card">
          <div class="nl-action-icon"><i class="bi bi-journal-medical"></i></div>
          <div class="nl-action-title">Catálogo de Medicamentos</div>
          <div class="nl-action-desc">Agregar, editar o eliminar medicamentos del sistema</div>
          <div class="nl-action-arrow"><i class="bi bi-arrow-right-circle"></i> Ir al módulo</div>
        </a>

      </div>

      <%-- ══════════════════════════════════════════════
           DASHBOARD ENFERMERO
           ══════════════════════════════════════════════ --%>
      <% } else { %>

      <!-- Banner de bienvenida -->
      <div class="nl-info-banner">
        <i class="bi bi-heart-pulse nl-info-banner-icon"></i>
        <div>
          <h2>Panel de Enfermería · NURSELOGIC</h2>
          <p>Bienvenido/a, <strong><%= nombreSesion %></strong>. Registre pacientes y gestione sus signos vitales.</p>
        </div>
      </div>

      <!-- Page header -->
      <div class="nl-page-header">
        <h1 class="nl-page-title">
          <i class="bi bi-speedometer2" style="color:var(--nl-primary);"></i>
          Resumen de Actividad
        </h1>
        <p class="nl-page-subtitle">Estado actual del servicio de enfermería</p>
      </div>

      <!-- Stats Enfermero (5 tarjetas) -->
      <div class="nl-stats-grid cols-4">
        <div class="nl-stat-card theme-teal">
          <div class="nl-stat-icon"><i class="bi bi-person-vcard-fill"></i></div>
          <div>
            <div class="nl-stat-value">0</div>
            <div class="nl-stat-label">Pacientes Registrados</div>
          </div>
        </div>
        <div class="nl-stat-card theme-blue">
          <div class="nl-stat-icon"><i class="bi bi-activity"></i></div>
          <div>
            <div class="nl-stat-value">0</div>
            <div class="nl-stat-label">Signos Vitales Hoy</div>
          </div>
        </div>
        <div class="nl-stat-card theme-red">
          <div class="nl-stat-icon"><i class="bi bi-exclamation-triangle-fill"></i></div>
          <div>
            <div class="nl-stat-value">0</div>
            <div class="nl-stat-label">Alertas Activas</div>
          </div>
        </div>
        <div class="nl-stat-card theme-green">
          <div class="nl-stat-icon"><i class="bi bi-clipboard2-check-fill"></i></div>
          <div>
            <div class="nl-stat-value">0</div>
            <div class="nl-stat-label">Administraciones Hoy</div>
          </div>
        </div>
      </div>

      <!-- Acciones rapidas Enfermero (7 modulos) -->
      <p class="nl-section-title"><i class="bi bi-lightning-fill me-1"></i>Modulos de Enfermeria</p>
      <div class="nl-actions-grid" style="grid-template-columns: repeat(4, 1fr);">

        <a href="${pageContext.request.contextPath}/PacientesServlet"
           id="card-pacientes" class="nl-action-card">
          <div class="nl-action-icon"><i class="bi bi-person-vcard-fill"></i></div>
          <div class="nl-action-title">Gestionar Pacientes</div>
          <div class="nl-action-desc">Ficha clinica digital con antecedentes y alergias</div>
          <div class="nl-action-arrow"><i class="bi bi-arrow-right-circle"></i> Ir al modulo</div>
        </a>

        <a href="${pageContext.request.contextPath}/SignosVitalesServlet"
           id="card-signos" class="nl-action-card">
          <div class="nl-action-icon"><i class="bi bi-activity"></i></div>
          <div class="nl-action-title">Signos Vitales</div>
          <div class="nl-action-desc">Registro con alertas cromaticas ROJO/AZUL automaticas</div>
          <div class="nl-action-arrow"><i class="bi bi-arrow-right-circle"></i> Ir al modulo</div>
        </a>

        <a href="${pageContext.request.contextPath}/GlasgowServlet"
           id="card-glasgow" class="nl-action-card">
          <div class="nl-action-icon"><i class="bi bi-clipboard2-data-fill"></i></div>
          <div class="nl-action-title">Escala Glasgow</div>
          <div class="nl-action-desc">Evaluacion de conciencia: Ocular + Verbal + Motor</div>
          <div class="nl-action-arrow"><i class="bi bi-arrow-right-circle"></i> Ir al modulo</div>
        </a>

        <a href="${pageContext.request.contextPath}/DosificacionServlet"
           id="card-dosis" class="nl-action-card">
          <div class="nl-action-icon"><i class="bi bi-droplet-fill"></i></div>
          <div class="nl-action-title">Calcular Dosis</div>
          <div class="nl-action-desc">Regla de tres con conversion g/mg/mcg y L/mL</div>
          <div class="nl-action-arrow"><i class="bi bi-arrow-right-circle"></i> Ir al modulo</div>
        </a>

        <a href="${pageContext.request.contextPath}/AdministracionServlet"
           id="card-admin" class="nl-action-card">
          <div class="nl-action-icon"><i class="bi bi-clipboard2-check-fill"></i></div>
          <div class="nl-action-title">Administracion</div>
          <div class="nl-action-desc">Registro de administracion de medicamentos y trazabilidad</div>
          <div class="nl-action-arrow"><i class="bi bi-arrow-right-circle"></i> Ir al modulo</div>
        </a>

        <a href="${pageContext.request.contextPath}/ReportesServlet"
           id="card-reportes" class="nl-action-card">
          <div class="nl-action-icon"><i class="bi bi-graph-up-arrow"></i></div>
          <div class="nl-action-title">Reportes</div>
          <div class="nl-action-desc">Tendencias de signos vitales con filtro por turno</div>
          <div class="nl-action-arrow"><i class="bi bi-arrow-right-circle"></i> Ir al modulo</div>
        </a>

        <a href="${pageContext.request.contextPath}/calculadora.jsp"
           id="card-imc" class="nl-action-card">
          <div class="nl-action-icon"><i class="bi bi-calculator-fill"></i></div>
          <div class="nl-action-title">Calculadora IMC</div>
          <div class="nl-action-desc">IMC = peso(kg) / estatura(m)² con clasificacion cromatica</div>
          <div class="nl-action-arrow"><i class="bi bi-arrow-right-circle"></i> Calcular</div>
        </a>

      </div>
      <% } %>

    </div><!-- /.nl-page-inner -->
  </main>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

</body>
</html>
