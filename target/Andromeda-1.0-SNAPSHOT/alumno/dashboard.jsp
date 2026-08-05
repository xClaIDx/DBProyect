<%-- 
    Document   : dashboard
    Created on : 30 jul 2026, 6:50:02 p.m.
    Author     : klaidneil
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="finesi.app.andromeda.modelo.Usuario"%>
<%@ page import="finesi.app.andromeda.modelo.Alumno"%>
<%@ page import="finesi.app.andromeda.modelo.Postulante"%>
<%@ page import="finesi.app.andromeda.modelo.ResultadoDetalle"%>
<%@ page import="finesi.app.andromeda.modelo.Periodo"%>
<%@ page import="finesi.app.andromeda.dao.AlumnoDAO"%>
<%@ page import="finesi.app.andromeda.dao.PostulanteDAO"%>
<%@ page import="finesi.app.andromeda.dao.ResultadoDAO"%>
<%@ page import="finesi.app.andromeda.dao.MaestrosDAO"%>
<%@ page import="java.util.List"%>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null || !"ALUMNO".equalsIgnoreCase(u.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?estado=requiere_login");
        return;
    }

    AlumnoDAO alumnoDAO = new AlumnoDAO();
    PostulanteDAO postulanteDAO = new PostulanteDAO();
    ResultadoDAO resultadoDAO = new ResultadoDAO();
    MaestrosDAO maestrosDAO = new MaestrosDAO();

    Alumno alumno = alumnoDAO.obtenerPorDni(u.getUsername());
    Postulante postulacionActiva = null;
    ResultadoDetalle resultado = null;
    List<Postulante> historialPostulaciones = null;
    
    // Obtener el periodo activo directamente de la BD
    Periodo periodoVigente = maestrosDAO.obtenerPeriodoActivoVigente();

    if (alumno != null) {
        if (periodoVigente != null) {
            postulacionActiva = postulanteDAO.obtenerPostulacion(alumno.getIdAlumno(), periodoVigente.getIdPeriodo());
        }
        resultado = resultadoDAO.obtenerResultadoPorDni(alumno.getNumDocumento());
        // Obtener todas las postulaciones/inscripciones del alumno
        historialPostulaciones = postulanteDAO.listarHistorialPorAlumno(alumno.getIdAlumno());
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal del Estudiante | Gran Unidad Escolar Andrómeda</title>
    
    <style>
        :root {
            /* Paleta Institucional - G.U.E. Andrómeda */
            --primary: #003366;        /* Azul Noche Institucional */
            --secondary: #0066CC;      /* Azul Cobalto */
            --bg-main: #F5F5F5;        /* Gris Claro Fondo */
            --panel: #FFFFFF;          /* Fondo Tarjetas */
            --ink: #333333;            /* Texto Principal */
            --ink-soft: #666666;       /* Texto Secundario */
            --line: #E0E0E0;           /* Bordes y Líneas */
            
            /* Acentos */
            --accent-red: #8B0000;     /* Rojo Crítico / Cancelar */
            --success: #006633;        /* Verde Éxito */
            --success-light: #E8F5E9;
            --warning: #CC9900;        /* Dorado/Amarillo Advertencia */
            --warning-light: #FFF8E1;
        }

        body {
            font-family: 'Segoe UI', Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-main);
            color: var(--ink);
            margin: 0;
            padding: 0;
            min-height: 100vh;
        }

        /* ---------------- HEADER INSTITUCIONAL ---------------- */
        .navbar {
            background-color: var(--primary);
            padding: 20px 48px; /* Encabezado agrandado */
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 4px solid var(--warning); /* Detalle dorado institucional */
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            flex-wrap: wrap;
            gap: 16px;
        }

        .brand-container {
            display: flex;
            align-items: center;
            gap: 20px; /* Separación ampliada */
        }

        /* Contenedor del Logo SVG */
        .crest {
            height: 100px;            /* <- Alto de 100px */
            width: auto;
            display: flex;
            align-items: center;
            justify-content: center;
            background: transparent;  /* <- Mimetizado sin recuadro blanco */
        }

        .crest img {
            height: 100%;
            width: auto;
            object-fit: contain;
            filter: drop-shadow(0px 2px 4px rgba(0, 0, 0, 0.3)); /* Sombra elegante */
        }

        .crest-title {
            font-size: 26px; /* Letras agrandadas y más estéticas */
            font-weight: 700;
            color: #FFFFFF;
            letter-spacing: 0.05em;
            text-transform: uppercase;
            line-height: 1.1;
        }
        
        .crest-subtitle {
            font-size: 14px;
            color: #E0E0E0;
            text-transform: uppercase;
            letter-spacing: 0.1em;
            margin-top: 4px;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .user-info {
            font-size: 14px;
            color: #E0E0E0;
        }
        .user-info b {
            color: #FFFFFF;
            font-weight: 600;
        }

        /* ---------------- BOTONES ---------------- */
        .btn {
            display: inline-block;
            font-family: 'Segoe UI', sans-serif;
            font-size: 13px;
            font-weight: 600;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            border: 1px solid transparent;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .btn-block { display: block; width: 100%; box-sizing: border-box; }

        .btn-primary { background: var(--primary); color: var(--panel); }
        .btn-primary:hover { background: #002244; }
        
        .btn-secondary { background: var(--secondary); color: var(--panel); }
        .btn-secondary:hover { background: #004C99; }
        
        .btn-red { background: var(--accent-red); color: var(--panel); }
        .btn-red:hover { background: #660000; }
        
        .btn-outline-light { background: transparent; border: 1px solid var(--line); color: var(--panel); }
        .btn-outline-light:hover { background: rgba(255,255,255,0.1); border-color: var(--panel); }

        .btn-gold { background: var(--warning); color: #FFFFFF; }
        .btn-gold:hover { background: #A87A00; }

        /* ---------------- CONTENEDORES Y PANELES ---------------- */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 32px 24px;
        }

        .panel {
            background: var(--panel);
            border: 1px solid var(--line);
            border-radius: 4px;
            padding: 28px;
            margin-bottom: 28px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }

        .panel-accent-primary { border-top: 4px solid var(--primary); }
        .panel-accent-gold { border-top: 4px solid var(--warning); }

        .panel-header {
            border-bottom: 1px solid var(--line);
            padding-bottom: 16px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
        }

        h3 {
            font-size: 18px;
            font-weight: 700;
            color: var(--primary);
            margin: 0;
            text-transform: uppercase;
            letter-spacing: 0.02em;
        }

        h4 {
            font-size: 16px;
            font-weight: 600;
            color: var(--ink);
            margin: 0 0 4px 0;
        }

        .text-desc {
            font-size: 13px;
            color: var(--ink-soft);
            margin: 0;
        }

        /* ---------------- ALERTAS ---------------- */
        .alert {
            padding: 16px 20px;
            border-radius: 4px;
            margin-bottom: 28px;
            font-size: 14px;
            font-weight: 500;
            border-left: 4px solid;
        }
        .alert-success { background: var(--success-light); color: var(--success); border-left-color: var(--success); }
        .alert-danger { background: #FDE8E8; color: var(--accent-red); border-left-color: var(--accent-red); }

        /* ---------------- GRID LAYOUTS ---------------- */
        .grid-3 { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 24px; }
        .grid-layout { display: grid; grid-template-columns: 2fr 1fr; gap: 28px; margin-bottom: 28px; }
        
        @media (max-width: 900px) {
            .grid-layout { grid-template-columns: 1fr; }
            .navbar { padding: 16px 24px; flex-direction: column; align-items: flex-start; }
            .nav-links { width: 100%; justify-content: space-between; margin-top: 16px; }
        }

        /* ---------------- TABLAS ---------------- */
        .table-responsive { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        
        th {
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 12px;
            color: var(--ink-soft);
            border-bottom: 2px solid var(--line);
            padding: 14px 16px;
            font-weight: 600;
        }
        
        td {
            padding: 16px;
            border-bottom: 1px solid var(--line);
            font-size: 14px;
            color: var(--ink);
        }
        
        tr:hover td { background-color: var(--bg-main); }
        .td-bold { font-weight: 600; color: var(--primary); }

        /* ---------------- ELEMENTOS FORMULARIO ---------------- */
        .form-label {
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 12px;
            color: var(--ink-soft);
            margin-bottom: 8px;
            font-weight: 600;
        }

        .form-control {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid var(--line);
            border-radius: 4px;
            font-family: 'Segoe UI', sans-serif;
            font-size: 14px;
            color: var(--ink);
            background: var(--panel);
            box-sizing: border-box;
            margin-bottom: 16px;
            transition: border-color 0.2s;
        }
        
        .form-control:focus { outline: none; border-color: var(--secondary); }

        /* ---------------- BADGES ---------------- */
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        .badge-active { background: var(--success-light); color: var(--success); border: 1px solid var(--success); }
        .badge-info { background: #E1EFFE; color: var(--secondary); }
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
                <div class="crest-subtitle">Portal del Estudiante</div>
            </div>
        </div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/ranking.jsp" class="btn btn-outline-light">
                Rankings Generales
            </a>
            <span class="user-info">DNI: <b><%= u.getUsername() %></b></span>
            <a href="${pageContext.request.contextPath}/index.jsp?estado=logout" class="btn btn-red">
                Cerrar Sesión
            </a>
        </div>
    </nav>

    <div class="container">

        <%-- Mensajes Informativos de Sesión --%>
        <% if (session.getAttribute("msgExito") != null) { %>
            <div class="alert alert-success">
                <%= session.getAttribute("msgExito") %>
            </div>
            <% session.removeAttribute("msgExito"); %>
        <% } %>

        <% if (session.getAttribute("msgError") != null) { %>
            <div class="alert alert-danger">
                <%= session.getAttribute("msgError") %>
            </div>
            <% session.removeAttribute("msgError"); %>
        <% } %>

        <div class="panel panel-accent-primary">
            <div class="panel-header">
                <h3>Información Institucional del Estudiante</h3>
            </div>
            <div class="grid-3">
                <div>
                    <span class="form-label">Nombres y Apellidos:</span>
                    <span style="font-size: 15px; font-weight: 600; color: var(--ink);">
                        <%= (alumno != null) ? alumno.getNombreCompleto() : "N/A" %>
                    </span>
                </div>
                <div>
                    <span class="form-label">Correo Electrónico:</span>
                    <span style="font-size: 15px; font-weight: 600; color: var(--ink);">
                        <%= (alumno != null) ? alumno.getCorreo() : "N/A" %>
                    </span>
                </div>
                <div>
                    <span class="form-label">Grado y Sección Escolar:</span>
                    <span style="font-size: 15px; font-weight: 600; color: var(--ink);">
                        <%= (alumno != null) ? alumno.getNombreGrado() + " - " + alumno.getNombreSeccion() : "N/A" %>
                    </span>
                </div>
            </div>
        </div>

        <div class="grid-layout">
            
            <div class="panel">
                <% if (periodoVigente != null) { %>
                    <div class="panel-header">
                        <h3>Convocatoria Vigente: <%= periodoVigente.getNombrePeriodo() %></h3>
                        <span class="badge badge-active">PROCESO ACTIVO</span>
                    </div>
                    
                    <% if (postulacionActiva != null) { %>
                        <div style="background: #F8FAFC; border: 1px solid var(--line); padding: 24px; border-radius: 4px;">
                            <span class="badge badge-info" style="margin-bottom: 12px;">Inscripción Confirmada</span>
                            <h4><%= postulacionActiva.getNombreCarrera() %></h4>
                            <p class="text-desc" style="font-size: 14px;">Área Académica: <b style="color: var(--ink);"><%= postulacionActiva.getNombreArea() %></b></p>

                            <div style="margin-top: 24px; padding-top: 20px; border-top: 1px solid var(--line); display: flex; flex-wrap: wrap; gap: 12px;">
                                <a href="${pageContext.request.contextPath}/documento?tipo=constancia&dni=<%= u.getUsername() %>" target="_blank" class="btn btn-primary">
                                    Ver Constancia Oficial (QR)
                                </a>
                                <a href="${pageContext.request.contextPath}/documento?tipo=boleta&dni=<%= u.getUsername() %>" target="_blank" class="btn btn-secondary">
                                    Ver Ficha de Calificaciones
                                </a>
                                <form action="${pageContext.request.contextPath}/alumno/cancelarInscripcion" method="POST" onsubmit="return confirm('¿Está seguro de cancelar su inscripción a este simulacro?');" style="margin:0;">
                                    <input type="hidden" name="idPostulante" value="<%= postulacionActiva.getIdPostulante() %>">
                                    <button type="submit" class="btn btn-red">
                                        Cancelar Inscripción
                                    </button>
                                </form>
                            </div>
                        </div>
                    <% } else { %>
                        <div style="background: #F8FAFC; border: 1px solid var(--line); padding: 28px; border-radius: 4px;">
                            <p class="form-label" style="margin-bottom: 20px;">Seleccione la carrera profesional de destino para formalizar su inscripción:</p>

                            <form action="${pageContext.request.contextPath}/alumno/inscribir" method="POST">
                                <input type="hidden" name="idAlumno" value="<%= (alumno != null) ? alumno.getIdAlumno() : 0 %>">
                                <input type="hidden" name="idPeriodo" value="<%= periodoVigente.getIdPeriodo() %>">

                                <div>
                                    <label class="form-label">Carrera Profesional (*)</label>
                                    <select name="idCarrera" class="form-control" required style="font-weight: 600; color: var(--primary);">
                                        <optgroup label="Área Biomédicas">
                                            <option value="1">Medicina Humana</option>
                                            <option value="2">Enfermería</option>
                                        </optgroup>
                                        <optgroup label="Área Ingenierías">
                                            <option value="3">Ingeniería de Datos e Inteligencia Artificial</option>
                                            <option value="4">Ingeniería de Sistemas</option>
                                        </optgroup>
                                        <optgroup label="Área Sociales">
                                            <option value="5">Derecho</option>
                                        </optgroup>
                                    </select>
                                </div>

                                <button type="submit" class="btn btn-primary btn-block" style="margin-top: 12px;">
                                    Confirmar Inscripción al Simulacro
                                </button>
                            </form>
                        </div>
                    <% } %>
                <% } else { %>
                    <div style="text-align: center; padding: 48px 20px;">
                        <h3 style="color: var(--ink-soft);">No Hay Convocatorias Activas</h3>
                        <p class="text-desc" style="margin-top: 8px;">La administración institucional habilitará próximamente el siguiente período de evaluación.</p>
                    </div>
                <% } %>
            </div>

            <div>
                <div class="panel panel-accent-gold" style="padding: 24px;">
                    <h4>Reconocimiento Académico Top 3</h4>
                    <p class="text-desc">Habilitado exclusivamente para los 3 mejores puntajes del Cómputo General.</p>

                    <% if (resultado != null && resultado.getPosicionGeneral() != null && resultado.getPosicionGeneral() <= 3 && resultado.getPosicionGeneral() > 0) { %>
                        <div style="margin-top: 20px; padding: 16px; background: var(--warning-light); border: 1px solid var(--warning); border-radius: 4px; text-align: center;">
                            <span style="font-size: 12px; font-weight: 700; color: #8A6200; text-transform: uppercase; display: block;">Distinción Obtenida: Puesto N° <%= resultado.getPosicionGeneral() %></span>
                            <span style="font-size: 13px; color: #664A00; display: block; margin-top: 6px;">Puntaje Total: <b style="font-size: 14px;"><%= resultado.getPuntajeTotal() %> pts</b></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/diploma?dni=<%= u.getUsername() %>" target="_blank" class="btn btn-gold btn-block" style="margin-top: 16px;">
                            Descargar Diploma de Honor
                        </a>
                    <% } else { %>
                        <div style="margin-top: 20px; padding: 16px; background: var(--bg-main); border: 1px solid var(--line); border-radius: 4px; text-align: center; font-size: 12px; color: var(--ink-soft);">
                            Estado: Fuera de la ubicación Top 3 o Evaluación Pendiente.
                        </div>
                    <% } %>
                </div>

                <div class="panel" style="padding: 24px;">
                    <h4>Cuadro General de Méritos</h4>
                    <p class="text-desc" style="margin-bottom: 20px;">Consulte los rankings ordenados por período lectivo y áreas académicas.</p>
                    <a href="${pageContext.request.contextPath}/ranking.jsp" class="btn btn-primary btn-block">
                        Consultar Ranking General
                    </a>
                </div>
            </div>

        </div>

        <div class="panel">
            <div class="panel-header">
                <h3>Historial Institucional de Simulacros y Postulaciones</h3>
            </div>
            <p class="text-desc" style="margin-bottom: 24px;">Registro cronológico de convocatorias en las que ha participado el estudiante en la institución.</p>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>Período / Convocatoria</th>
                            <th>Área Académica</th>
                            <th>Carrera Destino</th>
                            <th>Fecha de Inscripción</th>
                            <th style="text-align: center;">Documentos / Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (historialPostulaciones != null && !historialPostulaciones.isEmpty()) { 
                            for (Postulante hp : historialPostulaciones) { %>
                            <tr>
                                <td class="td-bold"><%= hp.getNombrePeriodo() %></td>
                                <td style="color: var(--ink-soft);"><%= hp.getNombreArea() %></td>
                                <td style="font-weight: 600;"><%= hp.getNombreCarrera() %></td>
                                <td style="color: var(--ink-soft);"><%= hp.getFechaInscripcion() != null ? hp.getFechaInscripcion() : "---" %></td>
                                <td style="text-align: center;">
                                    <a href="${pageContext.request.contextPath}/documento?tipo=constancia&dni=<%= u.getUsername() %>" target="_blank" class="btn btn-primary" style="padding: 6px 12px; font-size: 11px; margin-right: 4px;">
                                        Constancia QR
                                    </a>
                                    <a href="${pageContext.request.contextPath}/ranking.jsp?idPeriodo=<%= hp.getIdPeriodo() %>" class="btn" style="padding: 6px 12px; font-size: 11px; background: var(--bg-main); color: var(--ink); border: 1px solid var(--line);">
                                        Ranking Período
                                    </a>
                                </td>
                            </tr>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 32px; color: var(--ink-soft); font-weight: 500;">
                                    No se encontraron registros de postulaciones en períodos anteriores.
                                </td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</body>
</html> 