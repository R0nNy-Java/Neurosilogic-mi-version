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
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
  <style>
    :root { --nl-primary:#1a6b5e; --nl-primary-dark:#134f45; --nl-primary-light:#2a9d8a; --nl-accent:#e9f5f3; --nl-text:#1e2d2b; --nl-muted:#6c8c87; --nl-border:#d0e8e4; --nl-sidebar-bg:#0f3831; --nl-topbar-bg:#134f45; --nl-body-bg:#f0f7f6; --sidebar-width:240px; }
    *,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
    body { font-family:'Inter',sans-serif; background:var(--nl-body-bg); min-height:100vh; }

    /* SIDEBAR (idéntico al de gestionar_usuarios) */
    #nl-sidebar { position:fixed; top:0; left:0; width:var(--sidebar-width); height:100vh; background:var(--nl-sidebar-bg); display:flex; flex-direction:column; z-index:1000; }
    .nl-sidebar-brand { display:flex; align-items:center; gap:12px; padding:22px 20px; border-bottom:1px solid rgba(255,255,255,0.08); text-decoration:none; }
    .nl-sidebar-brand-icon { width:38px; height:38px; background:var(--nl-primary-light); border-radius:10px; display:flex; align-items:center; justify-content:center; }
    .nl-sidebar-brand-icon i { font-size:1.1rem; color:#fff; }
    .nl-sidebar-brand-text { font-size:1.05rem; font-weight:700; color:#fff; letter-spacing:1px; }
    .nl-sidebar-brand-sub  { font-size:0.62rem; color:rgba(255,255,255,0.45); }
    .nl-role-badge { margin:12px 16px 4px; padding:6px 12px; border-radius:20px; font-size:0.7rem; font-weight:700; text-align:center; background:rgba(99,179,237,0.18); color:#90cdf4; border:1px solid rgba(99,179,237,0.3); }
    .nl-nav-label { font-size:0.65rem; font-weight:600; color:rgba(255,255,255,0.3); text-transform:uppercase; letter-spacing:1px; padding:14px 20px 6px; }
    .nl-nav { list-style:none; padding:8px 12px; flex:1; }
    .nl-nav li { margin-bottom:4px; }
    .nl-nav a { display:flex; align-items:center; gap:12px; padding:11px 14px; border-radius:10px; text-decoration:none; color:rgba(255,255,255,0.65); font-size:0.88rem; font-weight:500; transition:background 0.18s,color 0.18s; }
    .nl-nav a:hover, .nl-nav a.active { background:var(--nl-primary); color:#fff; }
    .nl-nav a i { font-size:1rem; }
    .nl-sidebar-footer { padding:16px; border-top:1px solid rgba(255,255,255,0.08); }
    .nl-sidebar-user { display:flex; align-items:center; gap:10px; }
    .nl-sidebar-avatar { width:36px; height:36px; background:var(--nl-primary); border-radius:50%; display:flex; align-items:center; justify-content:center; }
    .nl-sidebar-avatar i { font-size:1rem; color:#fff; }
    .nl-sidebar-username { font-size:0.82rem; font-weight:600; color:rgba(255,255,255,0.9); }
    .nl-sidebar-role { font-size:0.7rem; color:rgba(255,255,255,0.45); }
    .nl-sidebar-logout { display:flex; align-items:center; gap:8px; margin-top:10px; padding:8px 12px; border-radius:8px; text-decoration:none; color:rgba(255,255,255,0.55); font-size:0.8rem; transition:background 0.15s; }
    .nl-sidebar-logout:hover { background:rgba(255,255,255,0.08); color:rgba(255,255,255,0.9); }

    /* TOPBAR */
    #nl-topbar { position:fixed; top:0; left:var(--sidebar-width); right:0; height:62px; background:var(--nl-topbar-bg); display:flex; align-items:center; justify-content:space-between; padding:0 28px; z-index:999; box-shadow:0 2px 10px rgba(0,0,0,0.2); }
    .nl-topbar-title { font-size:1rem; font-weight:600; color:rgba(255,255,255,0.9); display:flex; align-items:center; gap:10px; }
    .nl-topbar-right { display:flex; align-items:center; gap:14px; }
    .nl-topbar-user  { font-size:0.82rem; color:rgba(255,255,255,0.7); display:flex; align-items:center; gap:7px; }
    .nl-btn-topbar   { background:rgba(255,255,255,0.12); border:1px solid rgba(255,255,255,0.2); color:rgba(255,255,255,0.85); font-size:0.82rem; font-family:'Inter',sans-serif; padding:7px 16px; border-radius:8px; cursor:pointer; display:flex; align-items:center; gap:6px; text-decoration:none; transition:background 0.15s; }
    .nl-btn-topbar:hover { background:rgba(255,255,255,0.22); color:#fff; }

    /* CONTENT */
    #nl-content { margin-left:var(--sidebar-width); padding-top:62px; }
    .nl-page-inner { padding:28px 30px 40px; }
    .nl-page-header { margin-bottom:24px; }
    .nl-page-title  { font-size:1.35rem; font-weight:700; color:var(--nl-text); display:flex; align-items:center; gap:10px; }
    .nl-page-subtitle { font-size:0.83rem; color:var(--nl-muted); margin-top:4px; }

    /* ALERTS */
    .nl-alert-success { background:#e9f5f3; border:1px solid #b2ddd6; border-radius:10px; color:#145c50; padding:11px 14px; margin-bottom:18px; font-size:0.83rem; display:flex; align-items:center; gap:8px; }
    .nl-alert-error   { background:#fff1f1; border:1px solid #f5c6c6; border-radius:10px; color:#a02020; padding:11px 14px; margin-bottom:18px; font-size:0.83rem; display:flex; align-items:center; gap:8px; }

    /* LAYOUT 2 columnas */
    .nl-grid-2col { display:grid; grid-template-columns:1fr 380px; gap:22px; align-items:start; }

    /* TABLE CARD */
    .nl-card { background:#fff; border-radius:14px; box-shadow:0 2px 14px rgba(26,107,94,0.09); overflow:hidden; }
    .nl-card-head { background:linear-gradient(135deg,#134f45,#2a9d8a); padding:18px 24px; display:flex; align-items:center; justify-content:space-between; }
    .nl-card-head-title { font-size:1rem; font-weight:700; color:#fff; display:flex; align-items:center; gap:10px; }
    .nl-card-head-sub   { font-size:0.76rem; color:rgba(255,255,255,0.7); margin-top:3px; }
    .nl-card-body-pad   { padding:24px; }

    /* TABLE */
    .nl-table { width:100%; border-collapse:collapse; }
    .nl-table thead th { padding:12px 16px; font-size:0.74rem; font-weight:700; color:var(--nl-muted); text-transform:uppercase; letter-spacing:0.5px; background:#f7fcfb; border-bottom:2px solid var(--nl-border); text-align:left; }
    .nl-table tbody td { padding:12px 16px; font-size:0.87rem; color:var(--nl-text); border-bottom:1px solid #f0f7f6; vertical-align:middle; }
    .nl-table tbody tr:last-child td { border-bottom:none; }
    .nl-table tbody tr:hover { background:#f7fcfb; }

    /* BADGE stock */
    .badge-stock { display:inline-block; padding:3px 10px; border-radius:20px; font-size:0.72rem; font-weight:700; }
    .stock-ok  { background:#d1fae5; color:#065f46; }
    .stock-low { background:#fef3c7; color:#92400e; }
    .stock-out { background:#fee2e2; color:#991b1b; }

    /* FORM AGREGAR */
    .nl-form-group { margin-bottom:15px; }
    .nl-form-label { display:block; font-size:0.76rem; font-weight:600; color:var(--nl-muted); text-transform:uppercase; letter-spacing:0.5px; margin-bottom:6px; }
    .nl-form-control { width:100%; padding:10px 14px; border:1.5px solid var(--nl-border); border-radius:10px; font-size:0.88rem; font-family:'Inter',sans-serif; color:var(--nl-text); background:#fafffe; outline:none; transition:border-color 0.2s,box-shadow 0.2s; }
    .nl-form-control:focus { border-color:var(--nl-primary-light); box-shadow:0 0 0 3px rgba(42,157,138,0.12); background:#fff; }
    .nl-form-control::placeholder { color:#aac5c0; }
    .nl-select { -webkit-appearance:none; appearance:none; cursor:pointer; }

    /* Botones */
    .nl-btn { padding:12px 22px; border-radius:10px; font-size:0.9rem; font-weight:600; font-family:'Inter',sans-serif; border:none; cursor:pointer; display:inline-flex; align-items:center; gap:8px; width:100%; justify-content:center; transition:transform 0.15s,box-shadow 0.15s; }
    .nl-btn:hover { transform:translateY(-2px); }
    .nl-btn-primary { background:linear-gradient(135deg,#1a6b5e,#2a9d8a); color:#fff; box-shadow:0 4px 12px rgba(26,107,94,0.2); }
    .nl-btn-primary:hover { box-shadow:0 8px 22px rgba(26,107,94,0.35); }
    .nl-btn-sm-del  { padding:5px 12px; border-radius:8px; font-size:0.75rem; font-weight:600; font-family:'Inter',sans-serif; border:none; cursor:pointer; display:inline-flex; align-items:center; gap:4px; background:#fee2e2; color:#991b1b; transition:opacity 0.15s; }
    .nl-btn-sm-del:hover { opacity:0.8; }
  </style>
</head>
<body>

  <!-- SIDEBAR -->
  <nav id="nl-sidebar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="nl-sidebar-brand">
      <div class="nl-sidebar-brand-icon"><i class="bi bi-heart-pulse-fill"></i></div>
      <div><div class="nl-sidebar-brand-text">NURSELOGIC</div><div class="nl-sidebar-brand-sub">Gestion Clinica</div></div>
    </a>
    <div class="nl-role-badge"><i class="bi bi-shield-fill me-1"></i>Administrador</div>
    <div class="nl-nav-label">Menu Principal</div>
    <ul class="nl-nav">
      <li><a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard"><i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span></a></li>
      <li><a href="${pageContext.request.contextPath}/GestionarUsuariosServlet" id="nav-usuarios"><i class="bi bi-people-fill"></i><span>Gestionar Usuarios</span></a></li>
      <li><a href="${pageContext.request.contextPath}/GestionarCatalogoServlet" id="nav-catalogo" class="active"><i class="bi bi-journal-medical"></i><span>Catalogo Medicamentos</span></a></li>
    </ul>
    <div class="nl-sidebar-footer">
      <div class="nl-sidebar-user">
        <div class="nl-sidebar-avatar"><i class="bi bi-person-fill"></i></div>
        <div>
          <div class="nl-sidebar-username"><%= nombreSesion %></div>
          <div class="nl-sidebar-role">Administrador</div>
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/LogoutServlet" id="nav-logout" class="nl-sidebar-logout">
        <i class="bi bi-box-arrow-right"></i> Cerrar sesión
      </a>
    </div>
  </nav>

  <!-- TOPBAR -->
  <header id="nl-topbar">
    <div class="nl-topbar-title"><i class="bi bi-journal-medical"></i> Catálogo de Medicamentos</div>
    <div class="nl-topbar-right">
      <span class="nl-topbar-user"><i class="bi bi-person-circle"></i> <%= nombreSesion %></span>
      <a href="${pageContext.request.contextPath}/LogoutServlet" id="btnLogoutTop" class="nl-btn-topbar"><i class="bi bi-box-arrow-right"></i> Salir</a>
    </div>
  </header>

  <!-- CONTENT -->
  <main id="nl-content">
    <div class="nl-page-inner">

      <div class="nl-page-header">
        <h1 class="nl-page-title"><i class="bi bi-journal-medical" style="color:var(--nl-primary);"></i> Catálogo de Medicamentos</h1>
        <p class="nl-page-subtitle">Administre los medicamentos disponibles en el sistema NURSELOGIC</p>
      </div>

      <%-- Mensajes del servlet --%>
      <%
        String successMsg = (String) request.getAttribute("successMsg");
        String errorMsg   = (String) request.getAttribute("errorMsg");
        if (successMsg != null && !successMsg.isEmpty()) {
      %>
      <div class="nl-alert-success"><i class="bi bi-check-circle-fill"></i><%= successMsg %></div>
      <% } %>
      <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="nl-alert-error"><i class="bi bi-exclamation-circle-fill"></i><%= errorMsg %></div>
      <% } %>

      <div class="nl-grid-2col">

        <!-- TABLA DE MEDICAMENTOS -->
        <div class="nl-card">
          <div class="nl-card-head">
            <div>
              <div class="nl-card-head-title"><i class="bi bi-table"></i> Medicamentos Registrados</div>
              <div class="nl-card-head-sub">Catálogo actual del sistema</div>
            </div>
          </div>
          <table class="nl-table" id="tablaCatalogo">
            <thead>
              <tr>
                <th>Código</th>
                <th>Medicamento</th>
                <th>Descripción</th>
                <th>Unidad</th>
                <th>Stock</th>
                <th>Acción</th>
              </tr>
            </thead>
            <tbody>
              <%-- Filas de demo (datos de ejemplo visuales) --%>
              <tr id="row-med-001">
                <td><code>MED-001</code></td>
                <td><strong>Paracetamol 500mg</strong></td>
                <td>Analgésico y antipirético</td>
                <td>Comprimido</td>
                <td><span class="badge-stock stock-ok">120 uds</span></td>
                <td>
                  <form action="${pageContext.request.contextPath}/GestionarCatalogoServlet"
                        method="POST" style="display:inline;" id="formDel-001">
                    <input type="hidden" name="accion" value="eliminar"/>
                    <input type="hidden" name="Codigo" value="MED-001"/>
                    <button type="submit" class="nl-btn-sm-del" id="btnDel-001"
                            onclick="return confirm('¿Eliminar Paracetamol 500mg del catálogo?')">
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
                  <form action="${pageContext.request.contextPath}/GestionarCatalogoServlet"
                        method="POST" style="display:inline;" id="formDel-002">
                    <input type="hidden" name="accion" value="eliminar"/>
                    <input type="hidden" name="Codigo" value="MED-002"/>
                    <button type="submit" class="nl-btn-sm-del" id="btnDel-002"
                            onclick="return confirm('¿Eliminar Ibuprofeno 400mg del catálogo?')">
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
                  <form action="${pageContext.request.contextPath}/GestionarCatalogoServlet"
                        method="POST" style="display:inline;" id="formDel-003">
                    <input type="hidden" name="accion" value="eliminar"/>
                    <input type="hidden" name="Codigo" value="MED-003"/>
                    <button type="submit" class="nl-btn-sm-del" id="btnDel-003"
                            onclick="return confirm('¿Eliminar Amoxicilina del catálogo?')">
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
                  <form action="${pageContext.request.contextPath}/GestionarCatalogoServlet"
                        method="POST" style="display:inline;" id="formDel-004">
                    <input type="hidden" name="accion" value="eliminar"/>
                    <input type="hidden" name="Codigo" value="MED-004"/>
                    <button type="submit" class="nl-btn-sm-del" id="btnDel-004"
                            onclick="return confirm('¿Eliminar Suero Fisiológico del catálogo?')">
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
                  <form action="${pageContext.request.contextPath}/GestionarCatalogoServlet"
                        method="POST" style="display:inline;" id="formDel-005">
                    <input type="hidden" name="accion" value="eliminar"/>
                    <input type="hidden" name="Codigo" value="MED-005"/>
                    <button type="submit" class="nl-btn-sm-del" id="btnDel-005"
                            onclick="return confirm('¿Eliminar Metformina del catálogo?')">
                      <i class="bi bi-trash3-fill"></i> Eliminar
                    </button>
                  </form>
                </td>
              </tr>
            </tbody>
          </table>
        </div><!-- /.nl-card tabla -->

        <!-- FORMULARIO AGREGAR MEDICAMENTO -->
        <div class="nl-card">
          <div class="nl-card-head">
            <div>
              <div class="nl-card-head-title"><i class="bi bi-plus-circle-fill"></i> Agregar Medicamento</div>
              <div class="nl-card-head-sub">Complete los datos del nuevo medicamento</div>
            </div>
          </div>
          <div class="nl-card-body-pad">
            <form id="formAgregarMed"
                  action="${pageContext.request.contextPath}/GestionarCatalogoServlet"
                  method="POST" novalidate>
              <input type="hidden" name="accion" value="agregar"/>

              <div class="nl-form-group">
                <label class="nl-form-label" for="Codigo">Código *</label>
                <input type="text" id="Codigo" name="Codigo" class="nl-form-control"
                       placeholder="Ej: MED-006" maxlength="20" required/>
              </div>

              <div class="nl-form-group">
                <label class="nl-form-label" for="NombreMedicamento">Nombre del Medicamento *</label>
                <input type="text" id="NombreMedicamento" name="NombreMedicamento"
                       class="nl-form-control" placeholder="Ej: Atorvastatina 20mg" required/>
              </div>

              <div class="nl-form-group">
                <label class="nl-form-label" for="Descripcion">Descripción</label>
                <input type="text" id="Descripcion" name="Descripcion" class="nl-form-control"
                       placeholder="Uso o categoría del medicamento"/>
              </div>

              <div class="nl-form-group">
                <label class="nl-form-label" for="Unidad">Presentación / Unidad *</label>
                <select id="Unidad" name="Unidad" class="nl-form-control nl-select" required>
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

              <div class="nl-form-group">
                <label class="nl-form-label" for="Stock">Stock Inicial</label>
                <input type="number" id="Stock" name="Stock" class="nl-form-control"
                       placeholder="0" min="0" value="0"/>
              </div>

              <button type="submit" id="btnAgregarMed" class="nl-btn nl-btn-primary">
                <i class="bi bi-plus-circle-fill"></i> Agregar al Catálogo
              </button>
            </form>
          </div>
        </div><!-- /.nl-card form -->

      </div><!-- /.nl-grid-2col -->
    </div><!-- /.nl-page-inner -->
  </main>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
