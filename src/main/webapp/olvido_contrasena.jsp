<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <meta name="description" content="NURSELOGIC - Recuperacion de Acceso"/>
  <title>NURSELOGIC | Olvidé mi Contraseña</title>

  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>

<body class="min-vh-100 d-flex align-items-center justify-content-center bg-brand-gradient py-4"
      style="font-family:'Inter',sans-serif;">

  <div class="card border-0 shadow-lg overflow-hidden w-100 mx-3" style="max-width:440px;border-radius:1.25rem;">

    <!-- ══ HEADER ══ -->
    <div class="card-header bg-brand-gradient text-white text-center py-4 border-0">
      <div class="rounded-circle bg-white bg-opacity-25 border border-white border-opacity-50
                  d-inline-flex align-items-center justify-content-center mb-3"
           style="width:64px;height:64px;">
        <i class="bi bi-key-fill fs-3 text-white"></i>
      </div>
      <h1 class="fs-4 fw-bold mb-0 text-white">NURSELOGIC</h1>
      <p class="text-white-50 small mb-0">Recuperación de Acceso</p>
    </div>

    <!-- ══ CUERPO ══ -->
    <div class="card-body p-4">

      <%
        Boolean exitoso  = (Boolean) request.getAttribute("exitoso");
        String  usuarioR = (String)  request.getAttribute("usuarioRecuperado");
        String  passTemp = (String)  request.getAttribute("contrasenaTemp");
        String  errorMsg = (String)  request.getAttribute("errorMsg");

        if (Boolean.TRUE.equals(exitoso)) {
      %>
      <!-- ── Resultado exitoso ── -->
      <div class="text-center mb-3">
        <i class="bi bi-check-circle-fill text-success fs-1 d-block mb-2"></i>
        <h6 class="fw-bold mb-1">Contraseña temporal asignada</h6>
        <p class="text-muted small mb-3">
          Usuario: <strong><%= usuarioR %></strong>
        </p>
        <div class="bg-success bg-opacity-10 border border-success border-opacity-25 rounded-3 p-3 mb-3">
          <p class="text-muted small text-uppercase fw-semibold mb-1" style="font-size:.7rem;letter-spacing:.6px;">
            Tu nueva contraseña temporal
          </p>
          <code class="fs-4 fw-bold text-success"><%= passTemp %></code>
        </div>
        <p class="text-muted small">
          Ingresa con esta contraseña y cámbiala desde<br/>
          <em>Seguridad → Cambiar Contraseña</em>.
        </p>
        <a href="${pageContext.request.contextPath}/login.jsp"
           id="linkIrLogin"
           class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2 text-decoration-none">
          <i class="bi bi-box-arrow-in-right"></i>Ir al Inicio de Sesión
        </a>
      </div>

      <% } else { %>

      <h6 class="text-center fw-semibold mb-1">Olvidé mi Contraseña</h6>
      <p class="text-center text-muted small mb-4">
        Ingrese su usuario y correo registrado.<br/>
        Se le asignará una contraseña temporal.
      </p>

      <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small" role="alert">
        <i class="bi bi-exclamation-circle-fill flex-shrink-0"></i><%= errorMsg %>
      </div>
      <% } %>

      <form id="formOlvido"
            action="${pageContext.request.contextPath}/OlvidoContrasenaServlet"
            method="POST" novalidate>

        <label class="form-label small fw-semibold text-uppercase text-muted" for="NombreUsuario"
               style="letter-spacing:.6px;">Nombre de Usuario</label>
        <div class="input-group mb-3">
          <span class="input-group-text"><i class="bi bi-person"></i></span>
          <input type="text" id="NombreUsuario" name="NombreUsuario"
                 class="form-control" placeholder="Su nombre de usuario" required/>
        </div>

        <label class="form-label small fw-semibold text-uppercase text-muted" for="Email"
               style="letter-spacing:.6px;">Correo Electrónico Registrado</label>
        <div class="input-group mb-4">
          <span class="input-group-text"><i class="bi bi-envelope"></i></span>
          <input type="email" id="Email" name="Email"
                 class="form-control" placeholder="correo@nurselogic.ec" required/>
        </div>

        <button type="submit" id="btnRecuperar"
                class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2">
          <i class="bi bi-send-fill"></i>Recuperar Contraseña
        </button>

      </form>
      <% } %>
    </div><!-- /.card-body -->

    <!-- ══ FOOTER ══ -->
    <div class="card-footer bg-success bg-opacity-10 text-center border-0 py-3">
      <p class="text-muted small mb-0">
        <a href="${pageContext.request.contextPath}/login.jsp" id="linkVolverLogin"
           class="text-success fw-semibold text-decoration-none">
          ← Volver al inicio de sesión
        </a>
        &nbsp;&middot;&nbsp;
        <a href="${pageContext.request.contextPath}/RecuperarUsuarioServlet" id="linkRecupUsuario"
           class="text-success fw-semibold text-decoration-none">
          Recuperar usuario
        </a>
      </p>
    </div>

  </div><!-- /.card -->

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
