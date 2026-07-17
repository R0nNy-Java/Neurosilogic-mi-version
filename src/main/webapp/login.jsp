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
  <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@600;700&family=Inter:wght@400;500;600&family=IBM+Plex+Mono:wght@500&display=swap" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>

<body style="font-family:'Inter',sans-serif;">

  <div class="container-fluid p-0">
    <div class="row g-0 min-vh-100">

      <!-- ══ PANEL IZQUIERDO – MARCA (solo desktop) ══ -->
      <div class="col-lg-8 d-none d-lg-flex flex-column bg-brand-gradient text-white p-5">

        <!-- Marca superior -->
        <div>
          <div class="d-flex align-items-center gap-3 mb-3">
            <span class="rounded-circle bg-danger flex-shrink-0"
                  style="width:10px;height:10px;box-shadow:0 0 0 5px rgba(195,69,61,.25);">
            </span>
            <span class="fw-bold fs-5 text-white" style="font-family:'Space Grotesk',sans-serif;letter-spacing:.03em;">
              NURSELOGIC
            </span>
          </div>
          <p class="mb-0" style="max-width:340px;line-height:1.65;font-size:.95rem;color:#CFE3DE;">
            Lógica clínica y cálculos seguros para enfermería.
            Autenticación con roles diferenciados y trazabilidad
            completa de cada acceso.
          </p>
        </div>

        <!-- Centro: corazón + EKG -->
        <div class="flex-grow-1 d-flex flex-column align-items-center justify-content-center gap-4">
          <i class="bi bi-heart-pulse-fill heart-beat"
             style="font-size:5.5rem;color:rgba(255,255,255,.85);display:block;line-height:1;"></i>
          <div class="ekg-wrap">
            <svg class="ekg-svg" viewBox="0 0 420 60" xmlns="http://www.w3.org/2000/svg">
              <polyline class="ekg-line"
                points="0,30 30,30 50,30 60,10 70,50 80,10 90,30 110,30 120,30
                        140,30 150,30 160,10 170,50 180,10 190,30 210,30 220,30
                        240,30 250,30 260,10 270,50 280,10 290,30 310,30 320,30
                        340,30 350,30 360,10 370,50 380,10 390,30 420,30"/>
            </svg>
          </div>
        </div>

        <!-- Footer con estadísticas -->
        <div class="d-flex gap-4 border-top border-white border-opacity-25 pt-3">
          <div>
            <strong class="d-block font-monospace fs-5">24/7</strong>
            <small class="text-uppercase" style="font-size:.7rem;color:#9FC4BC;letter-spacing:.08em;">Disponibilidad</small>
          </div>
          <div>
            <strong class="d-block font-monospace fs-5">SSL</strong>
            <small class="text-uppercase" style="font-size:.7rem;color:#9FC4BC;letter-spacing:.08em;">Conexión segura</small>
          </div>
          <div>
            <strong class="d-block font-monospace fs-5">v1.0</strong>
            <small class="text-uppercase" style="font-size:.7rem;color:#9FC4BC;letter-spacing:.08em;">Sistema</small>
          </div>
        </div>

      </div><!-- /.col-lg-8 brand panel -->


      <!-- ══ PANEL DERECHO – FORMULARIO ══ -->
      <div class="col-12 col-lg-4 d-flex align-items-center justify-content-center bg-white p-4">
        <div class="w-100">

          <h2 class="fw-bold mb-1" style="font-family:'Space Grotesk',sans-serif;">Iniciar sesión</h2>
          <p class="text-muted small mb-4">Acceso al Sistema de Gestión Clínica</p>

          <%-- Mensaje de éxito (logout, nueva cuenta, cambio pass) --%>
          <%
            String successMsg = request.getParameter("msg");
            String errorMsg   = (String) request.getAttribute("errorMsg");
            if (successMsg != null && !successMsg.trim().isEmpty()) {
          %>
          <div class="alert alert-success d-flex align-items-center gap-2 py-2 small" role="alert">
            <i class="bi bi-check-circle-fill flex-shrink-0"></i><%= successMsg %>
          </div>
          <% } %>

          <%-- Mensaje de error del LoginServlet --%>
          <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
          <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small" role="alert">
            <i class="bi bi-exclamation-circle-fill flex-shrink-0"></i><%= errorMsg %>
          </div>
          <% } %>

          <%-- FORMULARIO → LoginServlet --%>
          <form id="formLogin"
                action="${pageContext.request.contextPath}/LoginServlet"
                method="POST" novalidate>

            <!-- Nombre de Usuario -->
            <label class="form-label small fw-semibold text-uppercase text-muted" for="NombreUsuario"
                   style="letter-spacing:.6px;">Nombre de Usuario</label>
            <div class="input-group mb-3">
              <span class="input-group-text"><i class="bi bi-person"></i></span>
              <input type="text" id="NombreUsuario" name="NombreUsuario"
                     class="form-control" placeholder="Ingrese su usuario"
                     autocomplete="username" required/>
            </div>

            <!-- Contraseña -->
            <label class="form-label small fw-semibold text-uppercase text-muted" for="Contrasena"
                   style="letter-spacing:.6px;">Contraseña</label>
            <div class="input-group mb-3">
              <span class="input-group-text"><i class="bi bi-lock"></i></span>
              <input type="password" id="Contrasena" name="Contrasena"
                     class="form-control" placeholder="Ingrese su contraseña"
                     autocomplete="current-password" required/>
            </div>

            <!-- Botón principal -->
            <button type="submit" id="btnIngresar"
                    class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2 mt-1">
              <i class="bi bi-box-arrow-in-right"></i>Ingresar al Sistema
            </button>

          </form>

          <!-- ══ ACCIONES SECUNDARIAS (3 botones) ══ -->
          <div class="row g-2 mt-3">

            <%-- 1. Registrar Usuario --%>
            <div class="col-4">
              <a href="${pageContext.request.contextPath}/NuevaCuentaServlet"
                 id="linkRegistrar"
                 class="btn btn-outline-secondary btn-sm w-100 py-3 d-flex flex-column align-items-center gap-1 text-muted text-decoration-none">
                <i class="bi bi-person-plus-fill fs-5"></i>
                <span style="font-size:.72rem;font-weight:600;line-height:1.3;">Registrar Usuario</span>
              </a>
            </div>

            <%-- 2. Olvidé mi Contraseña --%>
            <div class="col-4">
              <a href="${pageContext.request.contextPath}/OlvidoContrasenaServlet"
                 id="linkOlvido"
                 class="btn btn-outline-secondary btn-sm w-100 py-3 d-flex flex-column align-items-center gap-1 text-muted text-decoration-none">
                <i class="bi bi-key-fill fs-5"></i>
                <span style="font-size:.72rem;font-weight:600;line-height:1.3;">Olvidé mi Contraseña</span>
              </a>
            </div>

            <%-- 3. Recuperar Usuario --%>
            <div class="col-4">
              <a href="${pageContext.request.contextPath}/RecuperarUsuarioServlet"
                 id="linkRecuperar"
                 class="btn btn-outline-secondary btn-sm w-100 py-3 d-flex flex-column align-items-center gap-1 text-muted text-decoration-none">
                <i class="bi bi-person-exclamation fs-5"></i>
                <span style="font-size:.72rem;font-weight:600;line-height:1.3;">Recuperar Usuario</span>
              </a>
            </div>

          </div><!-- /.row acciones -->

          <!-- ══ FOOTER ══ -->
          <div class="bg-success bg-opacity-10 rounded-3 p-3 mt-4 text-center">
            <p class="text-muted small mb-0">
              <i class="bi bi-shield-lock-fill me-1"></i>
              Acceso restringido &middot; Solo personal autorizado &middot;
              <strong class="text-success">NURSELOGIC v1.0</strong>
            </p>
          </div>

        </div><!-- /.w-100 -->
      </div><!-- /.col form panel -->

    </div><!-- /.row -->
  </div><!-- /.container-fluid -->

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
