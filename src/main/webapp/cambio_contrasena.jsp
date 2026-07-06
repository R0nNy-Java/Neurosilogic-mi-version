<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Cambio de Contraseña</title>

  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>

  <style>
    :root {
      --nl-primary:#1a6b5e; --nl-primary-dark:#134f45; --nl-primary-light:#2a9d8a;
      --nl-accent:#e9f5f3; --nl-text:#1e2d2b; --nl-muted:#6c8c87; --nl-border:#d0e8e4;
      --nl-sidebar-bg:#0f3831; --nl-topbar-bg:#134f45; --nl-body-bg:#f0f7f6;
      --sidebar-width:240px;
    }
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    body { font-family:'Inter',sans-serif; background:var(--nl-body-bg); min-height:100vh; }

    /* SIDEBAR */
    #nl-sidebar { position:fixed; top:0; left:0; width:var(--sidebar-width); height:100vh; background:var(--nl-sidebar-bg); display:flex; flex-direction:column; z-index:1000; }
    .nl-sidebar-brand { display:flex; align-items:center; gap:12px; padding:22px 20px; border-bottom:1px solid rgba(255,255,255,0.1); text-decoration:none; }
    .nl-sidebar-brand-icon { width:38px; height:38px; background:var(--nl-primary-light); border-radius:10px; display:flex; align-items:center; justify-content:center; }
    .nl-sidebar-brand-icon i { font-size:1.1rem; color:#fff; }
    .nl-sidebar-brand-text { font-size:1.05rem; font-weight:700; color:#fff; letter-spacing:1px; }
    .nl-sidebar-brand-sub  { font-size:0.62rem; color:rgba(255,255,255,0.5); }
    .nl-nav-label { font-size:0.65rem; font-weight:600; color:rgba(255,255,255,0.35); text-transform:uppercase; letter-spacing:1px; padding:18px 20px 6px; }
    .nl-nav { list-style:none; padding:8px 12px; flex:1; }
    .nl-nav li { margin-bottom:4px; }
    .nl-nav a { display:flex; align-items:center; gap:12px; padding:11px 14px; border-radius:10px; text-decoration:none; color:rgba(255,255,255,0.7); font-size:0.88rem; font-weight:500; transition:background 0.18s; }
    .nl-nav a:hover { background:var(--nl-primary); color:#fff; }
    .nl-nav a i { font-size:1rem; }

    /* TOPBAR */
    #nl-topbar { position:fixed; top:0; left:var(--sidebar-width); right:0; height:62px; background:var(--nl-topbar-bg); display:flex; align-items:center; justify-content:space-between; padding:0 28px; z-index:999; box-shadow:0 2px 10px rgba(0,0,0,0.2); }
    .nl-topbar-breadcrumb { font-size:0.83rem; color:rgba(255,255,255,0.6); display:flex; align-items:center; gap:6px; }
    .nl-topbar-breadcrumb span.current { color:rgba(255,255,255,0.9); font-weight:600; }
    .nl-topbar-right { display:flex; align-items:center; gap:14px; }
    .nl-btn-logout { background:rgba(255,255,255,0.12); border:1px solid rgba(255,255,255,0.2); color:rgba(255,255,255,0.85); font-size:0.82rem; font-family:'Inter',sans-serif; padding:7px 16px; border-radius:8px; cursor:pointer; display:flex; align-items:center; gap:6px; text-decoration:none; transition:background 0.15s; }
    .nl-btn-logout:hover { background:rgba(255,255,255,0.22); color:#fff; }

    /* CONTENT */
    #nl-content { margin-left:var(--sidebar-width); padding-top:62px; }
    .nl-page-inner { padding:28px 30px 40px; }

    /* PAGE HEADER */
    .nl-page-header { margin-bottom:24px; }
    .nl-page-title   { font-size:1.35rem; font-weight:700; color:var(--nl-text); }
    .nl-page-subtitle { font-size:0.82rem; color:var(--nl-muted); margin-top:4px; }

    /* FORM CARD */
    .nl-card { background:#fff; border-radius:14px; max-width:520px; box-shadow:0 2px 16px rgba(26,107,94,0.09); overflow:hidden; }
    .nl-card-head { background:linear-gradient(135deg,#134f45,#2a9d8a); padding:20px 28px; display:flex; align-items:center; gap:14px; }
    .nl-card-head-icon { width:44px; height:44px; background:rgba(255,255,255,0.18); border:1.5px solid rgba(255,255,255,0.3); border-radius:12px; display:flex; align-items:center; justify-content:center; }
    .nl-card-head-icon i { font-size:1.3rem; color:#fff; }
    .nl-card-head-title { font-size:1.1rem; font-weight:700; color:#fff; }
    .nl-card-head-sub   { font-size:0.78rem; color:rgba(255,255,255,0.7); margin-top:2px; }
    .nl-card-body { padding:28px; }

    /* FORM CONTROLS */
    .nl-form-group { margin-bottom:18px; }
    .nl-form-label { display:block; font-size:0.78rem; font-weight:600; color:var(--nl-muted); text-transform:uppercase; letter-spacing:0.5px; margin-bottom:7px; }
    .nl-input-wrapper { position:relative; }
    .nl-input-icon { position:absolute; left:14px; top:50%; transform:translateY(-50%); color:var(--nl-muted); font-size:1rem; pointer-events:none; }
    .nl-form-control {
      width:100%; padding:12px 14px 12px 42px;
      border:1.5px solid var(--nl-border); border-radius:10px;
      font-size:0.93rem; font-family:'Inter',sans-serif; color:var(--nl-text);
      background:#fafffe; outline:none; transition:border-color 0.2s,box-shadow 0.2s;
    }
    .nl-form-control:focus { border-color:var(--nl-primary-light); box-shadow:0 0 0 3px rgba(42,157,138,0.15); background:#fff; }
    .nl-form-control::placeholder { color:#aac5c0; }

    /* Alerts */
    .nl-alert-error { background:#fff1f1; border:1px solid #f5c6c6; border-radius:10px; color:#a02020; font-size:0.82rem; padding:10px 14px; margin-bottom:18px; display:flex; align-items:center; gap:8px; }
    .nl-alert-info  { background:#e9f5f3; border:1px solid #b2ddd6; border-radius:10px; color:#145c50; font-size:0.82rem; padding:10px 14px; margin-bottom:18px; display:flex; align-items:center; gap:8px; }

    /* Separador de sección */
    .nl-sep { display:flex; align-items:center; gap:10px; margin-bottom:18px; }
    .nl-sep-icon { width:30px; height:30px; background:var(--nl-accent); border-radius:8px; display:flex; align-items:center; justify-content:center; }
    .nl-sep-icon i { font-size:0.88rem; color:var(--nl-primary); }
    .nl-sep-label { font-size:0.75rem; font-weight:700; color:var(--nl-primary); text-transform:uppercase; letter-spacing:0.7px; }
    .nl-sep-line { flex:1; height:1px; background:var(--nl-border); }

    /* Botones */
    .nl-btn-actions { display:flex; gap:14px; margin-top:24px; }
    .nl-btn { padding:14px 28px; border-radius:10px; font-size:0.95rem; font-weight:600; font-family:'Inter',sans-serif; cursor:pointer; border:none; display:flex; align-items:center; gap:8px; transition:transform 0.15s,box-shadow 0.15s; }
    .nl-btn:hover { transform:translateY(-2px); }
    .nl-btn-primary { background:linear-gradient(135deg,#1a6b5e,#2a9d8a); color:#fff; flex:2; justify-content:center; box-shadow:0 4px 14px rgba(26,107,94,0.25); }
    .nl-btn-primary:hover { box-shadow:0 8px 22px rgba(26,107,94,0.4); }
    .nl-btn-secondary { background:#fff; color:var(--nl-muted); border:1.5px solid var(--nl-border); flex:1; justify-content:center; }
    .nl-btn-secondary:hover { background:var(--nl-accent); border-color:var(--nl-primary-light); color:var(--nl-primary); }

    /* Nota de seguridad */
    .nl-security-note { background:var(--nl-accent); border-radius:10px; padding:12px 16px; margin-top:20px; font-size:0.8rem; color:var(--nl-muted); display:flex; align-items:flex-start; gap:8px; }
    .nl-security-note i { color:var(--nl-primary); margin-top:2px; flex-shrink:0; }

    /* Requisitos de contraseña */
    .nl-req-list { list-style:none; margin-top:10px; }
    .nl-req-list li { font-size:0.77rem; color:var(--nl-muted); display:flex; align-items:center; gap:6px; margin-bottom:3px; }
    .nl-req-list li i { font-size:0.75rem; }
    .nl-req-ok   { color:#2a9d8a !important; }
    .nl-req-fail { color:#aac5c0 !important; }
  </style>
</head>
<body>

  <!-- SIDEBAR -->
  <nav id="nl-sidebar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="nl-sidebar-brand">
      <div class="nl-sidebar-brand-icon"><i class="bi bi-heart-pulse-fill"></i></div>
      <div><div class="nl-sidebar-brand-text">NURSELOGIC</div><div class="nl-sidebar-brand-sub">Gestion Clinica</div></div>
    </a>
    <div class="nl-nav-label">Navegacion Principal</div>
    <ul class="nl-nav">
      <li><a href="${pageContext.request.contextPath}/index.jsp"><i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span></a></li>
      <li><a href="${pageContext.request.contextPath}/PacientesServlet"><i class="bi bi-person-vcard-fill"></i><span>Pacientes</span></a></li>
      <li><a href="${pageContext.request.contextPath}/SignosVitalesServlet"><i class="bi bi-activity"></i><span>Signos Vitales</span></a></li>
    </ul>
  </nav>

  <!-- TOPBAR -->
  <header id="nl-topbar">
    <div class="nl-topbar-breadcrumb">
      <i class="bi bi-house-fill"></i><span>/</span><span>Seguridad</span><span>/</span>
      <span class="current">Cambio de Contraseña</span>
    </div>
    <div class="nl-topbar-right">
      <%-- Nombre del usuario en sesión --%>
      <%
        String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
        if (nombreSesion == null) nombreSesion = (String) session.getAttribute("usuario");
      %>
      <span style="font-size:0.82rem;color:rgba(255,255,255,0.7);">
        <i class="bi bi-person-circle me-1"></i><%= nombreSesion != null ? nombreSesion : "" %>
      </span>
      <a href="${pageContext.request.contextPath}/LogoutServlet" id="btnLogout" class="nl-btn-logout">
        <i class="bi bi-box-arrow-right"></i>Salir
      </a>
    </div>
  </header>

  <!-- CONTENT -->
  <main id="nl-content">
    <div class="nl-page-inner">

      <!-- Page header -->
      <div class="nl-page-header">
        <h1 class="nl-page-title">
          <i class="bi bi-shield-lock-fill me-2" style="color:var(--nl-primary);"></i>
          Cambio de Contraseña
        </h1>
        <p class="nl-page-subtitle">Actualice su contraseña de acceso al sistema NURSELOGIC</p>
      </div>

      <!-- FORM CARD -->
      <div class="nl-card">
        <div class="nl-card-head">
          <div class="nl-card-head-icon"><i class="bi bi-key-fill"></i></div>
          <div>
            <div class="nl-card-head-title">Nueva Contraseña</div>
            <div class="nl-card-head-sub">
              Usuario: <strong>
              <%= session != null && session.getAttribute("usuario") != null
                  ? session.getAttribute("usuario").toString().toUpperCase() : "" %>
              </strong>
            </div>
          </div>
        </div>
        <div class="nl-card-body">

          <%-- Mensajes de error --%>
          <%
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null && !errorMsg.isEmpty()) {
          %>
          <div class="nl-alert-error">
            <i class="bi bi-exclamation-circle-fill"></i><%= errorMsg %>
          </div>
          <% } %>

          <form id="formCambioPass"
                action="${pageContext.request.contextPath}/CambioContrasenaServlet"
                method="POST" novalidate>

            <!-- Sección: Verificación -->
            <div class="nl-sep">
              <div class="nl-sep-icon"><i class="bi bi-check-circle-fill"></i></div>
              <span class="nl-sep-label">Verificación</span>
              <div class="nl-sep-line"></div>
            </div>

            <!-- Contraseña Actual -->
            <div class="nl-form-group">
              <label class="nl-form-label" for="ContrasenaActual">Contraseña Actual *</label>
              <div class="nl-input-wrapper">
                <i class="bi bi-lock nl-input-icon"></i>
                <input type="password" id="ContrasenaActual" name="ContrasenaActual"
                       class="nl-form-control" placeholder="Ingrese su contraseña actual" required/>
              </div>
            </div>

            <!-- Sección: Nueva Contraseña -->
            <div class="nl-sep" style="margin-top:22px;">
              <div class="nl-sep-icon"><i class="bi bi-shield-plus"></i></div>
              <span class="nl-sep-label">Nueva Contraseña</span>
              <div class="nl-sep-line"></div>
            </div>

            <!-- Nueva Contraseña -->
            <div class="nl-form-group">
              <label class="nl-form-label" for="NuevaContrasena">Nueva Contraseña *</label>
              <div class="nl-input-wrapper">
                <i class="bi bi-lock-fill nl-input-icon"></i>
                <input type="password" id="NuevaContrasena" name="NuevaContrasena"
                       class="nl-form-control" placeholder="Mínimo 6 caracteres"
                       minlength="6" required/>
              </div>
              <!-- Indicador de requisitos -->
              <ul class="nl-req-list" id="reqList">
                <li id="req-len" class="nl-req-fail">
                  <i class="bi bi-circle"></i> Mínimo 6 caracteres
                </li>
                <li id="req-dif" class="nl-req-fail">
                  <i class="bi bi-circle"></i> Distinta a la contraseña actual
                </li>
              </ul>
            </div>

            <!-- Confirmar Nueva Contraseña -->
            <div class="nl-form-group">
              <label class="nl-form-label" for="ConfirmarContrasena">Confirmar Nueva Contraseña *</label>
              <div class="nl-input-wrapper">
                <i class="bi bi-lock-fill nl-input-icon"></i>
                <input type="password" id="ConfirmarContrasena" name="ConfirmarContrasena"
                       class="nl-form-control" placeholder="Repita la nueva contraseña" required/>
              </div>
              <p id="matchMsg" style="font-size:0.77rem;margin-top:4px;color:#aac5c0;"></p>
            </div>

            <!-- Botones -->
            <div class="nl-btn-actions">
              <button type="submit" id="btnGuardar" class="nl-btn nl-btn-primary">
                <i class="bi bi-floppy-fill"></i> Guardar Cambio
              </button>
              <button type="button" id="btnCancelar" class="nl-btn nl-btn-secondary"
                      onclick="window.history.back();">
                <i class="bi bi-x-circle"></i> Cancelar
              </button>
            </div>

          </form>

          <!-- Nota de seguridad -->
          <div class="nl-security-note">
            <i class="bi bi-info-circle-fill"></i>
            <span>Al guardar la nueva contraseña, su sesión actual se cerrará automáticamente y
            deberá iniciar sesión nuevamente con sus nuevas credenciales.</span>
          </div>

        </div>
      </div>

    </div>
  </main>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
  <script>
    const campoNueva   = document.getElementById('NuevaContrasena');
    const campoActual  = document.getElementById('ContrasenaActual');
    const campoConf    = document.getElementById('ConfirmarContrasena');
    const reqLen       = document.getElementById('req-len');
    const reqDif       = document.getElementById('req-dif');
    const matchMsg     = document.getElementById('matchMsg');

    function actualizar() {
      const nueva  = campoNueva.value;
      const actual = campoActual.value;

      // Requisito longitud
      if (nueva.length >= 6) {
        reqLen.className = 'nl-req-ok';
        reqLen.innerHTML = '<i class="bi bi-check-circle-fill"></i> Mínimo 6 caracteres';
      } else {
        reqLen.className = 'nl-req-fail';
        reqLen.innerHTML = '<i class="bi bi-circle"></i> Mínimo 6 caracteres';
      }

      // Requisito: distinta a la actual
      if (nueva.length > 0 && actual.length > 0 && nueva !== actual) {
        reqDif.className = 'nl-req-ok';
        reqDif.innerHTML = '<i class="bi bi-check-circle-fill"></i> Distinta a la contraseña actual';
      } else {
        reqDif.className = 'nl-req-fail';
        reqDif.innerHTML = '<i class="bi bi-circle"></i> Distinta a la contraseña actual';
      }

      // Confirmación coincide
      const conf = campoConf.value;
      if (conf.length > 0) {
        if (nueva === conf) {
          matchMsg.textContent = '✔ Las contraseñas coinciden';
          matchMsg.style.color = '#2a9d8a';
        } else {
          matchMsg.textContent = '✖ Las contraseñas no coinciden';
          matchMsg.style.color = '#a02020';
        }
      } else {
        matchMsg.textContent = '';
      }
    }

    campoNueva.addEventListener('input',  actualizar);
    campoActual.addEventListener('input', actualizar);
    campoConf.addEventListener('input',   actualizar);

    document.getElementById('btnGuardar').addEventListener('click', function(e) {
      if (campoNueva.value !== campoConf.value) {
        e.preventDefault();
        alert('Las contraseñas no coinciden. Verifique.');
      }
    });
  </script>
</body>
</html>
