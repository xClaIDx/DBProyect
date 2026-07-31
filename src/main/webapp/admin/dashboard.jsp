<%-- 
    Document   : dashboard
    Created on : 30 jul 2026, 6:49:09 p.m.
    Author     : klaidneil
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="finesi.app.andromeda.modelo.Usuario"%>
<%@ page import="finesi.app.andromeda.modelo.Postulante"%>
<%@ page import="finesi.app.andromeda.modelo.Periodo"%>
<%@ page import="finesi.app.andromeda.modelo.Docente"%>
<%@ page import="finesi.app.andromeda.dao.PostulanteDAO"%>
<%@ page import="finesi.app.andromeda.dao.MaestrosDAO"%>
<%@ page import="finesi.app.andromeda.dao.DocenteDAO"%>
<%@ page import="java.util.List"%>
<%
    // 1. Validación de Sesión para Rol Administrador
    Usuario u = (Usuario) session.getAttribute("usuarioLogueado");
    if (u == null || !"ADMIN".equalsIgnoreCase(u.getRol())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp?estado=sin_permiso");
        return;
    }

    // 2. Instanciación de DAOs
    PostulanteDAO postulanteDAO = new PostulanteDAO();
    MaestrosDAO maestrosDAO = new MaestrosDAO();
    DocenteDAO docenteDAO = new DocenteDAO();

    // 3. Captura del filtro de Período
    List<Periodo> listaPeriodos = maestrosDAO.listarPeriodos();
    String idPeriodoFiltroParam = request.getParameter("idPeriodo");
    int idPeriodoFiltro = 0;
    if (idPeriodoFiltroParam != null && !idPeriodoFiltroParam.trim().isEmpty()) {
        try {
            idPeriodoFiltro = Integer.parseInt(idPeriodoFiltroParam);
        } catch (NumberFormatException e) {
            idPeriodoFiltro = 0;
        }
    }

    // 4. Obtención de Postulantes (Filtrado o Todos)
    List<Postulante> postulantesBD;
    if (idPeriodoFiltro > 0) {
        postulantesBD = postulanteDAO.listarPorPeriodo(idPeriodoFiltro);
    } else {
        postulantesBD = postulanteDAO.listarTodos();
    }

    List<Docente> listaDocentes = docenteDAO.listarDocentes();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración | Gran Unidad Escolar Andrómeda</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        body { 
            font-family: 'Segoe UI', 'Helvetica Neue', Arial, sans-serif;
            background: #f0f2f5;
        }
        
        /* Estilo moderno para tarjetas */
        .card-modern {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: box-shadow 0.2s ease;
        }
        
        .card-modern:hover {
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
        }
        
        /* Botones con estilo más vibrante */
        .btn-primary {
            background: #003366;
            color: white;
            transition: background 0.2s ease;
        }
        
        .btn-primary:hover {
            background: #002244;
        }
        
        .btn-success {
            background: #006633;
            color: white;
            transition: background 0.2s ease;
        }
        
        .btn-success:hover {
            background: #004d26;
        }
        
        .btn-danger {
            background: #cc0000;
            color: white;
            transition: background 0.2s ease;
        }
        
        .btn-danger:hover {
            background: #990000;
        }
        
        .btn-warning {
            background: #cc6600;
            color: white;
            transition: background 0.2s ease;
        }
        
        .btn-warning:hover {
            background: #995200;
        }
        
        /* Barra de navegación estilo universidad */
        .navbar-university {
            background: #003366;
            border-bottom: 4px solid #cc9900;
        }
        
        /* Cabecera de tabla estilo universidad */
        .table-header {
            background: #003366;
            color: white;
        }
        
        /* Enlaces de navegación */
        .nav-link {
            color: #ffcc00;
            transition: color 0.2s ease;
        }
        
        .nav-link:hover {
            color: #ffdd33;
        }
        
        /* Badges y etiquetas */
        .badge-primary {
            background: #003366;
            color: white;
        }
        
        .badge-success {
            background: #006633;
            color: white;
        }
        
        /* Bordes decorativos */
        .border-accent {
            border-left: 4px solid #cc9900;
        }
        
        .border-accent-blue {
            border-left: 4px solid #003366;
        }
        
        .border-accent-green {
            border-left: 4px solid #006633;
        }
        
        .border-accent-orange {
            border-left: 4px solid #cc6600;
        }
        
        .border-accent-red {
            border-left: 4px solid #cc0000;
        }
    </style>
</head>
<body class="min-h-screen">

    <!-- NAVEGACIÓN PRINCIPAL - Estilo Universidad -->
    <nav class="navbar-university text-white px-8 py-4 flex flex-wrap justify-between items-center">
        <div class="flex items-center space-x-4">
            <div class="flex items-center space-x-2">
                <span class="text-xs uppercase tracking-widest bg-[#cc9900] text-[#003366] px-3 py-1.5 rounded font-bold">G.U.E. Andrómeda</span>
                <span class="font-bold text-lg tracking-wide uppercase text-white hidden md:inline">Panel de Admisión</span>
            </div>
        </div>
        <div class="flex items-center space-x-3 flex-wrap gap-2 mt-2 md:mt-0">
            <a href="${pageContext.request.contextPath}/admin/docentes" 
               class="bg-[#cc9900] hover:bg-[#b38800] text-[#003366] text-xs font-bold py-2 px-4 rounded transition">
                Gestionar Docentes
            </a>
            <a href="${pageContext.request.contextPath}/ranking.jsp" target="_blank" 
               class="bg-transparent border border-white hover:bg-white hover:text-[#003366] text-white px-4 py-2 rounded text-xs font-bold transition">
                Portal Rankings
            </a>
            <span class="text-xs text-[#99bbdd] hidden sm:inline">Usuario: <b class="text-white"><%= u.getUsername() %></b></span>
            <a href="${pageContext.request.contextPath}/index.jsp?estado=logout" 
               class="bg-[#cc0000] hover:bg-[#990000] text-white px-4 py-2 rounded text-xs font-bold transition">
                Cerrar Sesión
            </a>
        </div>
    </nav>

    <div class="container mx-auto px-6 py-8">

        <!-- MENSAJES DE SESIÓN -->
        <% if (session.getAttribute("msgExitoAdmin") != null) { %>
            <div class="bg-green-50 border-l-4 border-[#006633] text-[#004d26] p-4 rounded mb-6 font-medium text-sm shadow-sm">
                <%= session.getAttribute("msgExitoAdmin") %>
            </div>
            <% session.removeAttribute("msgExitoAdmin"); %>
        <% } %>

        <% if (session.getAttribute("msgErrorAdmin") != null) { %>
            <div class="bg-red-50 border-l-4 border-[#cc0000] text-[#990000] p-4 rounded mb-6 font-medium text-sm shadow-sm">
                <%= session.getAttribute("msgErrorAdmin") %>
            </div>
            <% session.removeAttribute("msgErrorAdmin"); %>
        <% } %>

        <!-- TARJETAS DE ACCIONES RÁPIDAS -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4 mb-8">
            <div class="card-modern p-5 border-accent">
                <h4 class="text-xs uppercase text-[#003366] font-bold tracking-wider">Gestión de Periodos</h4>
                <button onclick="toggleModal('modalNuevoPeriodo')" 
                        class="mt-3 w-full btn-primary px-3 py-2.5 rounded text-xs font-bold transition cursor-pointer">
                    Crear Periodo Examen
                </button>
            </div>

            <div class="card-modern p-5 border-accent-blue">
                <h4 class="text-xs uppercase text-[#003366] font-bold tracking-wider">Aulas y Supervisores</h4>
                <button onclick="toggleModal('modalAsignarAula')" 
                        class="mt-3 w-full btn-primary px-3 py-2.5 rounded text-xs font-bold transition cursor-pointer">
                    Asignar Aula / Supervisor
                </button>
            </div>

            <div class="card-modern p-5 border-accent-orange">
                <h4 class="text-xs uppercase text-[#cc6600] font-bold tracking-wider">Carreras y Áreas</h4>
                <button onclick="toggleModal('modalNuevaCarrera')" 
                        class="mt-3 w-full btn-warning px-3 py-2.5 rounded text-xs font-bold transition cursor-pointer">
                    Crear Carrera / Área
                </button>
            </div>

            <div class="card-modern p-5 border-accent-green">
                <h4 class="text-xs uppercase text-[#006633] font-bold tracking-wider">Reportes de Evaluación</h4>
                <a href="${pageContext.request.contextPath}/ranking.jsp" 
                   class="mt-3 block text-center btn-success px-3 py-2.5 rounded text-xs font-bold transition">
                    Exportar Rankings
                </a>
            </div>
        </div>

        <!-- TABLA DE ESTUDIANTES -->
        <div class="card-modern p-6 mb-8">
            <div class="flex flex-col lg:flex-row justify-between items-center mb-6 gap-4 border-b border-gray-200 pb-4">
                <div>
                    <h3 class="text-lg font-bold text-[#003366]">Directorio de Estudiantes Inscritos</h3>
                    <p class="text-xs text-gray-500 mt-0.5">Gestión de información académica y asignación de postulaciones</p>
                </div>

                <div class="flex flex-col sm:flex-row gap-3 w-full lg:w-auto">
                    <form action="${pageContext.request.contextPath}/admin/dashboard.jsp" method="GET" id="formFiltroPeriodo" class="flex items-center gap-2">
                        <label class="text-xs font-bold text-[#003366] uppercase">Simulacro:</label>
                        <select name="idPeriodo" onchange="document.getElementById('formFiltroPeriodo').submit()" 
                                class="px-3 py-2 border border-gray-300 rounded text-xs font-bold text-[#003366] bg-white focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                            <option value="0">Todos los Períodos</option>
                            <% for (Periodo per : listaPeriodos) { %>
                                <option value="<%= per.getIdPeriodo() %>" <%= (idPeriodoFiltro == per.getIdPeriodo()) ? "selected" : "" %>>
                                    <%= per.getNombrePeriodo() %> [<%= per.getEstado() %>]
                                </option>
                            <% } %>
                        </select>
                    </form>

                    <div class="w-full sm:w-64">
                        <input type="text" id="inputBuscar" onkeyup="filtrarTabla()" 
                               placeholder="Buscar por DNI o Apellidos..." 
                               class="w-full px-3.5 py-2 border border-gray-300 rounded text-xs focus:outline-none focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                </div>
            </div>

            <div class="overflow-x-auto">
                <table id="tablaAlumnos" class="w-full text-sm text-left border border-gray-200">
                    <thead class="text-xs uppercase table-header">
                        <tr>
                            <th class="px-4 py-3">ID Post.</th>
                            <th class="px-4 py-3">DNI</th>
                            <th class="px-4 py-3">Estudiante</th>
                            <th class="px-4 py-3">Período Académico</th>
                            <th class="px-4 py-3">Área</th>
                            <th class="px-4 py-3">Carrera Destino</th>
                            <th class="px-4 py-3 text-center">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (postulantesBD != null && !postulantesBD.isEmpty()) { 
                            for (Postulante p : postulantesBD) { %>
                            <tr class="border-b border-gray-200 hover:bg-blue-50 transition text-xs">
                                <td class="px-4 py-3 font-bold text-[#003366]"><%= p.getIdPostulante() %></td>
                                <td class="px-4 py-3 font-mono font-bold text-[#003366]"><%= p.getNumDocumento() %></td>
                                <td class="px-4 py-3 font-semibold text-gray-800"><%= p.getNombreAlumno() %></td>
                                <td class="px-4 py-3 font-bold text-[#003366]"><%= p.getNombrePeriodo() %></td>
                                <td class="px-4 py-3 text-gray-600"><%= p.getNombreArea() %></td>
                                <td class="px-4 py-3 text-gray-600"><%= p.getNombreCarrera() %></td>
                                <td class="px-4 py-3 text-center space-x-1 whitespace-nowrap">
                                    <button onclick="abrirModalEditar('<%= p.getIdAlumno() %>', '<%= p.getNumDocumento() %>', '<%= p.getNombreAlumno() %>')" 
                                            class="bg-[#003366] hover:bg-[#002244] text-white px-2.5 py-1.5 rounded font-bold transition text-xs">
                                        Editar
                                    </button>
                                    
                                    <form action="${pageContext.request.contextPath}/eliminarAlumno" method="POST" class="inline" onsubmit="return confirm('¿Seguro que desea eliminar esta postulación?');">
                                        <input type="hidden" name="idAlumno" value="<%= p.getIdAlumno() %>">
                                        <button type="submit" class="btn-danger px-2.5 py-1.5 rounded font-bold transition text-xs">
                                            Eliminar
                                        </button>
                                    </form>

                                    <a href="${pageContext.request.contextPath}/documento?tipo=constancia&dni=<%= p.getNumDocumento() %>" target="_blank" 
                                       class="bg-[#006633] hover:bg-[#004d26] text-white px-2.5 py-1.5 rounded font-bold transition text-xs">
                                        Constancia
                                    </a>
                                </td>
                            </tr>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="7" class="text-center py-6 text-gray-500 font-medium">No se encontraron estudiantes registrados para el período seleccionado.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </div>

    <!-- MODAL: NUEVO PERIODO -->
    <div id="modalNuevoPeriodo" class="fixed inset-0 bg-black/50 backdrop-blur-sm hidden items-center justify-center z-50 p-4">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-lg p-6 border-t-4 border-[#cc9900]">
            <div class="flex justify-between items-center mb-4 border-b border-gray-200 pb-3">
                <h3 class="text-base font-bold text-[#003366] uppercase tracking-wide">Aperturar Nuevo Periodo Académico</h3>
                <button onclick="toggleModal('modalNuevoPeriodo')" class="text-gray-400 hover:text-gray-700 text-xl font-bold">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/maestros" method="POST" class="space-y-4">
                <input type="hidden" name="accion" value="crearPeriodo">

                <div>
                    <label class="block text-xs font-semibold uppercase text-[#003366] mb-1">Nombre de la Convocatoria (*)</label>
                    <input type="text" name="nombrePeriodo" required 
                           class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent" 
                           placeholder="Ej: III Simulacro Oficial 2026">
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-semibold uppercase text-[#003366] mb-1">Año Lectivo (*)</label>
                        <input type="number" name="anio" value="2026" required 
                               class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold uppercase text-[#003366] mb-1">Número de Ciclo (*)</label>
                        <input type="number" name="ciclo" value="3" required 
                               class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-semibold uppercase text-[#003366] mb-1">Inicio Inscripción (*)</label>
                        <input type="date" name="fechaInicioStr" required 
                               class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                    <div>
                        <label class="block text-xs font-semibold uppercase text-[#003366] mb-1">Fecha del Examen (*)</label>
                        <input type="date" name="fechaExamenStr" required 
                               class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                </div>

                <div class="pt-4 border-t border-gray-200 flex justify-end space-x-2">
                    <button type="button" onclick="toggleModal('modalNuevoPeriodo')" 
                            class="px-4 py-2 border border-gray-300 rounded text-sm text-gray-700 hover:bg-gray-100 transition">
                        Cancelar
                    </button>
                    <button type="submit" class="px-4 py-2 btn-primary font-bold rounded text-sm">
                        Guardar Periodo
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL: EDITAR ALUMNO -->
    <div id="modalEditarAlumno" class="fixed inset-0 bg-black/50 backdrop-blur-sm hidden items-center justify-center z-50 p-4">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl p-6 border-t-4 border-[#003366] max-h-[90vh] overflow-y-auto">
            <div class="flex justify-between items-center mb-4 border-b border-gray-200 pb-3">
                <h3 class="text-base font-bold text-[#003366] uppercase tracking-wide">Edición de Ficha de Estudiante</h3>
                <button onclick="toggleModal('modalEditarAlumno')" class="text-gray-400 hover:text-gray-700 text-xl font-bold">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/editarAlumno" method="POST" class="space-y-4 text-xs">
                <input type="hidden" id="edit_idAlumno" name="idAlumno">
                <input type="hidden" id="edit_idPeriodo" name="idPeriodo" value="1">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <div>
                        <label class="block font-bold text-[#003366] uppercase mb-1">Documento de Identidad (DNI) (*)</label>
                        <input type="text" id="edit_numDocumento" name="numDocumento" required 
                               class="w-full px-3 py-2 border border-gray-300 rounded font-mono text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                    <div>
                        <label class="block font-bold text-[#003366] uppercase mb-1">Nombres (*)</label>
                        <input type="text" id="edit_nombres" name="nombres" required 
                               class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-3">
                    <div>
                        <label class="block font-bold text-[#003366] uppercase mb-1">Apellido Paterno (*)</label>
                        <input type="text" id="edit_apPaterno" name="apPaterno" required 
                               class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                    <div>
                        <label class="block font-bold text-[#003366] uppercase mb-1">Apellido Materno (*)</label>
                        <input type="text" id="edit_apMaterno" name="apMaterno" required 
                               class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
                    <div>
                        <label class="block font-bold text-[#003366] uppercase mb-1">Fecha Nacimiento</label>
                        <input type="date" id="edit_fechaNacimiento" name="fechaNacimiento" 
                               class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                    <div>
                        <label class="block font-bold text-[#003366] uppercase mb-1">Teléfono / Celular</label>
                        <input type="text" id="edit_celular" name="celular" 
                               class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                    <div>
                        <label class="block font-bold text-[#003366] uppercase mb-1">Correo Electrónico</label>
                        <input type="email" id="edit_correo" name="correo" 
                               class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-3 gap-3 pt-2 border-t border-gray-200">
                    <div>
                        <label class="block font-bold text-[#003366] uppercase mb-1">Grado Escolar</label>
                        <select id="edit_idGrado" name="idGrado" 
                                class="w-full px-3 py-2 border border-gray-300 rounded text-sm bg-white focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                            <option value="1">Primer Año</option>
                            <option value="2">Segundo Año</option>
                            <option value="3">Tercer Año</option>
                            <option value="4">Cuarto Año</option>
                            <option value="5">Quinto Año</option>
                        </select>
                    </div>
                    <div>
                        <label class="block font-bold text-[#003366] uppercase mb-1">Sección</label>
                        <select id="edit_idSeccion" name="idSeccion" 
                                class="w-full px-3 py-2 border border-gray-300 rounded text-sm bg-white focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                            <option value="1">Sección A</option>
                            <option value="2">Sección B</option>
                        </select>
                    </div>
                    <div>
                        <label class="block font-bold text-[#003366] uppercase mb-1">Carrera Destino (*)</label>
                        <select id="edit_idCarrera" name="idCarrera" 
                                class="w-full px-3 py-2 border border-gray-300 rounded text-sm bg-white font-bold text-[#003366] focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                            <option value="1">Medicina Humana</option>
                            <option value="2">Enfermería</option>
                            <option value="3">Ingeniería de Datos e Inteligencia Artificial</option>
                            <option value="4">Ingeniería de Sistemas</option>
                            <option value="5">Derecho</option>
                        </select>
                    </div>
                </div>

                <div class="pt-4 border-t border-gray-200 flex justify-end space-x-2">
                    <button type="button" onclick="toggleModal('modalEditarAlumno')" 
                            class="px-4 py-2 border border-gray-300 rounded text-sm text-gray-700 hover:bg-gray-100 transition">
                        Cancelar
                    </button>
                    <button type="submit" class="px-4 py-2 btn-primary font-bold rounded text-sm">
                        Guardar Cambios
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL: NUEVA CARRERA -->
    <div id="modalNuevaCarrera" class="fixed inset-0 bg-black/50 backdrop-blur-sm hidden items-center justify-center z-50 p-4">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-lg p-6 border-t-4 border-[#cc6600]">
            <div class="flex justify-between items-center mb-4 border-b border-gray-200 pb-3">
                <h3 class="text-base font-bold text-[#003366] uppercase tracking-wide">Registrar Nueva Carrera Profesional</h3>
                <button onclick="toggleModal('modalNuevaCarrera')" class="text-gray-400 hover:text-gray-700 text-xl font-bold">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/maestros" method="POST" class="space-y-4">
                <input type="hidden" name="accion" value="crearCarrera">

                <div>
                    <label class="block text-xs font-semibold uppercase text-[#003366] mb-1">Área Académica (*)</label>
                    <select name="idArea" 
                            class="w-full px-3 py-2 border border-gray-300 rounded text-sm bg-white focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                        <option value="1">Biomédicas</option>
                        <option value="2">Ingenierías</option>
                        <option value="3">Sociales</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold uppercase text-[#003366] mb-1">Nombre de la Carrera (*)</label>
                    <input type="text" name="nombreCarrera" required 
                           class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent" 
                           placeholder="Ej: Arquitectura y Urbanismo">
                </div>

                <div class="pt-4 border-t border-gray-200 flex justify-end space-x-2">
                    <button type="button" onclick="toggleModal('modalNuevaCarrera')" 
                            class="px-4 py-2 border border-gray-300 rounded text-sm text-gray-700 hover:bg-gray-100 transition">
                        Cancelar
                    </button>
                    <button type="submit" class="px-4 py-2 btn-warning font-bold rounded text-sm">
                        Guardar Carrera
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- MODAL: ASIGNAR AULA -->
    <div id="modalAsignarAula" class="fixed inset-0 bg-black/50 backdrop-blur-sm hidden items-center justify-center z-50 p-4">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-lg p-6 border-t-4 border-[#003366]">
            <div class="flex justify-between items-center mb-4 border-b border-gray-200 pb-3">
                <h3 class="text-base font-bold text-[#003366] uppercase tracking-wide">Asignación de Aula y Docente Supervisor</h3>
                <button onclick="toggleModal('modalAsignarAula')" class="text-gray-400 hover:text-gray-700 text-xl font-bold">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/asignarAula" method="POST" class="space-y-4">
                
                <div>
                    <label class="block text-xs font-semibold uppercase text-[#003366] mb-1">Seleccionar Convocatoria (*)</label>
                    <select name="idPeriodo" required 
                            class="w-full px-3 py-2 border border-gray-300 rounded text-sm bg-white font-bold text-[#003366] focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                        <% if (listaPeriodos != null && !listaPeriodos.isEmpty()) { 
                            for (Periodo per : listaPeriodos) { %>
                                <option value="<%= per.getIdPeriodo() %>">
                                    <%= per.getNombrePeriodo() %> [<%= per.getEstado() %>]
                                </option>
                        <%  } 
                        } else { %>
                            <option value="1">I Simulacro Oficial 2026</option>
                        <% } %>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold uppercase text-[#003366] mb-1">Docente Supervisor (*)</label>
                    <select name="idDocente" required 
                            class="w-full px-3 py-2 border border-gray-300 rounded text-sm bg-white font-semibold focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                        <% if (listaDocentes != null && !listaDocentes.isEmpty()) { 
                            for (Docente doc : listaDocentes) { %>
                                <option value="<%= doc.getIdDocente() %>">
                                    <%= doc.getApPaterno() %> <%= doc.getApMaterno() %>, <%= doc.getNombres() %> (DNI: <%= doc.getNumDocumento() %>)
                                </option>
                        <%  } 
                        } else { %>
                            <option value="1">No hay docentes registrados en BD</option>
                        <% } %>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold uppercase text-[#003366] mb-1">Pabellón / Bloque (*)</label>
                    <select name="pabellon" 
                            class="w-full px-3 py-2 border border-gray-300 rounded text-sm bg-white focus:ring-2 focus:ring-[#003366] focus:border-transparent">
                        <option value="Pabellón A - Biomédicas">Pabellón A - Biomédicas</option>
                        <option value="Pabellón B - Ingenierías">Pabellón B - Ingenierías</option>
                        <option value="Pabellón C - Sociales">Pabellón C - Sociales</option>
                    </select>
                </div>

                <div>
                    <label class="block text-xs font-semibold uppercase text-[#003366] mb-1">Número de Aula (*)</label>
                    <input type="text" name="aula" required 
                           class="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:ring-2 focus:ring-[#003366] focus:border-transparent" 
                           placeholder="Ej: Aula 102 - Piso 2">
                </div>

                <div class="pt-4 border-t border-gray-200 flex justify-end space-x-2">
                    <button type="button" onclick="toggleModal('modalAsignarAula')" 
                            class="px-4 py-2 border border-gray-300 rounded text-sm text-gray-700 hover:bg-gray-100 transition">
                        Cancelar
                    </button>
                    <button type="submit" class="px-4 py-2 btn-primary font-bold rounded text-sm">
                        Registrar Asignación
                    </button>
                </div>
            </form>
        </div>
    </div>

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