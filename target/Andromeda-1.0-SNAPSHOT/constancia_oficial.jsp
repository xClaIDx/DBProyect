<%-- 
    Document   : constancia_oficial
    Created on : 30 jul 2026, 6:31:31 p.m.
    Author     : klaidneil
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="finesi.app.andromeda.modelo.Alumno"%>
<%@ page import="finesi.app.andromeda.modelo.Postulante"%>
<%
    Alumno alumno = (Alumno) request.getAttribute("alumno");
    Postulante postulante = (Postulante) request.getAttribute("postulante");
    String dniVal = (alumno != null && alumno.getNumDocumento() != null) ? alumno.getNumDocumento() : "00000000";
    String urlVerificacion = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() 
                            + request.getContextPath() + "/CertificadoServlet?tipo=constancia&dni=" + dniVal;
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Constancia de Preinscripción - G.U.E. Andrómeda</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 20px; color: #1e293b; background-color: #f8fafc; }
        .cert-container { border: 2px solid #0f172a; padding: 40px; max-width: 800px; margin: 0 auto; background: #ffffff; box-shadow: 0 4px 12px rgba(0,0,0,0.08); position: relative; }
        
        /* Cabecera con Logo Institucional */
        .header-container { display: flex; align-items: center; justify-content: space-between; border-bottom: 3px double #0f172a; padding-bottom: 15px; margin-bottom: 20px; }
        .header-logo { max-height: 75px; width: auto; object-fit: contain; }
        .header-text { text-align: right; flex-grow: 1; padding-left: 15px; }
        .header-text h2 { margin: 0; color: #0f172a; font-size: 20px; font-weight: 800; letter-spacing: 0.5px; }
        .header-text h3 { margin: 4px 0 0 0; font-size: 14px; color: #475569; font-weight: 600; }
        .header-text p { margin: 2px 0 0 0; font-size: 12px; color: #64748b; }

        .title { text-align: center; font-size: 15px; font-weight: bold; margin: 25px 0 20px 0; color: #1e3a8a; letter-spacing: 1px; text-transform: uppercase; }
        
        .data-table { width: 100%; border-collapse: collapse; margin: 20px 0; font-size: 13.5px; }
        .data-table td { padding: 9px 12px; border: 1px solid #cbd5e1; }
        .data-table td.label { font-weight: bold; width: 32%; background-color: #f8fafc; color: #0f172a; }

        .important-note { border-left: 4px solid #dc2626; background-color: #fef2f2; color: #991b1b; padding: 12px 16px; margin-top: 22px; font-size: 12px; border-radius: 4px; line-height: 1.5; }
        
        .footer-flex { display: flex; justify-content: space-between; align-items: flex-end; margin-top: 35px; padding-top: 15px; }
        .qr-box { display: flex; align-items: center; gap: 12px; }
        .qr-text { font-size: 11px; color: #64748b; max-width: 200px; line-height: 1.3; }

        .signature { text-align: center; width: 240px; }
        .signature-line { border-top: 1px solid #0f172a; margin-bottom: 6px; }

        @media print { .no-print { display: none !important; } body { background: #fff; margin: 0; } }
    </style>
</head>
<body>

<div class="no-print" style="text-align: center; margin-bottom: 20px; display: flex; justify-content: center; gap: 10px;">
    <button onclick="generarPDF()" style="padding: 10px 22px; background: #2563eb; color: white; border: none; cursor: pointer; font-size: 14px; border-radius: 6px; font-weight: bold; transition: 0.2s;">📥 Descargar Constancia PDF</button>
    <button onclick="window.print()" style="padding: 10px 22px; background: #0f172a; color: white; border: none; cursor: pointer; font-size: 14px; border-radius: 6px; font-weight: bold;">🖨️ Imprimir</button>
</div>

<div class="cert-container" id="contenidoConstancia">
    <div class="header-container">
        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Logo G.U.E. Andrómeda" class="header-logo">
        <div class="header-text">
            <h2>GRAN UNIDAD ESCOLAR ANDRÓMEDA</h2>
            <h3>Comisión Central de Admisión y Evaluación</h3>
            <p>II Simulacro Oficial de Admisión 2026</p>
        </div>
    </div>

    <div class="title">
        CONSTANCIA DE PREINSCRIPCIÓN VIRTUAL
    </div>

    <p style="text-align: justify; font-size: 13.5px; line-height: 1.7; color: #334155;">
        La Comisión de Admisión de la <b>Gran Unidad Escolar Andrómeda</b> certifica que don/doña 
        <b style="color: #0f172a;"><%= (alumno != null && alumno.getNombreCompleto() != null) ? alumno.getNombreCompleto().toUpperCase() : "---" %></b> 
        ha completado exitosamente su preinscripción en línea para participar en el <b>II Simulacro Oficial de Admisión 2026</b>.
    </p>

    <table class="data-table">
        <tr>
            <td class="label">Documento de Identidad (DNI):</td>
            <td><b><%= (alumno != null && alumno.getNumDocumento() != null) ? alumno.getNumDocumento() : "---" %></b></td>
        </tr>
        <tr>
            <td class="label">Grado y Sección:</td>
            <td><%= (alumno != null && alumno.getNombreGrado() != null) ? alumno.getNombreGrado() + " - " + alumno.getNombreSeccion() : "---" %></td>
        </tr>
        <tr>
            <td class="label">Área a la que postula:</td>
            <td><%= (postulante != null && postulante.getNombreArea() != null) ? postulante.getNombreArea() : "---" %></td>
        </tr>
        <tr>
            <td class="label">Carrera Profesional Destino:</td>
            <td><%= (postulante != null && postulante.getNombreCarrera() != null) ? postulante.getNombreCarrera() : "---" %></td>
        </tr>
        <tr>
            <td class="label">Correo Electrónico:</td>
            <td><%= (alumno != null && alumno.getCorreo() != null) ? alumno.getCorreo() : "---" %></td>
        </tr>
    </table>

    <p style="font-size: 12.5px; text-align: justify; color: #475569;">
        El registro ha sido verificado en la plataforma web oficial Andromeda y queda habilitado para la rendición de la evaluación.
    </p>

    <div class="important-note">
        <b>NOTA IMPORTANTE:</b> Para la validación el día del examen, el estudiante debe presentar esta constancia impresa o en formato digital, acompañada de su DNI físico.
    </div>

    <div class="footer-flex">
        <div class="qr-box">
            <div id="qrcode"></div>
            <div class="qr-text">
                <b>Verificación Digital QR</b><br>
                Código de validación institucional registrado en la G.U.E. Andrómeda.
            </div>
        </div>

        <div class="signature">
            <div class="signature-line"></div>
            <b style="font-size: 12px; color: #0f172a;">Comisión de Simulacro de Admisión</b><br>
            <span style="font-size: 11px; color: #64748b;">G.U.E. Andrómeda - Puno</span>
        </div>
    </div>

    <div style="text-align: right; font-size: 11px; color: #64748b; margin-top: 20px;">
        Puno, julio de 2026
    </div>
</div>

<script>
    // Generar Código QR mediante qrcode.js
    new QRCode(document.getElementById("qrcode"), {
        text: "<%= urlVerificacion %>",
        width: 75,
        height: 75
    });

    // Función para Exportar la Constancia directamente a PDF
    function generarPDF() {
        const elemento = document.getElementById('contenidoConstancia');
        const opciones = {
            margin:       10,
            filename:     'Constancia_Preinscripcion_<%= dniVal %>.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { scale: 2 },
            jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
        };
        html2pdf().set(opciones).from(elemento).save();
    }
</script>

</body>
</html>