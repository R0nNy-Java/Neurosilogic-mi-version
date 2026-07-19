<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Recuperar Usuario</title>
  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>
<body class="min-vh-100 d-flex align-items-center justify-content-center bg-brand-gradient py-4" style="font-family:'Inter',sans-serif;">

  <div class="card border-0 shadow-lg overflow-hidden w-100 mx-3" style="max-width:440px;border-radius:1.25rem;">

    <!-- HEADER -->
    <div class="card-header bg-brand-gradient text-white text-center py-4 border-0">
      <div class="rounded-circle bg-white bg-opacity-25 border border-white border-opacity-50 d-inline-flex align-items-center justify-content-center mb-3" style="width:64px;height:64px;">
        <i class="bi bi-person-exclamation fs-3 text-white"></i>
      </div>
      <h1 class="fs-4 fw-bold mb-0 text-white">NURSELOGIC</h1>
      <p class="text-white-50 small mb-0">Recuperación de Cuenta</p>
    </div>

    <!-- BODY -->
    <div class="card-body p-4">
      <h6 class="text-center fw-semibold mb-1">Recuperar Nombre de Usuario</h6>
      <p class="text-center text-muted small mb-4">
        Ingrese su nombre completo y el correo registrado.<br/>
        Le mostraremos su nombre de usuario.
      </p>

      <%
        Boolean exitoso  = (Boolean) request.getAttribute("exitoso");
        String  usuarioR = (String)  request.getAttribute("usuarioRecuperado");
        String  rolU     = (String)  request.getAttribute("rolUsuario");
        String  errorMsg = (String)  request.getAttribute("errorMsg");

        if (Boolean.TRUE.equals(exitoso)) {
      %>
      <div class="bg-success bg-opacity-10 border border-success border-opacity-25 rounded-3 p-4 text-center mb-4">
        <div class="small fw-bold text-success text-uppercase mb-1" style="letter-spacing:.6px;">✓ Usuario encontrado</div>
        <div class="fs-3 fw-bold text-success font-monospace mb-2"><%= usuarioR %></div>
        <%
          String badgeClass = "bg-warning text-dark";
          String rolLabel   = "⏳ Rol Pendiente de Asignación";

          if ("ADMINISTRADOR".equalsIgnoreCase(rolU)) {
              badgeClass = "bg-primary text-white";
              rolLabel   = "Administrador";
          } else if ("ENFERMERO".equalsIgnoreCase(rolU)) {
              badgeClass = "bg-success text-white";
              rolLabel   = "Enfermero";
          }
        %>
        <span class="badge <%= badgeClass %> px-3 py-2 rounded-pill mb-2"><%= rolLabel %></span>
        <div class="text-muted small mt-2">Este es su nombre de usuario registrado en el sistema.</div>
      </div>
      <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2">
        <i class="bi bi-box-arrow-in-right"></i> Ir al Inicio de Sesión
      </a>

      <% } else { %>

      <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small" role="alert">
        <i class="bi bi-exclamation-circle-fill flex-shrink-0"></i><%= errorMsg %>
      </div>
      <% } %>

      <form id="formRecuperar" action="${pageContext.request.contextPath}/RecuperarUsuarioServlet" method="POST" novalidate>
        <label class="form-label small fw-semibold text-uppercase text-muted" for="NombreCompleto" style="letter-spacing:.6px;">Nombre Completo</label>
        <div class="input-group mb-3">
          <span class="input-group-text"><i class="bi bi-person-lines-fill"></i></span>
          <input type="text" id="NombreCompleto" name="NombreCompleto" class="form-control" placeholder="Como fue registrado en el sistema" required/>
        </div>

        <label class="form-label small fw-semibold text-uppercase text-muted" for="Email" style="letter-spacing:.6px;">Correo Electrónico Registrado</label>
        <div class="input-group mb-4">
          <span class="input-group-text"><i class="bi bi-envelope"></i></span>
          <input type="email" id="Email" name="Email" class="form-control" placeholder="correo@nurselogic.ec" required/>
        </div>

        <button type="submit" id="btnRecuperar" class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2">
          <i class="bi bi-search"></i> Buscar mi Usuario
        </button>
      </form>
      <% } %>
    </div>

    <!-- FOOTER -->
    <div class="card-footer bg-success bg-opacity-10 text-center border-0 py-3">
      <p class="text-muted small mb-0">
        <a href="${pageContext.request.contextPath}/login.jsp" id="linkVolverLogin" class="text-success fw-semibold text-decoration-none">
          ← Volver al inicio de sesión
        </a>
        &nbsp;&middot;&nbsp;
        <a href="${pageContext.request.contextPath}/OlvidoContrasenaServlet" id="linkOlvido" class="text-success fw-semibold text-decoration-none">
          Olvidé mi contraseña
        </a>
      </p>
    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
