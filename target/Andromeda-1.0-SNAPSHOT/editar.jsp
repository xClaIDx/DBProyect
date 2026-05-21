<%-- 
    Document   : editar
    Created on : 20 may. 2026, 11:33:46 p. m.
    Author     : klaidneil
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Postulante | Andromeda</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-100 min-h-screen flex items-center justify-center p-6">

    <div class="bg-white rounded-xl shadow-xl w-full max-w-lg p-8 border-t-4 border-blue-600">
        <div class="mb-6">
            <h2 class="text-2xl font-bold text-gray-800">Editar Postulante</h2>
            <p class="text-gray-500 text-sm">Modifica los datos del alumno en el sistema.</p>
        </div>

        <form action="${pageContext.request.contextPath}/editarAlumno" method="POST" class="space-y-4">
            
            <input type="hidden" name="idAlumno" value="${alumnoEditar.idAlumno}">

            <div>
                <label class="block text-sm font-medium text-gray-700">DNI</label>
                <input type="text" name="numDocumento" value="${alumnoEditar.numDocumento}" required class="mt-1 w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
            </div>
            
            <div>
                <label class="block text-sm font-medium text-gray-700">Nombres</label>
                <input type="text" name="nombres" value="${alumnoEditar.nombres}" required class="mt-1 w-full px-4 py-2 border border-gray-300 rounded-md focus:ring-blue-500 focus:border-blue-500">
            </div>

            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-sm font-medium text-gray-700">Apellido Paterno</label>
                    <input type="text" name="apPaterno" value="${alumnoEditar.apPaterno}" required class="mt-1 w-full px-4 py-2 border border-gray-300 rounded-md">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700">Apellido Materno</label>
                    <input type="text" name="apMaterno" value="${alumnoEditar.apMaterno}" required class="mt-1 w-full px-4 py-2 border border-gray-300 rounded-md">
                </div>
            </div>

            <div class="mt-8 flex justify-end space-x-3 pt-4 border-t border-gray-200">
                <a href="${pageContext.request.contextPath}/alumnos" class="px-4 py-2 text-gray-700 bg-gray-200 hover:bg-gray-300 rounded-md font-medium transition">
                    Cancelar
                </a>
                <button type="submit" class="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white rounded-md font-medium transition shadow-md">
                    Guardar Cambios
                </button>
            </div>
        </form>
    </div>

</body>
</html>