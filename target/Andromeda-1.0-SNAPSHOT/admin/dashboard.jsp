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
    <title>Panel de Administración | G.U.E. Andrómeda</title>
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Source+Serif+4:wght@500;600&family=Inter:wght@400;500;600&display=swap');

        :root {
            /* Base Colegio Nacional */
            --navy: #15304F;        
            --navy-soft: #1E4269;   
            --bg: #F3F1EB;          
            --panel: #FFFFFF;       
            --ink: #212A26;         
            --ink-soft: #64716A;    
            --line: #E4E0D4;        

            /* Acentos semánticos - Versión viva */
            --green: #178F55;       
            --green-light: #DEF5E8;
            --gold: #E0A72E;        
            --gold-light: #FCF0D6;
            --red: #E14F3D;         
            --red-light: #FDE1DC;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            background-color: var(--bg);
            color: var(--ink);
            min-height: 100vh;
        }

        /* Utilidades JS */
        .hidden { display: none !important; }
        .flex { display: flex !important; }

        /* Navegación */
        .navbar {
            background-color: var(--navy);
            color: #E9E7DD;
            padding: 16px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 16px;
        }

        .brand-container {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        /* Contenedor del Logo SVG */
        .crest {
            height: 100px;            /* <- Alto de 100px */
            width: auto;
            display: flex;
            align-items: center;
            justify-content: center;
            background: transparent;  /* <- Mimetizado sin recuadro blanco */
        }

        .crest img {
            height: 100%;
            width: auto;
            object-fit: contain;
            filter: drop-shadow(0px 2px 4px rgba(0, 0, 0, 0.3)); /* Sombra elegante */
        }

        .crest-title {
            font-family: 'Source Serif 4', serif;
            font-size: 20px;
            font-weight: 600;
            color: var(--panel);
        }
        
        .crest-subtitle {
            font-size: 11px;
            color: var(--line);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .nav-links {
            display: flex;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
        }

        .user-info {
            font-size: 13px;
            color: var(--line);
        }
        .user-info b {
            color: var(--panel);
            font-weight: 500;
        }

        /* Layout principal */
        main {
            padding: 32px 40px 48px;
            max-width: 1120px;
            margin: 0 auto;
        }

        /* Tarjetas */
        .panel {
            background: var(--panel);
            border: 1px solid var(--line);
            border-radius: 4px;
            padding: 24px;
            margin-bottom: 24px;
        }

        .panel-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 1px solid var(--line);
            padding-bottom: 16px;
            margin-bottom: 20px;
            gap: 16px;
            flex-wrap: wrap;
        }

        .title-with-crest {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        h1, h2, h3 {
            font-family: 'Source Serif 4', serif;
            font-weight: 600;
            margin: 0;
            color: var(--navy);
        }

        h2 { font-size: 22px; }
        
        .panel-desc {
            font-size: 13px;
            color: var(--ink-soft);
            margin-top: 4px;
        }

        /* Botones */
        .btn {
            display: inline-block;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            font-weight: 500;
            padding: 8px 16px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            border: 1px solid transparent;
            transition: background 0.2s;
        }
        
        .btn-sm { padding: 4px 10px; font-size: 12px; }

        .btn-navy { background: var(--navy); color: var(--panel); }
        .btn-navy:hover { background: var(--navy-soft); }
        
        .btn-gold { background: var(--gold); color: var(--panel); }
        .btn-gold:hover { background: #C28E22; }
        
        .btn-green { background: var(--green); color: var(--panel); }
        .btn-green:hover { background: #127243; }
        
        .btn-red { background: var(--red); color: var(--panel); }
        .btn-red:hover { background: #C53D2C; }

        .btn-outline { background: transparent; border-color: var(--line); color: var(--ink); }
        .btn-outline:hover { background: var(--bg); }
        
        .btn-nav-outline { background: transparent; border-color: var(--line); color: var(--panel); }
        .btn-nav-outline:hover { background: var(--navy-soft); border-color: var(--panel); }

        /* Tarjetas de Acción Rápida (Estilo KPI) */
        .actions-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
            margin-bottom: 28px;
        }

        .action-card {
            background: var(--panel);
            border: 1px solid var(--line);
            border-radius: 4px;
            padding: 20px;
            border-left: 3px solid var(--navy);
        }
        
        .action-card.green { border-left-color: var(--green); }
        .action-card.gold { border-left-color: var(--gold); }

        .action-label {
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 11px;
            color: var(--ink-soft);
            font-weight: 500;
            margin-bottom: 12px;
            display: block;
        }

        /* Tabla */
        .table-responsive {
            overflow-x: auto;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            text-align: left;
        }

        th {
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 11px;
            color: var(--ink-soft);
            border-bottom: 1px solid var(--line);
            padding: 12px 16px;
            font-weight: 500;
        }

        td {
            padding: 14px 16px;
            border-bottom: 1px solid var(--line);
            font-size: 13px;
            color: var(--ink);
        }

        tr:hover td {
            background-color: var(--bg);
        }
        
        .td-bold { font-weight: 500; color: var(--navy); }

        /* Formularios y Filtros */
        .filter-group {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .form-label {
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 11px;
            color: var(--ink-soft);
            display: block;
            margin-bottom: 6px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid var(--line);
            border-radius: 4px;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            color: var(--ink);
            background: var(--panel);
            box-sizing: border-box;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--navy);
        }

        /* Badges de alerta */
        .alert {
            padding: 12px 16px;
            border-radius: 4px;
            margin-bottom: 24px;
            font-size: 13px;
            font-weight: 500;
            border-left: 3px solid;
        }
        
        .alert-success { background: var(--green-light); color: var(--green); border-left-color: var(--green); }
        .alert-danger { background: var(--red-light); color: var(--red); border-left-color: var(--red); }

        /* Modales */
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(21, 48, 79, 0.6);
            align-items: center;
            justify-content: center;
            z-index: 1000;
            padding: 20px;
        }

        .modal-content {
            background: var(--panel);
            border-radius: 4px;
            width: 100%;
            max-width: 600px;
            max-height: 90vh;
            overflow-y: auto;
            padding: 32px;
            border-top: 4px solid var(--navy);
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
        }

        .modal-content.border-gold { border-top-color: var(--gold); }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--line);
            padding-bottom: 16px;
            margin-bottom: 24px;
        }

        .close-btn {
            background: none;
            border: none;
            font-size: 24px;
            color: var(--ink-soft);
            cursor: pointer;
        }
        
        .close-btn:hover { color: var(--ink); }

        .form-grid-2 { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px; }
        .form-grid-3 { display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 16px; margin-bottom: 16px; }
        .form-row { margin-bottom: 16px; }
        
        .modal-footer {
            border-top: 1px solid var(--line);
            padding-top: 16px;
            margin-top: 24px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        @media (max-width: 900px) {
            .form-grid-2, .form-grid-3 { grid-template-columns: 1fr; }
            .panel-header { flex-direction: column; }
        }
    </style>
</head>
<body>

    <nav class="navbar">
        <div class="brand-container">
            <div class="crest">
                <img src="${pageContext.request.contextPath}/assets/images/logo.svg" alt="Escudo G.U.E. Andrómeda">
            </div>
            <div>
                <div class="crest-title">G.U.E. Andrómeda</div>
                <div class="crest-subtitle">Panel de Admisión</div>
            </div>
        </div>
        <div class="nav-links">
            <a href="${pageContext.request.contextPath}/admin/docentes" class="btn btn-gold">
                Gestionar Docentes
            </a>
            <a href="${pageContext.request.contextPath}/ranking.jsp" target="_blank" class="btn btn-nav-outline">
                Portal Rankings
            </a>
            <span class="user-info">Usuario: <b><%= u.getUsername() %></b></span>
            <a href="${pageContext.request.contextPath}/index.jsp?estado=logout" class="btn btn-red">
                Cerrar Sesión
            </a>
        </div>
    </nav>

    <main>
        <% if (session.getAttribute("msgExitoAdmin") != null) { %>
            <div class="alert alert-success">
                <%= session.getAttribute("msgExitoAdmin") %>
            </div>
            <% session.removeAttribute("msgExitoAdmin"); %>
        <% } %>

        <% if (session.getAttribute("msgErrorAdmin") != null) { %>
            <div class="alert alert-danger">
                <%= session.getAttribute("msgErrorAdmin") %>
            </div>
            <% session.removeAttribute("msgErrorAdmin"); %>
        <% } %>

        <div class="actions-grid">
            <div class="action-card">
                <span class="action-label">Gestión de Periodos</span>
                <button onclick="toggleModal('modalNuevoPeriodo')" class="btn btn-navy" style="width: 100%;">
                    Crear Periodo Examen
                </button>
            </div>

            <div class="action-card">
                <span class="action-label">Aulas y Supervisores</span>
                <button onclick="toggleModal('modalAsignarAula')" class="btn btn-navy" style="width: 100%;">
                    Asignar Aula / Supervisor
                </button>
            </div>

            <div class="action-card gold">
                <span class="action-label">Carreras y Áreas</span>
                <button onclick="toggleModal('modalNuevaCarrera')" class="btn btn-gold" style="width: 100%;">
                    Crear Carrera / Área
                </button>
            </div>

            <div class="action-card green">
                <span class="action-label">Reportes de Evaluación</span>
                <a href="${pageContext.request.contextPath}/ranking.jsp" class="btn btn-green" style="width: 100%; display: block; box-sizing: border-box;">
                    Exportar Rankings
                </a>
            </div>
        </div>

        <div class="panel">
            <div class="panel-header">
                <div class="title-with-crest">
                    <div class="crest" style="width: 34px; height: 34px;">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Escudo G.U.E. Andrómeda">
                    </div>
                    <div>
                        <h2>Directorio de Estudiantes Inscritos</h2>
                        <div class="panel-desc">Gestión de información académica y asignación de postulaciones</div>
                    </div>
                </div>

                <div class="filter-group">
                    <form action="${pageContext.request.contextPath}/admin/dashboard.jsp" method="GET" id="formFiltroPeriodo" style="display: flex; align-items: center; gap: 8px;">
                        <label class="form-label" style="margin: 0;">Simulacro:</label>
                        <select name="idPeriodo" onchange="document.getElementById('formFiltroPeriodo').submit()" class="form-control" style="width: auto;">
                            <option value="0">Todos los Períodos</option>
                            <% for (Periodo per : listaPeriodos) { %>
                                <option value="<%= per.getIdPeriodo() %>" <%= (idPeriodoFiltro == per.getIdPeriodo()) ? "selected" : "" %>>
                                    <%= per.getNombrePeriodo() %> [<%= per.getEstado() %>]
                                </option>
                            <% } %>
                        </select>
                    </form>

                    <input type="text" id="inputBuscar" onkeyup="filtrarTabla()" placeholder="Buscar por DNI o Apellidos..." class="form-control" style="width: 260px;">
                </div>
            </div>

            <div class="table-responsive">
                <table id="tablaAlumnos">
                    <thead>
                        <tr>
                            <th>ID Post.</th>
                            <th>DNI</th>
                            <th>Estudiante</th>
                            <th>Período Académico</th>
                            <th>Área</th>
                            <th>Carrera Destino</th>
                            <th style="text-align: right;">Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (postulantesBD != null && !postulantesBD.isEmpty()) { 
                            for (Postulante p : postulantesBD) { %>
                            <tr>
                                <td class="td-bold"><%= p.getIdPostulante() %></td>
                                <td class="td-bold"><%= p.getNumDocumento() %></td>
                                <td><%= p.getNombreAlumno() %></td>
                                <td class="td-bold"><%= p.getNombrePeriodo() %></td>
                                <td style="color: var(--ink-soft);"><%= p.getNombreArea() %></td>
                                <td style="color: var(--ink-soft);"><%= p.getNombreCarrera() %></td>
                                <td style="text-align: right; white-space: nowrap;">
                                    <button onclick="abrirModalEditar('<%= p.getIdAlumno() %>', '<%= p.getNumDocumento() %>', '<%= p.getNombreAlumno() %>')" class="btn btn-sm btn-navy">
                                        Editar
                                    </button>
                                    
                                    <form action="${pageContext.request.contextPath}/eliminarAlumno" method="POST" style="display: inline;" onsubmit="return confirm('¿Seguro que desea eliminar esta postulación?');">
                                        <input type="hidden" name="idAlumno" value="<%= p.getIdAlumno() %>">
                                        <button type="submit" class="btn btn-sm btn-red">Eliminar</button>
                                    </form>

                                    <a href="${pageContext.request.contextPath}/documento?tipo=constancia&dni=<%= p.getNumDocumento() %>" target="_blank" class="btn btn-sm btn-green">
                                        Constancia
                                    </a>
                                </td>
                            </tr>
                        <%  } 
                        } else { %>
                            <tr>
                                <td colspan="7" style="text-align: center; color: var(--ink-soft); padding: 32px;">No se encontraron estudiantes registrados para el período seleccionado.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <div id="modalNuevoPeriodo" class="modal-overlay hidden">
        <div class="modal-content border-gold">
            <div class="modal-header">
                <h3 class="modal-title" style="font-family: 'Source Serif 4', serif; color: var(--navy); margin:0;">Aperturar Nuevo Periodo Académico</h3>
                <button onclick="toggleModal('modalNuevoPeriodo')" class="close-btn">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/maestros" method="POST">
                <input type="hidden" name="accion" value="crearPeriodo">

                <div class="form-row">
                    <label class="form-label">Nombre de la Convocatoria (*)</label>
                    <input type="text" name="nombrePeriodo" required class="form-control" placeholder="Ej: III Simulacro Oficial 2026">
                </div>

                <div class="form-grid-2">
                    <div>
                        <label class="form-label">Año Lectivo (*)</label>
                        <input type="number" name="anio" value="2026" required class="form-control">
                    </div>
                    <div>
                        <label class="form-label">Número de Ciclo (*)</label>
                        <input type="number" name="ciclo" value="3" required class="form-control">
                    </div>
                </div>

                <div class="form-grid-2">
                    <div>
                        <label class="form-label">Inicio Inscripción (*)</label>
                        <input type="date" name="fechaInicioStr" required class="form-control">
                    </div>
                    <div>
                        <label class="form-label">Fecha del Examen (*)</label>
                        <input type="date" name="fechaExamenStr" required class="form-control">
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" onclick="toggleModal('modalNuevoPeriodo')" class="btn btn-outline">Cancelar</button>
                    <button type="submit" class="btn btn-navy">Guardar Periodo</button>
                </div>
            </form>
        </div>
    </div>

    <div id="modalEditarAlumno" class="modal-overlay hidden">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" style="font-family: 'Source Serif 4', serif; color: var(--navy); margin:0;">Edición de Ficha de Estudiante</h3>
                <button onclick="toggleModal('modalEditarAlumno')" class="close-btn">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/editarAlumno" method="POST">
                <input type="hidden" id="edit_idAlumno" name="idAlumno">
                <input type="hidden" id="edit_idPeriodo" name="idPeriodo" value="1">

                <div class="form-grid-2">
                    <div>
                        <label class="form-label">Documento de Identidad (DNI) (*)</label>
                        <input type="text" id="edit_numDocumento" name="numDocumento" required class="form-control" style="font-family: monospace;">
                    </div>
                    <div>
                        <label class="form-label">Nombres (*)</label>
                        <input type="text" id="edit_nombres" name="nombres" required class="form-control">
                    </div>
                </div>

                <div class="form-grid-2">
                    <div>
                        <label class="form-label">Apellido Paterno (*)</label>
                        <input type="text" id="edit_apPaterno" name="apPaterno" required class="form-control">
                    </div>
                    <div>
                        <label class="form-label">Apellido Materno (*)</label>
                        <input type="text" id="edit_apMaterno" name="apMaterno" required class="form-control">
                    </div>
                </div>

                <div class="form-grid-3">
                    <div>
                        <label class="form-label">Fecha Nacimiento</label>
                        <input type="date" id="edit_fechaNacimiento" name="fechaNacimiento" class="form-control">
                    </div>
                    <div>
                        <label class="form-label">Teléfono / Celular</label>
                        <input type="text" id="edit_celular" name="celular" class="form-control">
                    </div>
                    <div>
                        <label class="form-label">Correo Electrónico</label>
                        <input type="email" id="edit_correo" name="correo" class="form-control">
                    </div>
                </div>

                <div class="form-grid-3" style="border-top: 1px solid var(--line); padding-top: 16px; margin-top: 8px;">
                    <div>
                        <label class="form-label">Grado Escolar</label>
                        <select id="edit_idGrado" name="idGrado" class="form-control">
                            <option value="1">Primer Año</option>
                            <option value="2">Segundo Año</option>
                            <option value="3">Tercer Año</option>
                            <option value="4">Cuarto Año</option>
                            <option value="5">Quinto Año</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">Sección</label>
                        <select id="edit_idSeccion" name="idSeccion" class="form-control">
                            <option value="1">Sección A</option>
                            <option value="2">Sección B</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">Carrera Destino (*)</label>
                        <select id="edit_idCarrera" name="idCarrera" class="form-control" style="color: var(--navy); font-weight: 500;">
                            <option value="1">Medicina Humana</option>
                            <option value="2">Enfermería</option>
                            <option value="3">Ingeniería de Datos e IA</option>
                            <option value="4">Ingeniería de Sistemas</option>
                            <option value="5">Derecho</option>
                        </select>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" onclick="toggleModal('modalEditarAlumno')" class="btn btn-outline">Cancelar</button>
                    <button type="submit" class="btn btn-navy">Guardar Cambios</button>
                </div>
            </form>
        </div>
    </div>

    <div class="modal-overlay hidden" id="modalNuevaCarrera">
        <div class="modal-content border-gold">
            <div class="modal-header">
                <h3 class="modal-title" style="font-family: 'Source Serif 4', serif; color: var(--navy); margin:0;">Registrar Nueva Carrera Profesional</h3>
                <button onclick="toggleModal('modalNuevaCarrera')" class="close-btn">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/maestros" method="POST">
                <input type="hidden" name="accion" value="crearCarrera">

                <div class="form-row">
                    <label class="form-label">Área Académica (*)</label>
                    <select name="idArea" class="form-control">
                        <option value="1">Biomédicas</option>
                        <option value="2">Ingenierías</option>
                        <option value="3">Sociales</option>
                    </select>
                </div>

                <div class="form-row">
                    <label class="form-label">Nombre de la Carrera (*)</label>
                    <input type="text" name="nombreCarrera" required class="form-control" placeholder="Ej: Arquitectura y Urbanismo">
                </div>

                <div class="modal-footer">
                    <button type="button" onclick="toggleModal('modalNuevaCarrera')" class="btn btn-outline">Cancelar</button>
                    <button type="submit" class="btn btn-gold">Guardar Carrera</button>
                </div>
            </form>
        </div>
    </div>

    <div id="modalAsignarAula" class="modal-overlay hidden">
        <div class="modal-content">
            <div class="modal-header">
                <h3 class="modal-title" style="font-family: 'Source Serif 4', serif; color: var(--navy); margin:0;">Asignación de Aula y Docente Supervisor</h3>
                <button onclick="toggleModal('modalAsignarAula')" class="close-btn">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/admin/asignarAula" method="POST">
                
                <div class="form-row">
                    <label class="form-label">Seleccionar Convocatoria (*)</label>
                    <select name="idPeriodo" required class="form-control" style="color: var(--navy); font-weight: 500;">
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

                <div class="form-row">
                    <label class="form-label">Docente Supervisor (*)</label>
                    <select name="idDocente" required class="form-control" style="font-weight: 500;">
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

                <div class="form-row">
                    <label class="form-label">Pabellón / Bloque (*)</label>
                    <select name="pabellon" class="form-control">
                        <option value="Pabellón A - Biomédicas">Pabellón A - Biomédicas</option>
                        <option value="Pabellón B - Ingenierías">Pabellón B - Ingenierías</option>
                        <option value="Pabellón C - Sociales">Pabellón C - Sociales</option>
                    </select>
                </div>

                <div class="form-row">
                    <label class="form-label">Número de Aula (*)</label>
                    <input type="text" name="aula" required class="form-control" placeholder="Ej: Aula 102 - Piso 2">
                </div>

                <div class="modal-footer">
                    <button type="button" onclick="toggleModal('modalAsignarAula')" class="btn btn-outline">Cancelar</button>
                    <button type="submit" class="btn btn-navy">Registrar Asignación</button>
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