<%-- 
    Document   : ranking
    Created on : 30 jul 2026, 11:09:33 p.m.
    Author     : klaidneil
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="finesi.app.andromeda.modelo.ResultadoDetalle"%>
<%@ page import="finesi.app.andromeda.dao.ResultadoDAO"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.stream.Collectors"%>
<%
    ResultadoDAO resultadoDAO = new ResultadoDAO();
    List<ResultadoDetalle> listaCompleta = resultadoDAO.listarRankings();

    String areaFiltro = request.getParameter("area");
    if (areaFiltro == null || areaFiltro.trim().isEmpty()) areaFiltro = "TODAS";

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
    <title>Ranking Oficial de Admisión | Colegio Andromeda</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen">

    <nav class="bg-indigo-950 text-white px-8 py-4 flex justify-between items-center shadow-lg">
        <div class="flex items-center space-x-3">
            <span class="text-2xl">🏆</span>
            <span class="font-bold text-xl tracking-wider">CUADRO GENERAL DE MÉRITOS - SIMULACRO 2026</span>
        </div>
        <a href="${pageContext.request.contextPath}/alumno/dashboard.jsp" class="bg-indigo-800 hover:bg-indigo-700 text-white text-xs px-4 py-2 rounded-lg font-bold transition">
            Volver al Portal
        </a>
    </nav>

    <div class="container mx-auto px-6 py-8">

        <!-- Barra de Filtros -->
        <div class="bg-white rounded-xl shadow-md p-6 mb-8 flex flex-col md:flex-row justify-between items-center gap-4 border-l-4 border-indigo-900">
            <div>
                <h3 class="text-lg font-bold text-gray-800">Filtros de Clasificación</h3>
                <p class="text-xs text-gray-500">Selecciona el área académica para filtrar las posiciones del ranking</p>
            </div>

            <div class="flex flex-wrap gap-2">
                <a href="ranking.jsp?area=TODAS" class="px-4 py-2 rounded-lg text-xs font-bold transition <%= "TODAS".equalsIgnoreCase(areaFiltro) ? "bg-indigo-950 text-white shadow" : "bg-slate-100 text-gray-600 hover:bg-gray-200" %>">
                    🌐 Todas las Áreas
                </a>
                <a href="ranking.jsp?area=Biomédicas" class="px-4 py-2 rounded-lg text-xs font-bold transition <%= "Biomédicas".equalsIgnoreCase(areaFiltro) ? "bg-red-700 text-white shadow" : "bg-slate-100 text-gray-600 hover:bg-gray-200" %>">
                    🧬 Biomédicas
                </a>
                <a href="ranking.jsp?area=Ingenierías" class="px-4 py-2 rounded-lg text-xs font-bold transition <%= "Ingenierías".equalsIgnoreCase(areaFiltro) ? "bg-blue-700 text-white shadow" : "bg-slate-100 text-gray-600 hover:bg-gray-200" %>">
                    ⚙️ Ingenierías
                </a>
                <a href="ranking.jsp?area=Sociales" class="px-4 py-2 rounded-lg text-xs font-bold transition <%= "Sociales".equalsIgnoreCase(areaFiltro) ? "bg-amber-600 text-white shadow" : "bg-slate-100 text-gray-600 hover:bg-gray-200" %>">
                    ⚖️ Sociales
                </a>
            </div>
        </div>

        <!-- Tabla de Ranking -->
        <div class="bg-white rounded-xl shadow-lg p-6">
            <div class="overflow-x-auto">
                <table class="w-full text-sm text-left border border-slate-200">
                    <thead class="text-xs uppercase bg-indigo-950 text-white">
                        <tr>
                            <th class="px-4 py-3 text-center">Puesto</th>
                            <th class="px-4 py-3">DNI</th>
                            <th class="px-4 py-3">Postulante</th>
                            <th class="px-4 py-3">Área</th>
                            <th class="px-4 py-3">Carrera Destino</th>
                            <th class="px-3 py-3 text-center">Puntaje Total</th>
                            <th class="px-3 py-3 text-center">Condición</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listaFiltrada != null && !listaFiltrada.isEmpty()) { 
                            for (ResultadoDetalle r : listaFiltrada) { 
                                boolean esTop3 = (r.getPosicionGeneral() != null && r.getPosicionGeneral() <= 3);
                        %>
                            <tr class="border-b hover:bg-slate-50 <%= esTop3 ? "bg-amber-50/60 font-semibold" : "" %>">
                                <td class="px-4 py-3 text-center">
                                    <% if (esTop3) { %>
                                        <span class="bg-amber-500 text-white text-xs px-2.5 py-1 rounded-full font-bold">🥇 N° <%= r.getPosicionGeneral() %></span>
                                    <% } else { %>
                                        <span class="text-gray-600 font-bold">N° <%= r.getPosicionGeneral() %></span>
                                    <% } %>
                                </td>
                                <td class="px-4 py-3 font-mono text-xs"><%= r.getNumDocumento() %></td>
                                <td class="px-4 py-3"><%= r.getNombreAlumno() %></td>
                                <td class="px-4 py-3 text-xs font-bold text-indigo-900"><%= r.getAreaAcademica() %></td>
                                <td class="px-4 py-3 text-xs"><%= r.getCarreraProfesional() %></td>
                                <td class="px-3 py-3 text-center font-bold text-indigo-950"><%= r.getPuntajeTotal() %> pts</td>
                                <td class="px-3 py-3 text-center">
                                    <% if (esTop3) { %>
                                        <span class="bg-amber-100 text-amber-800 text-xs px-2 py-0.5 rounded font-bold">INGRESANTE TOP 3</span>
                                    <% } else { %>
                                        <span class="bg-emerald-100 text-emerald-800 text-xs px-2 py-0.5 rounded font-bold">EVALUADO</span>
                                    <% } %>
                                </td>
                            </tr>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="7" class="text-center py-8 text-gray-500">No hay calificaciones registradas para los filtros seleccionados.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</body>
</html>