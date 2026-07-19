<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Cambio de Contraseña</title>

  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>
<body class="bg-light" style="font-family:'Inter',sans-serif;">

  <!-- OFFCANVAS SIDEBAR (móvil) -->
  <div class="offcanvas offcanvas-start nl-sidebar text-white" id="sidebarMobile" style="width:240px;" tabindex="-1">
    <div class="offcanvas-header border-bottom border-white border-opacity-10 py-3">
      <span class="fw-bold text-white">NURSELOGIC</span>
      <button type="button" class="btn-close btn-close-white" data-bs-dismiss="offcanvas" aria-label="Cerrar"></button>
    </div>
    <div class="offcanvas-body d-flex flex-column p-0">
      <div class="px-4 py-3">
        <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">Navegación Principal</small>
      </div>
      <ul class="nav flex-column px-2 flex-grow-1">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-grid-1x2-fill"></i>Dashboard
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/PacientesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-person-vcard-fill"></i>Pacientes
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/SignosVitalesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-activity"></i>Signos Vitales
          </a>
        </li>
      </ul>
    </div>
  </div>

  <div class="container-fluid p-0">
    <div class="row g-0 min-vh-100">

      <!-- SIDEBAR DESKTOP -->
      <nav class="col-auto d-none d-lg-flex flex-column nl-sidebar text-white p-0" id="nl-sidebar" style="width:240px;min-height:100vh;position:sticky;top:0;height:100vh;overflow-y:auto;">
        <a href="${pageContext.request.contextPath}/index.jsp" class="d-flex align-items-center gap-3 p-4 text-white text-decoration-none border-bottom border-white border-opacity-10">
          <div class="rounded-3 bg-success p-2 flex-shrink-0">
            <i class="bi bi-heart-pulse-fill text-white fs-5"></i>
          </div>
          <div>
            <div class="fw-bold small text-white" style="letter-spacing:1px;">NURSELOGIC</div>
            <div style="font-size:.62rem;" class="text-white-50">Gestión Clínica</div>
          </div>
        </a>
        <div class="px-4 py-3">
          <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">Navegación Principal</small>
        </div>
        <ul class="nav flex-column px-2 flex-grow-1">
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/PacientesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-person-vcard-fill"></i><span>Pacientes</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/SignosVitalesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-activity"></i><span>Signos Vitales</span>
            </a>
          </li>
        </ul>
      </nav>

      <!-- CONTENIDO PRINCIPAL -->
      <div class="col">
        <!-- Topbar móvil -->
        <nav class="navbar navbar-dark bg-brand-gradient d-lg-none shadow-sm px-3">
          <div class="container-fluid px-0">
            <button class="navbar-toggler border-0" type="button" data-bs-toggle="offcanvas" data-bs-target="#sidebarMobile">
              <span class="navbar-toggler-icon"></span>
            </button>
            <span class="navbar-brand fw-bold mb-0">NURSELOGIC</span>
          </div>
        </nav>

        <!-- Topbar desktop -->
        <header class="navbar navbar-dark bg-brand-gradient d-none d-lg-flex shadow-sm px-4" style="min-height:62px;">
          <div class="small text-white-50 d-flex align-items-center gap-2">
            <i class="bi bi-house-fill"></i><span>/</span><span>Seguridad</span><span>/</span>
            <span class="text-white fw-semibold">Cambio de Contraseña</span>
          </div>
          <div class="d-flex align-items-center gap-3 ms-auto">
            <%
              String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
              if (nombreSesion == null) nombreSesion = (String) session.getAttribute("usuario");
            %>
            <span class="text-white-50 small d-flex align-items-center gap-1">
              <i class="bi bi-person-circle"></i><%= nombreSesion != null ? nombreSesion : "" %>
            </span>
            <a href="${pageContext.request.contextPath}/LogoutServlet" id="btnLogout" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
              <i class="bi bi-box-arrow-right"></i>Salir
            </a>
          </div>
        </header>

        <main class="p-4">
          <div class="mb-4">
            <h1 class="h4 fw-bold d-flex align-items-center gap-2">
              <i class="bi bi-shield-lock-fill text-success"></i>Cambio de Contraseña
            </h1>
            <p class="text-muted small mt-1">Actualice su contraseña de acceso al sistema NURSELOGIC</p>
          </div>

          <div class="card border-0 shadow-sm rounded-4 mx-auto overflow-hidden" style="max-width:520px;">
            <div class="card-header bg-brand-gradient text-white p-4 border-0 d-flex align-items-center gap-3">
              <div class="rounded-3 bg-white bg-opacity-25 p-2 d-flex align-items-center justify-content-center" style="width:44px;height:44px;">
                <i class="bi bi-key-fill fs-4 text-white"></i>
              </div>
              <div>
                <h2 class="h5 fw-bold mb-0 text-white">Nueva Contraseña</h2>
                <p class="text-white-50 small mb-0">
                  Usuario: <strong>
                  <%= session != null && session.getAttribute("usuario") != null
                      ? session.getAttribute("usuario").toString().toUpperCase() : "" %>
                  </strong>
                </p>
              </div>
            </div>

            <div class="card-body p-4">
              <%
                String errorMsg = (String) request.getAttribute("errorMsg");
                if (errorMsg != null && !errorMsg.isEmpty()) {
              %>
              <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small" role="alert">
                <i class="bi bi-exclamation-circle-fill flex-shrink-0"></i><%= errorMsg %>
              </div>
              <% } %>

              <form id="formCambioPass" action="${pageContext.request.contextPath}/CambioContrasenaServlet" method="POST" novalidate>
                <!-- Sección: Verificación -->
                <div class="nl-sep">
                  <div class="nl-sep-icon"><i class="bi bi-check-circle-fill"></i></div>
                  <span class="nl-sep-label">Verificación</span>
                  <div class="nl-sep-line"></div>
                </div>

                <!-- Contraseña Actual -->
                <div class="mb-3">
                  <label class="form-label small fw-semibold text-uppercase text-muted" for="ContrasenaActual">Contraseña Actual *</label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" id="ContrasenaActual" name="ContrasenaActual" class="form-control" placeholder="Ingrese su contraseña actual" required/>
                    <button class="btn btn-outline-secondary" type="button" id="toggleAct" title="Mostrar/Ocultar contraseña">
                      <i class="bi bi-eye-slash" id="iconAct"></i>
                    </button>
                  </div>
                </div>

                <!-- Sección: Nueva Contraseña -->
                <div class="nl-sep mt-4">
                  <div class="nl-sep-icon"><i class="bi bi-shield-plus"></i></div>
                  <span class="nl-sep-label">Nueva Contraseña</span>
                  <div class="nl-sep-line"></div>
                </div>

                <!-- Nueva Contraseña -->
                <div class="mb-3">
                  <label class="form-label small fw-semibold text-uppercase text-muted" for="NuevaContrasena">Nueva Contraseña *</label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                    <input type="password" id="NuevaContrasena" name="NuevaContrasena" class="form-control" placeholder="Mínimo 6 caracteres" minlength="6" required/>
                    <button class="btn btn-outline-secondary" type="button" id="toggleNue" title="Mostrar/Ocultar contraseña">
                      <i class="bi bi-eye-slash" id="iconNue"></i>
                    </button>
                  </div>
                  <ul class="nl-req-list" id="reqList">
                    <li id="req-len" class="req-fail">
                      <i class="bi bi-circle"></i> Mínimo 6 caracteres
                    </li>
                    <li id="req-dif" class="req-fail">
                      <i class="bi bi-circle"></i> Distinta a la contraseña actual
                    </li>
                  </ul>
                </div>

                <!-- Confirmar Nueva Contraseña -->
                <div class="mb-4">
                  <label class="form-label small fw-semibold text-uppercase text-muted" for="ConfirmarContrasena">Confirmar Nueva Contraseña *</label>
                  <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock-fill"></i></span>
                    <input type="password" id="ConfirmarContrasena" name="ConfirmarContrasena" class="form-control" placeholder="Repita la nueva contraseña" required/>
                    <button class="btn btn-outline-secondary" type="button" id="toggleConf" title="Mostrar/Ocultar contraseña">
                      <i class="bi bi-eye-slash" id="iconConf"></i>
                    </button>
                  </div>
                  <p id="matchMsg" class="small mt-1 mb-0" style="color:#aac5c0;"></p>
                </div>

                <!-- Botones -->
                <div class="d-flex gap-3">
                  <button type="submit" id="btnGuardar" class="btn btn-success flex-grow-1 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2">
                    <i class="bi bi-floppy-fill"></i> Guardar Cambio
                  </button>
                  <button type="button" id="btnCancelar" class="btn btn-outline-secondary py-3 fw-semibold" onclick="window.history.back();">
                    <i class="bi bi-x-circle"></i> Cancelar
                  </button>
                </div>
              </form>

              <!-- Nota de seguridad -->
              <div class="nl-security-note">
                <i class="bi bi-info-circle-fill"></i>
                <span>Al guardar la nueva contraseña, su sesión actual se cerrará automáticamente y deberá iniciar sesión nuevamente con sus nuevas credenciales.</span>
              </div>
            </div>
          </div>
        </main>
      </div>

    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
  <script>
    function setupToggle(inputId, btnId, iconId) {
      document.getElementById(btnId).addEventListener('click', function() {
        const input = document.getElementById(inputId);
        const icon = document.getElementById(iconId);
        const esPass = input.type === 'password';
        input.type = esPass ? 'text' : 'password';
        icon.className = esPass ? 'bi bi-eye-fill text-success' : 'bi bi-eye-slash';
      });
    }
    setupToggle('ContrasenaActual', 'toggleAct', 'iconAct');
    setupToggle('NuevaContrasena', 'toggleNue', 'iconNue');
    setupToggle('ConfirmarContrasena', 'toggleConf', 'iconConf');

    const campoNueva   = document.getElementById('NuevaContrasena');
    const campoActual  = document.getElementById('ContrasenaActual');
    const campoConf    = document.getElementById('ConfirmarContrasena');
    const reqLen       = document.getElementById('req-len');
    const reqDif       = document.getElementById('req-dif');
    const matchMsg     = document.getElementById('matchMsg');

    function actualizar() {
      const nueva  = campoNueva.value;
      const actual = campoActual.value;

      if (nueva.length >= 6) {
        reqLen.className = 'req-ok';
        reqLen.innerHTML = '<i class="bi bi-check-circle-fill"></i> Mínimo 6 caracteres';
      } else {
        reqLen.className = 'req-fail';
        reqLen.innerHTML = '<i class="bi bi-circle"></i> Mínimo 6 caracteres';
      }

      if (nueva.length > 0 && actual.length > 0 && nueva !== actual) {
        reqDif.className = 'req-ok';
        reqDif.innerHTML = '<i class="bi bi-check-circle-fill"></i> Distinta a la contraseña actual';
      } else {
        reqDif.className = 'req-fail';
        reqDif.innerHTML = '<i class="bi bi-circle"></i> Distinta a la contraseña actual';
      }

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
