<%-- 
    Document   : alumnos.jsp
    Author     : klaidneil
    Descripción: Panel de Administración del Sistema Andromeda.
                 Maneja el CRUD de Alumnos/Postulantes y la descarga de constancias.
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="finesi.app.andromeda.modelo.Alumno"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard | Simulacro UNAP</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-50 font-sans text-slate-800 antialiased overflow-x-hidden">

    <div class="flex h-screen w-full">

        <aside class="w-64 bg-slate-950 text-slate-300 flex flex-col justify-between shrink-0 shadow-2xl z-20">
            <div>
                <div class="h-20 flex items-center px-8 border-b border-slate-800 bg-slate-900/50">
                    <span class="text-xl font-bold tracking-widest text-white uppercase">Andromeda</span>
                </div>

                <nav class="p-4 space-y-1 mt-4">
                    <a href="#" class="flex items-center px-4 py-3 bg-indigo-600/10 text-indigo-400 rounded-lg font-medium border border-indigo-600/20 transition-colors">
                        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                        Postulantes
                    </a>
                    <a href="#" class="flex items-center px-4 py-3 text-slate-400 hover:bg-slate-900 hover:text-white rounded-lg font-medium transition-colors">
                        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"></path></svg>
                        Exámenes
                    </a>
                    <a href="#" class="flex items-center px-4 py-3 text-slate-400 hover:bg-slate-900 hover:text-white rounded-lg font-medium transition-colors">
                        <svg class="w-5 h-5 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                        Configuración
                    </a>
                </nav>
            </div>

            <div class="p-4 border-t border-slate-800 bg-slate-900/50">
                <div class="flex items-center justify-between">
                    <div class="flex items-center">
                        <div class="w-8 h-8 rounded-full bg-indigo-500 text-white flex items-center justify-center font-bold text-sm">
                            A
                        </div>
                        <div class="ml-3">
                            <p class="text-sm font-medium text-white">${not empty sessionScope.nombreAdmin ? sessionScope.nombreAdmin : 'Admin'}</p>
                            <p class="text-xs text-slate-500">Sesión activa</p>
                        </div>
                    </div>
                    <a href="${pageContext.request.contextPath}/logout" class="text-slate-400 hover:text-red-400 transition-colors" title="Cerrar Sesión">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                    </a>
                </div>
            </div>
        </aside>

        <main class="flex-1 h-full overflow-y-auto bg-slate-50/50">
            
            <div class="max-w-7xl mx-auto px-8 py-10">
                
                <header class="mb-10">
                    <h1 class="text-3xl font-bold text-slate-900 tracking-tight">Gestión de Postulantes</h1>
                    <p class="text-slate-500 mt-1">Administra las inscripciones para el simulacro de admisión UNAP.</p>
                </header>

                <c:if test="${param.error == 'true'}">
                    <div class="mb-8 p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded shadow-sm flex items-center">
                        <svg class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path></svg>
                        <p class="font-medium">No se pudo procesar la solicitud del alumno. Verifique los datos.</p>
                    </div>
                </c:if>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
                    <div class="bg-white p-6 rounded-xl border border-slate-200 shadow-sm relative overflow-hidden">
                        <h4 class="text-xs font-bold text-slate-500 uppercase tracking-wider">Total Inscritos</h4>
                        <div class="mt-2 flex items-baseline">
                            <p class="text-4xl font-extrabold text-slate-900">${not empty totalRegistrados ? totalRegistrados : '0'}</p>
                        </div>
                        <div class="absolute right-0 bottom-0 opacity-5 w-24 h-24 transform translate-x-4 translate-y-4">
                            <svg fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
                        </div>
                    </div>
                    <div class="bg-white p-6 rounded-xl border border-slate-200 shadow-sm">
                        <h4 class="text-xs font-bold text-slate-500 uppercase tracking-wider">Simulacros Activos</h4>
                        <div class="mt-2 flex items-baseline">
                            <p class="text-4xl font-extrabold text-slate-900">1</p>
                        </div>
                    </div>
                    <div class="bg-white p-6 rounded-xl border border-slate-200 shadow-sm">
                        <h4 class="text-xs font-bold text-slate-500 uppercase tracking-wider">Estado del Sistema</h4>
                        <div class="mt-4 flex items-center space-x-2">
                            <span class="relative flex h-3 w-3">
                                <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-emerald-400 opacity-75"></span>
                                <span class="relative inline-flex rounded-full h-3 w-3 bg-emerald-500"></span>
                            </span>
                            <span class="text-sm font-medium text-slate-700">Conectado a PostgreSQL</span>
                        </div>
                    </div>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-3 gap-8">
                    
                    <div class="bg-white rounded-xl shadow-sm border border-slate-200 h-fit overflow-hidden">
                        <div class="bg-slate-50 px-6 py-4 border-b border-slate-200">
                            <h3 class="text-sm font-bold text-slate-800 uppercase tracking-wider">Nuevo Registro</h3>
                        </div>
                        
                        <div class="p-6">
                            <form action="alumnos" method="POST" class="space-y-4">
                                <div>
                                    <label class="block text-xs font-semibold text-slate-600 mb-1">DNI</label>
                                    <input type="text" name="numDocumento" required maxlength="8" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm">
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-slate-600 mb-1">Nombres</label>
                                    <input type="text" name="nombres" required class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm">
                                </div>
                                <div class="grid grid-cols-2 gap-3">
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-600 mb-1">Ap. Paterno</label>
                                        <input type="text" name="apPaterno" required class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm">
                                    </div>
                                    <div>
                                        <label class="block text-xs font-semibold text-slate-600 mb-1">Ap. Materno</label>
                                        <input type="text" name="apMaterno" required class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm">
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-slate-600 mb-1">Fecha Nacimiento</label>
                                    <input type="date" name="fechaNacimiento" required class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm text-slate-700">
                                </div>
                                <div>
                                    <label class="block text-xs font-semibold text-slate-600 mb-1">Grado Escolar</label>
                                    <select name="idGrado" class="w-full px-3 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 outline-none transition-all text-sm text-slate-700 bg-white">
                                        <option value="2">5to de Secundaria</option>
                                        <option value="1">1ro de Secundaria</option>
                                    </select>
                                </div>
                                
                                <input type="hidden" name="celular" value="">
                                <input type="hidden" name="correo" value="">

                                <button type="submit" class="w-full mt-6 bg-slate-900 hover:bg-slate-800 text-white px-4 py-2.5 rounded-lg font-medium text-sm transition-colors shadow-sm">
                                    Registrar Alumno
                                </button>
                            </form>
                        </div>
                    </div>

                    <div class="lg:col-span-2 bg-white rounded-xl shadow-sm border border-slate-200 overflow-hidden">
                        <div class="px-6 py-4 border-b border-slate-200 bg-slate-50 flex justify-between items-center">
                            <h2 class="text-sm font-bold text-slate-800 uppercase tracking-wider">Directorio de Inscritos</h2>
                        </div>
                        
                        <div class="overflow-x-auto">
                            <table class="w-full text-left border-collapse">
                                <thead>
                                    <tr class="bg-white border-b border-slate-200 text-slate-500 text-xs uppercase tracking-wider">
                                        <th class="px-6 py-4 font-semibold">Documento</th>
                                        <th class="px-6 py-4 font-semibold">Apellidos y Nombres</th>
                                        <th class="px-6 py-4 font-semibold">Estado</th>
                                        <th class="px-6 py-4 font-semibold text-right">Acciones</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-100 text-sm">
                                    <c:choose>
                                        <c:when test="${not empty listaAlumnos}">
                                            <c:forEach var="alumno" items="${listaAlumnos}">
                                                <tr class="hover:bg-slate-50/50 transition-colors group">
                                                    <td class="px-6 py-4 font-mono font-medium text-slate-700">${alumno.numDocumento}</td>
                                                    <td class="px-6 py-4">
                                                        <span class="font-medium text-slate-900">${alumno.apPaterno} ${alumno.apMaterno}</span>, 
                                                        <span class="text-slate-600">${alumno.nombres}</span>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-50 text-emerald-700 border border-emerald-200">
                                                            Registrado
                                                        </span>
                                                    </td>
                                                    <td class="px-6 py-4">
                                                        <div class="flex justify-end space-x-2">
                                                            <a href="${pageContext.request.contextPath}/certificado?id=${alumno.idAlumno}" 
                                                               class="text-amber-600 hover:text-amber-900 bg-amber-50 hover:bg-amber-100 p-2 rounded-md transition-colors" title="Descargar Constancia">
                                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/editarAlumno?id=${alumno.idAlumno}" 
                                                               class="text-indigo-600 hover:text-indigo-900 bg-indigo-50 hover:bg-indigo-100 p-2 rounded-md transition-colors" title="Editar">
                                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z"></path></svg>
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/eliminarAlumno?id=${alumno.idAlumno}" 
                                                               onclick="return confirm('¿Está seguro de que desea eliminar permanentemente este registro?');"
                                                               class="text-red-600 hover:text-red-900 bg-red-50 hover:bg-red-100 p-2 rounded-md transition-colors" title="Eliminar">
                                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-4v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <tr>
                                                <td colspan="4" class="px-6 py-10 text-center text-slate-400">
                                                    No se encontraron postulantes registrados actualmente en el sistema.
                                                </td>
                                            </tr>
                                        </c:otherwise>
                                    </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>

                </div>

            </div>
        </main>

    </div>
</body>
</html>