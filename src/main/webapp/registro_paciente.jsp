<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <meta name="description" content="NURSELOGIC - Apertura / Edición de Ficha Clinica"/>
  <title>NURSELOGIC | Ficha Clínica de Paciente</title>

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
          <a href="${pageContext.request.contextPath}/PacientesServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
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
            <a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/PacientesServlet" id="nav-pacientes" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
              <i class="bi bi-person-vcard-fill"></i><span>Pacientes</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-activity"></i><span>Signos Vitales</span>
            </a>
          </li>
        </ul>

        <div class="border-top border-white border-opacity-10 p-3 mt-auto">
          <div class="d-flex align-items-center gap-2 mb-2">
            <div class="rounded-circle bg-success d-flex align-items-center justify-content-center flex-shrink-0" style="width:36px;height:36px;">
              <i class="bi bi-person-fill text-white small"></i>
            </div>
            <div class="overflow-hidden">
              <%
                String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : null;
                if (nombreSesion == null && session != null) nombreSesion = (String) session.getAttribute("usuario");
                String rolSesion = (session != null) ? (String) session.getAttribute("rol") : "";
              %>
              <div class="text-white small fw-semibold text-truncate"><%= nombreSesion != null ? nombreSesion : "Usuario" %></div>
              <div style="font-size:.7rem;" class="text-white-50"><%= rolSesion != null ? rolSesion : "Sesión activa" %></div>
            </div>
          </div>
        </div>
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
            <i class="bi bi-house-fill"></i><span>/</span>
            <a href="${pageContext.request.contextPath}/PacientesServlet" class="text-white-50 text-decoration-none">Pacientes</a><span>/</span>
            <span class="text-white fw-semibold">Ficha Clínica</span>
          </div>
          <div class="d-flex align-items-center gap-3 ms-auto">
            <span class="text-white-50 small" id="nl-datetime"></span>
            <a href="${pageContext.request.contextPath}/LogoutServlet" id="btnLogout" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
              <i class="bi bi-box-arrow-right"></i>Salir
            </a>
          </div>
        </header>

        <main class="p-4">
          <div class="mb-4">
            <h1 class="h4 fw-bold d-flex align-items-center gap-2">
              <i class="bi bi-file-earmark-medical-fill text-success"></i>Ficha Clínica de Paciente
            </h1>
            <p class="text-muted small mt-1">Apertura o actualización de datos clínicos en el sistema NURSELOGIC</p>
          </div>

          <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4">
            <div class="card-header bg-brand-gradient text-white p-4 border-0 d-flex align-items-center gap-3">
              <div class="rounded-3 bg-white bg-opacity-25 p-2 d-flex align-items-center justify-content-center" style="width:44px;height:44px;">
                <i class="bi bi-clipboard2-pulse-fill fs-4 text-white"></i>
              </div>
              <div>
                <h2 class="h5 fw-bold mb-0 text-white">Formulario Ficha Clínica</h2>
                <p class="text-white-50 small mb-0">Los datos de cédula existente se actualizarán automáticamente</p>
              </div>
            </div>

            <div class="card-body p-4">
              <%
                String errorMsg = (String) request.getAttribute("errorMsg");
                if (errorMsg != null && !errorMsg.isEmpty()) {
              %>
              <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small mb-4" role="alert">
                <i class="bi bi-exclamation-circle-fill flex-shrink-0"></i><strong><%= errorMsg %></strong>
              </div>
              <% } %>

              <form id="formRegistroPaciente" action="${pageContext.request.contextPath}/RegistroPacienteServlet" method="POST" novalidate>
                <!-- 1. DATOS DEMOGRÁFICOS -->
                <div class="nl-sep">
                  <div class="nl-sep-icon"><i class="bi bi-person-lines-fill"></i></div>
                  <span class="nl-sep-label">1. Datos Demográficos</span>
                  <div class="nl-sep-line"></div>
                </div>

                <div class="row g-3 mb-3">
                  <div class="col-md-4">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="Cedula">Cédula de Identidad *</label>
                    <input type="text" id="Cedula" name="Cedula" class="form-control py-2" placeholder="10 dígitos" maxlength="10" pattern="\d{10}" inputmode="numeric" value="${requestScope.paramCedula != null ? requestScope.paramCedula : param.Cedula}" required onblur="comprobarCedulaExistente(this.value)"/>
                    <div class="form-text text-muted" style="font-size:.72rem;">Al ingresar la cédula, si el paciente ya existe se prellenarán sus datos.</div>
                  </div>
                  <div class="col-md-4">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="Nombres">Nombres *</label>
                    <input type="text" id="Nombres" name="Nombres" class="form-control py-2" placeholder="Ej: María Elena" maxlength="80" value="${requestScope.paramNombres != null ? requestScope.paramNombres : param.Nombres}" required />
                  </div>
                  <div class="col-md-4">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="Apellidos">Apellidos *</label>
                    <input type="text" id="Apellidos" name="Apellidos" class="form-control py-2" placeholder="Ej: Quishpe Toapanta" maxlength="80" value="${requestScope.paramApellidos != null ? requestScope.paramApellidos : param.Apellidos}" required />
                  </div>
                </div>

                <div class="row g-3 mb-4">
                  <div class="col-md-6">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="Edad">Edad (años) *</label>
                    <input type="number" id="Edad" name="Edad" class="form-control py-2" placeholder="19 – 60" min="19" max="60" value="${requestScope.paramEdad != null ? requestScope.paramEdad : param.Edad}" required />
                  </div>
                  <div class="col-md-6">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="Sexo">Sexo *</label>
                    <% String sVal = (String) request.getAttribute("paramSexo"); if(sVal==null) sVal=request.getParameter("Sexo"); %>
                    <select id="Sexo" name="Sexo" class="form-select py-2" required>
                      <option value="" disabled <%= (sVal==null||sVal.isEmpty()) ? "selected" : "" %>>-- Seleccione --</option>
                      <option value="M" <%= "M".equalsIgnoreCase(sVal) ? "selected" : "" %>>Masculino (H)</option>
                      <option value="F" <%= "F".equalsIgnoreCase(sVal) ? "selected" : "" %>>Femenino (M)</option>
                    </select>
                  </div>
                </div>

                <!-- 2. ANTECEDENTES CLÍNICOS -->
                <div class="nl-sep">
                  <div class="nl-sep-icon"><i class="bi bi-journal-medical"></i></div>
                  <span class="nl-sep-label">2. Antecedentes Clínicos</span>
                  <div class="nl-sep-line"></div>
                </div>

                <div class="row g-3 mb-3">
                  <div class="col-md-3">
                    <div class="form-check card p-3 border rounded-3 h-100">
                      <input class="form-check-input" type="checkbox" id="antDiabetes" name="Antecedentes" value="DIABETES" onchange="toggleGlicemia(this)"/>
                      <label class="form-check-label fw-semibold text-dark d-flex align-items-center gap-2" for="antDiabetes">
                        <i class="bi bi-droplet-fill text-danger"></i> Diabetes
                      </label>
                    </div>
                  </div>
                  <div class="col-md-3">
                    <div class="form-check card p-3 border rounded-3 h-100">
                      <input class="form-check-input" type="checkbox" id="antHipertension" name="Antecedentes" value="HIPERTENSION"/>
                      <label class="form-check-label fw-semibold text-dark d-flex align-items-center gap-2" for="antHipertension">
                        <i class="bi bi-heart-fill text-danger"></i> Hipertensión
                      </label>
                    </div>
                  </div>
                  <div class="col-md-3">
                    <div class="form-check card p-3 border rounded-3 h-100">
                      <input class="form-check-input" type="checkbox" id="antCancer" name="Antecedentes" value="CANCER"/>
                      <label class="form-check-label fw-semibold text-dark d-flex align-items-center gap-2" for="antCancer">
                        <i class="bi bi-bandaid-fill text-primary"></i> Cáncer
                      </label>
                    </div>
                  </div>
                  <div class="col-md-3">
                    <div class="form-check card p-3 border rounded-3 h-100">
                      <input class="form-check-input" type="checkbox" id="antOtros" name="Antecedentes" value="OTROS" onchange="toggleOtrosAntecedentes(this)"/>
                      <label class="form-check-label fw-semibold text-dark d-flex align-items-center gap-2" for="antOtros">
                        <i class="bi bi-plus-circle-fill text-success"></i> Otros
                      </label>
                    </div>
                  </div>
                </div>

                <!-- Campo dinámico Glicemia -->
                <div id="glicemiaSection" style="display:none;" class="row g-3 mb-3 fade-in">
                  <div class="col-md-6">
                    <div class="alert alert-warning border border-warning rounded-3 p-3 mb-0">
                      <label class="form-label small fw-bold text-danger text-uppercase mb-2" for="GlicemiaInicial">
                        <i class="bi bi-exclamation-triangle-fill me-1"></i> Glicemia Inicial (mg/dL) * <span class="fw-normal text-muted">(Obligatorio por antecedente de Diabetes)</span>
                      </label>
                      <input type="number" id="GlicemiaInicial" name="GlicemiaInicial" class="form-control" placeholder="Ej: 126 mg/dL" min="0" max="999" step="1" value="${requestScope.paramGlicemia != null ? requestScope.paramGlicemia : param.GlicemiaInicial}"/>
                    </div>
                  </div>
                </div>

                <!-- Campo dinámico Otros -->
                <div id="otrosSection" style="display:none;" class="row g-3 mb-4 fade-in">
                  <div class="col-md-12">
                    <div class="alert alert-info border border-info rounded-3 p-3 mb-0">
                      <label class="form-label small fw-bold text-success text-uppercase mb-2" for="OtrosAntecedentesTexto">
                        <i class="bi bi-info-circle-fill me-1"></i> Especificar Otros Antecedentes Clínicos *
                      </label>
                      <input type="text" id="OtrosAntecedentesTexto" name="OtrosAntecedentesTexto" class="form-control" placeholder="Ej: Asma, Insuficiencia Renal Crónica, EPOC..." value="${requestScope.paramOtrosTexto != null ? requestScope.paramOtrosTexto : param.OtrosAntecedentesTexto}"/>
                    </div>
                  </div>
                </div>

                <!-- 3. OBSERVACIONES CLÍNICAS -->
                <div class="nl-sep">
                  <div class="nl-sep-icon"><i class="bi bi-stethoscope"></i></div>
                  <span class="nl-sep-label">3. Observaciones Clínicas</span>
                  <div class="nl-sep-line"></div>
                </div>

                <div class="row g-3 mb-4">
                  <div class="col-12">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="SintomasActuales">Síntomas Actuales</label>
                    <textarea id="SintomasActuales" name="SintomasActuales" class="form-control" placeholder="Describa los síntomas que presenta el paciente..." rows="3">${requestScope.paramSintomas != null ? requestScope.paramSintomas : param.SintomasActuales}</textarea>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="Alergias">Alergias Conocidas</label>
                    <textarea id="Alergias" name="Alergias" class="form-control" placeholder="Ej: Penicilina, látex, ibuprofeno..." rows="3">${requestScope.paramAlergias != null ? requestScope.paramAlergias : param.Alergias}</textarea>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="DispositivosMedicos">Dispositivos Médicos</label>
                    <textarea id="DispositivosMedicos" name="DispositivosMedicos" class="form-control" placeholder="Ej: Marcapasos, catéter..." rows="3">${requestScope.paramDispositivos != null ? requestScope.paramDispositivos : param.DispositivosMedicos}</textarea>
                  </div>
                </div>

                <!-- BOTONES -->
                <div class="d-flex gap-3">
                  <button type="submit" id="btnGuardar" class="btn btn-success flex-grow-1 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2">
                    <i class="bi bi-floppy-fill"></i> Guardar y Continuar al Panel
                  </button>
                  <button type="button" id="btnCancelar" class="btn btn-outline-secondary py-3 fw-semibold">
                    <i class="bi bi-x-circle"></i> Cancelar
                  </button>
                </div>
              </form>
            </div>

            <div class="card-footer bg-success bg-opacity-10 border-0 p-3 small text-muted">
              <i class="bi bi-info-circle-fill me-1"></i>
              Al presionar "Guardar y Continuar", se guardará el registro en MySQL y se abrirá el panel individual del paciente.
            </div>
          </div>
        </main>
      </div>

    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>

  <script>
    function updateTime() {
      const now = new Date();
      const opts = { weekday: 'short', year: 'numeric', month: 'short', day: '2-digit', hour: '2-digit', minute: '2-digit' };
      const str = now.toLocaleDateString('es-EC', opts);
      const el = document.getElementById('nl-datetime');
      if (el) el.textContent = str;
    }
    updateTime();

    document.getElementById('Cedula').addEventListener('input', function () {
      this.value = this.value.replace(/\D/g, '').slice(0, 10);
    });

  async function comprobarCedulaExistente(cedula) {
    if (!cedula || cedula.length !== 10) return;

    try {
      const resp = await fetch(
              '${pageContext.request.contextPath}/RegistroPacienteServlet?cedula=' + cedula
      );
      if (!resp.ok) return;

      const html = await resp.text();
      const doc = new DOMParser().parseFromString(html, 'text/html');

      // Si el paciente no existe, el servlet devuelve el formulario vacío:
      // no sobrescribimos nada (y jamás tocamos el campo Cédula).
      const nombresEncontrados = doc.getElementById('Nombres')?.value;
      if (!nombresEncontrados) return;

      const setIfPresent = (id) => {
        const nuevo = doc.getElementById(id);
        const actual = document.getElementById(id);
        if (nuevo && actual) actual.value = nuevo.value;
      };

      setIfPresent('Nombres');
      setIfPresent('Apellidos');
      setIfPresent('Edad');
      setIfPresent('SintomasActuales');
      setIfPresent('Alergias');
      setIfPresent('DispositivosMedicos');

      const sexoNuevo = doc.getElementById('Sexo')?.value;
      if (sexoNuevo) document.getElementById('Sexo').value = sexoNuevo;

    } catch (e) {
      console.error('No se pudo verificar la cédula existente:', e);
      }
    }

    document.getElementById('btnCancelar').addEventListener('click', function (e) {
      if (confirm('Se perderán los datos no guardados. ¿Desea regresar al listado de pacientes?')) {
        window.location.href = '${pageContext.request.contextPath}/PacientesServlet';
      }
    });

    function toggleGlicemia(checkbox) {
      const section = document.getElementById('glicemiaSection');
      const inputGlic = document.getElementById('GlicemiaInicial');
      if (checkbox.checked) {
        section.style.display = 'block';
        inputGlic.setAttribute('required', 'required');
      } else {
        section.style.display = 'none';
        inputGlic.removeAttribute('required');
      }
    }

    function toggleOtrosAntecedentes(checkbox) {
      const section = document.getElementById('otrosSection');
      const inputOtros = document.getElementById('OtrosAntecedentesTexto');
      if (checkbox.checked) {
        section.style.display = 'block';
        inputOtros.setAttribute('required', 'required');
      } else {
        section.style.display = 'none';
        inputOtros.removeAttribute('required');
      }
    }
  </script>
</body>
</html>
