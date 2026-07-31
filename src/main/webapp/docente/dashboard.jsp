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
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; }
    </style>
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen">

    <nav class="bg-slate-900 text-white px-8 py-4 flex justify-between items-center border-b-2 border-slate-700 shadow-md">
        <div class="flex items-center space-x-3">
            <span class="text-xs uppercase tracking-widest bg-slate-800 px-2.5 py-1 rounded border border-slate-700 text-slate-300 font-semibold">G.U.E. Andrómeda</span>
            <span class="font-bold text-lg tracking-wide uppercase text-slate-100">PANEL DOCENTE — EVALUACIÓN ACADÉMICA</span>
        </div>
        <div class="flex items-center space-x-6">
            <span class="text-xs text-slate-400">Docente Evaluador: <b class="text-slate-200"><%= u.getUsername() %></b></span>
            <a href="${pageContext.request.contextPath}/index.jsp?estado=logout" class="bg-red-800 hover:bg-red-900 text-white px-3.5 py-2 rounded text-xs font-bold transition">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container mx-auto px-6 py-8">

        <%-- Mensajes Informativos de Sesión --%>
        <% if (session.getAttribute("msgExito") != null) { %>
            <div class="bg-emerald-50 border-l-4 border-emerald-600 text-emerald-900 p-4 rounded mb-6 font-medium text-sm shadow-sm">
                <%= session.getAttribute("msgExito") %>
            </div>
            <% session.removeAttribute("msgExito"); %>
        <% } %>

        <% if (session.getAttribute("msgError") != null) { %>
            <div class="bg-red-50 border-l-4 border-red-600 text-red-900 p-4 rounded mb-6 font-medium text-sm shadow-sm">
                <%= session.getAttribute("msgError") %>
            </div>
            <% session.removeAttribute("msgError"); %>
        <% } %>

        <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-6 mb-8 border-l-4 border-l-slate-900 flex flex-col md:flex-row justify-between items-center gap-4">
            <div>
                <h3 class="text-base font-bold text-slate-900 uppercase tracking-wide">Selección de Convocatoria / Simulacro</h3>
                <p class="text-xs text-slate-500 mt-0.5">Elija el período académico para desplegar la nómina oficial de postulantes a evaluar.</p>
            </div>
            
            <form action="${pageContext.request.contextPath}/docente/dashboard.jsp" method="GET" class="flex items-center gap-3">
                <label class="text-xs font-bold text-slate-700 uppercase">Período Académico:</label>
                <select name="idPeriodo" onchange="this.form.submit()" class="px-4 py-2 border border-slate-300 rounded text-xs font-bold text-slate-900 bg-slate-50 focus:outline-none focus:ring-1 focus:ring-slate-900">
                    <% for (Periodo per : listaPeriodos) { %>
                        <option value="<%= per.getIdPeriodo() %>" <%= (idPeriodoSel == per.getIdPeriodo()) ? "selected" : "" %>>
                            <%= per.getNombrePeriodo() %> [<%= per.getEstado() %>]
                        </option>
                    <% } %>
                </select>
            </form>
        </div>

        <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-6">
            <div class="flex justify-between items-center mb-4 border-b border-slate-200 pb-3">
                <div>
                    <h3 class="text-lg font-bold text-slate-900">Registro de Calificaciones por Criterios</h3>
                    <p class="text-xs text-slate-500 mt-0.5">Ingrese los puntajes obtenidos en cada una de las 4 evaluaciones oficiales (Suma máxima: 100 puntos).</p>
                </div>
                <span class="text-xs font-semibold bg-slate-100 text-slate-700 px-3 py-1 rounded border border-slate-200">
                    <%= postulantes != null ? postulantes.size() : 0 %> Estudiantes Registrados
                </span>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-sm text-left border border-slate-200">
                    <thead class="text-xs uppercase bg-slate-900 text-white">
                        <tr>
                            <th class="px-3 py-3">DNI</th>
                            <th class="px-3 py-3">Postulante</th>
                            <th class="px-3 py-3">Carrera Profesional</th>
                            <th class="px-2 py-3 text-center">Competencias (60)</th>
                            <th class="px-2 py-3 text-center">Psicotécnico (20)</th>
                            <th class="px-2 py-3 text-center">Redacción (10)</th>
                            <th class="px-2 py-3 text-center">Entrevista (10)</th>
                            <th class="px-3 py-3 text-center">Acción</th>
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

                                <tr class="border-b border-slate-200 hover:bg-slate-50 text-xs">
                                    <td class="px-3 py-3 font-mono font-bold text-slate-900"><%= p.getNumDocumento() %></td>
                                    <td class="px-3 py-3 font-semibold text-slate-800"><%= p.getNombreAlumno() %></td>
                                    <td class="px-3 py-3 text-slate-600"><%= p.getNombreCarrera() %></td>
                                    <td class="px-2 py-3 text-center">
                                        <input type="number" step="0.01" min="0" max="60" name="notaCompetencias" value="0.00" class="w-20 px-2 py-1 border border-slate-300 rounded text-center text-xs focus:outline-none focus:ring-1 focus:ring-slate-900" required>
                                    </td>
                                    <td class="px-2 py-3 text-center">
                                        <input type="number" step="0.01" min="0" max="20" name="notaPsicotecnico" value="0.00" class="w-20 px-2 py-1 border border-slate-300 rounded text-center text-xs focus:outline-none focus:ring-1 focus:ring-slate-900" required>
                                    </td>
                                    <td class="px-2 py-3 text-center">
                                        <input type="number" step="0.01" min="0" max="10" name="notaRedaccion" value="0.00" class="w-20 px-2 py-1 border border-slate-300 rounded text-center text-xs focus:outline-none focus:ring-1 focus:ring-slate-900" required>
                                    </td>
                                    <td class="px-2 py-3 text-center">
                                        <input type="number" step="0.01" min="0" max="10" name="notaEntrevista" value="0.00" class="w-20 px-2 py-1 border border-slate-300 rounded text-center text-xs focus:outline-none focus:ring-1 focus:ring-slate-900" required>
                                    </td>
                                    <td class="px-3 py-3 text-center">
                                        <button type="submit" class="bg-slate-900 hover:bg-slate-800 text-white text-xs px-3 py-1.5 rounded font-bold transition">
                                            Guardar Nota
                                        </button>
                                    </td>
                                </tr>
                            </form>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="8" class="text-center py-6 text-slate-500 font-medium">No se encontraron postulantes registrados para el período académico seleccionado.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</body>
</html>