<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Calculadora IMC</title>
  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>

  <style>
    :root {
      --nl-primary: #1a6b5e;
      --nl-primary-light: #2a9d8a;
      --nl-accent: #e9f5f3;
      --nl-border: #d0e8e4;
      --nl-sidebar-bg: #0f3831;
      --nl-topbar-bg: #134f45;
      --nl-body-bg: #f0f7f6;
      --sidebar-width: 240px;
    }
    *, *::before, *::after { box-sizing: border-box; margin:0; padding:0; }
    body { font-family:'Inter',sans-serif; background:var(--nl-body-bg); min-height:100vh; }

    /* SIDEBAR */
    #nl-sidebar {
      position:fixed; top:0; left:0;
      width:var(--sidebar-width); height:100vh;
      background:var(--nl-sidebar-bg);
      display:flex; flex-direction:column; z-index:1000;
    }
    .nl-sidebar-brand {
      display:flex; align-items:center; gap:12px;
      padding:22px 20px;
      border-bottom:1px solid rgba(255,255,255,0.1);
      text-decoration:none;
    }
    .nl-sidebar-brand-icon {
      width:38px; height:38px;
      background:var(--nl-primary-light);
      border-radius:10px;
      display:flex; align-items:center; justify-content:center;
    }
    .nl-sidebar-brand-icon i { font-size:1.1rem; color:#fff; }
    .nl-sidebar-brand-text { font-size:1.05rem; font-weight:700; color:#fff; letter-spacing:1px; }
    .nl-sidebar-brand-sub  { font-size:0.62rem; color:rgba(255,255,255,0.5); }
    .nl-nav-label {
      font-size:0.65rem; font-weight:600; color:rgba(255,255,255,0.35);
      text-transform:uppercase; letter-spacing:1px; padding:18px 20px 6px;
    }
    .nl-nav { list-style:none; padding:8px 12px; flex:1; }
    .nl-nav li { margin-bottom:4px; }
    .nl-nav a {
      display:flex; align-items:center; gap:12px;
      padding:11px 14px; border-radius:10px;
      text-decoration:none; color:rgba(255,255,255,0.7);
      font-size:0.88rem; font-weight:500;
      transition:background 0.18s,color 0.18s;
    }
    .nl-nav a:hover { background:var(--nl-primary); color:#fff; }
    .nl-nav a.active {
      background:var(--nl-primary-light); color:#fff; font-weight:600;
      box-shadow:0 4px 12px rgba(42,157,138,0.35);
    }
    .nl-nav a i { font-size:1rem; }

    /* TOPBAR */
    #nl-topbar {
      position:fixed; top:0; left:var(--sidebar-width); right:0; height:62px;
      background:var(--nl-topbar-bg);
      display:flex; align-items:center; justify-content:space-between;
      padding:0 28px; z-index:999;
      box-shadow:0 2px 10px rgba(0,0,0,0.2);
    }
    .nl-topbar-breadcrumb { font-size:0.83rem; color:rgba(255,255,255,0.6); display:flex; align-items:center; gap:6px; }
    .nl-topbar-breadcrumb span.current { color:rgba(255,255,255,0.9); font-weight:600; }
    .nl-btn-logout {
      background:rgba(255,255,255,0.12); border:1px solid rgba(255,255,255,0.2);
      color:rgba(255,255,255,0.85); font-size:0.82rem; font-family:'Inter',sans-serif;
      padding:7px 16px; border-radius:8px; cursor:pointer;
      display:flex; align-items:center; gap:6px; text-decoration:none;
      transition:background 0.15s;
    }
    .nl-btn-logout:hover { background:rgba(255,255,255,0.22); color:#fff; }

    /* CONTENT */
    #nl-content { margin-left:var(--sidebar-width); padding-top:62px; }
    .nl-page-inner { padding:28px 30px 40px; }

    /* CARD */
    .nl-card {
      background:#fff; border-radius:14px; max-width:560px; margin:0 auto;
      box-shadow:0 2px 16px rgba(26,107,94,0.09); overflow:hidden;
    }
    .nl-card-head {
      background:linear-gradient(135deg,#134f45,#2a9d8a);
      padding:20px 28px; display:flex; align-items:center; gap:14px;
    }
    .nl-card-head-icon {
      width:44px; height:44px; background:rgba(255,255,255,0.18);
      border:1.5px solid rgba(255,255,255,0.3); border-radius:12px;
      display:flex; align-items:center; justify-content:center;
    }
    .nl-card-head-icon i { font-size:1.3rem; color:#fff; }
    .nl-card-head-title { font-size:1.1rem; font-weight:700; color:#fff; }
    .nl-card-head-sub   { font-size:0.78rem; color:rgba(255,255,255,0.7); margin-top:2px; }
    .nl-card-body { padding:28px; }

    .nl-form-label {
      display:block; font-size:0.78rem; font-weight:600;
      color:#6c8c87; text-transform:uppercase; letter-spacing:0.5px; margin-bottom:7px;
    }
    .nl-form-group { margin-bottom:18px; }
    .nl-form-control {
      width:100%; padding:12px 15px;
      border:1.5px solid #d0e8e4; border-radius:10px;
      font-size:0.95rem; font-family:'Inter',sans-serif; color:#1e2d2b;
      background:#fafffe; outline:none; transition:border-color 0.2s,box-shadow 0.2s;
    }
    .nl-form-control:focus {
      border-color:#2a9d8a; box-shadow:0 0 0 3px rgba(42,157,138,0.15); background:#fff;
    }
    .nl-form-control::placeholder { color:#aac5c0; }
    .nl-btn-calc {
      width:100%; padding:14px; border:none; border-radius:10px;
      background:linear-gradient(135deg,#1a6b5e,#2a9d8a);
      color:#fff; font-size:0.97rem; font-weight:600; font-family:'Inter',sans-serif;
      cursor:pointer; display:flex; align-items:center; justify-content:center; gap:8px;
      transition:transform 0.15s,box-shadow 0.15s;
    }
    .nl-btn-calc:hover { transform:translateY(-2px); box-shadow:0 8px 24px rgba(26,107,94,0.4); }
  </style>
</head>
<body>

  <!-- SIDEBAR -->
  <nav id="nl-sidebar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="nl-sidebar-brand">
      <div class="nl-sidebar-brand-icon"><i class="bi bi-heart-pulse-fill"></i></div>
      <div>
        <div class="nl-sidebar-brand-text">NURSELOGIC</div>
        <div class="nl-sidebar-brand-sub">Gestion Clinica</div>
      </div>
    </a>
    <div class="nl-nav-label">Navegacion Principal</div>
    <ul class="nl-nav">
      <li><a href="${pageContext.request.contextPath}/index.jsp" id="nav-dashboard"><i class="bi bi-grid-1x2-fill"></i><span>Dashboard</span></a></li>
      <li><a href="${pageContext.request.contextPath}/PacientesServlet" id="nav-pacientes"><i class="bi bi-person-vcard-fill"></i><span>Pacientes</span></a></li>
      <li><a href="${pageContext.request.contextPath}/SignosVitalesServlet" id="nav-signos"><i class="bi bi-activity"></i><span>Signos Vitales</span></a></li>
    </ul>
  </nav>

  <!-- TOPBAR -->
  <header id="nl-topbar">
    <div class="nl-topbar-breadcrumb">
      <i class="bi bi-house-fill"></i><span>/</span>
      <span>Herramientas</span><span>/</span>
      <span class="current">Calculadora IMC</span>
    </div>
    <a href="${pageContext.request.contextPath}/LogoutServlet" class="nl-btn-logout">
      <i class="bi bi-box-arrow-right"></i>Salir
    </a>
  </header>

  <!-- CONTENT -->
  <main id="nl-content">
    <div class="nl-page-inner">
      <div class="nl-card">
        <div class="nl-card-head">
          <div class="nl-card-head-icon"><i class="bi bi-calculator-fill"></i></div>
          <div>
            <div class="nl-card-head-title">Calculadora de IMC</div>
            <div class="nl-card-head-sub">Indice de Masa Corporal del paciente</div>
          </div>
        </div>
        <div class="nl-card-body">
          <form action="${pageContext.request.contextPath}/calcular" method="POST">
            <div class="nl-form-group">
              <label class="nl-form-label" for="nombre">Nombre del Paciente</label>
              <input type="text" id="nombre" name="nombre" class="nl-form-control" placeholder="Ingrese el nombre" required/>
            </div>
            <div class="nl-form-group">
              <label class="nl-form-label" for="peso">Peso (kg)</label>
              <input type="number" id="peso" name="peso" class="nl-form-control" step="0.1" placeholder="Ej: 70.5" required/>
            </div>
            <div class="nl-form-group">
              <label class="nl-form-label" for="altura">Altura (metros)</label>
              <input type="number" id="altura" name="altura" class="nl-form-control" step="0.01" placeholder="Ej: 1.75" required/>
            </div>
            <button type="submit" class="nl-btn-calc">
              <i class="bi bi-calculator"></i> Calcular IMC
            </button>
          </form>
        </div>
      </div>
    </div>
  </main>

  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
