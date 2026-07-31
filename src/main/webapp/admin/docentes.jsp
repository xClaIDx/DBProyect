<%-- 
    Document   : docentes.jsp
    Created on : 31 jul 2026, 12:10:37 a.m.
    Author     : klaidneil
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestión de Personal Docente | Gran Unidad Escolar Andrómeda</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; }
    </style>
</head>
<body class="bg-slate-100 min-h-screen text-slate-800">

    <nav class="bg-slate-900 text-white px-8 py-4 flex justify-between items-center border-b-2 border-slate-700 shadow-md">
        <div class="flex items-center space-x-3">
            <span class="text-xs uppercase tracking-widest bg-slate-800 px-2.5 py-1 rounded border border-slate-700 text-slate-300 font-semibold">G.U.E. Andrómeda</span>
            <span class="font-bold text-lg tracking-wide uppercase text-slate-100">GESTIÓN DE PERSONAL DOCENTE</span>
        </div>
        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="text-xs bg-slate-800 hover:bg-slate-700 text-slate-200 border border-slate-600 px-3.5 py-2 rounded font-bold transition">
            Volver al Panel Principal
        </a>
    </nav>

    <div class="container mx-auto px-6 py-8">
        
        <c:if test="${not empty sessionScope.msgExitoAdmin}">
            <div class="bg-emerald-50 border-l-4 border-emerald-600 text-emerald-900 p-4 mb-6 rounded font-medium text-sm shadow-sm" role="alert">
                <p>${sessionScope.msgExitoAdmin}</p>
            </div>
            <c:remove var="msgExitoAdmin" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.msgErrorAdmin}">
            <div class="bg-red-50 border-l-4 border-red-600 text-red-900 p-4 mb-6 rounded font-medium text-sm shadow-sm" role="alert">
                <p>${sessionScope.msgErrorAdmin}</p>
            </div>
            <c:remove var="msgErrorAdmin" scope="session"/>
        </c:if>

        <div class="flex flex-col lg:flex-row gap-6">
            
            <div class="w-full lg:w-1/3 bg-white p-6 rounded-lg shadow-sm border border-slate-200 border-t-4 border-t-slate-900">
                <h3 class="text-base font-bold text-slate-900 uppercase tracking-wide border-b border-slate-200 pb-3 mb-5">
                    Registrar Nuevo Docente
                </h3>
                
                <form action="${pageContext.request.contextPath}/admin/docentes" method="POST" class="space-y-4">
                    <input type="hidden" name="accion" value="registrar">
                    
                    <div>
                        <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">
                            Documento de Identidad (DNI) (*)
                        </label>
                        <input type="text" name="numDocumento" required maxlength="8" class="w-full px-3 py-2 border border-slate-300 rounded font-mono text-sm focus:outline-none focus:ring-1 focus:ring-slate-900" placeholder="Ingrese 8 dígitos">
                        <span class="text-[10px] text-slate-500 mt-1 block">El DNI servirá como usuario y clave por defecto.</span>
                    </div>

                    <div>
                        <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Nombres (*)</label>
                        <input type="text" name="nombres" required class="w-full px-3 py-2 border border-slate-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-slate-900">
                    </div>

                    <div class="grid grid-cols-2 gap-3">
                        <div>
                            <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Ap. Paterno (*)</label>
                            <input type="text" name="apPaterno" required class="w-full px-3 py-2 border border-slate-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-slate-900">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Ap. Materno (*)</label>
                            <input type="text" name="apMaterno" required class="w-full px-3 py-2 border border-slate-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-slate-900">
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-semibold text-slate-700 uppercase mb-1">Especialidad Académica</label>
                        <input type="text" name="especialidad" class="w-full px-3 py-2 border border-slate-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-slate-900" placeholder="Ej. Matemáticas / Física">
                    </div>
                    
                    <button type="submit" class="w-full bg-slate-900 hover:bg-slate-800 text-white font-bold py-2.5 px-4 rounded text-xs uppercase tracking-wider transition">
                        Guardar Registro de Docente
                    </button>
                </form>
            </div>

            <div class="w-full lg:w-2/3 bg-white p-6 rounded-lg shadow-sm border border-slate-200">
                <div class="flex justify-between items-center border-b border-slate-200 pb-3 mb-5">
                    <h3 class="text-base font-bold text-slate-900 uppercase tracking-wide">
                        Directorio de Personal Calificador
                    </h3>
                    <span class="text-xs font-semibold bg-slate-100 text-slate-700 px-2.5 py-1 rounded border border-slate-200">
                        Registros Activos
                    </span>
                </div>
                
                <div class="overflow-x-auto">
                    <table class="w-full text-sm text-left border border-slate-200">
                        <thead class="bg-slate-900 text-white uppercase text-xs">
                            <tr>
                                <th class="px-4 py-3">DNI</th>
                                <th class="px-4 py-3">Apellidos y Nombres</th>
                                <th class="px-4 py-3">Especialidad</th>
                                <th class="px-4 py-3 text-center">Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="doc" items="${listaDocentes}">
                                <tr class="border-b border-slate-200 hover:bg-slate-50 text-xs">
                                    <td class="px-4 py-3 font-mono font-bold text-slate-900">${doc.numDocumento}</td>
                                    <td class="px-4 py-3 font-semibold text-slate-800">${doc.apPaterno} ${doc.apMaterno}, ${doc.nombres}</td>
                                    <td class="px-4 py-3 text-slate-600">${doc.especialidad}</td>
                                    <td class="px-4 py-3 text-center">
                                        <form action="${pageContext.request.contextPath}/admin/docentes" method="POST" onsubmit="return confirm('¿Seguro que deseas eliminar a este docente del sistema?');">
                                            <input type="hidden" name="accion" value="eliminar">
                                            <input type="hidden" name="idDocente" value="${doc.idDocente}">
                                            <button type="submit" class="bg-red-800 hover:bg-red-900 text-white px-3 py-1 rounded text-xs font-bold transition">
                                                Eliminar
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty listaDocentes}">
                                <tr>
                                    <td colspan="4" class="text-center py-6 text-slate-500 font-medium">No se encontraron docentes registrados en la base de datos.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</body>
</html>