<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>NURSELOGIC | Resultado IMC</title>
  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
  <style>
    :root { --nl-primary:#1a6b5e; --nl-primary-light:#2a9d8a; --nl-sidebar-bg:#0f3831; --nl-topbar-bg:#134f45; --nl-body-bg:#f0f7f6; --sidebar-width:240px; }
    *, *::before, *::after { box-sizing:border-box; margin:0; padding:0; }
    body { font-family:'Inter',sans-serif; background:var(--nl-body-bg); min-height:100vh; }

    #nl-sidebar { position:fixed; top:0; left:0; width:var(--sidebar-width); height:100vh; background:var(--nl-sidebar-bg); display:flex; flex-direction:column; z-index:1000; }
    .nl-sidebar-brand { display:flex; align-items:center; gap:12px; padding:22px 20px; border-bottom:1px solid rgba(255,255,255,0.1); text-decoration:none; }
    .nl-sidebar-brand-icon { width:38px; height:38px; background:var(--nl-primary-light); border-radius:10px; display:flex; align-items:center; justify-content:center; }
    .nl-sidebar-brand-icon i { font-size:1.1rem; color:#fff; }
    .nl-sidebar-brand-text { font-size:1.05rem; font-weight:700; color:#fff; letter-spacing:1px; }
    .nl-sidebar-brand-sub  { font-size:0.62rem; color:rgba(255,255,255,0.5); }
    .nl-nav-label { font-size:0.65rem; font-weight:600; color:rgba(255,255,255,0.35); text-transform:uppercase; letter-spacing:1px; padding:18px 20px 6px; }
    .nl-nav { list-style:none; padding:8px 12px; flex:1; }
    .nl-nav li { margin-bottom:4px; }
    .nl-nav a { display:flex; align-items:center; gap:12px; padding:11px 14px; border-radius:10px; text-decoration:none; color:rgba(255,255,255,0.7); font-size:0.88rem; font-weight:500; transition:background 0.18s; }
    .nl-nav a:hover { background:var(--nl-primary); color:#fff; }
    .nl-nav a i { font-size:1rem; }

    #nl-topbar { position:fixed; top:0; left:var(--sidebar-width); right:0; height:62px; background:var(--nl-topbar-bg); display:flex; align-items:center; justify-content:space-between; padding:0 28px; z-index:999; box-shadow:0 2px 10px rgba(0,0,0,0.2); }
    .nl-topbar-breadcrumb { font-size:0.83rem; color:rgba(255,255,255,0.6); display:flex; align-items:center; gap:6px; }
    .nl-topbar-breadcrumb span.current { color:rgba(255,255,255,0.9); font-weight:600; }
    .nl-btn-back { background:rgba(255,255,255,0.12); border:1px solid rgba(255,255,255,0.2); color:rgba(255,255,255,0.85); font-size:0.82rem; font-family:'Inter',sans-serif; padding:7px 16px; border-radius:8px; cursor:pointer; display:flex; align-items:center; gap:6px; text-decoration:none; transition:background 0.15s; }
    .nl-btn-back:hover { background:rgba(255,255,255,0.22); color:#fff; }

    #nl-content { margin-left:var(--sidebar-width); padding-top:62px; }
    .nl-page-inner { padding:28px 30px 40px; }

    .nl-result-card { background:#fff; border-radius:14px; max-width:520px; margin:0 auto; box-shadow:0 2px 16px rgba(26,107,94,0.09); overflow:hidden; }
    .nl-result-head { background:linear-gradient(135deg,#134f45,#2a9d8a); padding:24px 28px; text-align:center; }
    .nl-result-head-icon { font-size:2.5rem; color:#fff; margin-bottom:8px; }
    .nl-result-head-title { font-size:1.2rem; font-weight:700; color:#fff; }
    .nl-result-body { padding:28px; }
    .nl-result-row { display:flex; justify-content:space-between; align-items:center; padding:12px 0; border-bottom:1px solid #e9f5f3; font-size:0.93rem; }
    .nl-result-row:last-child { border-bottom:none; }
    .nl-result-key { font-weight:600; color:#6c8c87; text-transform:uppercase; font-size:0.78rem; letter-spacing:0.5px; }
    .nl-result-val { font-weight:600; color:#1e2d2b; }
    .nl-categoria-badge { display:inline-block; padding:6px 16px; border-radius:20px; font-weight:700; font-size:0.88rem; }
    .bajo-peso    { background:#fff3cd; color:#856404; }
    .normal       { background:#d1f0e3; color:#155724; }
    .sobrepeso    { background:#ffe5cc; color:#7a3b00; }
    .obesidad     { background:#f8d7da; color:#721c24; }
    .nl-btn-volver { display:flex; align-items:center; gap:8px; margin-top:24px; padding:13px 24px; background:linear-gradient(135deg,#1a6b5e,#2a9d8a); color:#fff; border:none; border-radius:10px; font-size:0.95rem; font-weight:600; font-family:'Inter',sans-serif; text-decoration:none; cursor:pointer; transition:transform 0.15s,box-shadow 0.15s; justify-content:center; }
    .nl-btn-volver:hover { transform:translateY(-2px); box-shadow:0 8px 20px rgba(26,107,94,0.4); color:#fff; }
  </style>
</head>
<body>
  <nav id="nl-sidebar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="nl-sidebar-brand">
      <div class="nl-sidebar-brand-icon"><i class="bi bi-heart-pulse-fill"></i></div>
      <div><div class="nl-sidebar-brand-text">NURSELOGIC</div><div class="nl-sidebar-brand-sub">Gestion Clinica</div></div>
    </a>
    <div class="nl-nav-label">Navegacion Principal</div>
    <ul class="nl-nav">
      <li><a href="${pageContext.request.contextPath}/index.jsp"><i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span></a></li>
      <li><a href="${pageContext.request.contextPath}/PacientesServlet"><i class="bi bi-person-vcard-fill"></i><span>Pacientes</span></a></li>
      <li><a href="${pageContext.request.contextPath}/SignosVitalesServlet"><i class="bi bi-activity"></i><span>Signos Vitales</span></a></li>
    </ul>
  </nav>

  <header id="nl-topbar">
    <div class="nl-topbar-breadcrumb">
      <i class="bi bi-house-fill"></i><span>/</span><span>Herramientas</span><span>/</span>
      <span class="current">Resultado IMC</span>
    </div>
    <a href="${pageContext.request.contextPath}/calculadora.jsp" class="nl-btn-back">
      <i class="bi bi-arrow-left"></i> Volver
    </a>
  </header>

  <main id="nl-content">
    <div class="nl-page-inner">
      <div class="nl-result-card">
        <div class="nl-result-head">
          <div class="nl-result-head-icon"><i class="bi bi-clipboard2-data-fill"></i></div>
          <div class="nl-result-head-title">Resultado del Calculo IMC</div>
        </div>
        <div class="nl-result-body">
          <div class="nl-result-row">
            <span class="nl-result-key">Paciente</span>
            <span class="nl-result-val"><%= request.getAttribute("nombre") %></span>
          </div>
          <div class="nl-result-row">
            <span class="nl-result-key">Peso</span>
            <span class="nl-result-val"><%= request.getAttribute("peso") %> kg</span>
          </div>
          <div class="nl-result-row">
            <span class="nl-result-key">Altura</span>
            <span class="nl-result-val"><%= request.getAttribute("altura") %> m</span>
          </div>
          <div class="nl-result-row">
            <span class="nl-result-key">IMC Calculado</span>
            <span class="nl-result-val" style="font-size:1.15rem;color:var(--nl-primary);"><%= request.getAttribute("imc") %></span>
          </div>
          <div class="nl-result-row">
            <span class="nl-result-key">Clasificacion</span>
            <span class="nl-categoria-badge <%= request.getAttribute("categoria").toString().toLowerCase().replace(" ", "-") %>">
              <%= request.getAttribute("categoria") %>
            </span>
          </div>
          <a href="${pageContext.request.contextPath}/calculadora.jsp" class="nl-btn-volver">
            <i class="bi bi-arrow-left-circle"></i> Calcular otro IMC
          </a>
        </div>
      </div>
    </div>
  </main>
  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>