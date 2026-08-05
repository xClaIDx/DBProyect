<%-- 
    Document   : docentes.jsp
    Created on : 31 jul 2026, 12:10:37 a.m.
    Author     : klaidneil
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Personal Docente | G.U.E. Andrómeda</title>
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Source+Serif+4:wght@500;600&family=Inter:wght@400;500;600&display=swap');

        :root {
            /* Base Colegio Nacional */
            --navy: #15304F;        
            --navy-soft: #1E4269;   
            --bg: #F3F1EB;          
            --panel: #FFFFFF;       
            --ink: #212A26;         
            --ink-soft: #64716A;    
            --line: #E4E0D4;        

            /* Acentos semánticos */
            --green: #178F55;       
            --green-light: #DEF5E8;
            --gold: #E0A72E;        
            --gold-light: #FCF0D6;
            --red: #E14F3D;         
            --red-light: #FDE1DC;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            background-color: var(--bg);
            color: var(--ink);
            min-height: 100vh;
        }

        /* Navegación Institucional */
        .navbar {
            background-color: var(--navy);
            padding: 16px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            border-bottom: 1px solid var(--navy-soft);
        }

        .brand-container {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        /* Contenedor del Logo (Adaptado para SVG transparente) */
        .crest {
            height: 100px; /* Un poco más grande para darle mayor presencia */
            width: auto;
            display: flex;
            align-items: center;
            justify-content: center;
            background: transparent; /* Mimetización con el fondo navy */
        }

        .crest img {
            height: 100%;
            width: auto;
            object-fit: contain;
            /* Esta sombra suave hace que el SVG resalte elegantemente sobre el fondo oscuro */
            filter: drop-shadow(0px 2px 4px rgba(0, 0, 0, 0.3)); 
        }

        .crest-title {
            font-family: 'Source Serif 4', serif;
            font-size: 20px;
            font-weight: 600;
            color: var(--panel);
            line-height: 1.2;
            letter-spacing: 0.02em;
        }
        
        .crest-subtitle {
            font-size: 11px;
            color: var(--line);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        /* Botones */
        .btn {
            display: inline-block;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            font-weight: 500;
            padding: 10px 16px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            border: 1px solid transparent;
            transition: all 0.2s ease;
            box-sizing: border-box;
        }
        
        .btn-sm { padding: 6px 12px; font-size: 12px; }
        .btn-block { display: block; width: 100%; }

        .btn-navy { background: var(--navy); color: var(--panel); }
        .btn-navy:hover { background: var(--navy-soft); }
        
        .btn-red { background: var(--red); color: var(--panel); }
        .btn-red:hover { background: #C53D2C; }

        .btn-nav-outline { background: transparent; border: 1px solid var(--line); color: var(--panel); }
        .btn-nav-outline:hover { background: var(--navy-soft); border-color: var(--panel); }

        /* Estructura Principal */
        main {
            padding: 32px 40px 48px;
            max-width: 1200px;
            margin: 0 auto;
        }

        .content-grid {
            display: grid;
            grid-template-columns: 360px 1fr;
            gap: 28px;
            align-items: start;
        }

        @media (max-width: 900px) {
            .content-grid { grid-template-columns: 1fr; }
            .navbar { padding: 16px 20px; }
            main { padding: 24px 20px; }
        }

        /* Alertas de Sistema */
        .alert {
            padding: 14px 18px;
            border-radius: 4px;
            margin-bottom: 28px;
            font-size: 13px;
            font-weight: 500;
            border-left: 3px solid;
            box-shadow: 0 1px 2px rgba(0,0,0,0.02);
        }
        .alert p { margin: 0; }
        .alert-success { background: var(--green-light); color: var(--green); border-left-color: var(--green); }
        .alert-danger { background: var(--red-light); color: var(--red); border-left-color: var(--red); }

        /* Paneles */
        .panel {
            background: var(--panel);
            border: 1px solid var(--line);
            border-radius: 4px;
            padding: 24px;
        }

        .panel-accent {
            border-top: 4px solid var(--navy);
        }

        .panel-header {
            border-bottom: 1px solid var(--line);
            padding-bottom: 16px;
            margin-bottom: 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        h3 {
            font-family: 'Source Serif 4', serif;
            font-weight: 600;
            color: var(--navy);
            margin: 0;
            font-size: 18px;
        }

        .badge-neutral {
            font-family: 'Inter', sans-serif;
            background: var(--bg);
            color: var(--ink-soft);
            padding: 4px 10px;
            border-radius: 3px;
            font-size: 11px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border: 1px solid var(--line);
        }

        /* Formularios */
        .form-group { margin-bottom: 18px; }
        .form-row-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 14px; margin-bottom: 18px; }

        .form-label {
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 11px;
            color: var(--ink-soft);
            margin-bottom: 8px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--line);
            border-radius: 4px;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            color: var(--ink);
            box-sizing: border-box;
            background: var(--panel);
            transition: border-color 0.2s;
        }
        .form-control:focus { outline: none; border-color: var(--navy); }
        .form-control.mono { font-family: monospace; font-size: 14px; }
        
        .form-hint {
            display: block;
            font-size: 11px;
            color: var(--ink-soft);
            margin-top: 6px;
        }

        /* Tablas de Datos */
        .table-responsive { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        
        th {
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 11px;
            color: var(--ink-soft);
            border-bottom: 1px solid var(--line);
            padding: 14px 16px;
            font-weight: 500;
        }
        
        td {
            padding: 16px;
            border-bottom: 1px solid var(--line);
            font-size: 13px;
            color: var(--ink);
            vertical-align: middle;
        }
        
        tr:hover td { background-color: var(--bg); }
        
        .td-bold { font-weight: 500; color: var(--navy); }
        .td-mono { font-family: monospace; font-size: 14px; font-weight: 600; color: var(--navy); }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="brand-container">
            <div class="crest">
                <img src="${pageContext.request.contextPath}/assets/images/logo.svg" alt="Escudo G.U.E. Andrómeda">
            </div>
            <div>
                <div class="crest-title">G.U.E. Andrómeda</div>
                <div class="crest-subtitle">Gestión de Personal Docente</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="btn btn-nav-outline">
            Volver al Panel Principal
        </a>
    </nav>

    <main>
        <c:if test="${not empty sessionScope.msgExitoAdmin}">
            <div class="alert alert-success" role="alert">
                <p>${sessionScope.msgExitoAdmin}</p>
            </div>
            <c:remove var="msgExitoAdmin" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.msgErrorAdmin}">
            <div class="alert alert-danger" role="alert">
                <p>${sessionScope.msgErrorAdmin}</p>
            </div>
            <c:remove var="msgErrorAdmin" scope="session"/>
        </c:if>

        <div class="content-grid">
            
            <div class="panel panel-accent">
                <div class="panel-header">
                    <h3>Registrar Nuevo Docente</h3>
                </div>
                
                <form action="${pageContext.request.contextPath}/admin/docentes" method="POST">
                    <input type="hidden" name="accion" value="registrar">
                    
                    <div class="form-group">
                        <label class="form-label">Documento de Identidad (DNI) (*)</label>
                        <input type="text" name="numDocumento" required maxlength="8" class="form-control mono" placeholder="Ingrese 8 dígitos">
                        <span class="form-hint">El DNI servirá como usuario y clave por defecto.</span>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Nombres (*)</label>
                        <input type="text" name="nombres" required class="form-control">
                    </div>

                    <div class="form-row-2">
                        <div>
                            <label class="form-label">Ap. Paterno (*)</label>
                            <input type="text" name="apPaterno" required class="form-control">
                        </div>
                        <div>
                            <label class="form-label">Ap. Materno (*)</label>
                            <input type="text" name="apMaterno" required class="form-control">
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label">Especialidad Académica</label>
                        <input type="text" name="especialidad" class="form-control" placeholder="Ej. Matemáticas / Física">
                    </div>
                    
                    <div style="margin-top: 32px;">
                        <button type="submit" class="btn btn-navy btn-block">Guardar Registro de Docente</button>
                    </div>
                </form>
            </div>

            <div class="panel">
                <div class="panel-header">
                    <h3>Directorio de Personal Calificador</h3>
                    <span class="badge-neutral">Registros Activos</span>
                </div>
                
                <div class="table-responsive">
                    <table>
                        <thead>
                            <tr>
                                <th>DNI</th>
                                <th>Apellidos y Nombres</th>
                                <th>Especialidad</th>
                                <th style="text-align: center;">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="doc" items="${listaDocentes}">
                                <tr>
                                    <td class="td-mono">${doc.numDocumento}</td>
                                    <td class="td-bold">${doc.apPaterno} ${doc.apMaterno}, ${doc.nombres}</td>
                                    <td style="color: var(--ink-soft);">${doc.especialidad}</td>
                                    <td style="text-align: center;">
                                        <form action="${pageContext.request.contextPath}/admin/docentes" method="POST" onsubmit="return confirm('¿Seguro que deseas eliminar a este docente del sistema?');" style="margin: 0;">
                                            <input type="hidden" name="accion" value="eliminar">
                                            <input type="hidden" name="idDocente" value="${doc.idDocente}">
                                            <button type="submit" class="btn btn-sm btn-red">Eliminar</button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaDocentes}">
                                <tr>
                                    <td colspan="4" style="text-align: center; padding: 48px 16px; color: var(--ink-soft);">No se encontraron docentes registrados en la base de datos.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>

        </div>
    </main>
</body>
</html>