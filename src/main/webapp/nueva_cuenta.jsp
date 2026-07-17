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
  <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>

<body class="min-vh-100 d-flex align-items-center justify-content-center bg-brand-gradient py-4"
      style="font-family:'Inter',sans-serif;">

  <div class="card border-0 shadow-lg overflow-hidden w-100 mx-3" style="max-width:500px;border-radius:1.25rem;">

    <!-- ══ HEADER ══ -->
    <div class="card-header bg-brand-gradient text-white text-center py-4 border-0">
      <div class="rounded-circle bg-white bg-opacity-25 border border-white border-opacity-50
                  d-inline-flex align-items-center justify-content-center mb-3"
           style="width:64px;height:64px;">
        <i class="bi bi-person-plus-fill fs-3 text-white"></i>
      </div>
      <h1 class="fs-4 fw-bold mb-0 text-white">NURSELOGIC</h1>
      <p class="text-white-50 small mb-0">Crear nueva cuenta de acceso</p>
    </div>

    <!-- ══ FORMULARIO ══ -->
    <div class="card-body p-4">
      <h6 class="text-center fw-semibold mb-4 text-muted">Registro de Usuario</h6>

      <%-- Mensajes de error o éxito --%>
      <%
        String errorMsg = (String) request.getAttribute("errorMsg");
        if (errorMsg != null && !errorMsg.isEmpty()) {
      %>
      <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small" role="alert">
        <i class="bi bi-exclamation-circle-fill flex-shrink-0"></i><%= errorMsg %>
      </div>
      <% } %>

      <form id="formNuevaCuenta"
            action="${pageContext.request.contextPath}/NuevaCuentaServlet"
            method="POST" novalidate>

        <!-- Nombre Completo -->
        <label class="form-label small fw-semibold text-uppercase text-muted" for="NombreCompleto"
               style="letter-spacing:.6px;">Nombre Completo *</label>
        <div class="input-group mb-1">
          <span class="input-group-text"><i class="bi bi-person"></i></span>
          <input type="text" id="NombreCompleto" name="NombreCompleto"
                 class="form-control" placeholder="Ej: Maria Elena Quishpe"
                 maxlength="100" required/>
        </div>
        <div class="mb-3"></div>

        <!-- Nombre de Usuario -->
        <label class="form-label small fw-semibold text-uppercase text-muted" for="NombreUsuario"
               style="letter-spacing:.6px;">Nombre de Usuario *</label>
        <div class="input-group mb-1">
          <span class="input-group-text"><i class="bi bi-at"></i></span>
          <input type="text" id="NombreUsuario" name="NombreUsuario"
                 class="form-control" placeholder="4-20 caracteres (letras, números, _)"
                 maxlength="20" pattern="[a-zA-Z0-9_\-]{4,20}" required/>
        </div>
        <div class="form-text text-muted mb-3" style="font-size:.72rem;">
          Solo letras, números, guiones bajos o medios. Ej: enfermera_01
        </div>

        <!-- Email -->
        <label class="form-label small fw-semibold text-uppercase text-muted" for="Email"
               style="letter-spacing:.6px;">Correo Electrónico</label>
        <div class="input-group mb-3">
          <span class="input-group-text"><i class="bi bi-envelope"></i></span>
          <input type="email" id="Email" name="Email"
                 class="form-control" placeholder="correo@nurselogic.ec"/>
        </div>

        <!-- Aviso de rol -->
        <div class="alert alert-warning d-flex align-items-start gap-2 py-2 small mb-3" role="alert">
          <i class="bi bi-info-circle-fill flex-shrink-0 mt-1"></i>
          <span>Su <strong>rol de acceso</strong> será asignado por un Administrador del sistema una vez que su cuenta sea revisada.</span>
        </div>

        <!-- Contraseña -->
        <label class="form-label small fw-semibold text-uppercase text-muted" for="Contrasena"
               style="letter-spacing:.6px;">Contraseña *</label>
        <div class="input-group mb-3">
          <span class="input-group-text"><i class="bi bi-lock"></i></span>
          <input type="password" id="Contrasena" name="Contrasena"
                 class="form-control" placeholder="Mínimo 6 caracteres"
                 minlength="6" required/>
        </div>

        <!-- Confirmar Contraseña -->
        <label class="form-label small fw-semibold text-uppercase text-muted" for="ConfirmarContrasena"
               style="letter-spacing:.6px;">Confirmar Contraseña *</label>
        <div class="input-group mb-4">
          <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
          <input type="password" id="ConfirmarContrasena" name="ConfirmarContrasena"
                 class="form-control" placeholder="Repita su contraseña" required/>
        </div>

        <button type="submit" id="btnRegistrar"
                class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2">
          <i class="bi bi-person-check-fill"></i>Crear Cuenta
        </button>

      </form>
    </div><!-- /.card-body -->

    <!-- ══ FOOTER ══ -->
    <div class="card-footer bg-success bg-opacity-10 text-center border-0 py-3">
      <p class="text-muted small mb-0">
        ¿Ya tienes una cuenta?
        <a href="${pageContext.request.contextPath}/login.jsp" id="linkLogin"
           class="text-success fw-semibold text-decoration-none">Iniciar sesión</a>
      </p>
    </div>

  </div><!-- /.card -->

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
  <script>
    /* Validación del lado del cliente: contraseñas coincidan */
    document.getElementById('btnRegistrar').addEventListener('click', function(e) {
      const p1 = document.getElementById('Contrasena').value;
      const p2 = document.getElementById('ConfirmarContrasena').value;
      if (p1 && p2 && p1 !== p2) {
        e.preventDefault();
        alert('Las contraseñas no coinciden. Verifique.');
      }
    });
  </script>
</body>
</html>
