<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <meta name="description" content="NURSELOGIC - Crear nueva cuenta de acceso"/>
  <title>NURSELOGIC | Nueva Cuenta</title>

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
      font-family: 'Inter', sans-serif; min-height: 100vh;
      background: linear-gradient(135deg, #0d4038 0%, #1a6b5e 60%, #2a9d8a 100%);
      display: flex; align-items: center; justify-content: center; padding: 20px;
    }
    body::before {
      content:''; position:fixed; width:500px; height:500px;
      top:-150px; right:-150px; border-radius:50%;
      background:rgba(255,255,255,0.06); pointer-events:none;
    }
    .nl-card {
      background:#fff; border-radius:20px;
      box-shadow:0 25px 60px rgba(0,0,0,0.35), 0 8px 20px rgba(0,0,0,0.15);
      width:100%; max-width:500px; overflow:hidden;
      animation: slideUp 0.45s ease both;
    }
    @keyframes slideUp {
      from { opacity:0; transform:translateY(28px); }
      to   { opacity:1; transform:translateY(0); }
    }
    .nl-card-header {
      background:linear-gradient(135deg,#134f45,#2a9d8a);
      padding:28px 38px 22px; text-align:center;
    }
    .nl-brand-icon {
      width:60px; height:60px; background:rgba(255,255,255,0.18);
      border:2px solid rgba(255,255,255,0.3); border-radius:50%;
      display:inline-flex; align-items:center; justify-content:center; margin-bottom:12px;
    }
    .nl-brand-icon i { font-size:1.7rem; color:#fff; }
    .nl-brand-name { font-size:1.55rem; font-weight:700; color:#fff; letter-spacing:1.5px; }
    .nl-brand-sub  { font-size:0.75rem; color:rgba(255,255,255,0.72); margin-top:3px; }

    .nl-card-body { padding:28px 38px 24px; }
    .nl-section-title { font-size:0.95rem; font-weight:600; color:var(--nl-text); text-align:center; margin-bottom:22px; }

    .nl-form-group { margin-bottom:16px; }
    .nl-label {
      display:block; font-size:0.75rem; font-weight:600; color:var(--nl-muted);
      text-transform:uppercase; letter-spacing:0.6px; margin-bottom:6px;
    }
    .nl-input-wrapper { position:relative; }
    .nl-input-icon {
      position:absolute; left:13px; top:50%; transform:translateY(-50%);
      color:var(--nl-muted); font-size:0.95rem; pointer-events:none;
    }
    .nl-input {
      width:100%; padding:11px 13px 11px 40px;
      border:1.5px solid var(--nl-border); border-radius:10px;
      font-size:0.91rem; font-family:'Inter',sans-serif; color:var(--nl-text);
      background:#fafffe; outline:none; transition:border-color 0.2s, box-shadow 0.2s;
    }
    .nl-input:focus {
      border-color:var(--nl-primary-light);
      box-shadow:0 0 0 3px rgba(42,157,138,0.15); background:#fff;
    }
    .nl-input::placeholder { color:#aac5c0; }
    .nl-select {
      -webkit-appearance:none; appearance:none; cursor:pointer;
      background-image:url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='16' height='16' fill='%236c8c87' viewBox='0 0 16 16'%3E%3Cpath d='M7.247 11.14L2.451 5.658C1.885 5.013 2.345 4 3.204 4h9.592a1 1 0 0 1 .753 1.659l-4.796 5.48a1 1 0 0 1-1.506 0z'/%3E%3C/svg%3E");
      background-repeat:no-repeat; background-position:right 13px center; padding-right:36px;
    }

    /* Alert de error */
    .nl-alert-error {
      background:#fff1f1; border:1px solid #f5c6c6; border-radius:10px;
      color:#a02020; font-size:0.82rem; padding:10px 13px;
      margin-bottom:16px; display:flex; align-items:center; gap:8px;
    }
    .nl-alert-success {
      background:#e9f5f3; border:1px solid #b2ddd6; border-radius:10px;
      color:#145c50; font-size:0.82rem; padding:10px 13px;
      margin-bottom:16px; display:flex; align-items:center; gap:8px;
    }

    .nl-btn-submit {
      width:100%; padding:13px; background:linear-gradient(135deg,#1a6b5e,#2a9d8a);
      color:#fff; border:none; border-radius:10px; font-size:0.95rem; font-weight:600;
      font-family:'Inter',sans-serif; cursor:pointer; margin-top:6px;
      display:flex; align-items:center; justify-content:center; gap:8px;
      transition:transform 0.15s, box-shadow 0.15s;
    }
    .nl-btn-submit:hover { transform:translateY(-2px); box-shadow:0 8px 24px rgba(26,107,94,0.4); }

    .nl-card-footer {
      background:var(--nl-accent); border-top:1px solid var(--nl-border);
      padding:14px 38px; text-align:center;
    }
    .nl-footer-text { font-size:0.78rem; color:var(--nl-muted); }
    .nl-footer-text a { color:var(--nl-primary); font-weight:600; text-decoration:none; }
    .nl-footer-text a:hover { text-decoration:underline; }

    .nl-helper { font-size:0.72rem; color:var(--nl-muted); margin-top:4px; }
  </style>
</head>
<body>

  <div class="nl-card">

    <!-- HEADER -->
    <div class="nl-card-header">
      <div class="nl-brand-icon"><i class="bi bi-person-plus-fill"></i></div>
      <div class="nl-brand-name">NURSELOGIC</div>
      <div class="nl-brand-sub">Crear nueva cuenta de acceso</div>
    </div>

    <!-- FORM -->
    <div class="nl-card-body">
      <p class="nl-section-title">Registro de Usuario</p>

      <%-- Mensajes de error o éxito --%>
      <%
        String errorMsg = (String) request.getAttribute("errorMsg");
        if (errorMsg != null && !errorMsg.isEmpty()) {
      %>
      <div class="nl-alert-error">
        <i class="bi bi-exclamation-circle-fill"></i><%= errorMsg %>
      </div>
      <% } %>

      <form id="formNuevaCuenta"
            action="${pageContext.request.contextPath}/NuevaCuentaServlet"
            method="POST" novalidate>

        <!-- Nombre Completo -->
        <div class="nl-form-group">
          <label class="nl-label" for="NombreCompleto">Nombre Completo *</label>
          <div class="nl-input-wrapper">
            <i class="bi bi-person nl-input-icon"></i>
            <input type="text" id="NombreCompleto" name="NombreCompleto" class="nl-input"
                   placeholder="Ej: Maria Elena Quishpe" maxlength="100" required/>
          </div>
        </div>

        <!-- Nombre de Usuario -->
        <div class="nl-form-group">
          <label class="nl-label" for="NombreUsuario">Nombre de Usuario *</label>
          <div class="nl-input-wrapper">
            <i class="bi bi-at nl-input-icon"></i>
            <input type="text" id="NombreUsuario" name="NombreUsuario" class="nl-input"
                   placeholder="4-20 caracteres (letras, números, _)" maxlength="20"
                   pattern="[a-zA-Z0-9_\-]{4,20}" required/>
          </div>
          <p class="nl-helper">Solo letras, números, guiones bajos o medios. Ej: enfermera_01</p>
        </div>

        <!-- Email -->
        <div class="nl-form-group">
          <label class="nl-label" for="Email">Correo Electrónico</label>
          <div class="nl-input-wrapper">
            <i class="bi bi-envelope nl-input-icon"></i>
            <input type="email" id="Email" name="Email" class="nl-input"
                   placeholder="correo@nurselogic.ec"/>
          </div>
        </div>

        <!-- Aviso de asignacion de rol -->
        <div style="background:#fff8e1;border:1px solid #ffe082;border-radius:10px;
                    padding:11px 14px;margin-bottom:16px;
                    display:flex;align-items:center;gap:10px;font-size:0.8rem;color:#795548;">
          <i class="bi bi-info-circle-fill" style="font-size:1rem;color:#f9a825;flex-shrink:0;"></i>
          <span>Su <strong>rol de acceso</strong> será asignado por un Administrador
          del sistema una vez que su cuenta sea revisada.</span>
        </div>

        <!-- Contraseña -->
        <div class="nl-form-group">
          <label class="nl-label" for="Contrasena">Contraseña *</label>
          <div class="nl-input-wrapper">
            <i class="bi bi-lock nl-input-icon"></i>
            <input type="password" id="Contrasena" name="Contrasena" class="nl-input"
                   placeholder="Mínimo 6 caracteres" minlength="6" required/>
          </div>
        </div>

        <!-- Confirmar Contraseña -->
        <div class="nl-form-group">
          <label class="nl-label" for="ConfirmarContrasena">Confirmar Contraseña *</label>
          <div class="nl-input-wrapper">
            <i class="bi bi-lock-fill nl-input-icon"></i>
            <input type="password" id="ConfirmarContrasena" name="ConfirmarContrasena"
                   class="nl-input" placeholder="Repita su contraseña" required/>
          </div>
        </div>

        <button type="submit" id="btnRegistrar" class="nl-btn-submit">
          <i class="bi bi-person-check-fill"></i> Crear Cuenta
        </button>

      </form>
    </div>

    <!-- FOOTER -->
    <div class="nl-card-footer">
      <p class="nl-footer-text">
        ¿Ya tienes una cuenta?
        <a href="${pageContext.request.contextPath}/login.jsp">Iniciar sesión</a>
      </p>
    </div>

  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
  <script>
    // Verificar que las contraseñas coincidan en tiempo real
    document.getElementById('btnRegistrar').addEventListener('click', function(e) {
      const p1 = document.getElementById('Contrasena').value;
      const p2 = document.getElementById('ConfirmarContrasena').value;
      if (p1 && p2 && p1 !== p2) {
        e.preventDefault();
        alert('Las contraseñas no coinciden.');
      }
    });
  </script>
</body>
</html>
