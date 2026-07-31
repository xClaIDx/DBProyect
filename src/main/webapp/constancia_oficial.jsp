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
    String dniVal = (alumno != null) ? alumno.getNumDocumento() : "00000000";
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Constancia de Preinscripción Virtual</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; color: #111; }
        .cert-container { border: 2px solid #002b49; padding: 40px; max-width: 800px; margin: 0 auto; position: relative; }
        .header { text-align: center; margin-bottom: 25px; }
        .header h2 { margin: 0; font-size: 20px; color: #002b49; }
        .header h3 { margin: 5px 0; font-size: 14px; text-transform: uppercase; color: #444; }
        .title { text-align: center; font-size: 15px; font-weight: bold; margin: 20px 0; text-decoration: underline; color: #002b49; }
        .data-list { font-size: 14px; line-height: 2; margin: 20px 0; }
        .data-list b { width: 200px; display: inline-block; color: #333; }
        .important-note { border: 1px solid #d9534f; background-color: #f2dede; color: #a94442; padding: 12px; margin-top: 20px; font-size: 12px; }
        .qr-box { text-align: center; margin-top: 25px; }
        .qr-box img { width: 110px; height: 110px; border: 1px solid #ccc; padding: 3px; }
        .footer-flex { display: flex; justify-content: space-between; align-items: flex-end; margin-top: 40px; }
        .signature { text-align: center; width: 250px; }
        .signature-line { border-top: 1px solid #000; margin-bottom: 5px; }
        @media print { .no-print { display: none; } }
    </style>
</head>
<body>

<div class="no-print" style="text-align: center; margin-bottom: 20px;">
    <button onclick="window.print()" style="padding: 10px 20px; background: #002b49; color: white; border: none; cursor: pointer; font-size: 14px; border-radius: 4px; font-weight: bold;">🖨️ Imprimir / Guardar en PDF</button>
</div>

<div class="cert-container">
    <div class="header">
        <h2>UNIVERSIDAD MERCEDARIA "SAN PEDRO NOLASCO"</h2>
        <h3>Comisión de Admisión</h3>
    </div>

    <div class="title">
        CONSTANCIA DE PREINSCRIPCIÓN VIRTUAL DEL II - SIMULACRO DE ADMISIÓN 2026
    </div>

    <p style="text-align: justify; font-size: 14px;">
        La Comisión de Admisión certifica que don/doña <b><%= (alumno != null) ? alumno.getNombreCompleto().toUpperCase() : "---" %></b> 
        ha completado exitosamente su preinscripción en línea para participar en el II Simulacro de Admisión 2026.
    </p>

    <div class="data-list">
        <div><b>DNI:</b> <%= (alumno != null) ? alumno.getNumDocumento() : "---" %></div>
        <div><b>Grado y Sección:</b> <%= (alumno != null) ? alumno.getNombreGrado() + " - " + alumno.getNombreSeccion() : "---" %></div>
        <div><b>Área a la que postula:</b> <%= (postulante != null) ? postulante.getNombreArea() : "---" %></div>
        <div><b>Carrera Profesional:</b> <%= (postulante != null) ? postulante.getNombreCarrera() : "---" %></div>
        <div><b>Correo Electrónico:</b> <%= (alumno != null) ? alumno.getCorreo() : "---" %></div>
    </div>

    <p style="font-size: 13px; text-align: justify;">
        El registro ha sido confirmado en línea y queda registrado para el proceso académico actual.
    </p>

    <div class="important-note">
        <b>NOTA IMPORTANTE:</b> Para la inscripción presencial, debe portar esta constancia impresa, con copia de su DNI, y el Informe de competencias académicas del presente Bimestre.
    </div>

    <div class="footer-flex">
        <!-- Código QR Dinámico de Validación -->
        <div class="qr-box">
            <img src="https://api.qrserver.com/v1/create-qr-code/?size=150x150&data=CONSTANCIA-ANDROMEDA-DNI-<%= dniVal %>" alt="QR Verificación">
            <div style="font-size: 10px; color: #666; margin-top: 3px;">Código de Verificación</div>
        </div>

        <div class="signature">
            <div class="signature-line"></div>
            <b style="font-size: 12px;">Comisión de Simulacro de Admisión</b><br>
            <span style="font-size: 11px;">Universidad Mercedaria "San Pedro Nolasco"</span>
        </div>
    </div>

    <div style="text-align: right; font-size: 11px; color: #555; margin-top: 20px;">
        Puno, julio de 2026
    </div>
</div>

</body>
</html>