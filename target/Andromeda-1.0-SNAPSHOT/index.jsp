<%-- 
    Document   : index.jsp
    Created on : 20 may. 2026, 8:38:04 p.m.
    Author     : klaidneil
    Descripción: Vista principal del sistema Andromeda. 
                 Incluye Login centralizado (Tabla 'usuario') y Modal de Inscripción.
--%>
<%-- 
    Document   : index.jsp
    Created on : 20 may. 2026, 8:38:04 p.m.
    Author     : klaidneil
    Descripción: Vista principal del sistema Andromeda. 
                 Incluye Login centralizado (Tabla 'usuario') y Modal de Inscripción.
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es" id="htmlTag">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gran Unidad Escolar Andrómeda | Inicio y Sistema Integrado</title>
    
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Source+Serif+4:wght@500;600;700&family=Inter:wght@400;500;600&display=swap');

        :root {
            /* Base Colegio Nacional */
            --navy: #15304F;        
            --navy-soft: #1E4269;   
            --bg: #F3F1EB;          
            --panel: #FFFFFF;       
            --ink: #212A26;         
            --ink-soft: #64716A;    
            --line: #E4E0D4;        

            /* Acentos semánticos */
            --green: #178F55;       
            --green-light: #DEF5E8;
            --gold: #E0A72E;        
            --gold-light: #FCF0D6;
            --red: #E14F3D;         
            --red-light: #FDE1DC;
        }

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Inter', sans-serif;
            background-color: var(--bg);
            color: var(--ink);
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* ---------------- UTILIDADES DE MODAL Y ALERTAS ---------------- */
        .hidden { display: none !important; }
        .flex { display: flex !important; }

        /* Alertas Flotantes */
        .system-alert {
            position: fixed;
            top: 24px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1000;
            width: 90%;
            max-width: 480px;
            padding: 14px 18px;
            border-radius: 4px;
            font-size: 13px;
            font-weight: 500;
            border-left: 4px solid;
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: opacity 0.5s ease;
        }
        
        .alert-error { background: var(--red-light); color: var(--red); border-left-color: var(--red); }
        .alert-warn { background: var(--gold-light); color: #8A6200; border-left-color: var(--gold); }
        .alert-success { background: var(--green-light); color: var(--green); border-left-color: var(--green); }
        .alert-info { background: var(--panel); color: var(--navy); border-left-color: var(--navy); }

        .alert-close {
            background: none;
            border: none;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            color: inherit;
            margin-left: 12px;
        }

        /* ---------------- LAYOUT PRINCIPAL DE INDEX ---------------- */
        .landing-container {
            display: flex;
            min-height: 100vh;
            width: 100%;
        }

        /* Lado Izquierdo: Hero Institucional */
        .hero-section {
            flex: 3;
            position: relative;
            background-image: url('https://images.unsplash.com/photo-1541339907198-e08756dedf3f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            display: flex;
        }

        .hero-overlay {
            position: absolute;
            inset: 0;
            background-color: rgba(21, 48, 79, 0.88); /* Overlay Navy Institucional */
        }

        .hero-content {
            position: relative;
            z-index: 10;
            width: 100%;
            padding: 48px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            color: var(--panel);
        }

        .brand-header {
            display: flex;
            align-items: center;
            gap: 20px;
        }

        /* Contenedor del Logo Mimetizado a 100px */
        .crest {
            height: 200px;
            width: auto;
            display: flex;
            align-items: center;
            justify-content: center;
            background: transparent;
        }

        .crest img {
            height: 100%;
            width: auto;
            object-fit: contain;
            filter: drop-shadow(0px 2px 4px rgba(0, 0, 0, 0.3));
        }

        .brand-title {
            font-family: 'Source Serif 4', serif;
            font-size: 24px;
            font-weight: 600;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            color: var(--panel);
        }

        .hero-body {
            max-width: 640px;
        }

        .hero-headline {
            font-family: 'Source Serif 4', serif;
            font-size: 48px;
            font-weight: 600;
            line-height: 1.15;
            margin: 0 0 24px 0;
            color: var(--panel);
        }

        .hero-subtext {
            font-size: 16px;
            line-height: 1.5;
            color: var(--line);
            border-left: 3px solid var(--gold);
            padding-left: 16px;
            margin: 0;
            font-weight: 400;
        }

        .hero-footer {
            font-size: 12px;
            color: var(--line);
            opacity: 0.8;
        }

        /* Lado Derecho: Formulario de Login */
        .login-section {
            flex: 1;
            min-width: 340px;
            background: var(--panel);
            padding: 48px 40px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            border-left: 1px solid var(--line);
            position: relative;
            box-shadow: -4px 0 16px rgba(0,0,0,0.05);
        }

        .login-header {
            text-align: left;
            margin-bottom: 32px;
        }

        .login-header h2 {
            font-family: 'Source Serif 4', serif;
            font-size: 26px;
            font-weight: 600;
            color: var(--navy);
            margin: 0 0 8px 0;
        }

        .login-subtitle {
            font-size: 13px;
            color: var(--ink-soft);
            margin: 0;
        }

        .login-hint {
            font-size: 11px;
            color: var(--navy);
            background: var(--bg);
            padding: 8px 12px;
            border-radius: 4px;
            margin-top: 12px;
            border-left: 3px solid var(--navy);
            font-weight: 500;
        }

        /* ---------------- FORMULARIOS Y ELEMENTOS ---------------- */
        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 11px;
            color: var(--ink-soft);
            margin-bottom: 6px;
            font-weight: 500;
        }

        .form-control {
            width: 100%;
            padding: 10px 14px;
            border: 1px solid var(--line);
            border-radius: 4px;
            font-family: 'Inter', sans-serif;
            font-size: 13px;
            color: var(--ink);
            background: var(--panel);
            box-sizing: border-box;
            transition: border-color 0.2s;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--navy);
        }

        .divider {
            display: flex;
            align-items: center;
            margin: 28px 0;
            color: var(--ink-soft);
            font-size: 12px;
        }

        .divider::before, .divider::after {
            content: '';
            flex: 1;
            border-bottom: 1px solid var(--line);
        }

        .divider span {
            padding: 0 12px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            font-size: 10.5px;
        }

        /* ---------------- BOTONES ---------------- */
        .btn {
            display: inline-block;
            width: 100%;
            font-family: 'Inter', sans-serif;
            font-size: 12px;
            font-weight: 600;
            padding: 12px 16px;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            text-align: center;
            border: 1px solid transparent;
            transition: all 0.2s ease;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            box-sizing: border-box;
        }

        .btn-navy { background: var(--navy); color: var(--panel); }
        .btn-navy:hover { background: var(--navy-soft); }

        .btn-outline { background: transparent; border-color: var(--navy); color: var(--navy); }
        .btn-outline:hover { background: var(--bg); }

        .btn-gold { background: var(--gold); color: var(--panel); }
        .btn-gold:hover { background: #C28E22; }

        /* ---------------- MODAL DE INSCRIPCIÓN ---------------- */
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(21, 48, 79, 0.7);
            backdrop-filter: blur(2px);
            align-items: center;
            justify-content: center;
            z-index: 2000;
            padding: 20px;
        }

        .modal-content {
            background: var(--panel);
            border-radius: 4px;
            width: 100%;
            max-width: 640px;
            max-height: 90vh;
            overflow-y: auto;
            padding: 32px;
            border-top: 4px solid var(--navy);
            box-shadow: 0 8px 24px rgba(0,0,0,0.15);
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            border-bottom: 1px solid var(--line);
            padding-bottom: 16px;
            margin-bottom: 24px;
        }

        .modal-header h3 {
            font-family: 'Source Serif 4', serif;
            font-size: 20px;
            font-weight: 600;
            color: var(--navy);
            margin: 0;
        }

        .modal-header p {
            font-size: 12px;
            color: var(--ink-soft);
            margin: 4px 0 0 0;
        }

        .close-btn {
            background: none;
            border: none;
            font-size: 28px;
            color: var(--ink-soft);
            cursor: pointer;
            line-height: 1;
        }

        .close-btn:hover { color: var(--red); }

        .section-subtitle {
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--navy);
            margin: 16px 0 12px 0;
            padding-bottom: 4px;
            border-bottom: 1px solid var(--line);
        }

        .form-grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 12px;
        }

        .modal-footer {
            border-top: 1px solid var(--line);
            padding-top: 20px;
            margin-top: 24px;
            display: flex;
            justify-content: flex-end;
            gap: 12px;
        }

        .modal-footer .btn {
            width: auto;
            padding: 10px 20px;
        }

        @media (max-width: 900px) {
            .hero-section { display: none; }
            .login-section { flex: 1; width: 100%; padding: 32px 24px; }
            .form-grid-2 { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

    <%-- ALERTAS SISTEMA --%>
    <c:if test="${not empty param.estado || not empty param.error || not empty requestScope.error || not empty requestScope.mensajeExito}">
        <div id="alertaSistema" class="system-alert">
            <c:choose>
                <c:when test="${param.estado == 'error_login' || not empty requestScope.error}">
                    <div class="alert-error" style="width: 100%; display: flex; justify-content: space-between; align-items: center; background: none; padding: 0; border: none; box-shadow: none;">
                        <div>
                            <strong>[Aviso]</strong> 
                            <c:out value="${requestScope.error}" default="Credenciales incorrectas. Intenta de nuevo." />
                        </div>
                        <button onclick="document.getElementById('alertaSistema').style.display='none'" class="alert-close">&times;</button>
                    </div>
                </c:when>

                <c:when test="${param.estado == 'requiere_login'}">
                    <div class="alert-warn" style="width: 100%; display: flex; justify-content: space-between; align-items: center; background: none; padding: 0; border: none; box-shadow: none;">
                        <div>
                            <strong>[Seguridad]</strong> Acceso denegado. Inicia sesión primero.
                        </div>
                        <button onclick="document.getElementById('alertaSistema').style.display='none'" class="alert-close">&times;</button>
                    </div>
                </c:when>

                <c:when test="${param.estado == 'sin_permiso'}">
                    <div class="alert-error" style="width: 100%; display: flex; justify-content: space-between; align-items: center; background: none; padding: 0; border: none; box-shadow: none;">
                        <div>
                            <strong>[Restringido]</strong> No tienes permisos para ingresar a ese panel.
                        </div>
                        <button onclick="document.getElementById('alertaSistema').style.display='none'" class="alert-close">&times;</button>
                    </div>
                </c:when>

                <c:when test="${param.estado == 'exito' || not empty requestScope.mensajeExito}">
                    <div class="alert-success" style="width: 100%; display: flex; justify-content: space-between; align-items: center; background: none; padding: 0; border: none; box-shadow: none;">
                        <div>
                            <strong>[Éxito]</strong> 
                            <c:out value="${requestScope.mensajeExito}" default="¡Inscripción exitosa! Tu DNI es tu usuario y contraseña." />
                        </div>
                        <button onclick="document.getElementById('alertaSistema').style.display='none'" class="alert-close">&times;</button>
                    </div>
                </c:when>

                <c:when test="${param.estado == 'logout'}">
                    <div class="alert-info" style="width: 100%; display: flex; justify-content: space-between; align-items: center; background: none; padding: 0; border: none; box-shadow: none;">
                        <div>
                            <strong>[Sistema]</strong> Sesión cerrada correctamente. ¡Hasta pronto!
                        </div>
                        <button onclick="document.getElementById('alertaSistema').style.display='none'" class="alert-close">&times;</button>
                    </div>
                </c:when>
            </c:choose>
        </div>
    </c:if>

    <div class="landing-container">

        <div class="hero-section">
            <div class="hero-overlay"></div>

            <div class="hero-content">
                <div class="brand-header">
                    <div class="crest">
                        <img src="${pageContext.request.contextPath}/assets/images/logo.svg" alt="Escudo Gran Unidad Escolar Andrómeda">
                    </div>
                    <span class="brand-title">Gran Unidad Escolar Andrómeda</span>
                </div>

                <div class="hero-body">
                    <h1 class="hero-headline">Forjando el futuro<br>desde hoy.</h1>
                    <p class="hero-subtext">
                        Sistema Integrado de Gestión Académica y Admisión. Únete a nuestro simulacro institucional.
                    </p>
                </div>

                <div class="hero-footer">
                    &copy; 2026 Gran Unidad Escolar Andrómeda — Sistema Integrado de Admisión.
                </div>
            </div>
        </div>

        <div class="login-section">
            <div class="login-header">
                <h2>Acceso al Sistema</h2>
                <p class="login-subtitle">Ingresa tus credenciales institucionales</p>
                <div class="login-hint">Alumnos: Usuario y Clave inicial es su DNI</div>
            </div>

            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label class="form-label">Usuario / DNI</label>
                    <input type="text" name="username" required class="form-control" placeholder="Ingrese DNI o Usuario">
                </div>
                <div class="form-group">
                    <label class="form-label">Contraseña</label>
                    <input type="password" name="password" required class="form-control" placeholder="••••••••">
                </div>
                
                <button type="submit" class="btn btn-navy">
                    Iniciar Sesión
                </button>
            </form>

            <div class="divider">
                <span>¿Postulante nuevo?</span>
            </div>

            <button type="button" id="btnAbrirModal" class="btn btn-outline">
                Inscríbete al Simulacro
            </button>
        </div>

    </div>

    <div id="modalRegistro" class="modal-overlay hidden">
        <div class="modal-content">

            <div class="modal-header">
                <div>
                    <h3>Ficha Oficial de Inscripción</h3>
                    <p>Complete los datos obligatorios para emitir su constancia institucional</p>
                </div>
                <button type="button" id="btnCerrarModal" class="close-btn">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/registro" method="POST">
                
                <div class="section-subtitle">1. Identificación Personal</div>
                <div class="form-grid-2">
                    <div>
                        <label class="form-label">DNI (*)</label>
                        <input type="text" name="numDocumento" required maxlength="15" class="form-control" placeholder="Ej: 78409636" style="font-family: monospace;">
                    </div>
                    <div>
                        <label class="form-label">Nombres Completos (*)</label>
                        <input type="text" name="nombres" required class="form-control" placeholder="Ej: Natalie Jennifer">
                    </div>
                </div>
                <div class="form-grid-2">
                    <div>
                        <label class="form-label">Apellido Paterno (*)</label>
                        <input type="text" name="apPaterno" required class="form-control" placeholder="Ej: Herrera">
                    </div>
                    <div>
                        <label class="form-label">Apellido Materno (*)</label>
                        <input type="text" name="apMaterno" required class="form-control" placeholder="Ej: Melo">
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Fecha de Nacimiento (*)</label>
                    <input type="date" name="fechaNacimiento" required class="form-control">
                </div>

                <div class="section-subtitle">2. Contacto y Procedencia</div>
                <div class="form-grid-2">
                    <div>
                        <label class="form-label">Celular</label>
                        <input type="tel" name="celular" maxlength="15" class="form-control" placeholder="Ej: 987654321">
                    </div>
                    <div>
                        <label class="form-label">Correo Electrónico (*)</label>
                        <input type="email" name="correo" required maxlength="150" class="form-control" placeholder="ejemplo@correo.com">
                    </div>
                </div>
                <div class="form-grid-2">
                    <div>
                        <label class="form-label">Ubigeo Nacimiento</label>
                        <input type="text" name="ubigeoNacimiento" maxlength="6" class="form-control" placeholder="210101" style="font-family: monospace;">
                    </div>
                    <div>
                        <label class="form-label">Ubigeo Domicilio</label>
                        <input type="text" name="ubigeoDomicilio" maxlength="6" class="form-control" placeholder="210101" style="font-family: monospace;">
                    </div>
                </div>

                <div class="section-subtitle">3. Inscripción Académica y Simulacro</div>
                <div class="form-grid-2">
                    <div>
                        <label class="form-label">Periodo / Simulacro (*)</label>
                        <select name="idPeriodo" class="form-control" style="font-weight: 500;">
                            <option value="1">II Simulacro de Admisión 2026 (Activo)</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">Carrera Profesional (*)</label>
                        <select name="idCarrera" class="form-control" style="font-weight: 500; color: var(--navy);">
                            <option value="1">Medicina Humana (Biomédicas)</option>
                            <option value="2">Enfermería (Biomédicas)</option>
                            <option value="3">Ingeniería de Datos e IA (Ingenierías)</option>
                            <option value="4">Ingeniería de Sistemas (Ingenierías)</option>
                            <option value="5">Derecho (Sociales)</option>
                        </select>
                    </div>
                </div>
                <div class="form-grid-2">
                    <div>
                        <label class="form-label">Grado Escolar</label>
                        <select name="idGrado" class="form-control">
                            <option value="1">Primer Año</option>
                            <option value="2">Segundo Año</option>
                            <option value="3">Tercer Año</option>
                            <option value="4">Cuarto Año</option>
                            <option value="5">Quinto Año</option>
                        </select>
                    </div>
                    <div>
                        <label class="form-label">Sección</label>
                        <select name="idSeccion" class="form-control">
                            <option value="1">Sección A</option>
                            <option value="2">Sección B</option>
                        </select>
                    </div>
                </div>

                <div class="modal-footer">
                    <button type="button" id="btnCancelarModal" class="btn btn-outline">
                        Cancelar
                    </button>
                    <button type="submit" class="btn btn-navy">
                        Confirmar Inscripción
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const modal = document.getElementById('modalRegistro');
            const btnAbrir = document.getElementById('btnAbrirModal');
            const btnCerrar = document.getElementById('btnCerrarModal');
            const btnCancelar = document.getElementById('btnCancelarModal');

            function abrirModal() {
                modal.classList.remove('hidden');
                modal.classList.add('flex');
            }

            function cerrarModal() {
                modal.classList.add('hidden');
                modal.classList.remove('flex');
            }

            if (btnAbrir) btnAbrir.addEventListener('click', abrirModal);
            if (btnCerrar) btnCerrar.addEventListener('click', cerrarModal);
            if (btnCancelar) btnCancelar.addEventListener('click', cerrarModal);

            // Ocultar alerta automáticamente después de 5 segundos
            const alerta = document.getElementById('alertaSistema');
            if (alerta) {
                setTimeout(function () {
                    alerta.style.opacity = '0';
                    setTimeout(() => alerta.style.display = 'none', 500);
                }, 5000);
            }
        }); 
    </script>
</body>
</html>