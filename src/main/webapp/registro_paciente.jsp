<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <meta name="description" content="NURSELOGIC - Apertura de Ficha Clinica"/>
  <title>NURSELOGIC | Apertura de Ficha Clinica</title>

  <!-- Bootstrap 5 CSS (local) -->
  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>

  <!-- Google Fonts: Inter -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>

  <!-- Bootstrap Icons -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>

  <style>
    /* =================================================
       NURSELOGIC – REGISTRO PACIENTE (Dashtreme Clean)
       ================================================= */
    :root {
      --nl-primary:       #1a6b5e;
      --nl-primary-dark:  #134f45;
      --nl-primary-light: #2a9d8a;
      --nl-accent:        #e9f5f3;
      --nl-text:          #1e2d2b;
      --nl-muted:         #6c8c87;
      --nl-border:        #d0e8e4;
      --nl-sidebar-bg:    #0f3831;
      --nl-sidebar-hover: #1a6b5e;
      --nl-topbar-bg:     #134f45;
      --nl-body-bg:       #f0f7f6;
      --nl-white:         #ffffff;
      --sidebar-width:    240px;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Inter', sans-serif;
      background-color: var(--nl-body-bg);
      color: var(--nl-text);
      min-height: 100vh;
    }

    /* =============================================
       SIDEBAR
       ============================================= */
    #nl-sidebar {
      position: fixed;
      top: 0; left: 0;
      width: var(--sidebar-width);
      height: 100vh;
      background: var(--nl-sidebar-bg);
      display: flex;
      flex-direction: column;
      z-index: 1000;
      transition: width 0.25s ease;
      overflow-x: hidden;
    }

    /* Brand */
    .nl-sidebar-brand {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 22px 20px;
      border-bottom: 1px solid rgba(255,255,255,0.1);
      text-decoration: none;
    }

    .nl-sidebar-brand-icon {
      width: 38px; height: 38px;
      background: var(--nl-primary-light);
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    .nl-sidebar-brand-icon i { font-size: 1.1rem; color: #fff; }

    .nl-sidebar-brand-text {
      font-size: 1.05rem;
      font-weight: 700;
      color: #fff;
      letter-spacing: 1px;
    }

    .nl-sidebar-brand-sub {
      font-size: 0.62rem;
      color: rgba(255,255,255,0.5);
      letter-spacing: 0.3px;
    }

    /* Nav section label */
    .nl-nav-label {
      font-size: 0.65rem;
      font-weight: 600;
      color: rgba(255,255,255,0.35);
      text-transform: uppercase;
      letter-spacing: 1px;
      padding: 18px 20px 6px;
    }

    /* Nav items */
    .nl-nav {
      list-style: none;
      padding: 8px 12px;
      flex: 1;
    }

    .nl-nav li { margin-bottom: 4px; }

    .nl-nav a {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 11px 14px;
      border-radius: 10px;
      text-decoration: none;
      color: rgba(255,255,255,0.7);
      font-size: 0.88rem;
      font-weight: 500;
      transition: background 0.18s, color 0.18s;
    }

    .nl-nav a:hover {
      background: var(--nl-sidebar-hover);
      color: #fff;
    }

    .nl-nav a.active {
      background: var(--nl-primary-light);
      color: #fff;
      font-weight: 600;
      box-shadow: 0 4px 12px rgba(42,157,138,0.35);
    }

    .nl-nav a i { font-size: 1rem; flex-shrink: 0; }

    /* Sidebar footer */
    .nl-sidebar-footer {
      padding: 16px 20px;
      border-top: 1px solid rgba(255,255,255,0.08);
    }

    .nl-sidebar-user {
      display: flex;
      align-items: center;
      gap: 10px;
      text-decoration: none;
    }

    .nl-sidebar-avatar {
      width: 34px; height: 34px;
      background: var(--nl-primary-light);
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    .nl-sidebar-avatar i { font-size: 0.95rem; color: #fff; }

    .nl-sidebar-username {
      font-size: 0.83rem;
      font-weight: 600;
      color: rgba(255,255,255,0.85);
    }

    .nl-sidebar-role {
      font-size: 0.68rem;
      color: rgba(255,255,255,0.45);
    }

    /* =============================================
       TOPBAR
       ============================================= */
    #nl-topbar {
      position: fixed;
      top: 0;
      left: var(--sidebar-width);
      right: 0;
      height: 62px;
      background: var(--nl-topbar-bg);
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 0 28px;
      z-index: 999;
      box-shadow: 0 2px 10px rgba(0,0,0,0.2);
    }

    .nl-topbar-left {
      display: flex;
      align-items: center;
      gap: 14px;
    }

    /* Toggle button (mobile) */
    #nl-sidebar-toggle {
      background: none;
      border: none;
      color: rgba(255,255,255,0.75);
      font-size: 1.3rem;
      cursor: pointer;
      display: flex;
      align-items: center;
      padding: 4px 8px;
      border-radius: 8px;
      transition: background 0.15s;
    }

    #nl-sidebar-toggle:hover { background: rgba(255,255,255,0.1); }

    .nl-topbar-breadcrumb {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 0.83rem;
      color: rgba(255,255,255,0.6);
    }

    .nl-topbar-breadcrumb span.current {
      color: rgba(255,255,255,0.9);
      font-weight: 600;
    }

    .nl-topbar-right {
      display: flex;
      align-items: center;
      gap: 18px;
    }

    .nl-topbar-datetime {
      font-size: 0.8rem;
      color: rgba(255,255,255,0.6);
    }

    /* Logout button */
    .nl-btn-logout {
      background: rgba(255,255,255,0.12);
      border: 1px solid rgba(255,255,255,0.2);
      color: rgba(255,255,255,0.85);
      font-size: 0.82rem;
      font-family: 'Inter', sans-serif;
      padding: 7px 16px;
      border-radius: 8px;
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 6px;
      transition: background 0.15s;
      text-decoration: none;
    }

    .nl-btn-logout:hover {
      background: rgba(255,255,255,0.22);
      color: #fff;
    }

    /* =============================================
       MAIN CONTENT WRAPPER
       ============================================= */
    #nl-content {
      margin-left: var(--sidebar-width);
      padding-top: 62px;
      min-height: 100vh;
    }

    .nl-page-inner {
      padding: 28px 30px 40px;
    }

    /* =============================================
       PAGE HEADER
       ============================================= */
    .nl-page-header {
      margin-bottom: 24px;
    }

    .nl-page-title {
      font-size: 1.4rem;
      font-weight: 700;
      color: var(--nl-text);
    }

    .nl-page-subtitle {
      font-size: 0.83rem;
      color: var(--nl-muted);
      margin-top: 4px;
    }

    /* =============================================
       FORM CARD
       ============================================= */
    .nl-card {
      background: var(--nl-white);
      border-radius: 14px;
      box-shadow: 0 2px 16px rgba(26,107,94,0.09);
      overflow: hidden;
    }

    /* Card header */
    .nl-card-head {
      background: linear-gradient(135deg, var(--nl-primary-dark), var(--nl-primary-light));
      padding: 20px 28px;
      display: flex;
      align-items: center;
      gap: 14px;
    }

    .nl-card-head-icon {
      width: 44px; height: 44px;
      background: rgba(255,255,255,0.18);
      border: 1.5px solid rgba(255,255,255,0.3);
      border-radius: 12px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    .nl-card-head-icon i { font-size: 1.3rem; color: #fff; }

    .nl-card-head-title {
      font-size: 1.1rem;
      font-weight: 700;
      color: #fff;
    }

    .nl-card-head-sub {
      font-size: 0.78rem;
      color: rgba(255,255,255,0.7);
      margin-top: 2px;
    }

    /* Card body */
    .nl-card-body {
      padding: 30px 28px;
    }

    /* Section separator */
    .nl-section-sep {
      display: flex;
      align-items: center;
      gap: 10px;
      margin: 28px 0 18px;
    }

    .nl-section-sep:first-child { margin-top: 0; }

    .nl-section-sep-icon {
      width: 32px; height: 32px;
      background: var(--nl-accent);
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      flex-shrink: 0;
    }

    .nl-section-sep-icon i { font-size: 0.95rem; color: var(--nl-primary); }

    .nl-section-sep-label {
      font-size: 0.78rem;
      font-weight: 700;
      color: var(--nl-primary);
      text-transform: uppercase;
      letter-spacing: 0.7px;
    }

    .nl-section-sep-line {
      flex: 1;
      height: 1px;
      background: var(--nl-border);
    }

    /* =============================================
       FORM CONTROLS (ergonometria para guantes)
       ============================================= */
    .nl-form-label {
      font-size: 0.8rem;
      font-weight: 600;
      color: var(--nl-muted);
      text-transform: uppercase;
      letter-spacing: 0.5px;
      margin-bottom: 7px;
      display: block;
    }

    .nl-form-control {
      width: 100%;
      padding: 13px 15px;
      border: 1.5px solid var(--nl-border);
      border-radius: 10px;
      font-size: 0.95rem;
      font-family: 'Inter', sans-serif;
      color: var(--nl-text);
      background: #fafffe;
      outline: none;
      transition: border-color 0.2s, box-shadow 0.2s;
    }

    .nl-form-control:focus {
      border-color: var(--nl-primary-light);
      box-shadow: 0 0 0 3px rgba(42,157,138,0.15);
      background: #fff;
    }

    .nl-form-control::placeholder { color: #aac5c0; }

    .nl-select {
      -webkit-appearance: none;
      appearance: none;
      cursor: pointer;
      background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%236c8c87' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
      background-repeat: no-repeat;
      background-position: right 14px center;
      padding-right: 40px;
    }

    .nl-textarea {
      resize: vertical;
      min-height: 90px;
    }

    /* ---- Checkboxes (grandes para guantes) ---- */
    .nl-checks-group {
      display: flex;
      flex-wrap: wrap;
      gap: 12px;
    }

    .nl-check-item {
      display: flex;
      align-items: center;
      gap: 10px;
      background: #fafffe;
      border: 1.5px solid var(--nl-border);
      border-radius: 10px;
      padding: 12px 18px;
      cursor: pointer;
      transition: border-color 0.18s, background 0.18s;
      min-width: 160px;
      flex: 1;
    }

    .nl-check-item:hover {
      border-color: var(--nl-primary-light);
      background: var(--nl-accent);
    }

    .nl-check-item input[type="checkbox"] {
      width: 20px; height: 20px;
      accent-color: var(--nl-primary);
      cursor: pointer;
      flex-shrink: 0;
    }

    .nl-check-item label {
      font-size: 0.9rem;
      font-weight: 500;
      color: var(--nl-text);
      cursor: pointer;
      display: flex;
      align-items: center;
      gap: 7px;
    }

    .nl-check-item label i { color: var(--nl-muted); font-size: 0.95rem; }

    /* =============================================
       ACTION BUTTONS (grandes, ergonomicos)
       ============================================= */
    .nl-btn-actions {
      display: flex;
      gap: 16px;
      margin-top: 32px;
      flex-wrap: wrap;
    }

    .nl-btn {
      padding: 16px 36px;
      border-radius: 12px;
      font-size: 1rem;
      font-weight: 600;
      font-family: 'Inter', sans-serif;
      cursor: pointer;
      border: none;
      display: flex;
      align-items: center;
      gap: 10px;
      transition: transform 0.15s, box-shadow 0.15s, filter 0.15s;
      min-height: 54px; /* ergonomia guantes */
    }

    .nl-btn:hover { transform: translateY(-2px); }
    .nl-btn:active { transform: translateY(0); }

    .nl-btn-primary {
      background: linear-gradient(135deg, var(--nl-primary), var(--nl-primary-light));
      color: #fff;
      flex: 2;
      justify-content: center;
      box-shadow: 0 4px 16px rgba(26,107,94,0.3);
    }

    .nl-btn-primary:hover { box-shadow: 0 8px 24px rgba(26,107,94,0.45); }

    .nl-btn-secondary {
      background: #fff;
      color: var(--nl-muted);
      border: 1.5px solid var(--nl-border);
      flex: 1;
      justify-content: center;
    }

    .nl-btn-secondary:hover {
      background: #f5fffe;
      border-color: var(--nl-primary-light);
      color: var(--nl-primary);
      box-shadow: 0 4px 12px rgba(26,107,94,0.1);
    }

    /* =============================================
       FOOTER CARD
       ============================================= */
    .nl-card-footer-bar {
      background: var(--nl-accent);
      border-top: 1px solid var(--nl-border);
      padding: 12px 28px;
      font-size: 0.78rem;
      color: var(--nl-muted);
      display: flex;
      align-items: center;
      gap: 8px;
    }

    /* =============================================
       PAGE FOOTER
       ============================================= */
    .nl-page-footer {
      text-align: center;
      margin-top: 28px;
      font-size: 0.78rem;
      color: var(--nl-muted);
    }

    /* =============================================
       RESPONSIVE: colapso sidebar movil
       ============================================= */
    @media (max-width: 768px) {
      :root { --sidebar-width: 0px; }

      #nl-sidebar {
        transform: translateX(-240px);
        width: 240px;
      }

      #nl-sidebar.open {
        transform: translateX(0);
        width: 240px;
      }

      #nl-content { margin-left: 0; }
      #nl-topbar  { left: 0; }

      .nl-page-inner { padding: 20px 16px 30px; }
    }
  </style>
</head>

<body>

  <!-- =============================================
       SIDEBAR
       ============================================= -->
  <nav id="nl-sidebar">

    <!-- Brand -->
    <a href="${pageContext.request.contextPath}/DashboardServlet" class="nl-sidebar-brand">
      <div class="nl-sidebar-brand-icon">
        <i class="bi bi-heart-pulse-fill"></i>
      </div>
      <div>
        <div class="nl-sidebar-brand-text">NURSELOGIC</div>
        <div class="nl-sidebar-brand-sub">Gestion Clinica</div>
      </div>
    </a>

    <!-- Nav label -->
    <div class="nl-nav-label">Navegacion Principal</div>

    <!-- Nav items -->
    <ul class="nl-nav">

      <li>
        <a href="${pageContext.request.contextPath}/DashboardServlet" id="nav-dashboard">
          <i class="bi bi-grid-1x2-fill"></i>
          <span>Dashboard</span>
        </a>
      </li>

      <li>
        <a href="${pageContext.request.contextPath}/PacientesServlet" id="nav-pacientes" class="active">
          <i class="bi bi-person-vcard-fill"></i>
          <span>Pacientes</span>
        </a>
      </li>

      <li>
        <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos">
          <i class="bi bi-activity"></i>
          <span>Signos Vitales</span>
        </a>
      </li>

    </ul>

    <!-- User info -->
    <div class="nl-sidebar-footer">
      <div class="nl-sidebar-user">
        <div class="nl-sidebar-avatar">
          <i class="bi bi-person-fill"></i>
        </div>
        <div>
          <%
            String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : null;
            if (nombreSesion == null && session != null) nombreSesion = (String) session.getAttribute("usuario");
            String rolSesion = (session != null) ? (String) session.getAttribute("rol") : "";
          %>
          <div class="nl-sidebar-username"><%= nombreSesion != null ? nombreSesion : "Usuario" %></div>
          <div class="nl-sidebar-role"><%= rolSesion != null ? rolSesion : "Sesion activa" %></div>
        </div>
      </div>
    </div>

  </nav><!-- /#nl-sidebar -->


  <!-- =============================================
       TOPBAR
       ============================================= -->
  <header id="nl-topbar">

    <div class="nl-topbar-left">
      <!-- Toggle sidebar (movil) -->
      <button id="nl-sidebar-toggle" aria-label="Abrir menu">
        <i class="bi bi-list"></i>
      </button>

      <!-- Breadcrumb -->
      <div class="nl-topbar-breadcrumb">
        <i class="bi bi-house-fill"></i>
        <span>/</span>
        <span>Pacientes</span>
        <span>/</span>
        <span class="current">Nueva Ficha</span>
      </div>
    </div>

    <div class="nl-topbar-right">
      <!-- Fecha/hora (mostrada via JS) -->
      <span class="nl-topbar-datetime" id="nl-datetime"></span>

      <!-- Cerrar sesion -->
      <a href="${pageContext.request.contextPath}/LogoutServlet"
         id="btnLogout"
         class="nl-btn-logout">
        <i class="bi bi-box-arrow-right"></i>
        Salir
      </a>
    </div>

  </header><!-- /#nl-topbar -->


  <!-- =============================================
       MAIN CONTENT
       ============================================= -->
  <main id="nl-content">
    <div class="nl-page-inner">

      <!-- Page header -->
      <div class="nl-page-header">
        <h1 class="nl-page-title">
          <i class="bi bi-file-earmark-medical-fill me-2" style="color: var(--nl-primary);"></i>
          Apertura de Ficha Clinica
        </h1>
        <p class="nl-page-subtitle">
          Registro de nuevo paciente en el sistema NURSELOGIC
        </p>
      </div>

      <!-- ============================================
           FORM CARD
           ============================================ -->
      <div class="nl-card">

        <!-- Card header -->
        <div class="nl-card-head">
          <div class="nl-card-head-icon">
            <i class="bi bi-clipboard2-pulse-fill"></i>
          </div>
          <div>
            <div class="nl-card-head-title">Formulario de Registro</div>
            <div class="nl-card-head-sub">Complete todos los campos requeridos (*)</div>
          </div>
        </div>

        <!-- Card body - FORM -->
        <div class="nl-card-body">

          <%-- ====================================================
               Mensajes de respuesta del RegistroPacienteServlet
               ==================================================== --%>
          <%
            String successMsg = (String) request.getAttribute("successMsg");
            String errorMsg   = (String) request.getAttribute("errorMsg");
          %>
          <% if (successMsg != null && !successMsg.isEmpty()) { %>
          <div style="background:#e9f5f3;border:1px solid #b2ddd6;border-radius:10px;color:#145c50;font-size:0.85rem;padding:12px 16px;margin-bottom:20px;display:flex;align-items:center;gap:10px;">
            <i class="bi bi-check-circle-fill" style="font-size:1.1rem;"></i>
            <strong><%= successMsg %></strong>
          </div>
          <% } %>
          <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
          <div style="background:#fff1f1;border:1px solid #f5c6c6;border-radius:10px;color:#a02020;font-size:0.85rem;padding:12px 16px;margin-bottom:20px;display:flex;align-items:center;gap:10px;">
            <i class="bi bi-exclamation-circle-fill" style="font-size:1.1rem;"></i>
            <strong><%= errorMsg %></strong>
          </div>
          <% } %>

          <form id="formRegistroPaciente"
                action="${pageContext.request.contextPath}/RegistroPacienteServlet"
                method="POST"
                novalidate>

            <!-- ══════════════════════════════════════════
                 SECCION 1: DATOS DEMOGRAFICOS
                 ══════════════════════════════════════════ -->
            <div class="nl-section-sep">
              <div class="nl-section-sep-icon">
                <i class="bi bi-person-lines-fill"></i>
              </div>
              <span class="nl-section-sep-label">1. Datos Demograficos</span>
              <div class="nl-section-sep-line"></div>
            </div>

            <!-- Fila: Nombres + Apellidos -->
            <div class="row g-3 mb-3">
              <div class="col-md-6">
                <label class="nl-form-label" for="Nombres">
                  Nombres *
                </label>
                <input
                  type="text"
                  id="Nombres"
                  name="Nombres"
                  class="nl-form-control"
                  placeholder="Ej: Maria Elena"
                  maxlength="80"
                  required />
              </div>
              <div class="col-md-6">
                <label class="nl-form-label" for="Apellidos">
                  Apellidos *
                </label>
                <input
                  type="text"
                  id="Apellidos"
                  name="Apellidos"
                  class="nl-form-control"
                  placeholder="Ej: Quishpe Toapanta"
                  maxlength="80"
                  required />
              </div>
            </div>

            <!-- Fila: Cedula + Edad + Sexo -->
            <div class="row g-3">
              <div class="col-md-4">
                <label class="nl-form-label" for="Cedula">
                  Cedula de Identidad *
                </label>
                <input
                  type="text"
                  id="Cedula"
                  name="Cedula"
                  class="nl-form-control"
                  placeholder="10 digitos"
                  maxlength="10"
                  pattern="\d{10}"
                  inputmode="numeric"
                  required />
              </div>

              <div class="col-md-4">
                <label class="nl-form-label" for="Edad">
                  Edad (anos) *
                </label>
                <input
                  type="number"
                  id="Edad"
                  name="Edad"
                  class="nl-form-control"
                  placeholder="19 – 60"
                  min="19"
                  max="60"
                  required />
              </div>

              <div class="col-md-4">
                <label class="nl-form-label" for="Sexo">
                  Sexo *
                </label>
                <select id="Sexo" name="Sexo" class="nl-form-control nl-select" required>
                  <option value="" disabled selected>-- Seleccione --</option>
                  <option value="M">Masculino (H)</option>
                  <option value="F">Femenino (M)</option>
                </select>
              </div>
            </div>


            <!-- ══════════════════════════════════════════
                 SECCION 2: ANTECEDENTES CLINICOS
                 ══════════════════════════════════════════ -->
            <div class="nl-section-sep">
              <div class="nl-section-sep-icon">
                <i class="bi bi-journal-medical"></i>
              </div>
              <span class="nl-section-sep-label">2. Antecedentes Clinicos</span>
              <div class="nl-section-sep-line"></div>
            </div>

            <div class="nl-checks-group">

              <!-- Diabetes (trigger glicemia obligatoria) -->
              <div class="nl-check-item">
                <input type="checkbox" id="antDiabetes" name="Antecedentes" value="DIABETES"
                       onchange="toggleGlicemia(this)"/>
                <label for="antDiabetes">
                  <i class="bi bi-droplet-fill"></i>
                  Diabetes
                </label>
              </div>

              <!-- Hipertension -->
              <div class="nl-check-item">
                <input type="checkbox" id="antHipertension" name="Antecedentes" value="HIPERTENSION"/>
                <label for="antHipertension">
                  <i class="bi bi-heart-fill"></i>
                  Hipertension
                </label>
              </div>

              <!-- Cancer -->
              <div class="nl-check-item">
                <input type="checkbox" id="antCancer" name="Antecedentes" value="CANCER"/>
                <label for="antCancer">
                  <i class="bi bi-bandaid-fill"></i>
                  Cancer
                </label>
              </div>

            </div><!-- /.nl-checks-group -->

            <!-- Campo Glicemia (OBLIGATORIO si Diabetes esta marcado) -->
            <div id="glicemiaSection" style="display:none; margin-top:14px;"
                 class="row g-3">
              <div class="col-md-6">
                <div style="background:#fff8e1;border:2px solid #f6ad55;border-radius:12px;padding:16px;">
                  <label class="nl-form-label" for="GlicemiaInicial" style="color:#c05621;font-size:0.82rem;">
                    <i class="bi bi-exclamation-triangle-fill" style="margin-right:5px;"></i>
                    Glicemia Inicial (mg/dL) * <em style="font-weight:400;">(Obligatorio por antecedente de Diabetes)</em>
                  </label>
                  <input type="number"
                         id="GlicemiaInicial"
                         name="GlicemiaInicial"
                         class="nl-form-control"
                         placeholder="Ej: 126 mg/dL"
                         min="0" max="999" step="1"
                         style="border-color:#f6ad55;"/>
                </div>
              </div>
            </div>


            <!-- ══════════════════════════════════════════
                 SECCION 3: OBSERVACIONES CLINICAS
                 ══════════════════════════════════════════ -->
            <div class="nl-section-sep">
              <div class="nl-section-sep-icon">
                <i class="bi bi-stethoscope"></i>
              </div>
              <span class="nl-section-sep-label">3. Observaciones Clinicas</span>
              <div class="nl-section-sep-line"></div>
            </div>

            <div class="row g-3">
              <!-- Sintomas Actuales -->
              <div class="col-md-12">
                <label class="nl-form-label" for="SintomasActuales">
                  Sintomas Actuales
                </label>
                <textarea
                  id="SintomasActuales"
                  name="SintomasActuales"
                  class="nl-form-control nl-textarea"
                  placeholder="Describa los sintomas que presenta el paciente al momento de la consulta..."
                  rows="3"></textarea>
              </div>

              <!-- Alergias -->
              <div class="col-md-6">
                <label class="nl-form-label" for="Alergias">
                  Alergias Conocidas
                </label>
                <textarea
                  id="Alergias"
                  name="Alergias"
                  class="nl-form-control nl-textarea"
                  placeholder="Ej: Penicilina, latex, ibuprofeno..."
                  rows="3"></textarea>
              </div>

              <!-- Dispositivos Medicos -->
              <div class="col-md-6">
                <label class="nl-form-label" for="DispositivosMedicos">
                  Dispositivos Medicos
                </label>
                <textarea
                  id="DispositivosMedicos"
                  name="DispositivosMedicos"
                  class="nl-form-control nl-textarea"
                  placeholder="Ej: Marcapasos, cateter, silla de ruedas..."
                  rows="3"></textarea>
              </div>
            </div>


            <!-- ══════════════════════════════════════════
                 BOTONES DE ACCION
                 ══════════════════════════════════════════ -->
            <div class="nl-btn-actions">

              <button type="submit" id="btnGuardar" class="nl-btn nl-btn-primary">
                <i class="bi bi-floppy-fill"></i>
                Guardar Registro
              </button>

              <button type="button"
                      id="btnCancelar"
                      class="nl-btn nl-btn-secondary"
                      onclick="window.history.back();">
                <i class="bi bi-x-circle"></i>
                Cancelar
              </button>

            </div>

          </form>
        </div><!-- /.nl-card-body -->

        <!-- Card footer note -->
        <div class="nl-card-footer-bar">
          <i class="bi bi-info-circle-fill"></i>
          Los campos marcados con (*) son obligatorios. Los datos ingresados quedan registrados con la
          fecha y hora del sistema: <strong id="nl-timestamp" style="margin-left:4px;"></strong>
        </div>

      </div><!-- /.nl-card -->

      <!-- Page footer -->
      <footer class="nl-page-footer">
        &copy; 2025 NURSELOGIC &mdash; Sistema de Gestion Clinica &middot; Ecuador
      </footer>

    </div><!-- /.nl-page-inner -->
  </main><!-- /#nl-content -->


  <!-- Bootstrap 5 JS (local) -->
  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

  <script>
    /* ---- Reloj en topbar ---- */
    function updateTime() {
      const now = new Date();
      const opts = {
        weekday: 'short', year: 'numeric', month: 'short',
        day: '2-digit', hour: '2-digit', minute: '2-digit'
      };
      const str = now.toLocaleDateString('es-EC', opts);
      const el = document.getElementById('nl-datetime');
      const ts = document.getElementById('nl-timestamp');
      if (el) el.textContent = str;
      if (ts) ts.textContent = now.toLocaleString('es-EC');
    }
    updateTime();
    setInterval(updateTime, 30000);

    /* ---- Toggle sidebar (movil) ---- */
    document.getElementById('nl-sidebar-toggle').addEventListener('click', function () {
      document.getElementById('nl-sidebar').classList.toggle('open');
    });

    /* ---- Validacion basica de cedula ecuatoriana (10 digitos numericos) ---- */
    document.getElementById('Cedula').addEventListener('input', function () {
      this.value = this.value.replace(/\D/g, '').slice(0, 10);
    });

    /* ---- Confirmacion antes de cancelar ---- */
    document.getElementById('btnCancelar').addEventListener('click', function (e) {
      if (!confirm('Se perderan los datos no guardados. ¿Desea continuar?')) {
        e.stopPropagation();
      } else {
        window.history.back();
      }
    });

    /* ====================================================
       REGLA DE NEGOCIO: Diabetes → Glicemia OBLIGATORIA
       Si el paciente tiene antecedente de Diabetes,
       se debe ingresar el valor de glicemia inicial.
       ==================================================== */
    function toggleGlicemia(checkbox) {
      const section  = document.getElementById('glicemiaSection');
      const inputGlic = document.getElementById('GlicemiaInicial');
      const diab = checkbox.checked;

      if (diab) {
        section.style.display = 'block';
        section.style.animation = 'fadeIn 0.3s ease';
        inputGlic.setAttribute('required', 'required');
        inputGlic.focus();
      } else {
        section.style.display = 'none';
        inputGlic.removeAttribute('required');
        inputGlic.value = '';
      }
    }

    /* Validacion en submit: si Diabetes marcado y glicemia vacia → error */
    document.getElementById('formRegistroPaciente').addEventListener('submit', function (e) {
      const cbDiab   = document.getElementById('antDiabetes');
      const inputGlic = document.getElementById('GlicemiaInicial');
      if (cbDiab.checked && (!inputGlic.value || parseFloat(inputGlic.value) <= 0)) {
        e.preventDefault();
        inputGlic.style.borderColor = '#e53e3e';
        inputGlic.style.background  = '#fff5f5';
        inputGlic.setCustomValidity(
          'El valor de Glicemia es obligatorio cuando existe antecedente de Diabetes.');
        inputGlic.reportValidity();
      } else {
        inputGlic.setCustomValidity('');
      }
    });

    /* Animacion fadeIn para la seccion de glicemia */
    const style = document.createElement('style');
    style.textContent = '@keyframes fadeIn { from{opacity:0;transform:translateY(-8px)} to{opacity:1;transform:translateY(0)} }';
    document.head.appendChild(style);

  </script>

</body>
</html>
