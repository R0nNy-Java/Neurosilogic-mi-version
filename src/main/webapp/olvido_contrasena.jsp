<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Olvidé mi Contraseña</title>
  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
  <style>
    :root { --nl-primary:#1a6b5e; --nl-primary-dark:#134f45; --nl-primary-light:#2a9d8a; --nl-accent:#e9f5f3; --nl-text:#1e2d2b; --nl-muted:#6c8c87; --nl-border:#d0e8e4; }
    *,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
    body { font-family:'Inter',sans-serif; min-height:100vh; background:linear-gradient(135deg,#0d4038 0%,#1a6b5e 60%,#2a9d8a 100%); display:flex; align-items:center; justify-content:center; padding:20px; }
    body::before { content:''; position:fixed; width:500px; height:500px; top:-150px; right:-150px; border-radius:50%; background:rgba(255,255,255,0.06); pointer-events:none; }

    .nl-card { background:#fff; border-radius:20px; box-shadow:0 25px 60px rgba(0,0,0,0.35); width:100%; max-width:440px; overflow:hidden; animation:slideUp 0.45s ease both; }
    @keyframes slideUp { from{opacity:0;transform:translateY(28px)} to{opacity:1;transform:translateY(0)} }

    .nl-card-header { background:linear-gradient(135deg,#134f45,#2a9d8a); padding:30px 38px 22px; text-align:center; }
    .nl-brand-icon { width:62px; height:62px; background:rgba(255,255,255,0.18); border:2px solid rgba(255,255,255,0.3); border-radius:50%; display:inline-flex; align-items:center; justify-content:center; margin-bottom:12px; }
    .nl-brand-icon i { font-size:1.7rem; color:#fff; }
    .nl-brand-name { font-size:1.5rem; font-weight:700; color:#fff; letter-spacing:1.5px; }
    .nl-brand-sub  { font-size:0.76rem; color:rgba(255,255,255,0.72); margin-top:3px; }

    .nl-card-body { padding:28px 38px 24px; }
    .nl-section-title { font-size:0.95rem; font-weight:600; color:var(--nl-text); text-align:center; margin-bottom:6px; }
    .nl-section-desc  { font-size:0.8rem; color:var(--nl-muted); text-align:center; margin-bottom:20px; line-height:1.5; }

    .nl-alert-error   { background:#fff1f1; border:1px solid #f5c6c6; border-radius:10px; color:#a02020; font-size:0.82rem; padding:10px 14px; margin-bottom:16px; display:flex; align-items:center; gap:8px; }
    .nl-alert-success { background:#e9f5f3; border:1px solid #b2ddd6; border-radius:10px; color:#145c50; font-size:0.82rem; padding:10px 14px; margin-bottom:16px; display:flex; align-items:flex-start; gap:8px; flex-direction:column; }
    .nl-alert-success strong { font-size:0.88rem; }

    /* Caja de resultado exitoso */
    .nl-result-box { background:var(--nl-accent); border:2px solid var(--nl-border); border-radius:12px; padding:18px 20px; margin-bottom:18px; text-align:center; }
    .nl-result-label { font-size:0.72rem; font-weight:700; color:var(--nl-muted); text-transform:uppercase; letter-spacing:0.6px; margin-bottom:6px; }
    .nl-result-value { font-size:1.5rem; font-weight:700; color:var(--nl-primary); letter-spacing:1px; font-family:monospace; }
    .nl-result-note  { font-size:0.76rem; color:var(--nl-muted); margin-top:8px; }

    .nl-form-group { margin-bottom:16px; }
    .nl-label { display:block; font-size:0.76rem; font-weight:600; color:var(--nl-muted); text-transform:uppercase; letter-spacing:0.6px; margin-bottom:6px; }
    .nl-input-wrapper { position:relative; }
    .nl-input-icon { position:absolute; left:13px; top:50%; transform:translateY(-50%); color:var(--nl-muted); font-size:0.95rem; pointer-events:none; }
    .nl-input { width:100%; padding:11px 13px 11px 40px; border:1.5px solid var(--nl-border); border-radius:10px; font-size:0.91rem; font-family:'Inter',sans-serif; color:var(--nl-text); background:#fafffe; outline:none; transition:border-color 0.2s,box-shadow 0.2s; }
    .nl-input:focus { border-color:var(--nl-primary-light); box-shadow:0 0 0 3px rgba(42,157,138,0.15); background:#fff; }
    .nl-input::placeholder { color:#aac5c0; }

    .nl-btn-submit { width:100%; padding:13px; background:linear-gradient(135deg,#1a6b5e,#2a9d8a); color:#fff; border:none; border-radius:10px; font-size:0.95rem; font-weight:600; font-family:'Inter',sans-serif; cursor:pointer; display:flex; align-items:center; justify-content:center; gap:8px; transition:transform 0.15s,box-shadow 0.15s; }
    .nl-btn-submit:hover { transform:translateY(-2px); box-shadow:0 8px 24px rgba(26,107,94,0.4); }

    .nl-card-footer { background:var(--nl-accent); border-top:1px solid var(--nl-border); padding:12px 38px; text-align:center; }
    .nl-footer-text { font-size:0.78rem; color:var(--nl-muted); }
    .nl-footer-text a { color:var(--nl-primary); font-weight:600; text-decoration:none; }
    .nl-footer-text a:hover { text-decoration:underline; }
  </style>
</head>
<body>
  <div class="nl-card">

    <div class="nl-card-header">
      <div class="nl-brand-icon"><i class="bi bi-key-fill"></i></div>
      <div class="nl-brand-name">NURSELOGIC</div>
      <div class="nl-brand-sub">Recuperacion de Acceso</div>
    </div>

    <div class="nl-card-body">
      <p class="nl-section-title">Olvidé mi Contraseña</p>
      <p class="nl-section-desc">Ingrese su usuario y correo registrado.<br/>Se le asignará una contraseña temporal.</p>

      <%-- Resultado exitoso --%>
      <%
        Boolean exitoso = (Boolean) request.getAttribute("exitoso");
        String  usuarioR = (String) request.getAttribute("usuarioRecuperado");
        String  passTemp = (String) request.getAttribute("contrasenaTemp");
        String  errorMsg = (String) request.getAttribute("errorMsg");

        if (Boolean.TRUE.equals(exitoso)) {
      %>
      <div class="nl-result-box">
        <div class="nl-result-label">&#10003; Contraseña temporal asignada</div>
        <div class="nl-result-value"><%= passTemp %></div>
        <div class="nl-result-note">
          Usuario: <strong><%= usuarioR %></strong><br/>
          Ingrese al sistema con esta contraseña y cámbiela inmediatamente desde
          <em>Seguridad &rarr; Cambiar Contraseña</em>.
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/login.jsp" class="nl-btn-submit" style="text-decoration:none;margin-top:0;">
        <i class="bi bi-box-arrow-in-right"></i> Ir al Inicio de Sesion
      </a>
      <% } else { %>

      <%-- Mensaje de error --%>
      <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="nl-alert-error"><i class="bi bi-exclamation-circle-fill"></i><%= errorMsg %></div>
      <% } %>

      <%-- Formulario → OlvidoContrasenaServlet --%>
      <form id="formOlvido"
            action="${pageContext.request.contextPath}/OlvidoContrasenaServlet"
            method="POST" novalidate>

        <div class="nl-form-group">
          <label class="nl-label" for="NombreUsuario">Nombre de Usuario</label>
          <div class="nl-input-wrapper">
            <i class="bi bi-person nl-input-icon"></i>
            <input type="text" id="NombreUsuario" name="NombreUsuario" class="nl-input"
                   placeholder="Su nombre de usuario" required/>
          </div>
        </div>

        <div class="nl-form-group">
          <label class="nl-label" for="Email">Correo Electronico Registrado</label>
          <div class="nl-input-wrapper">
            <i class="bi bi-envelope nl-input-icon"></i>
            <input type="email" id="Email" name="Email" class="nl-input"
                   placeholder="correo@nurselogic.ec" required/>
          </div>
        </div>

        <button type="submit" id="btnRecuperar" class="nl-btn-submit">
          <i class="bi bi-send-fill"></i> Recuperar Contraseña
        </button>
      </form>
      <% } %>
    </div>

    <div class="nl-card-footer">
      <p class="nl-footer-text">
        <a href="${pageContext.request.contextPath}/login.jsp" id="linkVolverLogin">
          &larr; Volver al inicio de sesion
        </a>
        &nbsp;&middot;&nbsp;
        <a href="${pageContext.request.contextPath}/RecuperarUsuarioServlet" id="linkRecupUsuario">
          Recuperar usuario
        </a>
      </p>
    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
