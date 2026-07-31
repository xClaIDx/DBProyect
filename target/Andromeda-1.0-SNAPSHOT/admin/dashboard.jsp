<%-- 
    Document   : dashboard
    Created on : 30 jul 2026, 6:49:09 p.m.
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
    if (u == null || !"ADMIN".equalsIgnoreCase(u.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?estado=sin_permiso");
        return;
    }

    PostulanteDAO postulanteDAO = new PostulanteDAO();
    List<Postulante> postulantesBD = postulanteDAO.listarTodos();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración | Colegio Andromeda</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-100 text-slate-800 min-h-screen">

    <!-- Navegación Admin -->
    <nav class="bg-indigo-950 text-white px-8 py-4 flex justify-between items-center shadow-lg">
        <div class="flex items-center space-x-3">
            <span class="text-2xl">🛡️</span>
            <span class="font-bold text-xl tracking-wider">PANEL ADMINISTRATIVO DE ADMISIÓN</span>
        </div>
        <div class="flex items-center space-x-4">
            <a href="${pageContext.request.contextPath}/ranking.jsp" target="_blank" class="bg-amber-600 hover:bg-amber-700 text-white px-3.5 py-2 rounded-lg text-xs font-bold transition flex items-center space-x-1">
                <span>🏆 Portal de Rankings</span>
            </a>
            <span class="text-xs text-indigo-200">Admin: <b><%= u.getUsername() %></b></span>
            <a href="${pageContext.request.contextPath}/index.jsp?estado=logout" class="bg-red-600 hover:bg-red-700 px-3.5 py-2 rounded-lg text-xs font-bold transition">Cerrar Sesión</a>
        </div>
    </nav>

    <div class="container mx-auto px-6 py-8">

        <%-- Mensajes Informativos --%>
        <% if (session.getAttribute("msgExitoAdmin") != null) { %>
            <div class="bg-emerald-100 border-l-4 border-emerald-500 text-emerald-800 p-4 rounded-lg mb-6 font-semibold text-sm">
                <%= session.getAttribute("msgExitoAdmin") %>
            </div>
            <% session.removeAttribute("msgExitoAdmin"); %>
        <% } %>

        <% if (session.getAttribute("msgErrorAdmin") != null) { %>
            <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded-lg mb-6 font-semibold text-sm">
                <%= session.getAttribute("msgErrorAdmin") %>
            </div>
            <% session.removeAttribute("msgErrorAdmin"); %>
        <% } %>

        <!-- Acciones Rápidas -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-8">
            <div class="bg-white p-5 rounded-xl shadow-md border-l-4 border-indigo-600">
                <h4 class="text-xs uppercase text-gray-500 font-bold">Gestión de Periodos</h4>
                <button onclick="toggleModal('modalNuevoPeriodo')" class="mt-2 w-full bg-indigo-950 hover:bg-indigo-900 text-white px-3 py-2 rounded-lg text-xs font-bold transition cursor-pointer">
                    + Crear Periodo Examen
                </button>
            </div>

            <div class="bg-white p-5 rounded-xl shadow-md border-l-4 border-blue-600">
                <h4 class="text-xs uppercase text-gray-500 font-bold">Aulas y Supervisores</h4>
                <button onclick="toggleModal('modalAsignarAula')" class="mt-2 w-full bg-blue-700 hover:bg-blue-800 text-white px-3 py-2 rounded-lg text-xs font-bold transition cursor-pointer">
                    + Asignar Aula / Supervisor
                </button>
            </div>

            <div class="bg-white p-5 rounded-xl shadow-md border-l-4 border-amber-600">
                <h4 class="text-xs uppercase text-gray-500 font-bold">Carreras y Áreas</h4>
                <button onclick="toggleModal('modalNuevaCarrera')" class="mt-2 w-full bg-amber-600 hover:bg-amber-700 text-white px-3 py-2 rounded-lg text-xs font-bold transition cursor-pointer">
                    + Crear Carrera / Área
                </button>
            </div>

            <div class="bg-white p-5 rounded-xl shadow-md border-l-4 border-emerald-600">
                <h4 class="text-xs uppercase text-gray-500 font-bold">Reportes</h4>
                <a href="${pageContext.request.contextPath}/exportar/excel" class="mt-2 block text-center bg-emerald-600 hover:bg-emerald-700 text-white px-3 py-2 rounded-lg text-xs font-bold transition">
                    📊 Exportar Rankings CSV
                </a>
            </div>
        </div>

        <!-- Tabla con Buscador Dinámico de Alumnos -->
        <div class="bg-white rounded-xl shadow-lg p-6 mb-8">
            <div class="flex flex-col md:flex-row justify-between items-center mb-6 gap-4">
                <div>
                    <h3 class="text-xl font-bold text-gray-800">Alumnos Inscritos Registrados en BD</h3>
                    <p class="text-xs text-gray-500 mt-0.5">Gestión de información personal, postulaciones y eliminación</p>
                </div>
                <!-- Filtro de Búsqueda -->
                <div class="w-full md:w-80">
                    <input type="text" id="inputBuscar" onkeyup="filtrarTabla()" placeholder="🔍 Buscar por DNI o Nombre..." class="w-full px-3.5 py-2 border border-slate-300 rounded-lg text-xs focus:outline-none focus:ring-2 focus:ring-indigo-900">
                </div>
            </div>

            <div class="overflow-x-auto">
                <table id="tablaAlumnos" class="w-full text-sm text-left border border-slate-200">
                    <thead class="text-xs uppercase bg-indigo-950 text-white">
                        <tr>
                            <th class="px-4 py-3">ID Post.</th>
                            <th class="px-4 py-3">DNI</th>
                            <th class="px-4 py-3">Postulante</th>
                            <th class="px-4 py-3">Área</th>
                            <th class="px-4 py-3">Carrera Destino</th>
                            <th class="px-4 py-3 text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (postulantesBD != null && !postulantesBD.isEmpty()) { 
                            for (Postulante p : postulantesBD) { %>
                            <tr class="border-b hover:bg-slate-50 text-xs">
                                <td class="px-4 py-3 font-bold"><%= p.getIdPostulante() %></td>
                                <td class="px-4 py-3 font-mono font-bold text-indigo-950"><%= p.getNumDocumento() %></td>
                                <td class="px-4 py-3 font-semibold text-gray-800"><%= p.getNombreAlumno() %></td>
                                <td class="px-4 py-3"><%= p.getNombreArea() %></td>
                                <td class="px-4 py-3"><%= p.getNombreCarrera() %></td>
                                <td class="px-4 py-3 text-center space-x-1.5">
                                    <button onclick="abrirModalEditar('<%= p.getIdAlumno() %>', '<%= p.getNumDocumento() %>', '<%= p.getNombreAlumno() %>')" class="bg-amber-500 hover:bg-amber-600 text-white px-2.5 py-1 rounded font-bold transition text-xs">✏️ Editar</button>
                                    
                                    <form action="${pageContext.request.contextPath}/eliminarAlumno" method="POST" class="inline" onsubmit="return confirm('¿Seguro de eliminar este estudiante permanentemente?');">
                                        <input type="hidden" name="idAlumno" value="<%= p.getIdAlumno() %>">
                                        <button type="submit" class="bg-red-600 hover:bg-red-700 text-white px-2.5 py-1 rounded font-bold transition text-xs">🗑️ Eliminar</button>
                                    </form>

                                    <a href="${pageContext.request.contextPath}/documento?tipo=constancia&dni=<%= p.getNumDocumento() %>" target="_blank" class="bg-blue-600 hover:bg-blue-700 text-white px-2.5 py-1 rounded font-bold transition text-xs">📄 Constancia</a>
                                </td>
                            </tr>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="6" class="text-center py-6 text-gray-500">No hay postulantes registrados en la base de datos.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <!-- MODAL CREAR NUEVO PERIODO -->
    <div id="modalNuevoPeriodo" class="fixed inset-0 bg-black/60 backdrop-blur-sm hidden items-center justify-center z-50 p-4">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg p-6 border-t-4 border-indigo-950">
            <div class="flex justify-between items-center mb-4 border-b pb-3">
                <h3 class="text-lg font-bold text-indigo-950">Crear Nuevo Periodo / Examen</h3>
                <button onclick="toggleModal('modalNuevoPeriodo')" class="text-gray-400 hover:text-red-500 text-2xl font-light">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/maestros" method="POST" class="space-y-4">
                <input type="hidden" name="accion" value="crearPeriodo">

                <div>
                    <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Nombre del Periodo / Simulacro (*)</label>
                    <input type="text" name="nombrePeriodo" required class="w-full px-3 py-2 border rounded-lg text-sm" placeholder="Ej: III Simulacro de Admisión 2026">
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Año (*)</label>
                        <input type="number" name="anio" value="2026" required class="w-full px-3 py-2 border rounded-lg text-sm">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Número de Ciclo (*)</label>
                        <input type="number" name="ciclo" value="2" required class="w-full px-3 py-2 border rounded-lg text-sm">
                    </div>
                </div>

                <div class="pt-4 border-t flex justify-end space-x-2">
                    <button type="button" onclick="toggleModal('modalNuevoPeriodo')" class="px-4 py-2 border rounded-lg text-sm text-gray-600 hover:bg-gray-100">Cancelar</button>
                    <button type="submit" class="px-4 py-2 bg-indigo-950 hover:bg-indigo-900 text-white font-bold rounded-lg text-sm">Guardar Periodo</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL EDITAR ALUMNO COMPLETO -->
    <div id="modalEditarAlumno" class="fixed inset-0 bg-black/60 backdrop-blur-sm hidden items-center justify-center z-50 p-4">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-2xl p-6 border-t-4 border-amber-500 max-h-[90vh] overflow-y-auto">
            <div class="flex justify-between items-center mb-4 border-b pb-3">
                <h3 class="text-lg font-bold text-gray-800">Edición Integral de Ficha del Alumno</h3>
                <button onclick="toggleModal('modalEditarAlumno')" class="text-gray-400 hover:text-red-500 text-2xl font-light">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/editarAlumno" method="POST" class="space-y-4 text-xs">
                <input type="hidden" id="edit_idAlumno" name="idAlumno">
                <input type="hidden" id="edit_idPeriodo" name="idPeriodo" value="1">

                <!-- 1. Identificación Personal -->
                <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <div>
                        <label class="block font-bold text-gray-700 uppercase mb-1">DNI / Documento (*)</label>
                        <input type="text" id="edit_numDocumento" name="numDocumento" required class="w-full px-3 py-2 border rounded-lg font-mono text-sm">
                    </div>
                    <div>
                        <label class="block font-bold text-gray-700 uppercase mb-1">Nombres (*)</label>
                        <input type="text" id="edit_nombres" name="nombres" required class="w-full px-3 py-2 border rounded-lg text-sm">
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <div>
                        <label class="block font-bold text-gray-700 uppercase mb-1">Apellido Paterno (*)</label>
                        <input type="text" id="edit_apPaterno" name="apPaterno" required class="w-full px-3 py-2 border rounded-lg text-sm">
                    </div>
                    <div>
                        <label class="block font-bold text-gray-700 uppercase mb-1">Apellido Materno (*)</label>
                        <input type="text" id="edit_apMaterno" name="apMaterno" required class="w-full px-3 py-2 border rounded-lg text-sm">
                    </div>
                </div>

                <!-- 2. Contacto y Nacimiento -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
                    <div>
                        <label class="block font-bold text-gray-700 uppercase mb-1">Fecha Nacimiento</label>
                        <input type="date" id="edit_fechaNacimiento" name="fechaNacimiento" class="w-full px-3 py-2 border rounded-lg text-sm">
                    </div>
                    <div>
                        <label class="block font-bold text-gray-700 uppercase mb-1">Celular</label>
                        <input type="text" id="edit_celular" name="celular" class="w-full px-3 py-2 border rounded-lg text-sm">
                    </div>
                    <div>
                        <label class="block font-bold text-gray-700 uppercase mb-1">Correo Electrónico</label>
                        <input type="email" id="edit_correo" name="correo" class="w-full px-3 py-2 border rounded-lg text-sm">
                    </div>
                </div>

                <!-- 3. Asignación Académica y Postulación -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-3 pt-2 border-t">
                    <div>
                        <label class="block font-bold text-gray-700 uppercase mb-1">Grado Escolar</label>
                        <select id="edit_idGrado" name="idGrado" class="w-full px-3 py-2 border rounded-lg text-sm bg-white">
                            <option value="1">Primer Año</option>
                            <option value="2">Segundo Año</option>
                            <option value="3">Tercer Año</option>
                            <option value="4">Cuarto Año</option>
                            <option value="5">Quinto Año</option>
                        </select>
                    </div>
                    <div>
                        <label class="block font-bold text-gray-700 uppercase mb-1">Sección</label>
                        <select id="edit_idSeccion" name="idSeccion" class="w-full px-3 py-2 border rounded-lg text-sm bg-white">
                            <option value="1">Sección A</option>
                            <option value="2">Sección B</option>
                        </select>
                    </div>
                    <div>
                        <label class="block font-bold text-gray-700 uppercase mb-1">Carrera Destino (*)</label>
                        <select id="edit_idCarrera" name="idCarrera" class="w-full px-3 py-2 border rounded-lg text-sm bg-white font-bold text-indigo-950">
                            <option value="1">Medicina Humana</option>
                            <option value="2">Enfermería</option>
                            <option value="3">Ingeniería de Datos e Inteligencia Artificial</option>
                            <option value="4">Ingeniería de Sistemas</option>
                            <option value="5">Derecho</option>
                        </select>
                    </div>
                </div>

                <div class="pt-4 border-t flex justify-end space-x-2">
                    <button type="button" onclick="toggleModal('modalEditarAlumno')" class="px-4 py-2 border rounded-lg text-sm text-gray-600 hover:bg-gray-100">Cancelar</button>
                    <button type="submit" class="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white font-bold rounded-lg text-sm">Guardar Ficha Completa</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL CREAR CARRERA -->
    <div id="modalNuevaCarrera" class="fixed inset-0 bg-black/60 backdrop-blur-sm hidden items-center justify-center z-50 p-4">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg p-6 border-t-4 border-amber-600">
            <div class="flex justify-between items-center mb-4 border-b pb-3">
                <h3 class="text-lg font-bold text-gray-800">Agregar Nueva Carrera Profesional</h3>
                <button onclick="toggleModal('modalNuevaCarrera')" class="text-gray-400 hover:text-red-500 text-2xl font-light">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/maestros" method="POST" class="space-y-4">
                <input type="hidden" name="accion" value="crearCarrera">

                <div>
                    <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Área Académica (*)</label>
                    <select name="idArea" class="w-full px-3 py-2 border rounded-lg text-sm bg-white">
                        <option value="1">Biomédicas</option>
                        <option value="2">Ingenierías</option>
                        <option value="3">Sociales</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Nombre de la Carrera (*)</label>
                    <input type="text" name="nombreCarrera" required class="w-full px-3 py-2 border rounded-lg text-sm" placeholder="Ej: Arquitectura y Urbanismo">
                </div>

                <div class="pt-4 border-t flex justify-end space-x-2">
                    <button type="button" onclick="toggleModal('modalNuevaCarrera')" class="px-4 py-2 border rounded-lg text-sm text-gray-600 hover:bg-gray-100">Cancelar</button>
                    <button type="submit" class="px-4 py-2 bg-amber-600 hover:bg-amber-700 text-white font-bold rounded-lg text-sm">Guardar Carrera</button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL ASIGNAR AULA -->
    <div id="modalAsignarAula" class="fixed inset-0 bg-black/60 backdrop-blur-sm hidden items-center justify-center z-50 p-4">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg p-6 border-t-4 border-blue-700">
            <div class="flex justify-between items-center mb-4 border-b pb-3">
                <h3 class="text-lg font-bold text-indigo-950">Asignación de Aula a Docente Supervisor</h3>
                <button onclick="toggleModal('modalAsignarAula')" class="text-gray-400 hover:text-red-500 text-2xl font-light">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/asignarAula" method="POST" class="space-y-4">
                <input type="hidden" name="idPeriodo" value="1">

                <div>
                    <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">ID Docente Supervisor (*)</label>
                    <input type="number" name="idDocente" value="1" required class="w-full px-3 py-2 border rounded-lg text-sm" placeholder="Ingrese ID del Docente">
                </div>

                <div>
                    <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Pabellón / Bloque (*)</label>
                    <select name="pabellon" class="w-full px-3 py-2 border rounded-lg text-sm bg-white">
                        <option value="Pabellón A - Biomédicas">Pabellón A - Biomédicas</option>
                        <option value="Pabellón B - Ingenierías">Pabellón B - Ingenierías</option>
                        <option value="Pabellón C - Sociales">Pabellón C - Sociales</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold uppercase text-gray-600 mb-1">Número de Aula (*)</label>
                    <input type="text" name="aula" required class="w-full px-3 py-2 border rounded-lg text-sm" placeholder="Ej: Aula 102 - Piso 2">
                </div>

                <div class="pt-4 border-t flex justify-end space-x-2">
                    <button type="button" onclick="toggleModal('modalAsignarAula')" class="px-4 py-2 border rounded-lg text-sm text-gray-600 hover:bg-gray-100">Cancelar</button>
                    <button type="submit" class="px-4 py-2 bg-blue-700 hover:bg-blue-800 text-white font-bold rounded-lg text-sm">Registrar Asignación</button>
                </div>
            </form>
        </div>
    </div>

    <!-- JS de Interactividad Modal y Filtro de Búsqueda -->
    <script>
        function toggleModal(modalID) {
            const modal = document.getElementById(modalID);
            if (modal.classList.contains('hidden')) {
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            } else {
                modal.classList.add('hidden');
                modal.classList.remove('flex');
            }
        }

        function abrirModalEditar(id, dni, nombreCompleto) {
            document.getElementById('edit_idAlumno').value = id;
            document.getElementById('edit_numDocumento').value = dni;
            
            // Separar nombres por espacios de cortesía
            const partes = nombreCompleto.split(' ');
            document.getElementById('edit_nombres').value = partes[0] || '';
            document.getElementById('edit_apPaterno').value = partes[1] || '';
            document.getElementById('edit_apMaterno').value = partes[2] || '';
            
            toggleModal('modalEditarAlumno');
        }

        function filtrarTabla() {
            const input = document.getElementById('inputBuscar');
            const filter = input.value.toLowerCase();
            const table = document.getElementById('tablaAlumnos');
            const tr = table.getElementsByTagName('tr');

            for (let i = 1; i < tr.length; i++) {
                const tdDni = tr[i].getElementsByTagName('td')[1];
                const tdNombre = tr[i].getElementsByTagName('td')[2];
                if (tdDni || tdNombre) {
                    const txtDni = tdDni.textContent || tdDni.innerText;
                    const txtNombre = tdNombre.textContent || tdNombre.innerText;
                    if (txtDni.toLowerCase().indexOf(filter) > -1 || txtNombre.toLowerCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
</body>
</html>