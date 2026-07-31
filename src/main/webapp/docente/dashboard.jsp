<%-- 
    Document   : dashboard
    Created on : 30 jul 2026, 9:48:34 p.m.
    Author     : klaidneil
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="finesi.app.andromeda.modelo.Usuario"%>
<%@ page import="finesi.app.andromeda.modelo.Postulante"%>
<%@ page import="finesi.app.andromeda.dao.PostulanteDAO"%>
<%@ page import="java.util.List"%>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null || (!"DOCENTE".equalsIgnoreCase(u.getRol()) && !"ADMIN".equalsIgnoreCase(u.getRol()))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?estado=sin_permiso");
        return;
    }

    PostulanteDAO postulanteDAO = new PostulanteDAO();
    List<Postulante> postulantes = postulanteDAO.listarTodos();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel Docente - Calificaciones | Colegio Andromeda</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen">

    <nav class="bg-indigo-900 text-white px-8 py-4 flex justify-between items-center shadow-lg">
        <div class="flex items-center space-x-3">
            <span class="text-2xl">👨‍🏫</span>
            <span class="font-bold text-xl tracking-wider">PANEL DOCENTE — CALIFICACIÓN DE CRITERIOS</span>
        </div>
        <div class="flex items-center space-x-6">
            <span class="text-sm text-indigo-200">Docente: <b><%= u.getUsername() %></b></span>
            <a href="${pageContext.request.contextPath}/index.jsp?estado=logout" class="bg-red-600 hover:bg-red-700 px-4 py-2 rounded text-sm font-bold transition">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container mx-auto px-6 py-8">

        <% if (session.getAttribute("msgExito") != null) { %>
            <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded mb-6">
                <%= session.getAttribute("msgExito") %>
            </div>
            <% session.removeAttribute("msgExito"); %>
        <% } %>

        <% if (session.getAttribute("msgError") != null) { %>
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded mb-6">
                <%= session.getAttribute("msgError") %>
            </div>
            <% session.removeAttribute("msgError"); %>
        <% } %>

        <div class="bg-white rounded-xl shadow-lg p-6">
            <h3 class="text-xl font-bold text-gray-800 mb-2">Evaluación por Criterios de Postulantes</h3>
            <p class="text-sm text-gray-500 mb-6">Ingresa las notas obtenidas en cada una de las 4 pruebas oficiales (Suma automática a 100 pts).</p>

            <div class="overflow-x-auto">
                <table class="w-full text-sm text-left border border-slate-200">
                    <thead class="text-xs uppercase bg-indigo-900 text-white">
                        <tr>
                            <th class="px-3 py-3">DNI</th>
                            <th class="px-3 py-3">Postulante</th>
                            <th class="px-3 py-3">Carrera</th>
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

                                <tr class="border-b hover:bg-slate-50">
                                    <td class="px-3 py-3 font-mono"><%= p.getNumDocumento() %></td>
                                    <td class="px-3 py-3 font-semibold"><%= p.getNombreAlumno() %></td>
                                    <td class="px-3 py-3 text-xs"><%= p.getNombreCarrera() %></td>
                                    <td class="px-2 py-3">
                                        <input type="number" step="0.01" min="0" max="60" name="notaCompetencias" value="0.00" class="w-20 px-2 py-1 border rounded text-center text-sm" required>
                                    </td>
                                    <td class="px-2 py-3">
                                        <input type="number" step="0.01" min="0" max="20" name="notaPsicotecnico" value="0.00" class="w-20 px-2 py-1 border rounded text-center text-sm" required>
                                    </td>
                                    <td class="px-2 py-3">
                                        <input type="number" step="0.01" min="0" max="10" name="notaRedaccion" value="0.00" class="w-20 px-2 py-1 border rounded text-center text-sm" required>
                                    </td>
                                    <td class="px-2 py-3">
                                        <input type="number" step="0.01" min="0" max="10" name="notaEntrevista" value="0.00" class="w-20 px-2 py-1 border rounded text-center text-sm" required>
                                    </td>
                                    <td class="px-3 py-3 text-center">
                                        <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white text-xs px-3 py-1.5 rounded font-bold transition">Guardar Nota</button>
                                    </td>
                                </tr>
                            </form>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="8" class="text-center py-6 text-gray-500">No hay postulantes pendientes de evaluación.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</body>
</html>