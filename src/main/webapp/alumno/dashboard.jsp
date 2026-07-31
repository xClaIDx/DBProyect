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
<%@ page import="finesi.app.andromeda.dao.AlumnoDAO"%>
<%@ page import="finesi.app.andromeda.dao.PostulanteDAO"%>
<%@ page import="finesi.app.andromeda.dao.ResultadoDAO"%>
<%
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null || !"ALUMNO".equalsIgnoreCase(u.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?estado=requiere_login");
        return;
    }

    AlumnoDAO alumnoDAO = new AlumnoDAO();
    PostulanteDAO postulanteDAO = new PostulanteDAO();
    ResultadoDAO resultadoDAO = new ResultadoDAO();

    Alumno alumno = alumnoDAO.obtenerPorDni(u.getUsername());
    Postulante postulacionActiva = null;
    ResultadoDetalle resultado = null;

    if (alumno != null) {
        postulacionActiva = postulanteDAO.obtenerPostulacion(alumno.getIdAlumno(), 1);
        resultado = resultadoDAO.obtenerResultadoPorDni(alumno.getNumDocumento());
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Portal del Estudiante | Colegio Andromeda</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen">

    <!-- Navegación -->
    <nav class="bg-indigo-950 text-white px-8 py-4 flex justify-between items-center shadow-lg">
        <div class="flex items-center space-x-3">
            <span class="text-2xl">🎓</span>
            <span class="font-bold text-xl tracking-wider">PORTAL DEL ESTUDIANTE</span>
        </div>
        <div class="flex items-center space-x-6">
            <a href="${pageContext.request.contextPath}/ranking.jsp" class="bg-indigo-800 hover:bg-indigo-700 text-white text-xs px-4 py-2 rounded-lg font-bold transition flex items-center space-x-1">
                <span>🏆 Rankings Generales</span>
            </a>
            <span class="text-sm text-indigo-200">DNI: <b><%= u.getUsername() %></b></span>
            <a href="${pageContext.request.contextPath}/index.jsp?estado=logout" class="bg-red-600 hover:bg-red-700 px-4 py-2 rounded text-sm font-bold transition text-xs">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container mx-auto px-6 py-8">

        <%-- Mensajes Informativos --%>
        <% if (session.getAttribute("msgExito") != null) { %>
            <div class="bg-emerald-100 border-l-4 border-emerald-500 text-emerald-800 p-4 rounded-lg mb-6 font-semibold text-sm">
                <%= session.getAttribute("msgExito") %>
            </div>
            <% session.removeAttribute("msgExito"); %>
        <% } %>

        <% if (session.getAttribute("msgError") != null) { %>
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-lg mb-6 font-semibold text-sm">
                <%= session.getAttribute("msgError") %>
            </div>
            <% session.removeAttribute("msgError"); %>
        <% } %>

        <!-- Datos del Alumno -->
        <div class="bg-white rounded-xl shadow-md p-6 mb-8 border-l-4 border-indigo-600">
            <h3 class="text-lg font-bold text-gray-800 mb-2">Información Institucional del Estudiante</h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm mt-4">
                <div><span class="text-gray-500 block">Nombres y Apellidos:</span> <b><%= (alumno != null) ? alumno.getNombreCompleto() : "N/A" %></b></div>
                <div><span class="text-gray-500 block">Correo Electrónico:</span> <b><%= (alumno != null) ? alumno.getCorreo() : "N/A" %></b></div>
                <div><span class="text-gray-500 block">Grado y Sección:</span> <b><%= (alumno != null) ? alumno.getNombreGrado() + " - " + alumno.getNombreSeccion() : "N/A" %></b></div>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8">
            
            <!-- Columna Principal: Simulacro Activo e Inscripción -->
            <div class="md:col-span-2 space-y-6">
                
                <div class="bg-white rounded-xl shadow-md p-6">
                    <h3 class="text-lg font-bold text-gray-800 mb-4">Simulacro de Admisión Vigente (2026-I)</h3>

                    <% if (postulacionActiva != null) { %>
                        <div class="bg-emerald-50 border border-emerald-200 text-emerald-900 p-5 rounded-xl">
                            <div class="flex justify-between items-start">
                                <div>
                                    <span class="bg-emerald-600 text-white text-xs px-2.5 py-1 rounded font-bold uppercase">Inscripción Confirmada</span>
                                    <h4 class="text-xl font-bold mt-2"><%= postulacionActiva.getNombreCarrera() %></h4>
                                    <p class="text-sm text-emerald-800 mt-1">Área: <b><%= postulacionActiva.getNombreArea() %></b> | Periodo: <b><%= postulacionActiva.getNombrePeriodo() %></b></p>
                                </div>
                            </div>

                            <div class="flex flex-wrap gap-3 mt-6 pt-4 border-t border-emerald-200">
                                <a href="${pageContext.request.contextPath}/documento?tipo=constancia&dni=<%= u.getUsername() %>" target="_blank" class="bg-indigo-950 hover:bg-indigo-900 text-white text-xs px-4 py-2.5 rounded-lg font-bold transition flex items-center space-x-1">
                                    <span>📄 Ver / Imprimir Constancia de Matrícula (QR)</span>
                                </a>
                                <a href="${pageContext.request.contextPath}/documento?tipo=boleta&dni=<%= u.getUsername() %>" target="_blank" class="bg-emerald-700 hover:bg-emerald-800 text-white text-xs px-4 py-2.5 rounded-lg font-bold transition flex items-center space-x-1">
                                    <span>📊 Ver Ficha de Notas</span>
                                </a>
                                <form action="${pageContext.request.contextPath}/alumno/cancelarInscripcion" method="POST" onsubmit="return confirm('¿Está seguro de cancelar su inscripción a este simulacro?');" class="inline">
                                    <input type="hidden" name="idPostulante" value="<%= postulacionActiva.getIdPostulante() %>">
                                    <button type="submit" class="bg-red-100 hover:bg-red-200 text-red-700 text-xs px-4 py-2.5 rounded-lg font-bold transition">
                                        ❌ Cancelar Inscripción
                                    </button>
                                </form>
                            </div>
                        </div>
                    <% } else { %>
                        <div class="bg-amber-50 border border-amber-200 text-amber-900 p-6 rounded-xl">
                            <h4 class="font-bold text-base mb-1">Periodo Disponible: II Simulacro de Admisión 2026</h4>
                            <p class="text-xs text-amber-800 mb-4">Selecciona tu carrera profesional de destino para inscribirte formalmente:</p>

                            <form action="${pageContext.request.contextPath}/alumno/inscribir" method="POST" class="space-y-4">
                                <input type="hidden" name="idAlumno" value="<%= (alumno != null) ? alumno.getIdAlumno() : 0 %>">
                                <input type="hidden" name="idPeriodo" value="1">

                                <div>
                                    <label class="block text-xs font-bold uppercase text-amber-900 mb-1">Carrera Profesional (*)</label>
                                    <select name="idCarrera" class="w-full px-3 py-2.5 border border-amber-300 rounded-lg text-sm bg-white font-medium" required>
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

                                <button type="submit" class="w-full bg-indigo-950 hover:bg-indigo-900 text-white font-bold py-3 rounded-lg text-sm shadow transition">
                                    🚀 Confirmar e Inscribirme al Simulacro
                                </button>
                            </form>
                        </div>
                    <% } %>
                </div>

            </div>

            <!-- Columna Lateral: Estado de Evaluación & Diploma Top 3 -->
            <div class="space-y-6">
                
                <div class="bg-white rounded-xl shadow-md p-6 border-t-4 border-amber-500">
                    <span class="text-3xl">🏆</span>
                    <h4 class="text-lg font-bold text-gray-800 mt-2">Distinción y Diploma Top 3</h4>
                    <p class="text-xs text-gray-500 mt-1">Habilitado exclusivamente para los 3 mejores puntajes del Cómputo General.</p>

                    <% if (resultado != null && resultado.getPosicionGeneral() != null && resultado.getPosicionGeneral() <= 3 && resultado.getPosicionGeneral() > 0) { %>
                        <div class="mt-4 p-4 bg-amber-50 border border-amber-300 rounded-xl text-center">
                            <span class="text-xs font-bold text-amber-800 uppercase block">¡Felicitaciones! Puesto N° <%= resultado.getPosicionGeneral() %></span>
                            <span class="text-xs text-amber-700 block mt-1">Puntaje Obtenido: <b><%= resultado.getPuntajeTotal() %> pts</b></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/diploma?dni=<%= u.getUsername() %>" target="_blank" class="mt-4 block text-center bg-amber-600 hover:bg-amber-700 text-white text-xs px-4 py-2.5 rounded-lg font-bold transition">
                            🎖️ Imprimir Diploma de Honor
                        </a>
                    <% } else { %>
                        <div class="mt-4 p-4 bg-slate-50 border border-slate-200 rounded-xl text-center text-xs text-gray-500">
                            Estado: Fuera del Top 3 o Evaluación Pendiente.
                        </div>
                    <% } %>
                </div>

                <div class="bg-white rounded-xl shadow-md p-6">
                    <h4 class="text-sm font-bold text-gray-800 mb-2">📊 Acceso a Cuadro de Méritos</h4>
                    <p class="text-xs text-gray-500 mb-4">Consulta las puntuaciones generales ordenadas por periodo y áreas académicas.</p>
                    <a href="${pageContext.request.contextPath}/ranking.jsp" class="block text-center bg-indigo-900 hover:bg-indigo-800 text-white text-xs px-4 py-2.5 rounded-lg font-bold transition">
                        Ver Ranking General
                    </a>
                </div>

            </div>

        </div>

    </div>

</body>
</html>