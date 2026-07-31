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
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif;
            background-color: #f8f9fa;
            color: #1a2332;
            line-height: 1.6;
        }
        
        /* Navegación */
        .navbar {
            background: linear-gradient(135deg, #0f3460 0%, #162a47 100%);
            box-shadow: 0 2px 8px rgba(15, 52, 96, 0.12);
            border-bottom: 3px solid #8b2d3f;
        }
        
        .navbar-title {
            color: #ffffff;
            font-weight: 700;
            letter-spacing: 0.5px;
            font-size: 1.1rem;
        }
        
        .navbar-badge {
            background-color: rgba(255, 255, 255, 0.15);
            color: #d4d9e3;
            font-size: 0.75rem;
            letter-spacing: 1px;
            padding: 0.4rem 0.8rem;
            border-radius: 4px;
            border: 1px solid rgba(255, 255, 255, 0.25);
            font-weight: 600;
        }
        
        .btn-back {
            background-color: rgba(255, 255, 255, 0.1);
            color: #e8ecf3;
            border: 1px solid rgba(255, 255, 255, 0.2);
            padding: 0.6rem 1.2rem;
            font-size: 0.85rem;
            font-weight: 600;
            border-radius: 5px;
            transition: all 0.3s ease;
            text-decoration: none;
            cursor: pointer;
        }
        
        .btn-back:hover {
            background-color: rgba(255, 255, 255, 0.2);
            border-color: rgba(255, 255, 255, 0.3);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        /* Panel de Filtros */
        .filter-panel {
            background: #ffffff;
            border: 1px solid #e0e6ed;
            border-radius: 8px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
            border-left: 4px solid #0f3460;
        }
        
        .filter-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        
        .filter-label {
            font-size: 0.8rem;
            font-weight: 700;
            color: #2d3f5b;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }
        
        .filter-select {
            padding: 0.7rem 0.9rem;
            font-size: 0.9rem;
            border: 1px solid #d0d7e0;
            border-radius: 5px;
            background-color: #f8f9fb;
            color: #1a2332;
            font-weight: 500;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .filter-select:hover {
            border-color: #0f3460;
            background-color: #ffffff;
        }
        
        .filter-select:focus {
            outline: none;
            border-color: #0f3460;
            box-shadow: 0 0 0 3px rgba(15, 52, 96, 0.1);
            background-color: #ffffff;
        }
        
        .filter-buttons {
            display: flex;
            flex-wrap: wrap;
            gap: 0.8rem;
        }
        
        .btn-filter {
            padding: 0.6rem 1rem;
            font-size: 0.8rem;
            font-weight: 600;
            border: 1px solid #d0d7e0;
            border-radius: 5px;
            background-color: #f8f9fb;
            color: #2d3f5b;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        
        .btn-filter:hover {
            border-color: #0f3460;
            background-color: #eff3f8;
        }
        
        .btn-filter.active {
            background-color: #0f3460;
            color: #ffffff;
            border-color: #0f3460;
            box-shadow: 0 2px 6px rgba(15, 52, 96, 0.2);
        }
        
        /* Botón Exportar */
        .btn-export {
            background: linear-gradient(135deg, #2d5f3f 0%, #1f4530 100%);
            color: #ffffff;
            border: none;
            padding: 0.7rem 1.4rem;
            font-size: 0.8rem;
            font-weight: 700;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            text-decoration: none;
            display: inline-block;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        
        .btn-export:hover {
            box-shadow: 0 4px 8px rgba(45, 95, 63, 0.2);
            transform: translateY(-1px);
        }
        
        /* Tabla */
        .table-container {
            background: #ffffff;
            border: 1px solid #e0e6ed;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            font-size: 0.9rem;
        }
        
        thead {
            background: linear-gradient(135deg, #0f3460 0%, #162a47 100%);
            color: #ffffff;
        }
        
        th {
            padding: 1rem;
            text-align: left;
            font-weight: 700;
            font-size: 0.85rem;
            letter-spacing: 0.3px;
            text-transform: uppercase;
            border-bottom: 2px solid #162a47;
        }
        
        th:nth-child(1),
        th:nth-child(6),
        th:nth-child(7) {
            text-align: center;
        }
        
        tbody tr {
            border-bottom: 1px solid #e8ecf3;
            transition: background-color 0.2s ease;
        }
        
        tbody tr:hover {
            background-color: #f8f9fb;
        }
        
        tbody tr.top-3 {
            background-color: #fef8f0;
        }
        
        tbody tr.top-3:hover {
            background-color: #fef1e6;
        }
        
        td {
            padding: 1rem;
        }
        
        td:nth-child(1),
        td:nth-child(6),
        td:nth-child(7) {
            text-align: center;
        }
        
        /* Badges */
        .badge {
            display: inline-block;
            padding: 0.4rem 0.8rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 700;
            letter-spacing: 0.3px;
            text-transform: uppercase;
            border: 1px solid;
        }
        
        .badge-top3 {
            background-color: #8b2d3f;
            color: #ffffff;
            border-color: #6b1f2f;
        }
        
        .badge-evaluated {
            background-color: #e8ecf3;
            color: #2d3f5b;
            border-color: #d0d7e0;
        }
        
        .badge-top3-status {
            background-color: #fff3e0;
            color: #7d4a1f;
            border-color: #ffe0b2;
        }
        
        /* Texto Monoespaciado */
        .text-mono {
            font-family: 'Courier New', monospace;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        /* Estado Sin Datos */
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #7a8a9e;
            font-size: 0.95rem;
        }
        
        /* Responsivo */
        @media (max-width: 768px) {
            .filter-panel {
                padding: 1.5rem;
            }
            
            .filter-buttons {
                gap: 0.6rem;
            }
            
            .btn-filter {
                flex: 1;
                min-width: calc(50% - 0.4rem);
            }
            
            th, td {
                padding: 0.75rem 0.5rem;
                font-size: 0.85rem;
            }
            
            .badge {
                padding: 0.3rem 0.6rem;
                font-size: 0.7rem;
            }
        }
    </style>
    <script>
        function aplicarFiltros() {
            document.getElementById('filtroForm').submit();
        }
    </script>
</head>
<body>

    <!-- NAVEGACIÓN -->
    <nav class="navbar">
        <div class="flex justify-between items-center px-8 py-4" style="gap: 2rem;">
            <div class="flex items-center" style="gap: 1.5rem;">
                <span class="navbar-badge">G.U.E. Andrómeda</span>
                <h1 class="navbar-title">Cuadro General de Méritos y Ranking</h1>
            </div>
            <a href="${pageContext.request.contextPath}/alumno/dashboard.jsp" class="btn-back">
                Volver al Portal
            </a>
        </div>
    </nav>

    <!-- CONTENEDOR PRINCIPAL -->
    <div class="container mx-auto px-6 py-8" style="max-width: 1400px;">

        <!-- PANEL DE FILTROS -->
        <div class="filter-panel">
            <form id="filtroForm" action="ranking.jsp" method="GET" style="display: flex; flex-direction: column; gap: 2rem;">
                
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; margin-bottom: 1rem;">
                    <!-- Filtro Período -->
                    <div class="filter-group">
                        <label class="filter-label">Simulacro / Período:</label>
                        <select name="idPeriodo" onchange="aplicarFiltros()" class="filter-select">
                            <option value="0">-- Todos los Simulacros Históricos --</option>
                            <% for (Periodo p : listaPeriodos) { %>
                                <option value="<%= p.getIdPeriodo() %>" <%= (idPeriodoFiltro != null && idPeriodoFiltro == p.getIdPeriodo()) ? "selected" : "" %>>
                                    <%= p.getNombrePeriodo() %> [<%= p.getEstado() %>]
                                </option>
                            <% } %>
                        </select>
                    </div>

                    <!-- Filtro Área Académica -->
                    <div class="filter-group">
                        <label class="filter-label">Área Académica:</label>
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

                <!-- Botón Exportar -->
                <div style="display: flex; justify-content: flex-end;">
                    <a href="${pageContext.request.contextPath}/exportarExcel?idPeriodo=<%= (idPeriodoFiltro != null ? idPeriodoFiltro : 0) %>&area=<%= areaFiltro %>" class="btn-export">
                        Exportar Cuadro a Excel
                    </a>
                </div>
            </form>
        </div>

        <!-- TABLA DE RESULTADOS -->
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Puesto</th>
                        <th>DNI</th>
                        <th>Postulante</th>
                        <th>Área / Período</th>
                        <th>Carrera Destino</th>
                        <th>Puntaje Total</th>
                        <th>Condición</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (listaFiltrada != null && !listaFiltrada.isEmpty()) { 
                        for (ResultadoDetalle r : listaFiltrada) { 
                            boolean esTop3 = (r.getPosicionGeneral() != null && r.getPosicionGeneral() <= 3 && r.getPosicionGeneral() > 0);
                    %>
                        <tr class="<%= esTop3 ? "top-3" : "" %>">
                            <td>
                                <% if (esTop3) { %>
                                    <span class="badge badge-top3">Puesto N° <%= r.getPosicionGeneral() %></span>
                                <% } else { %>
                                    <span style="color: #2d3f5b; font-weight: 700;">N° <%= r.getPosicionGeneral() %></span>
                                <% } %>
                            </td>
                            <td class="text-mono" style="color: #1a2332;"><%= r.getNumDocumento() %></td>
                            <td style="font-weight: 600; color: #1a2332;"><%= r.getNombreAlumno() %></td>
                            <td>
                                <div style="font-weight: 700; color: #1a2332; margin-bottom: 0.3rem;"><%= r.getAreaAcademica() %></div>
                                <div style="font-size: 0.85rem; color: #7a8a9e;"><%= r.getNombreExamen() %></div>
                            </td>
                            <td style="color: #4a5f78; font-size: 0.9rem;"><%= r.getCarreraProfesional() %></td>
                            <td style="font-weight: 700; color: #1a2332;"><%= r.getPuntajeTotal() %> pts</td>
                            <td>
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

</body>
</html>
