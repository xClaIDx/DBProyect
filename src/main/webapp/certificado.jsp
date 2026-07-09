<%-- 
    Document   : certificado
    Created on : 21 may. 2026, 9:28:30 a. m.
    Author     : klaidneil
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Constancia de Inscripción | Andromeda</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @page { size: A4 portrait; margin: 0; }
        @media print {
            body { background-color: white !important; }
            .no-imprimir { display: none !important; }
        }
    </style>
</head>
<body class="bg-slate-200 min-h-screen flex items-center justify-center py-10 font-sans">

    <div class="bg-white w-[210mm] min-h-[297mm] shadow-2xl print:shadow-none border-[12px] border-double border-indigo-900 p-12 relative flex flex-col">
        
        <header class="flex justify-between items-center border-b-2 border-slate-300 pb-6 mb-10">
            
            <div class="flex items-center space-x-6">
                <img src="${pageContext.request.contextPath}/assets/images/logo.png" 
                     alt="Escudo Institucional" 
                     class="h-24 w-auto object-contain print:m-0">
                     
                <div>
                    <h1 class="text-3xl font-serif font-extrabold text-indigo-900 uppercase tracking-widest">Colegio Andromeda</h1>
                    <p class="text-sm text-slate-500 font-medium mt-1">Sistema Integrado de Gestión Académica</p>
                </div>
            </div>
            
            <div class="text-right">
                <p class="text-xs text-slate-400 font-mono">ID Registro: #${alumno.numDocumento}</p>
                <p class="text-xs text-slate-400">Generado automáticamente</p>
            </div>
            
        </header>

        <div class="text-center mb-12">
            <h2 class="text-4xl font-black text-slate-800 uppercase tracking-wide">Constancia de Matrícula</h2>
            <p class="text-slate-500 mt-2 text-lg">Simulacro General de Admisión</p>
        </div>

        <div class="flex-grow">
            <div class="bg-slate-50 border border-slate-200 rounded-xl p-8 space-y-6 text-lg">
                
                <div class="flex border-b border-slate-200 pb-3">
                    <span class="font-bold w-48 text-indigo-900 uppercase text-sm tracking-wider">Postulante:</span>
                    <span class="text-slate-800 font-medium">${alumno.apPaterno} ${alumno.apMaterno}, ${alumno.nombres}</span>
                </div>
                
                <div class="flex border-b border-slate-200 pb-3">
                    <span class="font-bold w-48 text-indigo-900 uppercase text-sm tracking-wider">Documento (DNI):</span>
                    <span class="text-slate-800 font-mono">${alumno.numDocumento}</span>
                </div>

                <div class="flex border-b border-slate-200 pb-3">
                    <span class="font-bold w-48 text-indigo-900 uppercase text-sm tracking-wider">Ciclo / Periodo:</span>
                    <span class="text-slate-800">${alumno.nombrePeriodo}</span>
                </div>

                <div class="flex border-b border-slate-200 pb-3">
                    <span class="font-bold w-48 text-indigo-900 uppercase text-sm tracking-wider">Grado Académico:</span>
                    <span class="text-slate-800">${alumno.nombreGrado}</span>
                </div>

                <div class="flex border-b border-slate-200 pb-3">
                    <span class="font-bold w-48 text-indigo-900 uppercase text-sm tracking-wider">Área Postulación:</span>
                    <span class="text-slate-800">${alumno.nombreArea}</span>
                </div>
                
            </div>
        </div>

        <div class="mt-20 flex justify-around">
            <div class="text-center w-64 border-t border-slate-400 pt-2">
                <p class="font-bold text-slate-700">Firma del Postulante</p>
                <p class="text-xs text-slate-500">DNI: ${alumno.numDocumento}</p>
            </div>
            <div class="text-center w-64 border-t border-slate-400 pt-2">
                <p class="font-bold text-slate-700">Sello de la Institución</p>
                <p class="text-xs text-slate-500">Dirección Académica</p>
            </div>
        </div>
        
    </div>

    <div class="fixed bottom-8 right-8 flex space-x-4 no-imprimir">
        <a href="${pageContext.request.contextPath}/home" class="px-6 py-3 bg-slate-800 hover:bg-slate-900 text-white rounded-full font-bold shadow-xl transition-all">
            Volver al Inicio
        </a>
        <button onclick="window.print()" class="px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white rounded-full font-bold shadow-xl flex items-center transition-all">
            <span class="mr-2">🖨️</span> Descargar / Imprimir
        </button>
    </div>

</body>
</html>