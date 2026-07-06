<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <meta name="description" content="NURSELOGIC - Sistema de Gestion Clinica para Enfermeros"/>
  <title>NURSELOGIC | Iniciar Sesion</title>

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
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Inter', sans-serif;
      min-height: 100vh;
      background: linear-gradient(135deg, #0d4038 0%, #1a6b5e 60%, #2a9d8a 100%);
      display: flex; align-items: center; justify-content: center;
      padding: 20px; position: relative; overflow: hidden;
    }
    body::before {
      content: ''; position: fixed;
      width: 500px; height: 500px; top: -150px; right: -150px;
      border-radius: 50%; background: rgba(255,255,255,0.06); pointer-events: none;
    }
    body::after {
      content: ''; position: fixed;
      width: 350px; height: 350px; bottom: -100px; left: -100px;
      border-radius: 50%; background: rgba(255,255,255,0.04); pointer-events: none;
    }

    /* ── Login Card ── */
    .nl-login-card {
      background: #fff; border-radius: 20px;
      box-shadow: 0 25px 60px rgba(0,0,0,0.35), 0 8px 20px rgba(0,0,0,0.15);
      width: 100%; max-width: 440px; overflow: hidden;
      animation: slideUp 0.45s ease both;
    }
    @keyframes slideUp {
      from { opacity: 0; transform: translateY(28px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* ── Header ── */
    .nl-card-header {
      background: linear-gradient(135deg, #134f45, #2a9d8a);
      padding: 36px 40px 26px; text-align: center;
    }
    .nl-brand-icon {
      width: 70px; height: 70px;
      background: rgba(255,255,255,0.18); border: 2px solid rgba(255,255,255,0.3);
      border-radius: 50%; display: inline-flex; align-items: center; justify-content: center;
      margin-bottom: 14px;
    }
    .nl-brand-icon i  { font-size: 2rem; color: #fff; }
    .nl-brand-name    { font-size: 1.75rem; font-weight: 700; color: #fff; letter-spacing: 1.5px; }
    .nl-brand-sub     { font-size: 0.78rem; color: rgba(255,255,255,0.72); margin-top: 4px; }

    /* ── Card Body ── */
    .nl-card-body { padding: 32px 40px 24px; }
    .nl-section-title { font-size: 0.95rem; font-weight: 600; color: var(--nl-text); text-align: center; margin-bottom: 22px; }

    /* ── Alerts ── */
    .nl-alert-error {
      background: #fff1f1; border: 1px solid #f5c6c6; border-radius: 10px;
      color: #a02020; font-size: 0.82rem; padding: 10px 14px; margin-bottom: 18px;
      display: flex; align-items: center; gap: 8px;
    }
    .nl-alert-success {
      background: #e9f5f3; border: 1px solid #b2ddd6; border-radius: 10px;
      color: #145c50; font-size: 0.82rem; padding: 10px 14px; margin-bottom: 18px;
      display: flex; align-items: center; gap: 8px;
    }

    /* ── Form Controls ── */
    .nl-form-group { margin-bottom: 18px; }
    .nl-label {
      display: block; font-size: 0.78rem; font-weight: 600; color: var(--nl-muted);
      text-transform: uppercase; letter-spacing: 0.6px; margin-bottom: 7px;
    }
    .nl-input-wrapper { position: relative; }
    .nl-input-icon {
      position: absolute; left: 14px; top: 50%; transform: translateY(-50%);
      color: var(--nl-muted); font-size: 1rem; pointer-events: none;
    }
    .nl-input {
      width: 100%; padding: 12px 14px 12px 42px;
      border: 1.5px solid var(--nl-border); border-radius: 10px;
      font-size: 0.93rem; font-family: 'Inter', sans-serif; color: var(--nl-text);
      background: #fafffe; outline: none;
      transition: border-color 0.2s, box-shadow 0.2s;
    }
    .nl-input:focus {
      border-color: var(--nl-primary-light);
      box-shadow: 0 0 0 3px rgba(42,157,138,0.15); background: #fff;
    }
    .nl-input::placeholder { color: #aac5c0; }

    /* ── Botón principal ── */
    .nl-btn-submit {
      width: 100%; padding: 14px;
      background: linear-gradient(135deg, var(--nl-primary), var(--nl-primary-light));
      color: #fff; border: none; border-radius: 10px;
      font-size: 0.97rem; font-weight: 600; font-family: 'Inter', sans-serif;
      cursor: pointer; margin-top: 6px;
      display: flex; align-items: center; justify-content: center; gap: 8px;
      transition: transform 0.15s, box-shadow 0.15s;
    }
    .nl-btn-submit:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(26,107,94,0.45);
    }
    .nl-btn-submit:active { transform: translateY(0); box-shadow: none; }

    /* ── Links de acciones secundarias ── */
    .nl-links-grid {
      display: grid; grid-template-columns: 1fr 1fr 1fr;
      gap: 8px; margin-top: 18px;
    }
    .nl-link-btn {
      display: flex; flex-direction: column; align-items: center; gap: 5px;
      padding: 12px 8px; border-radius: 10px;
      border: 1.5px solid var(--nl-border); background: #fafffe;
      text-decoration: none; color: var(--nl-muted);
      font-size: 0.72rem; font-weight: 600; text-align: center; line-height: 1.3;
      transition: border-color 0.18s, background 0.18s, color 0.18s;
    }
    .nl-link-btn:hover {
      border-color: var(--nl-primary-light);
      background: var(--nl-accent); color: var(--nl-primary);
    }
    .nl-link-btn i { font-size: 1.15rem; }

    /* ── Card Footer ── */
    .nl-card-footer {
      background: var(--nl-accent); border-top: 1px solid var(--nl-border);
      padding: 12px 40px; text-align: center;
    }
    .nl-footer-text { font-size: 0.76rem; color: var(--nl-muted); }
    .nl-footer-text span { font-weight: 600; color: var(--nl-primary); }
  </style>
</head>

<body>

  <div class="nl-login-card">

    <!-- ══ BRAND HEADER ══ -->
    <div class="nl-card-header">
      <div class="nl-brand-icon">
        <i class="bi bi-heart-pulse-fill"></i>
      </div>
      <div class="nl-brand-name">NURSELOGIC</div>
      <div class="nl-brand-sub">Sistema de Gestion Clinica &middot; Ecuador</div>
    </div>

    <!-- ══ FORM ══ -->
    <div class="nl-card-body">

      <p class="nl-section-title">Acceso al Sistema</p>

      <%-- Mensaje de exito (desde redirect: logout, nueva cuenta, cambio pass) --%>
      <%
        String successMsg = request.getParameter("msg");
        String errorMsg   = (String) request.getAttribute("errorMsg");
        if (successMsg != null && !successMsg.trim().isEmpty()) {
      %>
      <div class="nl-alert-success">
        <i class="bi bi-check-circle-fill"></i> <%= successMsg %>
      </div>
      <% } %>

      <%-- Mensaje de error del LoginServlet --%>
      <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="nl-alert-error">
        <i class="bi bi-exclamation-circle-fill"></i> <%= errorMsg %>
      </div>
      <% } %>

      <%-- FORMULARIO → LoginServlet (rol implícito en credenciales) --%>
      <form id="formLogin"
            action="${pageContext.request.contextPath}/LoginServlet"
            method="POST"
            novalidate>

        <!-- Nombre de Usuario -->
        <div class="nl-form-group">
          <label class="nl-label" for="NombreUsuario">Nombre de Usuario</label>
          <div class="nl-input-wrapper">
            <i class="bi bi-person nl-input-icon"></i>
            <input type="text" id="NombreUsuario" name="NombreUsuario"
                   class="nl-input" placeholder="Ingrese su usuario"
                   autocomplete="username" required/>
          </div>
        </div>

        <!-- Contraseña -->
        <div class="nl-form-group">
          <label class="nl-label" for="Contrasena">Contraseña</label>
          <div class="nl-input-wrapper">
            <i class="bi bi-lock nl-input-icon"></i>
            <input type="password" id="Contrasena" name="Contrasena"
                   class="nl-input" placeholder="Ingrese su contraseña"
                   autocomplete="current-password" required/>
          </div>
        </div>

        <!-- Botón de acceso -->
        <button type="submit" id="btnIngresar" class="nl-btn-submit">
          <i class="bi bi-box-arrow-in-right"></i>
          Ingresar al Sistema
        </button>

      </form>

      <!-- ══ ACCIONES SECUNDARIAS ══ -->
      <div class="nl-links-grid">

        <%-- 1. Registrar Usuario --%>
        <a href="${pageContext.request.contextPath}/NuevaCuentaServlet"
           id="linkRegistrar" class="nl-link-btn">
          <i class="bi bi-person-plus-fill"></i>
          Registrar Usuario
        </a>

        <%-- 2. Olvido su Contrasena --%>
        <a href="${pageContext.request.contextPath}/OlvidoContrasenaServlet"
           id="linkOlvido" class="nl-link-btn">
          <i class="bi bi-key-fill"></i>
          Olvidé mi Contraseña
        </a>

        <%-- 3. Recuperar Usuario --%>
        <a href="${pageContext.request.contextPath}/RecuperarUsuarioServlet"
           id="linkRecuperar" class="nl-link-btn">
          <i class="bi bi-person-exclamation"></i>
          Recuperar Usuario
        </a>

      </div>

    </div><!-- /.nl-card-body -->

    <!-- ══ FOOTER ══ -->
    <div class="nl-card-footer">
      <p class="nl-footer-text">
        <i class="bi bi-shield-lock-fill me-1"></i>
        Acceso restringido &middot; Solo personal autorizado &middot;
        <span>NURSELOGIC v1.0</span>
      </p>
    </div>

  </div><!-- /.nl-login-card -->

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

</body>
</html>
