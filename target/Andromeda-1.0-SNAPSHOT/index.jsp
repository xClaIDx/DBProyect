<%-- 
    Document   : index.jsp
    Created on : 20 may. 2026, 8:38:04 p. m.
    Author     : klaidneil
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="es" class="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Colegio Andromeda | Inicio</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
        }
    </script>
</head>
<body class="bg-slate-50 text-slate-800 transition-colors duration-300 dark:bg-slate-900 dark:text-slate-100 overflow-hidden">
    
    <c:if test="${not empty param.estado}">
        <div id="alertaSistema" class="fixed top-20 left-1/2 transform -translate-x-1/2 z-50 w-full max-w-md px-4 transition-all duration-500">
            <c:choose>
                
                <c:when test="${param.estado == 'error_login'}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded shadow-lg flex items-center">
                        <span class="text-2xl mr-3"></span>
                        <p class="font-bold">Credenciales incorrectas. Intenta de nuevo.</p>
                    </div>
                </c:when>

                <c:when test="${param.estado == 'requiere_login'}">
                    <div class="bg-yellow-100 border-l-4 border-yellow-500 text-yellow-800 p-4 rounded shadow-lg flex items-center">
                        <span class="text-2xl mr-3"></span>
                        <p class="font-bold">Acceso denegado. Por favor, inicia sesión primero.</p>
                    </div>
                </c:when>
                
                <c:when test="${param.estado == 'exito'}">
                    <div class="bg-green-100 border-l-4 border-green-500 text-green-700 p-4 rounded shadow-lg flex justify-between items-center">
                        <div class="flex items-center">
                            <span class="text-2xl mr-3"></span>
                            <p class="font-bold">¡Inscripción exitosa! Te contactaremos pronto.</p>
                        </div>
                        <button onclick="document.getElementById('alertaSistema').style.display='none'" class="text-green-900 font-bold">&times;</button>
                    </div>
                </c:when>
                
                <c:when test="${param.estado == 'error'}">
                    <div class="bg-red-100 border-l-4 border-red-500 text-red-700 p-4 rounded shadow-lg flex justify-between items-center">
                        <div class="flex items-center">
                            <span class="text-2xl mr-3">⚠️</span>
                            <p class="font-bold">Error. Verifica tus datos o el DNI ingresado.</p>
                        </div>
                        <button onclick="document.getElementById('alertaSistema').style.display='none'" class="text-red-900 font-bold">&times;</button>
                    </div>
                </c:when>
                
                <c:when test="${param.estado == 'logout'}">
                    <div class="bg-blue-100 border-l-4 border-blue-500 text-blue-800 p-4 rounded shadow-lg flex items-center">
                        <span class="text-2xl mr-3"></span>
                        <p class="font-bold">Sesión cerrada correctamente. ¡Hasta pronto!</p>
                    </div>
                </c:when>
                
            </c:choose>
        </div>
        
        <script>
            setTimeout(function() {
                var alerta = document.getElementById('alertaSistema');
                if(alerta) {
                    alerta.style.opacity = '0';
                    setTimeout(() => alerta.style.display = 'none', 500);
                }
            }, 5000);
        </script>
    </c:if>

    <div class="flex min-h-screen">

        <div class="hidden lg:flex lg:w-3/4 relative bg-cover bg-center" 
             style="background-image: url('https://images.unsplash.com/photo-1541339907198-e08756dedf3f?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');">
            
            <div class="absolute inset-0 bg-indigo-950/70 mix-blend-multiply"></div>

            <div class="relative z-10 w-full p-12 flex flex-col justify-between">
                
                <div class="flex items-center space-x-4">
                    <img src="${pageContext.request.contextPath}/assets/images/logo.png" 
                         alt="Logo Oficial Colegio Andromeda" 
                         class="h-32 w-35 object-contain">
                         
                    <span class="text-3xl font-serif font-bold text-white tracking-widest uppercase">Colegio Andromeda</span>
                </div>

                <div class="max-w-2xl text-white">
                    <h1 class="text-6xl font-serif font-bold mb-6 leading-tight">Forjando el futuro<br>desde hoy.</h1>
                    <p class="text-xl text-indigo-100 font-light border-l-4 border-indigo-400 pl-4">
                        Sistema Integrado de Gestión Académica. Únete a nuestro simulacro de admisión y descubre tu potencial.
                    </p>
                </div>

                <div class="text-indigo-200 text-sm">
                    &copy; 2026 Colegio Andromeda. Todos los derechos reservados.
                </div>
            </div>
        </div>

        <div class="w-full lg:w-1/4 bg-white dark:bg-slate-800 p-8 md:p-12 flex flex-col justify-center relative shadow-2xl z-20">
            
            <button id="themeToggle" class="absolute top-6 right-6 p-2 rounded-full hover:bg-slate-100 dark:hover:bg-slate-700 transition">
                🌓
            </button>

            <div class="mb-10 text-center lg:text-left">
                <h2 class="text-3xl font-bold text-gray-800 dark:text-white mb-2">Acceso al Sistema</h2>
                <p class="text-sm text-gray-500 dark:text-gray-400">Ingresa tus credenciales para continuar</p>
            </div>

            <form action="login" method="POST" class="space-y-6">
                <div>
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Usuario / DNI</label>
                    <input type="text" name="username" required 
                           class="mt-1 w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition dark:bg-slate-700 dark:border-slate-600 dark:text-white">
                </div>
                <div>
                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300">Contraseña</label>
                    <input type="password" name="password" required 
                           class="mt-1 w-full px-4 py-3 border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition dark:bg-slate-700 dark:border-slate-600 dark:text-white">
                </div>
                
                <button type="submit" class="w-full bg-indigo-900 hover:bg-indigo-800 text-white font-bold py-3 rounded-lg shadow-lg transition transform hover:-translate-y-0.5">
                    Iniciar Sesión
                </button>
            </form>

            <div class="my-8 flex items-center">
                <div class="flex-grow border-t border-gray-200 dark:border-slate-600"></div>
                <span class="flex-shrink-0 mx-4 text-gray-400 text-sm">¿Eres postulante?</span>
                <div class="flex-grow border-t border-gray-200 dark:border-slate-600"></div>
            </div>

            <button onclick="toggleModal('modalRegistro')" class="w-full border-2 border-indigo-900 text-indigo-900 dark:border-indigo-400 dark:text-indigo-400 hover:bg-indigo-50 dark:hover:bg-slate-700 font-bold py-3 rounded-lg transition">
                Inscríbete al Simulacro
            </button>
        </div>

    </div> <div id="modalRegistro" class="fixed inset-0 bg-black/60 backdrop-blur-sm hidden items-center justify-center z-50 transition-opacity">
        <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-2xl w-full max-w-lg p-8 transform transition-all border-t-4 border-indigo-600">

            <div class="flex justify-between items-center mb-6">
                <div>
                    <h3 class="text-2xl font-bold text-gray-800 dark:text-white">Registro de Postulante</h3>
                    <p class="text-sm text-gray-500 dark:text-gray-400">Completa tus datos para el simulacro</p>
                </div>
                <button onclick="toggleModal('modalRegistro')" class="text-gray-400 hover:text-red-500 transition text-3xl font-light">&times;</button>
            </div>

            <form action="registro" method="POST" class="space-y-4">

                <div>
                    <input type="text" name="numDocumento" placeholder="DNI" required 
                           class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none">
                </div>
                <div>
                    <input type="text" name="nombres" placeholder="Nombres" required 
                           class="w-full px-4 py-2 border rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none">
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-semibold text-gray-600 uppercase mb-1">Ciclo</label>
                        <select name="idPeriodo" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none">
                            <c:forEach var="entry" items="${mapaPeriodos}">
                                <option value="${entry.key}">${entry.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label class="block text-xs font-semibold text-gray-600 uppercase mb-1">Grado</label>
                        <select name="idGrado" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none">
                            <c:forEach var="entry" items="${mapaGrados}">
                                <option value="${entry.key}">${entry.value}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-semibold text-gray-600 uppercase mb-1">Área Académica</label>
                    <select name="idArea" class="w-full px-3 py-2 border rounded-lg focus:ring-2 focus:ring-indigo-500 outline-none">
                        <c:forEach var="a" items="${listaAreas}">
                            <option value="${a.idArea}">${a.nombre}</option>
                        </c:forEach>
                    </select>
                </div>

                <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white py-3 rounded-lg font-bold transition-all shadow-lg mt-6">
                    Confirmar Inscripción
                </button>
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

        const themeToggleBtn = document.getElementById('themeToggle');
        const htmlElement = document.documentElement;

        themeToggleBtn.addEventListener('click', () => {
            if (htmlElement.classList.contains('dark')) {
                htmlElement.classList.remove('dark');
                htmlElement.classList.add('light');
            } else {
                htmlElement.classList.remove('light');
                htmlElement.classList.add('dark');
            }
        });
    </script>
</body>
</html>