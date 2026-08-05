<%-- 
    Document   : ranking
    Created on : 30 jul 2026, 11:09:33 p.m.
    Author     : klaidneil
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="finesi.app.andromeda.modelo.ResultadoDetalle"%>
<%@ page import="finesi.app.andromeda.modelo.Periodo"%>
<%@ page import="finesi.app.andromeda.dao.ResultadoDAO"%>
<%@ page import="finesi.app.andromeda.dao.MaestrosDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.stream.Collectors"%>
<%
    MaestrosDAO maestrosDAO = new MaestrosDAO();
    List<Periodo> listaPeriodos = maestrosDAO.listarPeriodos();

    // Capturar parámetros de filtrado
    String idPeriodoParam = request.getParameter("idPeriodo");
    Integer idPeriodoFiltro = null;
    if (idPeriodoParam != null && !idPeriodoParam.trim().isEmpty() && !idPeriodoParam.equals("0")) {
        try {
            idPeriodoFiltro = Integer.parseInt(idPeriodoParam);
        } catch (NumberFormatException e) {
            idPeriodoFiltro = null;
        }
    }

    String areaFiltro = request.getParameter("area");
    if (areaFiltro == null || areaFiltro.trim().isEmpty()) areaFiltro = "TODAS";

    // Obtener lista filtrada por Período desde la BD
    ResultadoDAO resultadoDAO = new ResultadoDAO();
    List<ResultadoDetalle> listaCompleta = resultadoDAO.listarRankingsPorPeriodo(idPeriodoFiltro);

    // Filtrar adicionalmente por Área
    final String filtroFinal = areaFiltro.toLowerCase().trim();
    List<ResultadoDetalle> listaFiltrada = listaCompleta;

    if (!"todas".equals(filtroFinal) && listaCompleta != null) {
        listaFiltrada = listaCompleta.stream()
            .filter(r -> {
                String areaNom = (r.getAreaAcademica() != null) ? r.getAreaAcademica().toLowerCase() : "";
                if (filtroFinal.contains("ing") && areaNom.contains("ing")) return true;
                if (filtroFinal.contains("bio") && areaNom.contains("bio")) return true;
                if (filtroFinal.contains("soc") && areaNom.contains("soc")) return true;
                return areaNom.equalsIgnoreCase(filtroFinal);
            })
            .collect(Collectors.toList());
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cuadro General de Méritos y Ranking | Gran Unidad Escolar Andrómeda</title>
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Source+Serif+4:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');

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

        * {
            box-sizing: border-box;
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

        /* ---------------- BOTONES ---------------- */
        .btn {
            display: inline-block;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            font-weight: 500;
            padding: 10px 18px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            border: 1px solid transparent;
            transition: all 0.2s ease;
            box-sizing: border-box;
            letter-spacing: 0.03em;
        }

        .btn-green { background: var(--green); color: var(--panel); }
        .btn-green:hover { background: #127243; }

        .btn-nav-outline { background: transparent; border: 1px solid var(--line); color: var(--panel); }
        .btn-nav-outline:hover { background: var(--navy-soft); border-color: var(--panel); }

        .btn-filter {
            padding: 8px 14px;
            font-size: 12px;
            font-weight: 500;
            border: 1px solid var(--line);
            border-radius: 4px;
            background: var(--panel);
            color: var(--ink);
            cursor: pointer;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .btn-filter:hover {
            border-color: var(--navy);
            background: var(--bg);
        }

        .btn-filter.active {
            background: var(--navy);
            color: var(--panel);
            border-color: var(--navy);
        }

        /* ---------------- ESTRUCTURA GENERAL Y PANELES ---------------- */
        .container {
            max-width: 1240px;
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

        .filter-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 11px;
            color: var(--ink-soft);
            font-weight: 500;
            margin-bottom: 8px;
        }

        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--line);
            border-radius: 4px;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            color: var(--ink);
            background: var(--panel);
            box-sizing: border-box;
        }

        .form-control:focus { outline: none; border-color: var(--navy); }

        .filter-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }

        /* ---------------- TABLA DE RESULTADOS ---------------- */
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
            background: var(--panel);
        }

        td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--line);
            font-size: 13px;
            color: var(--ink);
            vertical-align: middle;
        }

        tr:hover td { background-color: var(--bg); }

        /* Fila de Reconocimiento Top 3 */
        tr.top-3-row td {
            background-color: var(--gold-light);
        }

        tr.top-3-row:hover td {
            background-color: #F8E8C7;
        }

        /* Badges */
        .badge {
            display: inline-block;
            border-radius: 3px;
            padding: 4px 10px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .badge-gold {
            background-color: var(--gold);
            color: var(--panel);
            font-family: 'Source Serif 4', serif;
        }

        .badge-evaluated {
            background-color: var(--bg);
            color: var(--ink-soft);
            border: 1px solid var(--line);
        }

        .badge-top3-status {
            background-color: var(--gold-light);
            color: #8A6200;
            border: 1px solid var(--gold);
        }

        .td-bold { font-weight: 600; color: var(--navy); }
        .td-mono { font-family: monospace; font-size: 13px; font-weight: 600; color: var(--navy); }

        .empty-state {
            text-align: center;
            padding: 48px 16px;
            color: var(--ink-soft);
        }

        @media (max-width: 900px) {
            .navbar { padding: 16px 20px; }
            .container { padding: 20px 16px; }
            .filter-grid { grid-template-columns: 1fr; }
        }
    </style>
    <script>
        function aplicarFiltros() {
            document.getElementById('filtroForm').submit();
        }
    </script>
</head>
<body>

    <nav class="navbar">
        <div class="brand-container">
            <div class="crest">
                <img src="${pageContext.request.contextPath}/assets/images/logo.svg" alt="Escudo G.U.E. Andrómeda">
            </div>
            <div>
                <div class="crest-title">G.U.E. Andrómeda</div>
                <div class="crest-subtitle">Cuadro General de Méritos y Ranking</div>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/alumno/dashboard.jsp" class="btn btn-nav-outline">
            Volver al Portal
        </a>
    </nav>

    <div class="container">

        <div class="panel panel-accent">
            <form id="filtroForm" action="ranking.jsp" method="GET" style="margin: 0;">
                
                <div class="filter-grid">
                    <div>
                        <label class="form-label">Simulacro / Período Académico:</label>
                        <select name="idPeriodo" onchange="aplicarFiltros()" class="form-control" style="font-weight: 600; color: var(--navy);">
                            <option value="0">-- Todos los Simulacros Históricos --</option>
                            <% for (Periodo p : listaPeriodos) { %>
                                <option value="<%= p.getIdPeriodo() %>" <%= (idPeriodoFiltro != null && idPeriodoFiltro == p.getIdPeriodo()) ? "selected" : "" %>>
                                    <%= p.getNombrePeriodo() %> [<%= p.getEstado() %>]
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <div>
                        <label class="form-label">Área Académica:</label>
                        <input type="hidden" name="area" id="areaInput" value="<%= areaFiltro %>">
                        <div class="filter-buttons">
                            <button type="button" onclick="document.getElementById('areaInput').value='TODAS'; aplicarFiltros();" class="btn-filter <%= "TODAS".equalsIgnoreCase(areaFiltro) ? "active" : "" %>">
                                Todas
                            </button>
                            <button type="button" onclick="document.getElementById('areaInput').value='Biomédicas'; aplicarFiltros();" class="btn-filter <%= "Biomédicas".equalsIgnoreCase(areaFiltro) ? "active" : "" %>">
                                Biomédicas
                            </button>
                            <button type="button" onclick="document.getElementById('areaInput').value='Ingenierías'; aplicarFiltros();" class="btn-filter <%= "Ingenierías".equalsIgnoreCase(areaFiltro) ? "active" : "" %>">
                                Ingenierías
                            </button>
                            <button type="button" onclick="document.getElementById('areaInput').value='Sociales'; aplicarFiltros();" class="btn-filter <%= "Sociales".equalsIgnoreCase(areaFiltro) ? "active" : "" %>">
                                Sociales
                            </button>
                        </div>
                    </div>
                </div>

                <div style="display: flex; justify-content: flex-end; border-top: 1px solid var(--line); padding-top: 16px;">
                    <a href="${pageContext.request.contextPath}/exportarExcel?idPeriodo=<%= (idPeriodoFiltro != null ? idPeriodoFiltro : 0) %>&area=<%= areaFiltro %>" class="btn btn-green">
                        Exportar Cuadro a Excel
                    </a>
                </div>
            </form>
        </div>

        <div class="panel" style="padding: 0; overflow: hidden;">
            <div class="table-responsive">
                <table>
                    <thead>
                        <tr>
                            <th style="text-align: center;">Puesto</th>
                            <th>DNI</th>
                            <th>Postulante</th>
                            <th>Área / Período</th>
                            <th>Carrera Destino</th>
                            <th style="text-align: center;">Puntaje Total</th>
                            <th style="text-align: center;">Condición</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaFiltrada != null && !listaFiltrada.isEmpty()) { 
                            for (ResultadoDetalle r : listaFiltrada) { 
                                boolean esTop3 = (r.getPosicionGeneral() != null && r.getPosicionGeneral() <= 3 && r.getPosicionGeneral() > 0);
                        %>
                            <tr class="<%= esTop3 ? "top-3-row" : "" %>">
                                <td style="text-align: center;">
                                    <% if (esTop3) { %>
                                        <span class="badge badge-gold">Puesto N° <%= r.getPosicionGeneral() %></span>
                                    <% } else { %>
                                        <span style="color: var(--navy); font-weight: 600;">N° <%= r.getPosicionGeneral() %></span>
                                    <% } %>
                                </td>
                                <td class="td-mono"><%= r.getNumDocumento() %></td>
                                <td class="td-bold"><%= r.getNombreAlumno() %></td>
                                <td>
                                    <div style="font-weight: 600; color: var(--navy);"><%= r.getAreaAcademica() %></div>
                                    <div style="font-size: 11px; color: var(--ink-soft);"><%= r.getNombreExamen() %></div>
                                </td>
                                <td style="color: var(--ink-soft);"><%= r.getCarreraProfesional() %></td>
                                <td style="text-align: center; font-weight: 700; color: var(--navy);"><%= r.getPuntajeTotal() %> pts</td>
                                <td style="text-align: center;">
                                    <% if (esTop3) { %>
                                        <span class="badge badge-top3-status">Ingresante Top 3</span>
                                    <% } else { %>
                                        <span class="badge badge-evaluated">Evaluado</span>
                                    <% } %>
                                </td>
                            </tr>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="7" class="empty-state">
                                    <strong>No hay calificaciones registradas</strong><br>
                                    para los filtros seleccionados.
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