<%-- 
    Document   : alumnos
    Created on : 18 may. 2026, 8:57:47 p. m.
    Author     : klaidneil
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="finesi.app.andromeda.modelo.Alumno"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Dashboard | Simulacro UNAP</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-50 font-sans text-slate-800">

    <nav class="bg-blue-900 text-white shadow-lg">
        <div class="max-w-7xl mx-auto px-4 py-4 flex justify-between items-center">
            <h1 class="text-2xl font-bold tracking-wider">Andromeda <span class="font-light">Simulacros </span></h1>
            <span class="text-sm bg-blue-800 px-3 py-1 rounded-full">Administrador: neils  </span>
        </div>
    </nav>

    <main class="max-w-7xl mx-auto px-4 py-8">
        
        <% if ("true".equals(request.getParameter("error"))) { %>
        <div class="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded-lg">
            <p>Error: No se pudo registrar al alumno. Verifique los datos o la conexion.</p>
        </div>
        <% } %>

        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            
            <div class="bg-white rounded-xl shadow-md p-6 h-fit border border-gray-200">
                <h3 class="text-lg font-bold text-gray-800 mb-4 border-b pb-2">Registrar Postulante</h3>
                
                <form action="alumnos" method="POST" class="space-y-3">
                    <div>
                        <label class="block text-xs font-medium text-gray-700">DNI</label>
                        <input type="text" name="numDocumento" required maxlength="8" class="w-full px-3 py-2 border rounded-md">
                    </div>
                    <div>
                        <label class="block text-xs font-medium text-gray-700">Nombres</label>
                        <input type="text" name="nombres" required class="w-full px-3 py-2 border rounded-md">
                    </div>
                    <div class="grid grid-cols-2 gap-2">
                        <div>
                            <label class="block text-xs font-medium text-gray-700">Ap. Paterno</label>
                            <input type="text" name="apPaterno" required class="w-full px-3 py-2 border rounded-md">
                        </div>
                        <div>
                            <label class="block text-xs font-medium text-gray-700">Ap. Materno</label>
                            <input type="text" name="apMaterno" required class="w-full px-3 py-2 border rounded-md">
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-medium text-gray-700">Fecha Nacimiento</label>
                        <input type="date" name="fechaNacimiento" required class="w-full px-3 py-2 border rounded-md">
                    </div>
                    <div>
                        <label class="block text-xs font-medium text-gray-700">Grado Escolar</label>
                        <select name="idGrado" class="w-full px-3 py-2 border rounded-md">
                            <option value="2">5to de Secundaria</option>
                            <option value="1">1ro de Secundaria</option>
                        </select>
                    </div>
                    
                    <input type="hidden" name="celular" value="">
                    <input type="hidden" name="correo" value="">

                    <button type="submit" class="w-full mt-4 bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium">
                        Guardar Alumno
                    </button>
                </form>
            </div>

            <div class="md:col-span-2 bg-white rounded-xl shadow-md overflow-hidden border border-gray-200">
                <div class="px-6 py-4 border-b border-gray-200">
                    <h2 class="text-xl font-semibold text-gray-800">Alumnos Inscritos</h2>
                </div>
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-slate-100 text-slate-600 text-sm uppercase">
                                <th class="px-6 py-3 font-medium">DNI</th>
                                <th class="px-6 py-3 font-medium">Apellidos y Nombres</th>
                                <th class="px-6 py-3 font-medium">Estado</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-200 text-sm">
                            <% 
                                // Leemos la variable "listaAlumnos" que inyecto el Servlet
                                List<Alumno> lista = (List<Alumno>) request.getAttribute("listaAlumnos");
                                
                                if (lista != null && !lista.isEmpty()) {
                                    // Bucle for tradicional en Java para dibujar las filas HTML
                                    for (Alumno alumno : lista) {
                            %>
                            <tr class="hover:bg-slate-50">
                                <td class="px-6 py-4 font-medium text-gray-900"><%= alumno.getNumDocumento() %></td>
                                <td class="px-6 py-4 text-gray-700">
                                    <%= alumno.getApPaterno() %> <%= alumno.getApMaterno() %>, <%= alumno.getNombres() %>
                                </td>
                                <td class="px-6 py-4"><span class="bg-green-100 text-green-800 px-2 py-1 rounded-full text-xs">Registrado</span></td>
                            </tr>
                            <% 
                                    } 
                                } else {
                            %>
                            <tr>
                                <td colspan="3" class="px-6 py-4 text-center text-gray-500">No hay alumnos registrados.</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </main>
</body>
</html>