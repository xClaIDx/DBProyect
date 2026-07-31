<%-- 
    Document   : login
    Created on : 30 jul 2026, 6:30:48 p.m.
    Author     : klaidneil
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Iniciar Sesión - Simulacro 2026</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        body { background-color: #002b49; }
        .login-card { border-radius: 12px; margin-top: 10%; }
    </style>
</head>
<body>

<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-5">
            <div class="card login-card p-4 shadow-lg">
                <h3 class="text-center text-primary mb-3">Acceso al Sistema</h3>
                <p class="text-center text-muted small">Alumnos: Ingresar con DNI en usuario y clave.</p>

                <% if (request.getAttribute("error") != null) { %>
                    <div class="alert alert-danger py-2 small"><%= request.getAttribute("error") %></div>
                <% } %>
                <% if (request.getAttribute("mensajeExito") != null) { %>
                    <div class="alert alert-success py-2 small"><%= request.getAttribute("mensajeExito") %></div>
                <% } %>

                <form action="login" method="POST">
                    <div class="mb-3">
                        <label class="form-label">Usuario / DNI</label>
                        <input type="text" name="username" class="form-control" required autofocus placeholder="Número de DNI o usuario">
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Contraseña</label>
                        <input type="password" name="password" class="form-control" required placeholder="Contraseña">
                    </div>
                    <div class="d-grid gap-2 mt-4">
                        <button type="submit" class="btn btn-primary">Ingresar</button>
                    </div>
                </form>

                <div class="text-center mt-3">
                    <a href="index.jsp" class="small text-decoration-none">← Regresar al Formulario de Registro</a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>