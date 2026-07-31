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
<html lang="es" id="htmlTag" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gran Unidad Escolar Andrómeda | Inicio y Sistema Integrado</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
        }
    </script>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; }
    </style>
</head>
<body class="bg-slate-50 text-slate-800 transition-colors duration-300 dark:bg-slate-900 dark:text-slate-100 min-h-screen overflow-x-hidden">

    <%-- ALERTAS SISTEMA --%>
    <c:if test="${not empty param.estado || not empty param.error || not empty requestScope.error || not empty requestScope.mensajeExito}">
        <div id="alertaSistema" class="fixed top-20 left-1/2 transform -translate-x-1/2 z-50 w-full max-w-md px-4 transition-all duration-500">
            <c:choose>
                <c:when test="${param.estado == 'error_login' || not empty requestScope.error}">
                    <div class="bg-red-50 border-l-4 border-red-800 text-red-900 p-4 rounded shadow-lg flex justify-between items-center">
                        <div class="flex items-center">
                            <span class="text-sm font-bold mr-3">[Aviso]</span>
                            <p class="font-bold text-sm">
                                <c:out value="${requestScope.error}" default="Credenciales incorrectas. Intenta de nuevo." />
                            </p>
                        </div>
                        <button onclick="document.getElementById('alertaSistema').style.display='none'" class="text-red-900 font-bold ml-2">&times;</button>
                    </div>
                </c:when>

                <c:when test="${param.estado == 'requiere_login'}">
                    <div class="bg-amber-50 border-l-4 border-amber-700 text-amber-900 p-4 rounded shadow-lg flex items-center">
                        <span class="text-sm font-bold mr-3">[Seguridad]</span>
                        <p class="font-bold text-sm">Acceso denegado. Inicia sesión primero.</p>
                    </div>
                </c:when>

                <c:when test="${param.estado == 'sin_permiso'}">
                    <div class="bg-red-50 border-l-4 border-red-800 text-red-900 p-4 rounded shadow-lg flex items-center">
                        <span class="text-sm font-bold mr-3">[Restringido]</span>
                        <p class="font-bold text-sm">No tienes permisos para ingresar a ese panel.</p>
                    </div>
                </c:when>

                <c:when test="${param.estado == 'exito' || not empty requestScope.mensajeExito}">
                    <div class="bg-emerald-50 border-l-4 border-emerald-700 text-emerald-900 p-4 rounded shadow-lg flex justify-between items-center">
                        <div class="flex items-center">
                            <span class="text-sm font-bold mr-3">[Éxito]</span>
                            <p class="font-bold text-sm">
                                <c:out value="${requestScope.mensajeExito}" default="¡Inscripción exitosa! Tu DNI es tu usuario y contraseña." />
                            </p>
                        </div>
                        <button onclick="document.getElementById('alertaSistema').style.display='none'" class="text-emerald-900 font-bold ml-2">&times;</button>
                    </div>
                </c:when>

                <c:when test="${param.estado == 'logout'}">
                    <div class="bg-slate-100 border-l-4 border-slate-700 text-slate-800 p-4 rounded shadow-lg flex items-center">
                        <span class="text-sm font-bold mr-3">[Sistema]</span>
                        <p class="font-bold text-sm">Sesión cerrada correctamente. ¡Hasta pronto!</p>
                    </div>
                </c:when>
            </c:choose>
        </div>
    </c:if>

    <div class="flex min-h-screen">

        <div class="hidden lg:flex lg:w-3/4 relative bg-cover bg-center" 
             style="background-image: url('https://images.unsplash.com/photo-1541339907198-e08756dedf3f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');">
            
            <div class="absolute inset-0 bg-slate-950/80 mix-blend-multiply"></div>

            <div class="relative z-10 w-full p-12 flex flex-col justify-between">
                <div class="flex items-center space-x-4">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png" 
                         alt="Logo Gran Unidad Escolar Andrómeda" 
                         class="h-28 w-28 object-contain">
                    <span class="text-2xl font-bold text-white tracking-wider uppercase">Gran Unidad Escolar Andrómeda</span>
                </div>

                <div class="max-w-2xl text-white">
                    <h1 class="text-5xl font-bold mb-6 leading-tight">Forjando el futuro<br>desde hoy.</h1>
                    <p class="text-lg text-slate-200 font-light border-l-4 border-slate-400 pl-4">
                        Sistema Integrado de Gestión Académica y Admisión. Únete a nuestro simulacro institucional.
                    </p>
                </div>

                <div class="text-slate-300 text-xs">
                    &copy; 2026 Gran Unidad Escolar Andrómeda — Sistema Integrado de Admisión.
                </div>
            </div>
        </div>

        <div class="w-full lg:w-1/4 bg-white dark:bg-slate-800 p-8 md:p-12 flex flex-col justify-center relative shadow-2xl z-20">
            
            <button id="themeToggleBtn" type="button" class="absolute top-6 right-6 px-3 py-1.5 rounded bg-slate-100 dark:bg-slate-700 hover:bg-slate-200 dark:hover:bg-slate-600 transition cursor-pointer text-xs font-bold text-slate-700 dark:text-slate-200" title="Cambiar Tema">
                Tema
            </button>

            <div class="mb-8 text-center lg:text-left">
                <h2 class="text-2xl font-bold text-slate-900 dark:text-white mb-2">Acceso al Sistema</h2>
                <p class="text-xs text-slate-500 dark:text-slate-400">Ingresa tus credenciales institucionales</p>
                <p class="text-[11px] text-slate-700 dark:text-slate-300 mt-1 font-semibold">Alumnos: Usuario y Clave inicial es su DNI</p>
            </div>

            <form action="${pageContext.request.contextPath}/login" method="POST" class="space-y-4">
                <div>
                    <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase mb-1">Usuario / DNI</label>
                    <input type="text" name="username" required 
                           class="w-full px-4 py-2.5 border border-slate-300 rounded-lg focus:ring-1 focus:ring-slate-900 outline-none transition dark:bg-slate-700 dark:border-slate-600 dark:text-white text-sm"
                           placeholder="Ingrese DNI o Usuario">
                </div>
                <div>
                    <label class="block text-xs font-bold text-slate-700 dark:text-slate-300 uppercase mb-1">Contraseña</label>
                    <input type="password" name="password" required 
                           class="w-full px-4 py-2.5 border border-slate-300 rounded-lg focus:ring-1 focus:ring-slate-900 outline-none transition dark:bg-slate-700 dark:border-slate-600 dark:text-white text-sm"
                           placeholder="••••••••">
                </div>
                
                <button type="submit" class="w-full bg-slate-900 hover:bg-slate-800 text-white font-bold py-2.5 rounded-lg shadow transition cursor-pointer text-xs uppercase tracking-wider">
                    Iniciar Sesión
                </button>
            </form>

            <div class="my-6 flex items-center">
                <div class="flex-grow border-t border-slate-200 dark:border-slate-600"></div>
                <span class="flex-shrink-0 mx-4 text-slate-400 text-xs">¿Postulante nuevo?</span>
                <div class="flex-grow border-t border-slate-200 dark:border-slate-600"></div>
            </div>

            <button type="button" id="btnAbrirModal" class="w-full border border-slate-900 text-slate-900 dark:border-slate-300 dark:text-slate-200 hover:bg-slate-50 dark:hover:bg-slate-700 font-bold py-2.5 rounded-lg transition cursor-pointer text-xs uppercase tracking-wider">
                Inscríbete al Simulacro
            </button>
        </div>

    </div>
            
    <div id="modalRegistro" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm hidden items-center justify-center z-50 transition-opacity p-4">
        <div class="bg-white dark:bg-slate-800 rounded-lg shadow-2xl w-full max-w-2xl p-6 md:p-8 transform transition-all border-t-4 border-slate-900 max-h-[90vh] overflow-y-auto">

            <div class="flex justify-between items-center mb-6 border-b border-slate-100 dark:border-slate-700 pb-4">
                <div>
                    <h3 class="text-xl font-bold text-slate-900 dark:text-white uppercase tracking-wide">Ficha Oficial de Inscripción</h3>
                    <p class="text-xs text-slate-500 dark:text-slate-400 mt-0.5">Complete los datos obligatorios para emitir su constancia institucional</p>
                </div>
                <button type="button" id="btnCerrarModal" class="text-slate-400 hover:text-red-700 transition text-3xl font-light cursor-pointer">&times;</button>
            </div>

            <form action="${pageContext.request.contextPath}/registro" method="POST" class="space-y-6">
                <div>
                    <h4 class="text-xs font-bold text-slate-900 dark:text-slate-300 uppercase tracking-wider mb-3">1. Identificación Personal</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">DNI (*)</label>
                            <input type="text" name="numDocumento" required maxlength="15" class="w-full px-4 py-2 border border-slate-300 dark:border-slate-600 rounded focus:ring-1 focus:ring-slate-900 outline-none dark:bg-slate-700 dark:text-white text-sm" placeholder="Ej: 78409636">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Nombres Completos (*)</label>
                            <input type="text" name="nombres" required class="w-full px-4 py-2 border border-slate-300 dark:border-slate-600 rounded focus:ring-1 focus:ring-slate-900 outline-none dark:bg-slate-700 dark:text-white text-sm" placeholder="Ej: Natalie Jennifer">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Apellido Paterno (*)</label>
                            <input type="text" name="apPaterno" required class="w-full px-4 py-2 border border-slate-300 dark:border-slate-600 rounded focus:ring-1 focus:ring-slate-900 outline-none dark:bg-slate-700 dark:text-white text-sm" placeholder="Ej: Herrera">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Apellido Materno (*)</label>
                            <input type="text" name="apMaterno" required class="w-full px-4 py-2 border border-slate-300 dark:border-slate-600 rounded focus:ring-1 focus:ring-slate-900 outline-none dark:bg-slate-700 dark:text-white text-sm" placeholder="Ej: Melo">
                        </div>
                        <div class="md:col-span-2">
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Fecha de Nacimiento (*)</label>
                            <input type="date" name="fechaNacimiento" required class="w-full px-4 py-2 border border-slate-300 dark:border-slate-600 rounded focus:ring-1 focus:ring-slate-900 outline-none dark:bg-slate-700 dark:text-white text-sm">
                        </div>
                    </div>
                </div>

                <div>
                    <h4 class="text-xs font-bold text-slate-900 dark:text-slate-300 uppercase tracking-wider mb-3">2. Contacto y Procedencia</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Celular</label>
                            <input type="tel" name="celular" maxlength="15" class="w-full px-4 py-2 border border-slate-300 dark:border-slate-600 rounded focus:ring-1 focus:ring-slate-900 outline-none dark:bg-slate-700 dark:text-white text-sm" placeholder="Ej: 987654321">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Correo Electrónico (*)</label>
                            <input type="email" name="correo" required maxlength="150" class="w-full px-4 py-2 border border-slate-300 dark:border-slate-600 rounded focus:ring-1 focus:ring-slate-900 outline-none dark:bg-slate-700 dark:text-white text-sm" placeholder="ejemplo@correo.com">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Ubigeo Nacimiento</label>
                            <input type="text" name="ubigeoNacimiento" maxlength="6" class="w-full px-4 py-2 border border-slate-300 dark:border-slate-600 rounded focus:ring-1 focus:ring-slate-900 outline-none dark:bg-slate-700 dark:text-white text-sm font-mono" placeholder="210101">
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Ubigeo Domicilio</label>
                            <input type="text" name="ubigeoDomicilio" maxlength="6" class="w-full px-4 py-2 border border-slate-300 dark:border-slate-600 rounded focus:ring-1 focus:ring-slate-900 outline-none dark:bg-slate-700 dark:text-white text-sm font-mono" placeholder="210101">
                        </div>
                    </div>
                </div>

                <div>
                    <h4 class="text-xs font-bold text-slate-900 dark:text-slate-300 uppercase tracking-wider mb-3">3. Inscripción Académica y Simulacro</h4>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Periodo / Simulacro (*)</label>
                            <select name="idPeriodo" class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded text-sm bg-white dark:bg-slate-700 dark:text-white">
                                <option value="1">II Simulacro de Admisión 2026 (Activo)</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Carrera Profesional de Destino (*)</label>
                            <select name="idCarrera" class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded text-sm bg-white dark:bg-slate-700 dark:text-white">
                                <option value="1">Medicina Humana (Biomédicas)</option>
                                <option value="2">Enfermería (Biomédicas)</option>
                                <option value="3">Ingeniería de Datos e IA (Ingenierías)</option>
                                <option value="4">Ingeniería de Sistemas (Ingenierías)</option>
                                <option value="5">Derecho (Sociales)</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Grado Escolar</label>
                            <select name="idGrado" class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded text-sm bg-white dark:bg-slate-700 dark:text-white">
                                <option value="1">Primer Año</option>
                                <option value="2">Segundo Año</option>
                                <option value="3">Tercer Año</option>
                                <option value="4">Cuarto Año</option>
                                <option value="5">Quinto Año</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-xs font-semibold text-slate-600 dark:text-slate-400 uppercase mb-1">Sección</label>
                            <select name="idSeccion" class="w-full px-3 py-2 border border-slate-300 dark:border-slate-600 rounded text-sm bg-white dark:bg-slate-700 dark:text-white">
                                <option value="1">Sección A</option>
                                <option value="2">Sección B</option>
                            </select>
                        </div>
                    </div>
                </div>

                <div class="pt-4 border-t border-slate-200 dark:border-slate-700 flex justify-end space-x-3">
                    <button type="button" id="btnCancelarModal" class="px-4 py-2 rounded border border-slate-300 dark:border-slate-600 text-slate-700 dark:text-slate-300 hover:bg-slate-100 dark:hover:bg-slate-700 font-medium text-xs uppercase tracking-wider transition cursor-pointer">
                        Cancelar
                    </button>
                    <button type="submit" class="px-5 py-2 bg-slate-900 hover:bg-slate-800 text-white font-bold rounded text-xs uppercase tracking-wider shadow transition cursor-pointer">
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

            // Modo Oscuro
            const themeBtn = document.getElementById('themeToggleBtn');
            const htmlTag = document.getElementById('htmlTag');

            if (themeBtn) {
                themeBtn.addEventListener('click', function () {
                    if (htmlTag.classList.contains('dark')) {
                        htmlTag.classList.remove('dark');
                        htmlTag.classList.add('light');
                    } else {
                        htmlTag.classList.remove('light');
                        htmlTag.classList.add('dark');
                    }
                });
            }

            // Ocultar alerta automáticamente
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