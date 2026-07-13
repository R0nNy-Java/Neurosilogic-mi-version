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
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;600;700&family=Inter:wght@400;500;600&family=IBM+Plex+Mono:wght@500&display=swap" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>

  <style>
    /* ── Variables ── */
    :root {
      --bg:           #F6F8F7;
      --surface:      #FFFFFF;
      --ink:          #152322;
      --muted:        #5C6B68;
      --line:         #E1E7E4;
      --brand:        #145C54;
      --brand-dark:   #0C332F;
      --brand-soft:   #E6F0EE;
      --brand-light:  #2a9d8a;
      --rojo:         #C3453D;
      --rojo-soft:    #FBEAE8;
      --verde:        #3C7A5C;
      --verde-soft:   #E8F3EC;
      --radius:       10px;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Inter', sans-serif;
      min-height: 100vh;
      background: var(--bg);
      color: var(--ink);
      -webkit-font-smoothing: antialiased;
    }

    h1, h2, h3, .brand-font { font-family: 'Space Grotesk', sans-serif; }
    .mono { font-family: 'IBM Plex Mono', monospace; }

    /* ══════════════════════════════════════════
       LOGIN – Split Panel Layout
    ══════════════════════════════════════════ */
    #login-screen {
      min-height: 100vh;
      display: grid;
      grid-template-columns: 1.05fr 1fr;
    }
    @media (max-width: 820px) {
      #login-screen { grid-template-columns: 1fr; }
      .brand-panel  { min-height: 220px; }
    }

    /* ── Panel izquierdo (marca) ── */
    .brand-panel {
      background: linear-gradient(160deg, var(--brand-dark), var(--brand) 75%);
      color: #EFF6F4;
      padding: 56px 48px;
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      position: relative;
      overflow: hidden;
    }
    /* Decoración de círculos de fondo */
    .brand-panel::before {
      content: '';
      position: absolute;
      width: 380px; height: 380px;
      top: -120px; right: -120px;
      border-radius: 50%;
      background: rgba(255,255,255,0.05);
      pointer-events: none;
    }
    .brand-panel::after {
      content: '';
      position: absolute;
      width: 260px; height: 260px;
      bottom: -80px; left: -80px;
      border-radius: 50%;
      background: rgba(255,255,255,0.04);
      pointer-events: none;
    }

    /* Logo / marca */
    .brand-mark {
      display: flex;
      align-items: center;
      gap: 10px;
      position: relative;
      z-index: 1;
    }
    .brand-mark .dot {
      width: 10px; height: 10px;
      border-radius: 50%;
      background: var(--rojo);
      box-shadow: 0 0 0 5px rgba(195,69,61,.25);
      animation: pulse 2.4s infinite ease-in-out;
    }
    @keyframes pulse {
      0%,100% { box-shadow: 0 0 0 4px rgba(195,69,61,.22); }
      50%      { box-shadow: 0 0 0 9px rgba(195,69,61,.08); }
    }
    .brand-mark span {
      font-size: 22px;
      font-weight: 700;
      letter-spacing: .03em;
      font-family: 'Space Grotesk', sans-serif;
      color: #fff;
    }

    .brand-tagline {
      max-width: 340px;
      margin-top: 20px;
      color: #CFE3DE;
      font-size: 15px;
      line-height: 1.6;
      position: relative;
      z-index: 1;
    }

    /* Icono central grande del panel */
    .brand-center-icon {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      position: relative;
      z-index: 1;
    }
    .brand-center-icon i {
      font-size: 6rem;
      color: rgba(255,255,255,0.18);
    }

    .brand-foot {
      display: flex;
      gap: 28px;
      border-top: 1px solid rgba(255,255,255,.14);
      padding-top: 18px;
      position: relative;
      z-index: 1;
    }
    .brand-foot .stat b {
      display: block;
      font-family: 'IBM Plex Mono', monospace;
      font-size: 18px;
    }
    .brand-foot .stat span {
      font-size: 11px;
      color: #9FC4BC;
      text-transform: uppercase;
      letter-spacing: .08em;
    }

    /* ── Panel derecho (formulario) ── */
    .form-panel {
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 40px 32px;
      background: var(--surface);
    }
    .form-card {
      width: 100%;
      max-width: 400px;
      animation: slideUp 0.45s ease both;
    }
    @keyframes slideUp {
      from { opacity: 0; transform: translateY(24px); }
      to   { opacity: 1; transform: translateY(0); }
    }

    /* Título del formulario */
    .form-card h2 {
      font-size: 24px;
      font-family: 'Space Grotesk', sans-serif;
      font-weight: 700;
      color: var(--ink);
      margin-bottom: 4px;
    }
    .form-card .form-subtitle {
      font-size: 13.5px;
      color: var(--muted);
      margin-bottom: 28px;
    }

    /* ── Alertas ── */
    .nl-alert-error {
      background: var(--rojo-soft);
      border: 1px solid #EFC9C5;
      border-radius: var(--radius);
      color: var(--rojo);
      font-size: 0.82rem;
      padding: 10px 14px;
      margin-bottom: 18px;
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .nl-alert-success {
      background: var(--brand-soft);
      border: 1px solid #b2ddd6;
      border-radius: var(--radius);
      color: var(--brand);
      font-size: 0.82rem;
      padding: 10px 14px;
      margin-bottom: 18px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    /* ── Grupos de formulario ── */
    .nl-form-group { margin-bottom: 18px; }
    .nl-label {
      display: block;
      font-size: 11.5px;
      font-weight: 600;
      color: var(--muted);
      text-transform: uppercase;
      letter-spacing: 0.6px;
      margin-bottom: 7px;
    }
    .nl-input-wrapper { position: relative; }
    .nl-input-icon {
      position: absolute;
      left: 14px; top: 50%;
      transform: translateY(-50%);
      color: var(--muted);
      font-size: 1rem;
      pointer-events: none;
    }
    .nl-input {
      width: 100%;
      padding: 12px 14px 12px 42px;
      border: 1.5px solid var(--line);
      border-radius: var(--radius);
      font-size: 0.93rem;
      font-family: 'Inter', sans-serif;
      color: var(--ink);
      background: #fafffe;
      outline: none;
      transition: border-color 0.2s, box-shadow 0.2s;
    }
    .nl-input:focus {
      border-color: var(--brand-light);
      box-shadow: 0 0 0 3px rgba(42,157,138,0.15);
      background: #fff;
    }
    .nl-input::placeholder { color: #aac5c0; }

    /* ── Botón de acceso ── */
    .nl-btn-submit {
      width: 100%;
      padding: 13px;
      background: linear-gradient(135deg, var(--brand), var(--brand-light));
      color: #fff;
      border: none;
      border-radius: var(--radius);
      font-size: 0.97rem;
      font-weight: 600;
      font-family: 'Inter', sans-serif;
      cursor: pointer;
      margin-top: 6px;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 8px;
      transition: transform 0.15s, box-shadow 0.15s;
    }
    .nl-btn-submit:hover {
      transform: translateY(-2px);
      box-shadow: 0 8px 24px rgba(20,92,84,0.40);
    }
    .nl-btn-submit:active { transform: translateY(0); box-shadow: none; }

    /* ── Acciones secundarias (grid de 3 botones) ── */
    .nl-links-grid {
      display: grid;
      grid-template-columns: 1fr 1fr 1fr;
      gap: 8px;
      margin-top: 20px;
    }
    .nl-link-btn {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 5px;
      padding: 12px 8px;
      border-radius: var(--radius);
      border: 1.5px solid var(--line);
      background: #fafffe;
      text-decoration: none;
      color: var(--muted);
      font-size: 0.72rem;
      font-weight: 600;
      text-align: center;
      line-height: 1.3;
      transition: border-color 0.18s, background 0.18s, color 0.18s;
    }
    .nl-link-btn:hover {
      border-color: var(--brand-light);
      background: var(--brand-soft);
      color: var(--brand);
    }
    .nl-link-btn i { font-size: 1.15rem; }

    /* ── Footer de la tarjeta ── */
    .form-footer {
      background: var(--brand-soft);
      border-top: 1px solid var(--line);
      padding: 12px 16px;
      text-align: center;
      border-radius: 0 0 var(--radius) var(--radius);
      margin-top: 28px;
    }
    .form-footer p {
      font-size: 0.75rem;
      color: var(--muted);
    }
    .form-footer span { font-weight: 600; color: var(--brand); }
  </style>
</head>

<body>

  <div id="login-screen">

    <!-- ══ PANEL IZQUIERDO – MARCA ══ -->
    <div class="brand-panel">
      <div>
        <div class="brand-mark">
          <span class="dot"></span>
          <span class="brand-font">NURSELOGIC</span>
        </div>
        <p class="brand-tagline">
          Lógica clínica y cálculos seguros para enfermería.
          Autenticación con roles diferenciados y trazabilidad
          completa de cada acceso.
        </p>
      </div>

      <div class="brand-center-icon">
        <i class="bi bi-heart-pulse-fill"></i>
      </div>

      <div class="brand-foot">
        <div class="stat">
          <b>24/7</b>
          <span>Disponibilidad</span>
        </div>
        <div class="stat">
          <b>SSL</b>
          <span>Conexión segura</span>
        </div>
        <div class="stat">
          <b>v1.0</b>
          <span>Sistema</span>
        </div>
      </div>
    </div>

    <!-- ══ PANEL DERECHO – FORMULARIO ══ -->
    <div class="form-panel">
      <div class="form-card">

        <h2>Iniciar sesión</h2>
        <p class="form-subtitle">Acceso al Sistema de Gestión Clínica</p>

        <%-- Mensaje de éxito (desde redirect: logout, nueva cuenta, cambio pass) --%>
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

        <%-- FORMULARIO → LoginServlet --%>
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

          <%-- 2. Olvidé mi Contraseña --%>
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

        <!-- ══ FOOTER ══ -->
        <div class="form-footer">
          <p>
            <i class="bi bi-shield-lock-fill me-1"></i>
            Acceso restringido &middot; Solo personal autorizado &middot;
            <span>NURSELOGIC v1.0</span>
          </p>
        </div>

      </div><!-- /.form-card -->
    </div><!-- /.form-panel -->

  </div><!-- /#login-screen -->

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

</body>
</html>
