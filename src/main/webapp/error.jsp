<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
  <title>NURSELOGIC | Error</title>
  <link href="${pageContext.request.contextPath}/css/bootstrap.min.css" rel="stylesheet"/>
  <link href="${pageContext.request.contextPath}/css/nurselogic.css" rel="stylesheet"/>
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet"/>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet"/>
</head>
<body class="bg-light min-vh-100 d-flex align-items-center justify-content-center p-3" style="font-family:'Inter',sans-serif;">
  <div class="card border-0 shadow-lg rounded-4 text-center p-4 w-100" style="max-width: 500px;">
    <div class="card-body">
      <i class="bi bi-x-circle-fill text-danger d-block mb-3" style="font-size: 3.5rem;"></i>
      <h1 class="h4 text-danger fw-bold mb-3">Error en el cálculo</h1>
      <p class="text-muted small mb-3">Por favor, verifica que todos los datos sean válidos:</p>
      <div class="alert alert-danger text-start small mb-4">
        <ul class="mb-0 ps-3">
          <li>El peso debe ser un número positivo</li>
          <li>La altura debe ser un número positivo</li>
          <li>No uses letras en los campos numéricos</li>
        </ul>
      </div>
      <a href="${pageContext.request.contextPath}/index.jsp" class="btn btn-outline-primary d-inline-flex align-items-center gap-2">
        <i class="bi bi-arrow-left"></i> Volver al panel principal
      </a>
    </div>
  </div>
  <script src="${pageContext.request.contextPath}/js/bootstrap.bundle.min.js"></script>
</body>
</html>
