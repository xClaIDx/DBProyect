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
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; }
    </style>
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen">

    <nav class="bg-slate-900 text-white px-8 py-4 flex justify-between items-center border-b-2 border-slate-700 shadow-md">
        <div class="flex items-center space-x-3">
            <span class="text-xs uppercase tracking-widest bg-slate-800 px-2.5 py-1 rounded border border-slate-700 text-slate-300 font-semibold">G.U.E. Andrómeda</span>
            <span class="font-bold text-lg tracking-wide uppercase text-slate-100">PORTAL DEL ESTUDIANTE</span>
        </div>
        <div class="flex items-center space-x-4">
            <a href="${pageContext.request.contextPath}/ranking.jsp" class="bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-600 text-xs font-bold py-2 px-3.5 rounded transition">
                Rankings Generales
            </a>
            <span class="text-xs text-slate-400">DNI: <b class="text-slate-200"><%= u.getUsername() %></b></span>
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

        <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-6 mb-8 border-l-4 border-l-slate-900">
            <h3 class="text-base font-bold text-slate-900 uppercase tracking-wide border-b border-slate-200 pb-2 mb-4">
                Información Institucional del Estudiante
            </h3>
            <div class="grid grid-cols-1 md:grid-cols-3 gap-4 text-sm">
                <div><span class="text-xs font-semibold text-slate-500 uppercase block">Nombres y Apellidos:</span> <b class="text-slate-800"><%= (alumno != null) ? alumno.getNombreCompleto() : "N/A" %></b></div>
                <div><span class="text-xs font-semibold text-slate-500 uppercase block">Correo Electrónico:</span> <b class="text-slate-800"><%= (alumno != null) ? alumno.getCorreo() : "N/A" %></b></div>
                <div><span class="text-xs font-semibold text-slate-500 uppercase block">Grado y Sección Escolar:</span> <b class="text-slate-800"><%= (alumno != null) ? alumno.getNombreGrado() + " - " + alumno.getNombreSeccion() : "N/A" %></b></div>
            </div>
        </div>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-8">
            
            <div class="md:col-span-2 space-y-6">
                
                <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-6">
                    <% if (periodoVigente != null) { %>
                        <div class="flex items-center justify-between border-b border-slate-200 pb-3 mb-4">
                            <h3 class="text-base font-bold text-slate-900 uppercase tracking-wide">
                                Convocatoria Vigente: <%= periodoVigente.getNombrePeriodo() %>
                            </h3>
                            <span class="bg-emerald-50 text-emerald-800 border border-emerald-300 text-xs font-bold px-2.5 py-1 rounded">PROCESO ACTIVO</span>
                        </div>
                        
                        <% if (postulacionActiva != null) { %>
                            <div class="bg-slate-50 border border-slate-300 text-slate-900 p-5 rounded-lg">
                                <div class="flex justify-between items-start">
                                    <div>
                                        <span class="bg-slate-800 text-white text-[10px] px-2.5 py-1 rounded font-bold uppercase tracking-wider">Inscripción Confirmada</span>
                                        <h4 class="text-lg font-bold text-slate-900 mt-2"><%= postulacionActiva.getNombreCarrera() %></h4>
                                        <p class="text-xs text-slate-600 mt-1">Área Académica: <b><%= postulacionActiva.getNombreArea() %></b></p>
                                    </div>
                                </div>

                                <div class="flex flex-wrap gap-2 mt-6 pt-4 border-t border-slate-200">
                                    <a href="${pageContext.request.contextPath}/documento?tipo=constancia&dni=<%= u.getUsername() %>" target="_blank" class="bg-slate-900 hover:bg-slate-800 text-white text-xs px-4 py-2 rounded font-bold transition">
                                        Ver Constancia Oficial (QR)
                                    </a>
                                    <a href="${pageContext.request.contextPath}/documento?tipo=boleta&dni=<%= u.getUsername() %>" target="_blank" class="bg-slate-800 hover:bg-slate-700 text-white text-xs px-4 py-2 rounded font-bold transition">
                                        Ver Ficha de Calificaciones
                                    </a>
                                    <form action="${pageContext.request.contextPath}/alumno/cancelarInscripcion" method="POST" onsubmit="return confirm('¿Está seguro de cancelar su inscripción a este simulacro?');" class="inline">
                                        <input type="hidden" name="idPostulante" value="<%= postulacionActiva.getIdPostulante() %>">
                                        <button type="submit" class="bg-red-800 hover:bg-red-900 text-white text-xs px-4 py-2 rounded font-bold transition">
                                            Cancelar Inscripción
                                        </button>
                                    </form>
                                </div>
                            </div>
                        <% } else { %>
                            <div class="bg-slate-50 border border-slate-200 text-slate-900 p-6 rounded-lg">
                                <p class="text-xs text-slate-600 uppercase font-semibold mb-4">Seleccione la carrera profesional de destino para formalizar su inscripción:</p>

                                <form action="${pageContext.request.contextPath}/alumno/inscribir" method="POST" class="space-y-4">
                                    <input type="hidden" name="idAlumno" value="<%= (alumno != null) ? alumno.getIdAlumno() : 0 %>">
                                    <input type="hidden" name="idPeriodo" value="<%= periodoVigente.getIdPeriodo() %>">

                                    <div>
                                        <label class="block text-xs font-bold uppercase text-slate-700 mb-1">Carrera Profesional (*)</label>
                                        <select name="idCarrera" class="w-full px-3 py-2.5 border border-slate-300 rounded text-sm bg-white font-medium focus:ring-1 focus:ring-slate-900" required>
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

                                    <button type="submit" class="w-full bg-slate-900 hover:bg-slate-800 text-white font-bold py-2.5 rounded text-xs uppercase tracking-wider transition">
                                        Confirmar Inscripción al Simulacro
                                    </button>
                                </form>
                            </div>
                        <% } %>
                    <% } else { %>
                        <div class="text-center py-8">
                            <h3 class="text-base font-bold text-slate-800 uppercase tracking-wide">No Hay Convocatorias Activas</h3>
                            <p class="text-xs text-slate-500 mt-2">La administración institucional habilitará próximamente el siguiente período de evaluación.</p>
                        </div>
                    <% } %>
                </div>

            </div>

            <div class="space-y-6">
                
                <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-6 border-t-4 border-t-amber-800">
                    <h4 class="text-base font-bold text-slate-900 uppercase tracking-wide">Reconocimiento Académico Top 3</h4>
                    <p class="text-xs text-slate-500 mt-1">Habilitado exclusivamente para los 3 mejores puntajes del Cómputo General.</p>

                    <% if (resultado != null && resultado.getPosicionGeneral() != null && resultado.getPosicionGeneral() <= 3 && resultado.getPosicionGeneral() > 0) { %>
                        <div class="mt-4 p-4 bg-amber-50 border border-amber-300 rounded text-center">
                            <span class="text-xs font-bold text-amber-900 uppercase block">Distinción Obtenida: Puesto N° <%= resultado.getPosicionGeneral() %></span>
                            <span class="text-xs text-amber-800 block mt-1">Puntaje Total: <b><%= resultado.getPuntajeTotal() %> pts</b></span>
                        </div>
                        <a href="${pageContext.request.contextPath}/diploma?dni=<%= u.getUsername() %>" target="_blank" class="mt-4 block text-center bg-amber-800 hover:bg-amber-900 text-white text-xs px-4 py-2.5 rounded font-bold transition">
                            Descargar Diploma de Honor
                        </a>
                    <% } else { %>
                        <div class="mt-4 p-4 bg-slate-50 border border-slate-200 rounded text-center text-xs text-slate-500">
                            Estado: Fuera de la ubicación Top 3 o Evaluación Pendiente.
                        </div>
                    <% } %>
                </div>

                <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-6">
                    <h4 class="text-base font-bold text-slate-900 uppercase tracking-wide mb-1">Cuadro General de Méritos</h4>
                    <p class="text-xs text-slate-500 mb-4">Consulte los rankings ordenados por período lectivo y áreas académicas.</p>
                    <a href="${pageContext.request.contextPath}/ranking.jsp" class="block text-center bg-slate-900 hover:bg-slate-800 text-white text-xs px-4 py-2.5 rounded font-bold transition">
                        Consultar Ranking General
                    </a>
                </div>

            </div>

        </div>

        <div class="bg-white rounded-lg shadow-sm border border-slate-200 p-6">
            <h3 class="text-base font-bold text-slate-900 uppercase tracking-wide border-b border-slate-200 pb-2 mb-2">
                Historial Institucional de Simulacros y Postulaciones
            </h3>
            <p class="text-xs text-slate-500 mb-4">Registro cronológico de convocatorias en las que ha participado el estudiante en la institución.</p>

            <div class="overflow-x-auto">
                <table class="w-full text-sm text-left border border-slate-200">
                    <thead class="text-xs uppercase bg-slate-900 text-white">
                        <tr>
                            <th class="px-4 py-3">Período / Convocatoria</th>
                            <th class="px-4 py-3">Área Académica</th>
                            <th class="px-4 py-3">Carrera Destino</th>
                            <th class="px-4 py-3">Fecha de Inscripción</th>
                            <th class="px-4 py-3 text-center">Documentos / Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (historialPostulaciones != null && !historialPostulaciones.isEmpty()) { 
                            for (Postulante hp : historialPostulaciones) { %>
                            <tr class="border-b border-slate-200 hover:bg-slate-50 text-xs">
                                <td class="px-4 py-3 font-bold text-slate-900"><%= hp.getNombrePeriodo() %></td>
                                <td class="px-4 py-3 text-slate-600"><%= hp.getNombreArea() %></td>
                                <td class="px-4 py-3 font-semibold text-slate-800"><%= hp.getNombreCarrera() %></td>
                                <td class="px-4 py-3 text-slate-500"><%= hp.getFechaInscripcion() != null ? hp.getFechaInscripcion() : "---" %></td>
                                <td class="px-4 py-3 text-center space-x-1">
                                    <a href="${pageContext.request.contextPath}/documento?tipo=constancia&dni=<%= u.getUsername() %>" target="_blank" class="bg-slate-800 hover:bg-slate-900 text-white px-2.5 py-1 rounded text-xs font-bold transition inline-block">
                                        Constancia QR
                                    </a>
                                    <a href="${pageContext.request.contextPath}/ranking.jsp?idPeriodo=<%= hp.getIdPeriodo() %>" class="bg-slate-200 hover:bg-slate-300 text-slate-800 px-2.5 py-1 rounded text-xs font-bold transition inline-block border border-slate-300">
                                        Ranking Período
                                    </a>
                                </td>
                            </tr>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="5" class="text-center py-6 text-slate-500 font-medium">No se encontraron registros de postulaciones en períodos anteriores.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

</body>
</html>