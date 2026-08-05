<%-- 
    Document   : dashboard
    Created on : 30 jul 2026, 9:48:34 p.m.
    Author     : klaidneil
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="finesi.app.andromeda.modelo.Usuario"%>
<%@ page import="finesi.app.andromeda.modelo.Postulante"%>
<%@ page import="finesi.app.andromeda.modelo.Periodo"%>
<%@ page import="finesi.app.andromeda.dao.PostulanteDAO"%>
<%@ page import="finesi.app.andromeda.dao.MaestrosDAO"%>
<%@ page import="java.util.List"%>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null || (!"DOCENTE".equalsIgnoreCase(u.getRol()) && !"ADMIN".equalsIgnoreCase(u.getRol()))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?estado=sin_permiso");
        return;
    }

    MaestrosDAO maestrosDAO = new MaestrosDAO();
    PostulanteDAO postulanteDAO = new PostulanteDAO();

    List<Periodo> listaPeriodos = maestrosDAO.listarPeriodos();
    
    // Capturar el idPeriodo seleccionado por el docente
    String idPeriodoParam = request.getParameter("idPeriodo");
    int idPeriodoSel = 0;
    
    if (idPeriodoParam != null && !idPeriodoParam.trim().isEmpty()) {
        try {
            idPeriodoSel = Integer.parseInt(idPeriodoParam);
        } catch (NumberFormatException e) {
            idPeriodoSel = 0;
        }
    }
    
    // Si no se seleccionó ninguno, tomamos el período activo vigente
    if (idPeriodoSel == 0) {
        Periodo activo = maestrosDAO.obtenerPeriodoActivoVigente();
        if (activo != null) {
            idPeriodoSel = activo.getIdPeriodo();
        } else if (listaPeriodos != null && !listaPeriodos.isEmpty()) {
            idPeriodoSel = listaPeriodos.get(0).getIdPeriodo();
        }
    }

    List<Postulante> postulantes = (idPeriodoSel > 0) ? postulanteDAO.listarPorPeriodo(idPeriodoSel) : postulanteDAO.listarTodos();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel Docente - Registro de Calificaciones | Gran Unidad Escolar Andrómeda</title>

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

        /* ---------------- NAVEGACIÓN INSTITUCIONAL ---------------- */
        .navbar {
            background-color: var(--navy);
            padding: 16px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
            border-bottom: 3px solid var(--gold);
        }

        .brand-container {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        /* Contenedor del Logo (Configurado a 100px y mimetizado) */
        .crest {
            height: 100px;
            width: auto;
            display: flex;
            align-items: center;
            justify-content: center;
            background: transparent;
        }

        .crest img {
            height: 100%;
            width: auto;
            object-fit: contain;
            filter: drop-shadow(0px 2px 4px rgba(0, 0, 0, 0.3));
        }

        .crest-title {
            font-family: 'Source Serif 4', serif;
            font-size: 22px;
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
            margin-top: 2px;
        }

        .user-info {
            font-size: 13px;
            color: var(--line);
        }
        .user-info b {
            color: var(--panel);
            font-weight: 500;
        }

        /* ---------------- BOTONES ---------------- */
        .btn {
            display: inline-block;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            border: 1px solid transparent;
            transition: all 0.2s ease;
            box-sizing: border-box;
        }
        
        .btn-sm { padding: 5px 12px; font-size: 12px; }

        .btn-navy { background: var(--navy); color: var(--panel); }
        .btn-navy:hover { background: var(--navy-soft); }
        
        .btn-red { background: var(--red); color: var(--panel); }
        .btn-red:hover { background: #C53D2C; }

        .btn-green { background: var(--green); color: var(--panel); }
        .btn-green:hover { background: #127243; }

        /* ---------------- ESTRUCTURA GENERAL Y PANELES ---------------- */
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 32px 24px;
        }

        .panel {
            background: var(--panel);
            border: 1px solid var(--line);
            border-radius: 4px;
            padding: 24px;
            margin-bottom: 28px;
        }

        .panel-accent {
            border-top: 4px solid var(--navy);
        }

        .panel-header {
            border-bottom: 1px solid var(--line);
            padding-bottom: 16px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        h3 {
            font-family: 'Source Serif 4', serif;
            font-weight: 600;
            color: var(--navy);
            margin: 0;
            font-size: 20px;
        }

        .panel-desc {
            font-size: 13px;
            color: var(--ink-soft);
            margin-top: 4px;
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

        /* ---------------- ALERTAS ---------------- */
        .alert {
            padding: 14px 18px;
            border-radius: 4px;
            margin-bottom: 28px;
            font-size: 13px;
            font-weight: 500;
            border-left: 3px solid;
            box-shadow: 0 1px 2px rgba(0,0,0,0.02);
        }
        .alert-success { background: var(--green-light); color: var(--green); border-left-color: var(--green); }
        .alert-danger { background: var(--red-light); color: var(--red); border-left-color: var(--red); }

        /* ---------------- FORMULARIOS ---------------- */
        .form-label {
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 11px;
            color: var(--ink-soft);
            font-weight: 500;
        }

        .form-control {
            padding: 8px 12px;
            border: 1px solid var(--line);
            border-radius: 4px;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            color: var(--ink);
            background: var(--panel);
            box-sizing: border-box;
        }

        .form-control:focus { outline: none; border-color: var(--navy); }
        .input-number { width: 80px; text-align: center; font-weight: 500; }

        /* ---------------- TABLA ---------------- */
        .table-responsive { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; text-align: left; }
        
        th {
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 11px;
            color: var(--ink-soft);
            border-bottom: 1px solid var(--line);
            padding: 12px 14px;
            font-weight: 500;
            background: var(--panel);
        }
        
        td {
            padding: 12px 14px;
            border-bottom: 1px solid var(--line);
            font-size: 13px;
            color: var(--ink);
            vertical-align: middle;
        }
        
        tr:hover td { background-color: var(--bg); }
        
        .td-bold { font-weight: 500; color: var(--navy); }
        .td-mono { font-family: monospace; font-size: 13px; font-weight: 600; color: var(--navy); }

        @media (max-width: 900px) {
            .navbar { padding: 16px 20px; }
            .container { padding: 20px 16px; }
        }
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
                <div class="crest-subtitle">Panel Docente — Evaluación Académica</div>
            </div>
        </div>
        <div style="display: flex; align-items: center; gap: 20px;">
            <span class="user-info">Docente Evaluador: <b><%= u.getUsername() %></b></span>
            <a href="${pageContext.request.contextPath}/index.jsp?estado=logout" class="btn btn-red">Cerrar Sesión</a>
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

        <div class="panel panel-accent" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px;">
            <div>
                <h3 style="font-size: 18px;">Selección de Convocatoria / Simulacro</h3>
                <div class="panel-desc">Elija el período académico para desplegar la nómina oficial de postulantes a evaluar.</div>
            </div>
            
            <form action="${pageContext.request.contextPath}/docente/dashboard.jsp" method="GET" style="display: flex; align-items: center; gap: 12px; margin: 0;">
                <label class="form-label" style="margin: 0;">Período Académico:</label>
                <select name="idPeriodo" onchange="this.form.submit()" class="form-control" style="font-weight: 600; color: var(--navy);">
                    <% for (Periodo per : listaPeriodos) { %>
                        <option value="<%= per.getIdPeriodo() %>" <%= (idPeriodoSel == per.getIdPeriodo()) ? "selected" : "" %>>
                            <%= per.getNombrePeriodo() %> [<%= per.getEstado() %>]
                        </option>
                    <% } %>
                </select>
            </form>
        </div>

        <div class="panel">
            <div class="panel-header">
                <div>
                    <h3>Registro de Calificaciones por Criterios</h3>
                    <div class="panel-desc">Ingrese los puntajes obtenidos en cada una de las 4 evaluaciones oficiales (Suma máxima: 100 puntos).</div>
                </div>
                <span class="badge-neutral">
                    <%= postulantes != null ? postulantes.size() : 0 %> Estudiantes Registrados
                </span>
            </div>

            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th>DNI</th>
                            <th>Postulante</th>
                            <th>Carrera Profesional</th>
                            <th style="text-align: center;">Competencias (60)</th>
                            <th style="text-align: center;">Psicotécnico (20)</th>
                            <th style="text-align: center;">Redacción (10)</th>
                            <th style="text-align: center;">Entrevista (10)</th>
                            <th style="text-align: center;">Acción</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (postulantes != null && !postulantes.isEmpty()) { 
                            for (Postulante p : postulantes) { %>
                            <form action="${pageContext.request.contextPath}/docente/calificar" method="POST">
                                <input type="hidden" name="idPostulante" value="<%= p.getIdPostulante() %>">
                                <input type="hidden" name="idAlumno" value="<%= p.getIdAlumno() %>">
                                <input type="hidden" name="idExamen" value="1">
                                <input type="hidden" name="idPeriodo" value="<%= p.getIdPeriodo() %>">
                                <input type="hidden" name="correctas" value="0">
                                <input type="hidden" name="incorrectas" value="0">
                                <input type="hidden" name="vacias" value="0">

                                <tr>
                                    <td class="td-mono"><%= p.getNumDocumento() %></td>
                                    <td class="td-bold"><%= p.getNombreAlumno() %></td>
                                    <td style="color: var(--ink-soft);"><%= p.getNombreCarrera() %></td>
                                    <td style="text-align: center;">
                                        <input type="number" step="0.01" min="0" max="60" name="notaCompetencias" value="0.00" class="form-control input-number" required>
                                    </td>
                                    <td style="text-align: center;">
                                        <input type="number" step="0.01" min="0" max="20" name="notaPsicotecnico" value="0.00" class="form-control input-number" required>
                                    </td>
                                    <td style="text-align: center;">
                                        <input type="number" step="0.01" min="0" max="10" name="notaRedaccion" value="0.00" class="form-control input-number" required>
                                    </td>
                                    <td style="text-align: center;">
                                        <input type="number" step="0.01" min="0" max="10" name="notaEntrevista" value="0.00" class="form-control input-number" required>
                                    </td>
                                    <td style="text-align: center;">
                                        <button type="submit" class="btn btn-sm btn-navy">
                                            Guardar Nota
                                        </button>
                                    </td>
                                </tr>
                            </form>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="8" style="text-align: center; padding: 32px; color: var(--ink-soft); font-weight: 500;">
                                    No se encontraron postulantes registrados para el período académico seleccionado.
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