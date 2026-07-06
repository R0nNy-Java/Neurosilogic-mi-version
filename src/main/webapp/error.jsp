<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<html>
<head>
 <meta charset="UTF-8">
 <title>Error</title>
 <style>
 body {
 font-family: Arial, sans-serif;
 max-width: 500px;
  margin: 50px auto;
  padding: 20px;
  background-color: #f5f5f5;
  }
  .container {
  background: white;
  padding: 30px;
  border-radius: 10px;
  box-shadow: 0 0 10px rgba(0,0,0,0.1);
  text-align: center;
  }
  .error-icon {
  font-size: 60px;
  color: #dc3545;
  }
  h1 { color: #dc3545; }
  .volver {
  display: inline-block;
  margin-top: 15px;
  color: #007bff;
  text-decoration: none;
  }
  </style>
 </head>
 <body>
  <div class="container">
  <div class="error-icon">❌</div>
  <h1>Error en el cálculo</h1>
  <p>Por favor, verifica que todos los datos sean válidos:</p>
  <ul style="text-align: left; display: inline-block;">
  <li>El peso debe ser un número positivo</li>
  <li>La altura debe ser un número positivo</li>
  <li>No uses letras en los campos numéricos</li>
  </ul>
  <br>
  <a href="index.jsp" class="volver">← Volver al formulario</a>
  </div>
 </body>
 </html>
