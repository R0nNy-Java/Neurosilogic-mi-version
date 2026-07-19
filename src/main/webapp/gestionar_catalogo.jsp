<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  String nombreSesion = (session != null) ? (String) session.getAttribute("nombreCompleto") : "";
  if (nombreSesion == null) nombreSesion = (session != null) ? (String) session.getAttribute("usuario") : "";
%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Catálogo de Medicamentos</title>
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
      <div class="px-3 pt-3 pb-2">
        <span class="badge w-100 py-2 bg-info bg-opacity-25 text-info" style="font-size:.7rem;">
          <i class="bi bi-shield-fill me-1"></i>Administrador
        </span>
      </div>
      <div class="px-4 py-1">
        <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">Menú Principal</small>
      </div>
      <ul class="nav flex-column px-2 flex-grow-1 mt-1">
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/index.jsp" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-grid-1x2-fill"></i>Dashboard
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/GestionarUsuariosServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
            <i class="bi bi-people-fill"></i>Gestionar Usuarios
          </a>
        </li>
        <li class="nav-item">
          <a href="${pageContext.request.contextPath}/GestionarCatalogoServlet" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
            <i class="bi bi-journal-medical"></i>Catálogo Medicamentos
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
        <div class="px-3 pt-3 pb-2">
          <span class="badge w-100 py-2 bg-info bg-opacity-25 text-info" style="font-size:.7rem;">
            <i class="bi bi-shield-fill me-1"></i>Administrador
          </span>
        </div>
        <div class="px-4 py-1">
          <small class="fw-bold text-uppercase" style="color:rgba(255,255,255,.3);font-size:.65rem;letter-spacing:1px;">Menú Principal</small>
        </div>
        <ul class="nav flex-column px-2 flex-grow-1 mt-1">
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/GestionarUsuariosServlet" id="nav-usuarios" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3">
              <i class="bi bi-people-fill"></i><span>Gestionar Usuarios</span>
            </a>
          </li>
          <li class="nav-item">
            <a href="${pageContext.request.contextPath}/GestionarCatalogoServlet" id="nav-catalogo" class="nav-link nl-nav-link d-flex align-items-center gap-3 py-2 px-3 active">
              <i class="bi bi-journal-medical"></i><span>Catálogo Medicamentos</span>
            </a>
          </li>
        </ul>
        <div class="border-top border-white border-opacity-10 p-3 mt-auto">
          <div class="d-flex align-items-center gap-2 mb-2">
            <div class="rounded-circle bg-success d-flex align-items-center justify-content-center flex-shrink-0" style="width:36px;height:36px;">
              <i class="bi bi-person-fill text-white small"></i>
            </div>
            <div class="overflow-hidden">
              <div class="text-white small fw-semibold text-truncate"><%= nombreSesion %></div>
              <div style="font-size:.7rem;" class="text-white-50">Administrador</div>
            </div>
          </div>
          <a href="${pageContext.request.contextPath}/LogoutServlet" id="nav-logout" class="nav-link nl-nav-link d-flex align-items-center gap-2 py-2 px-3 small">
            <i class="bi bi-box-arrow-right"></i>Cerrar sesión
          </a>
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
          <span class="navbar-brand fw-semibold mb-0 d-flex align-items-center gap-2">
            <i class="bi bi-journal-medical"></i> Catálogo de Medicamentos
          </span>
          <div class="d-flex align-items-center gap-3 ms-auto">
            <span class="text-white-50 small d-flex align-items-center gap-1">
              <i class="bi bi-person-circle"></i><%= nombreSesion %>
            </span>
            <a href="${pageContext.request.contextPath}/LogoutServlet" id="btnLogoutTop" class="btn btn-outline-light btn-sm d-flex align-items-center gap-1">
              <i class="bi bi-box-arrow-right"></i>Salir
            </a>
          </div>
        </header>

        <main class="p-4">
          <div class="mb-4">
            <h1 class="h4 fw-bold d-flex align-items-center gap-2">
              <i class="bi bi-journal-medical text-success"></i>Catálogo de Medicamentos
            </h1>
            <p class="text-muted small mt-1">Administre los medicamentos disponibles en el sistema NURSELOGIC</p>
          </div>

          <%-- Mensajes del servlet --%>
          <%
            String successMsg = (String) request.getAttribute("successMsg");
            String errorMsg   = (String) request.getAttribute("errorMsg");
            if (successMsg != null && !successMsg.isEmpty()) {
          %>
          <div class="alert alert-success d-flex align-items-center gap-2 py-2 small" role="alert">
            <i class="bi bi-check-circle-fill flex-shrink-0"></i><%= successMsg %>
          </div>
          <% } %>
          <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
          <div class="alert alert-danger d-flex align-items-center gap-2 py-2 small" role="alert">
            <i class="bi bi-exclamation-circle-fill flex-shrink-0"></i><%= errorMsg %>
          </div>
          <% } %>

          <div class="nl-grid-2col">
            <!-- TABLA DE MEDICAMENTOS -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
              <div class="card-header bg-brand-gradient text-white p-3 border-0">
                <div class="fw-bold"><i class="bi bi-table me-2"></i>Medicamentos Registrados</div>
                <div class="text-white-50 small">Catálogo actual del sistema</div>
              </div>
              <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="tablaCatalogo">
                  <thead class="table-light">
                    <tr>
                      <th class="small fw-bold text-uppercase text-muted">Código</th>
                      <th class="small fw-bold text-uppercase text-muted">Medicamento</th>
                      <th class="small fw-bold text-uppercase text-muted">Descripción</th>
                      <th class="small fw-bold text-uppercase text-muted">Unidad</th>
                      <th class="small fw-bold text-uppercase text-muted">Stock</th>
                      <th class="small fw-bold text-uppercase text-muted">Acción</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr id="row-med-001">
                      <td><code>MED-001</code></td>
                      <td><strong>Paracetamol 500mg</strong></td>
                      <td>Analgésico y antipirético</td>
                      <td>Comprimido</td>
                      <td><span class="badge-stock stock-ok">120 uds</span></td>
                      <td>
                        <form action="${pageContext.request.contextPath}/GestionarCatalogoServlet" method="POST" class="d-inline" id="formDel-001">
                          <input type="hidden" name="accion" value="eliminar"/>
                          <input type="hidden" name="Codigo" value="MED-001"/>
                          <button type="submit" class="btn btn-sm btn-outline-danger d-inline-flex align-items-center gap-1" id="btnDel-001" onclick="return confirm('¿Eliminar Paracetamol 500mg del catálogo?')">
                            <i class="bi bi-trash3-fill"></i> Eliminar
                          </button>
                        </form>
                      </td>
                    </tr>
                    <tr id="row-med-002">
                      <td><code>MED-002</code></td>
                      <td><strong>Ibuprofeno 400mg</strong></td>
                      <td>Antiinflamatorio no esteroideo</td>
                      <td>Comprimido</td>
                      <td><span class="badge-stock stock-ok">85 uds</span></td>
                      <td>
                        <form action="${pageContext.request.contextPath}/GestionarCatalogoServlet" method="POST" class="d-inline" id="formDel-002">
                          <input type="hidden" name="accion" value="eliminar"/>
                          <input type="hidden" name="Codigo" value="MED-002"/>
                          <button type="submit" class="btn btn-sm btn-outline-danger d-inline-flex align-items-center gap-1" id="btnDel-002" onclick="return confirm('¿Eliminar Ibuprofeno 400mg del catálogo?')">
                            <i class="bi bi-trash3-fill"></i> Eliminar
                          </button>
                        </form>
                      </td>
                    </tr>
                    <tr id="row-med-003">
                      <td><code>MED-003</code></td>
                      <td><strong>Amoxicilina 500mg</strong></td>
                      <td>Antibiótico de amplio espectro</td>
                      <td>Cápsula</td>
                      <td><span class="badge-stock stock-low">18 uds</span></td>
                      <td>
                        <form action="${pageContext.request.contextPath}/GestionarCatalogoServlet" method="POST" class="d-inline" id="formDel-003">
                          <input type="hidden" name="accion" value="eliminar"/>
                          <input type="hidden" name="Codigo" value="MED-003"/>
                          <button type="submit" class="btn btn-sm btn-outline-danger d-inline-flex align-items-center gap-1" id="btnDel-003" onclick="return confirm('¿Eliminar Amoxicilina del catálogo?')">
                            <i class="bi bi-trash3-fill"></i> Eliminar
                          </button>
                        </form>
                      </td>
                    </tr>
                    <tr id="row-med-004">
                      <td><code>MED-004</code></td>
                      <td><strong>Suero Fisiológico 0.9%</strong></td>
                      <td>Solución isotónica para uso IV</td>
                      <td>Frasco 500ml</td>
                      <td><span class="badge-stock stock-ok">44 uds</span></td>
                      <td>
                        <form action="${pageContext.request.contextPath}/GestionarCatalogoServlet" method="POST" class="d-inline" id="formDel-004">
                          <input type="hidden" name="accion" value="eliminar"/>
                          <input type="hidden" name="Codigo" value="MED-004"/>
                          <button type="submit" class="btn btn-sm btn-outline-danger d-inline-flex align-items-center gap-1" id="btnDel-004" onclick="return confirm('¿Eliminar Suero Fisiológico del catálogo?')">
                            <i class="bi bi-trash3-fill"></i> Eliminar
                          </button>
                        </form>
                      </td>
                    </tr>
                    <tr id="row-med-005">
                      <td><code>MED-005</code></td>
                      <td><strong>Metformina 850mg</strong></td>
                      <td>Antidiabético oral (biguanida)</td>
                      <td>Comprimido</td>
                      <td><span class="badge-stock stock-out">0 uds</span></td>
                      <td>
                        <form action="${pageContext.request.contextPath}/GestionarCatalogoServlet" method="POST" class="d-inline" id="formDel-005">
                          <input type="hidden" name="accion" value="eliminar"/>
                          <input type="hidden" name="Codigo" value="MED-005"/>
                          <button type="submit" class="btn btn-sm btn-outline-danger d-inline-flex align-items-center gap-1" id="btnDel-005" onclick="return confirm('¿Eliminar Metformina del catálogo?')">
                            <i class="bi bi-trash3-fill"></i> Eliminar
                          </button>
                        </form>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- FORMULARIO AGREGAR MEDICAMENTO -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
              <div class="card-header bg-brand-gradient text-white p-3 border-0">
                <div class="fw-bold"><i class="bi bi-plus-circle-fill me-2"></i>Agregar Medicamento</div>
                <div class="text-white-50 small">Complete los datos del nuevo medicamento</div>
              </div>
              <div class="card-body p-4">
                <form id="formAgregarMed" action="${pageContext.request.contextPath}/GestionarCatalogoServlet" method="POST" novalidate>
                  <input type="hidden" name="accion" value="agregar"/>

                  <div class="mb-3">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="Codigo">Código *</label>
                    <input type="text" id="Codigo" name="Codigo" class="form-control" placeholder="Ej: MED-006" maxlength="20" required/>
                  </div>

                  <div class="mb-3">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="NombreMedicamento">Nombre del Medicamento *</label>
                    <input type="text" id="NombreMedicamento" name="NombreMedicamento" class="form-control" placeholder="Ej: Atorvastatina 20mg" required/>
                  </div>

                  <div class="mb-3">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="Descripcion">Descripción</label>
                    <input type="text" id="Descripcion" name="Descripcion" class="form-control" placeholder="Uso o categoría del medicamento"/>
                  </div>

                  <div class="mb-3">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="Unidad">Presentación / Unidad *</label>
                    <select id="Unidad" name="Unidad" class="form-select" required>
                      <option value="" disabled selected>-- Seleccione --</option>
                      <option value="Comprimido">Comprimido</option>
                      <option value="Cápsula">Cápsula</option>
                      <option value="Frasco">Frasco</option>
                      <option value="Ampolla">Ampolla</option>
                      <option value="Sobre">Sobre</option>
                      <option value="Jarabe">Jarabe (ml)</option>
                      <option value="Parche">Parche</option>
                    </select>
                  </div>

                  <div class="mb-4">
                    <label class="form-label small fw-semibold text-uppercase text-muted" for="Stock">Stock Inicial</label>
                    <input type="number" id="Stock" name="Stock" class="form-control" placeholder="0" min="0" value="0"/>
                  </div>

                  <button type="submit" id="btnAgregarMed" class="btn btn-success w-100 py-3 fw-semibold d-flex align-items-center justify-content-center gap-2">
                    <i class="bi bi-plus-circle-fill"></i> Agregar al Catálogo
                  </button>
                </form>
              </div>
            </div>
          </div>
        </main>
      </div>

    </div>
  </div>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
