<%--
  Created by IntelliJ IDEA.
  User: Adrian Alexander
  Date: 19/7/26
  Time: 20:42
  To change this template use File | Settings | File Templates.
--%>
<%--
  NURSELOGIC - Escala de Glasgow
  Formulario clínico para el registro del componente ocular, verbal y motor,
  cálculo del puntaje total (3-15) y clasificación del nivel de severidad.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.rrparedes.dao.PacienteDAO, com.rrparedes.model.Paciente" %>
<%@ page import="com.rrparedes.model.EscalaGlasgow, java.util.List" %>
<%
    String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
    if (nombreSesion == null) nombreSesion = (session != null) ? (String) session.getAttribute("usuario") : "";

    String cedulaParam  = request.getParameter("cedula");
    String nombreParam  = request.getParameter("Paciente");

    if ((nombreParam == null || nombreParam.trim().isEmpty()) && cedulaParam != null && !cedulaParam.trim().isEmpty()) {
        PacienteDAO pDao = new PacienteDAO();
        Paciente p = pDao.buscarPorCedula(cedulaParam.trim());
        if (p != null) {
            nombreParam = p.getNombres() + " " + p.getApellidos();
        }
    }

    boolean tienePaciente = (nombreParam != null && !nombreParam.trim().isEmpty());
    boolean cedulaProvista = (cedulaParam != null && !cedulaParam.trim().isEmpty());
    boolean pacienteNoEncontrado = (cedulaProvista && !tienePaciente);

    String errorMsg   = (String) request.getAttribute("errorMsg");
    String successMsg = (String) request.getAttribute("successMsg");
    Integer total = (Integer) request.getAttribute("totalGlasgowResult");
    String nivel  = (String) request.getAttribute("nivelResult");

    String nivelBadgeClass = "bg-secondary";
    if (nivel != null) {
        if (nivel.equals("Leve")) nivelBadgeClass = "bg-success";
        else if (nivel.equals("Moderado")) nivelBadgeClass = "bg-warning text-dark";
        else if (nivel.equals("Grave")) nivelBadgeClass = "bg-danger";
    }

    // Historial de evaluaciones previas de Glasgow para este paciente
    List<EscalaGlasgow> historialGlasgow = (List<EscalaGlasgow>) request.getAttribute("historialGlasgow");
    boolean yaTienePrueba = (historialGlasgow != null && !historialGlasgow.isEmpty());
    EscalaGlasgow ultimaPrueba = yaTienePrueba ? historialGlasgow.get(0) : null;

    String ultimoNivel = null;
    String ultimoBadgeClass = "bg-secondary";
    if (ultimaPrueba != null) {
        ultimoNivel = ultimaPrueba.getNivelSeveridad();
        if (ultimoNivel == null && ultimaPrueba.getPuntajeTotal() != null) {
            int t = ultimaPrueba.getPuntajeTotal();
            ultimoNivel = t >= 13 ? "Leve" : t >= 9 ? "Moderado" : "Grave";
        }
        if ("Leve".equals(ultimoNivel)) ultimoBadgeClass = "bg-success";
        else if ("Moderado".equals(ultimoNivel)) ultimoBadgeClass = "bg-warning text-dark";
        else if ("Grave".equals(ultimoNivel)) ultimoBadgeClass = "bg-danger";
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <title>NURSELOGIC | Escala de Glasgow</title>
    <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
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
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/GlasgowServlet" class="nav-link nl-nav-link active d-flex align-items-center gap-3 py-2 px-3">
                    <i class="bi bi-clipboard2-data-fill"></i>Escala Glasgow
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
                    <a href="${pageContext.request.contextPath}/PacientesServlet" id="nav-pacientes" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
                        <i class="bi bi-person-vcard-fill"></i><span>Pacientes</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
                        <i class="bi bi-activity"></i><span>Signos Vitales</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/GlasgowServlet" id="nav-glasgow" class="nav-link nl-nav-link active d-flex align-items-center gap-3 py-2 px-3">
                        <i class="bi bi-clipboard2-data-fill"></i><span>Escala Glasgow</span>
                    </a>
                </li>
            </ul>
        </nav>

        <!-- CONTENIDO PRINCIPAL -->
        <div class="col nl-main-col">
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
                    <i class="bi bi-house-fill"></i><span>/</span><span>Herramientas</span><span>/</span>
                    <span class="text-white fw-semibold">Escala de Glasgow</span>
                </div>
                <div class="ms-auto d-flex align-items-center gap-2">
                    <% if (cedulaParam != null && !cedulaParam.trim().isEmpty()) { %>
                    <a href="${pageContext.request.contextPath}/PanelPacienteServlet?cedula=<%= cedulaParam %>" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-arrow-left"></i> Volver al Panel del Paciente
                    </a>
                    <% } else { %>
                    <button type="button" onclick="history.back()" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
                        <i class="bi bi-arrow-left"></i> Volver
                    </button>
                    <% } %>
                </div>
            </header>

            <main class="p-4">
                <!-- ENCABEZADO -->
                <div class="d-flex align-items-center justify-content-between mb-4">
                    <div>
                        <h1 class="h4 fw-bold mb-0 text-dark d-flex align-items-center gap-2">
                            <i class="bi bi-clipboard2-data-fill text-success"></i> Escala de Glasgow
                        </h1>
                        <p class="text-muted small mb-0">Respuesta Ocular (1-4) · Verbal (1-5) · Motora (1-6)</p>
                    </div>
                    <% if (cedulaParam != null && !cedulaParam.trim().isEmpty()) { %>
                    <a href="${pageContext.request.contextPath}/PanelPacienteServlet?cedula=<%= cedulaParam %>" class="btn btn-outline-secondary btn-sm d-inline-flex align-items-center gap-1">
                        <i class="bi bi-arrow-left-circle"></i> Volver al Panel
                    </a>
                    <% } else { %>
                    <button type="button" onclick="history.back()" class="btn btn-outline-secondary btn-sm d-inline-flex align-items-center gap-1">
                        <i class="bi bi-arrow-left-circle"></i> Volver
                    </button>
                    <% } %>
                </div>

                <% if (!tienePaciente) { %>
                <!-- ══════════ BUSCADOR POR CÉDULA (acceso directo, sin paciente) ══════════ -->
                <div class="row justify-content-center">
                    <div class="col-lg-6 col-md-8">
                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                            <div class="card-header bg-brand-gradient text-white p-4 border-0 d-flex align-items-center gap-3">
                                <div class="rounded-3 bg-white bg-opacity-25 p-2 d-flex align-items-center justify-content-center" style="width:44px;height:44px;">
                                    <i class="bi bi-search fs-4 text-white"></i>
                                </div>
                                <div>
                                    <h2 class="h5 fw-bold mb-0 text-white">Buscar Paciente</h2>
                                    <p class="text-white-50 small mb-0">Ingrese la cédula para cargar la ficha clínica</p>
                                </div>
                            </div>
                            <div class="card-body p-4">
                                <% if (pacienteNoEncontrado) { %>
                                <div class="alert alert-danger d-flex align-items-center gap-2 mb-3" role="alert">
                                    <i class="bi bi-exclamation-triangle-fill"></i>
                                    <span>No se encontró ningún paciente con la cédula <b><%= cedulaParam.trim() %></b>.</span>
                                </div>
                                <% } %>
                                <form action="${pageContext.request.contextPath}/GlasgowServlet" method="GET">
                                    <label class="form-label small fw-semibold text-uppercase text-muted" for="cedulaBusqueda">Cédula del Paciente *</label>
                                    <div class="input-group">
                                        <input type="text" id="cedulaBusqueda" name="cedula" class="form-control py-2" placeholder="Ej: 1712345678" maxlength="10" pattern="[0-9]{10}" inputmode="numeric" value="<%= cedulaParam != null ? cedulaParam.trim() : "" %>" required autofocus/>
                                        <button type="submit" class="btn btn-success d-flex align-items-center gap-2 px-4">
                                            <i class="bi bi-search"></i> Buscar
                                        </button>
                                    </div>
                                    <div class="form-text" style="font-size:.73rem;">
                                        También puede acceder directamente desde el Panel del Paciente, donde el nombre y la cédula ya vienen precargados.
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <% } else { %>

                <div class="row g-4">

                    <!-- ══════════ COLUMNA IZQUIERDA: FORMULARIO ══════════ -->
                    <div class="col-lg-7">

                        <!-- ALERTAS -->
                        <% if (errorMsg != null) { %>
                        <div class="alert alert-danger d-flex align-items-center gap-2" role="alert">
                            <i class="bi bi-exclamation-triangle-fill"></i><span><%= errorMsg %></span>
                        </div>
                        <% } %>
                        <% if (successMsg != null) { %>
                        <div class="alert alert-success d-flex align-items-center gap-2" role="alert">
                            <i class="bi bi-check-circle-fill"></i><span><%= successMsg %></span>
                        </div>
                        <% } %>

                        <!-- RESULTADO -->
                        <% if (total != null && nivel != null) { %>
                        <div class="card border-0 shadow-sm rounded-4 mb-4 overflow-hidden">
                            <div class="card-body p-4 d-flex align-items-center justify-content-between">
                                <div>
                                    <div class="text-uppercase text-muted small fw-semibold">Puntaje Total Glasgow</div>
                                    <div class="fw-bold text-dark" style="font-size:2rem;line-height:1;"><%= total %><span class="fs-6 text-muted">/15</span></div>
                                </div>
                                <span class="badge <%= nivelBadgeClass %> rounded-pill px-3 py-2 fs-6"><%= nivel %></span>
                            </div>
                        </div>
                        <% } %>

                        <!-- FORMULARIO -->
                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
                            <div class="card-header bg-brand-gradient text-white p-4 border-0 d-flex align-items-center gap-3">
                                <div class="rounded-3 bg-white bg-opacity-25 p-2 d-flex align-items-center justify-content-center" style="width:44px;height:44px;">
                                    <i class="bi bi-clipboard2-data-fill fs-4 text-white"></i>
                                </div>
                                <div>
                                    <h2 class="h5 fw-bold mb-0 text-white">Registro de Escala Glasgow</h2>
                                    <p class="text-white-50 small mb-0">
                                        <%= tienePaciente ? "Paciente: " + nombreParam : "Evaluación neurológica del paciente" %>
                                    </p>
                                </div>
                            </div>
                            <div class="card-body p-4">
                                <form action="${pageContext.request.contextPath}/GlasgowServlet" method="POST" novalidate>
                                    <% if (cedulaParam != null && !cedulaParam.trim().isEmpty()) { %>
                                    <input type="hidden" name="cedula" value="<%= cedulaParam.trim() %>"/>
                                    <% } %>

                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold text-uppercase text-muted" for="Paciente">Paciente *</label>
                                        <input type="text" id="Paciente" name="Paciente" class="form-control py-2 <%= tienePaciente ? "bg-light text-dark fw-semibold" : "" %>" placeholder="Ingrese el nombre del paciente" value="<%= nombreParam != null ? nombreParam : "" %>" <%= tienePaciente ? "readonly" : "required" %>/>
                                        <% if (tienePaciente) { %>
                                        <div class="form-text text-success" style="font-size:.73rem;">
                                            <i class="bi bi-check-circle-fill me-1"></i>Nombre precargado automáticamente desde la Ficha Clínica.
                                        </div>
                                        <% } %>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold text-uppercase text-muted" for="FechaHora">Fecha y Hora *</label>
                                        <input type="datetime-local" id="FechaHora" name="FechaHora" class="form-control py-2" required/>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold text-uppercase text-muted" for="Ocular">Respuesta Ocular (1-4) *</label>
                                        <select id="Ocular" name="Ocular" class="form-select py-2 nl-glasgow-input" required>
                                            <option value="" selected disabled>Seleccione una opción</option>
                                            <option value="4">4 - Espontánea</option>
                                            <option value="3">3 - Al estímulo verbal</option>
                                            <option value="2">2 - Al estímulo doloroso</option>
                                            <option value="1">1 - Ninguna</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold text-uppercase text-muted" for="Verbal">Respuesta Verbal (1-5) *</label>
                                        <select id="Verbal" name="Verbal" class="form-select py-2 nl-glasgow-input" required>
                                            <option value="" selected disabled>Seleccione una opción</option>
                                            <option value="5">5 - Orientada</option>
                                            <option value="4">4 - Confusa</option>
                                            <option value="3">3 - Palabras inapropiadas</option>
                                            <option value="2">2 - Sonidos incomprensibles</option>
                                            <option value="1">1 - Ninguna</option>
                                        </select>
                                    </div>

                                    <div class="mb-3">
                                        <label class="form-label small fw-semibold text-uppercase text-muted" for="Motor">Respuesta Motora (1-6) *</label>
                                        <select id="Motor" name="Motor" class="form-select py-2 nl-glasgow-input" required>
                                            <option value="" selected disabled>Seleccione una opción</option>
                                            <option value="6">6 - Obedece órdenes</option>
                                            <option value="5">5 - Localiza el dolor</option>
                                            <option value="4">4 - Retira ante el dolor</option>
                                            <option value="3">3 - Flexión anormal</option>
                                            <option value="2">2 - Extensión anormal</option>
                                            <option value="1">1 - Ninguna</option>
                                        </select>
                                    </div>

                                    <div class="mb-3 p-3 rounded-3 bg-light border d-flex align-items-center justify-content-between">
                                        <span class="small fw-semibold text-muted text-uppercase">Puntaje estimado</span>
                                        <span id="previewTotal" class="fw-bold fs-5 text-dark">--</span>
                                    </div>

                                    <div class="mb-4">
                                        <label class="form-label small fw-semibold text-uppercase text-muted" for="Observacion">Observaciones</label>
                                        <textarea id="Observacion" name="Observacion" class="form-control py-2" rows="3" placeholder="Observaciones clínicas adicionales (opcional)"></textarea>
                                    </div>

                                    <button type="submit" class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2 shadow-sm">
                                        <i class="bi bi-clipboard2-check"></i> Registrar Escala Glasgow
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>

                    <!-- ══════════ COLUMNA DERECHA: HISTORIAL ══════════ -->
                    <div class="col-lg-5">
                        <div class="card border-0 shadow-sm rounded-4 overflow-hidden" style="position:sticky; top:1rem;">
                            <div class="card-header bg-white p-3 d-flex align-items-center gap-2 border-bottom">
                                <div class="rounded-3 bg-success bg-opacity-10 p-2 d-flex align-items-center justify-content-center" style="width:38px;height:38px;">
                                    <i class="bi bi-clock-history text-success fs-5"></i>
                                </div>
                                <div>
                                    <h2 class="h6 fw-bold mb-0 text-dark">Historial de Evaluaciones</h2>
                                    <p class="text-muted mb-0" style="font-size:.72rem;">
                                        <% if (yaTienePrueba) { %>
                                        <%= historialGlasgow.size() %> registro<%= historialGlasgow.size() != 1 ? "s" : "" %> previo<%= historialGlasgow.size() != 1 ? "s" : "" %>
                                        <% } else { %>
                                        Sin registros previos
                                        <% } %>
                                    </p>
                                </div>
                            </div>
                            <div class="card-body p-3" style="max-height:680px;overflow-y:auto;">
                                <% if (!yaTienePrueba) { %>
                                <div class="text-center text-muted py-5">
                                    <i class="bi bi-inbox fs-1 d-block mb-2 opacity-50"></i>
                                    <span class="small">Este paciente no tiene evaluaciones de Glasgow registradas todavía.</span>
                                </div>
                                <% } else {
                                    for (EscalaGlasgow registro : historialGlasgow) {
                                        String nivelReg = registro.getNivelSeveridad();
                                        if (nivelReg == null && registro.getPuntajeTotal() != null) {
                                            int t = registro.getPuntajeTotal();
                                            nivelReg = t >= 13 ? "Leve" : t >= 9 ? "Moderado" : "Grave";
                                        }
                                        String badgeReg = "bg-secondary";
                                        if ("Leve".equals(nivelReg)) badgeReg = "bg-success";
                                        else if ("Moderado".equals(nivelReg)) badgeReg = "bg-warning text-dark";
                                        else if ("Grave".equals(nivelReg)) badgeReg = "bg-danger";
                                %>
                                <div class="border rounded-3 p-3 mb-2">
                                    <div class="d-flex justify-content-between align-items-start mb-2 gap-2">
                        <span class="small fw-semibold text-dark">
                          <i class="bi bi-calendar-event text-muted me-1"></i>
                          <%= registro.getFechaHora() != null ? registro.getFechaHora().toString().replace("T", " ") : "-" %>
                        </span>
                                        <span class="badge <%= badgeReg %> rounded-pill px-2 py-1 flex-shrink-0"><%= nivelReg %></span>
                                    </div>
                                    <div class="d-flex align-items-center justify-content-between">
                                        <div class="small text-muted">
                                            O:<b class="text-dark"><%= registro.getRespuestaOcular() %></b>
                                            &nbsp;·&nbsp; V:<b class="text-dark"><%= registro.getRespuestaVerbal() %></b>
                                            &nbsp;·&nbsp; M:<b class="text-dark"><%= registro.getRespuestaMotora() %></b>
                                        </div>
                                        <div class="fw-bold text-dark"><%= registro.getPuntajeTotal() %><span class="text-muted fw-normal">/15</span></div>
                                    </div>
                                    <% if (registro.getObservacion() != null && !registro.getObservacion().trim().isEmpty()) { %>
                                    <div class="small text-muted fst-italic mt-2" style="font-size:.75rem;">
                                        <i class="bi bi-chat-left-quote me-1"></i><%= registro.getObservacion() %>
                                    </div>
                                    <% } %>
                                </div>
                                <%   }
                                } %>
                            </div>
                        </div>
                    </div>

                </div>
                <% } %>
            </main>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
<script>
    // Vista previa en vivo del puntaje total (no reemplaza el cálculo del servidor)
    (function () {
        var selects = document.querySelectorAll('.nl-glasgow-input');
        var preview = document.getElementById('previewTotal');

        function actualizarPreview() {
            var ocular = document.getElementById('Ocular').value;
            var verbal = document.getElementById('Verbal').value;
            var motor  = document.getElementById('Motor').value;

            if (ocular && verbal && motor) {
                var total = parseInt(ocular, 10) + parseInt(verbal, 10) + parseInt(motor, 10);
                var nivel = total >= 13 ? 'Leve' : total >= 9 ? 'Moderado' : 'Grave';
                preview.textContent = total + '/15 (' + nivel + ')';
            } else {
                preview.textContent = '--';
            }
        }

        selects.forEach(function (s) { s.addEventListener('change', actualizarPreview); });
    })();
</script>
</body>
</html>
