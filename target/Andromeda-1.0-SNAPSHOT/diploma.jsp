<%-- 
    Document   : diploma
    Created on : 30 jul 2026, 9:49:01 p.m.
    Author     : klaidneil
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="finesi.app.andromeda.modelo.ResultadoDetalle"%>
<%
    ResultadoDetalle res = (ResultadoDetalle) request.getAttribute("resultado");
    String urlVerificacion = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() 
                            + request.getContextPath() + "/diploma?dni=" + (res != null ? res.getNumDocumento() : "");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Diploma de Honor - G.U.E. Andrómeda</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>

    <style>
        body { font-family: 'Georgia', serif; background-color: #fcfbfa; padding: 20px; text-align: center; }
        .diploma-box { border: 10px double #b8860b; padding: 35px 45px; max-width: 880px; margin: 0 auto; background: #fff; box-shadow: 0 0 25px rgba(0,0,0,0.12); position: relative; }
        
        .diploma-header { display: flex; align-items: center; justify-content: center; gap: 20px; margin-bottom: 10px; }
        .diploma-logo { max-height: 85px; width: auto; object-fit: contain; }
        .header-titles h1 { color: #002b49; font-size: 24px; margin: 0; font-family: 'Times New Roman', serif; text-transform: uppercase; letter-spacing: 1px; }
        .header-titles h3 { color: #b8860b; font-size: 14px; margin-top: 4px; text-transform: uppercase; letter-spacing: 1.5px; }

        .title { font-size: 28px; font-weight: bold; margin: 20px 0; color: #002b49; text-transform: uppercase; letter-spacing: 2px; }
        .recipient { font-size: 23px; font-weight: bold; color: #b8860b; border-bottom: 2px solid #b8860b; display: inline-block; padding: 4px 28px; margin: 12px 0; }
        .body-text { font-size: 15px; line-height: 1.8; color: #333; margin: 18px 25px; text-align: center; }
        
        .footer-signatures { margin-top: 45px; display: flex; justify-content: space-around; align-items: flex-end; }
        .signature { border-top: 1px solid #333; width: 210px; font-size: 12px; padding-top: 6px; color: #1e293b; }
        
        .qr-seal { display: flex; justify-content: space-between; align-items: center; margin-top: 35px; padding-top: 12px; border-top: 1px solid #f1f5f9; }
        
        @media print { .no-print { display: none !important; } body { background: none; padding: 0; } }
    </style>
</head>
<body>

<div class="no-print" style="margin-bottom: 20px; display: flex; justify-content: center; gap: 10px;">
    <button onclick="generarPDF()" style="padding: 10px 24px; background: #b8860b; color: white; border: none; font-size: 14px; cursor: pointer; border-radius: 6px; font-weight: bold;">📥 Descargar Diploma PDF</button>
    <button onclick="window.print()" style="padding: 10px 24px; background: #002b49; color: white; border: none; font-size: 14px; cursor: pointer; border-radius: 6px; font-weight: bold;">🖨️ Imprimir</button>
</div>

<div class="diploma-box" id="contenidoDiploma">
    <div class="diploma-header">
        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Logo G.U.E. Andrómeda" class="diploma-logo">
        <div class="header-titles">
            <h1>GRAN UNIDAD ESCOLAR ANDRÓMEDA</h1>
            <h3>Comisión de Admisión & Gobierno Académico</h3>
        </div>
    </div>

    <div class="title">DIPLOMA DE MERITO Y HONOR</div>

    <p style="font-size: 14px; color: #555; margin: 0;">Otorgado con distinción especial a:</p>

    <div class="recipient">
        <%= (res != null) ? res.getNombreAlumno().toUpperCase() : "NOMBRE DEL ESTUDIANTE" %>
    </div>

    <div class="body-text">
        Por haber obtenido el destacado <b>PUESTO N° <%= (res != null) ? res.getPosicionGeneral() : "1" %></b> en el Cómputo General del
        <b>II Simulacro de Admisión 2026</b>, alcanzando un puntaje sobresaliente de 
        <b><%= (res != null) ? res.getPuntajeTotal() : "0.00" %> puntos</b> en la carrera profesional de 
        <b><%= (res != null) ? res.getCarreraProfesional() : "CARRERA" %></b>.
    </div>

    <div class="footer-signatures">
        <div class="signature">
            <b>Comisión de Simulacro</b><br>
            Presidente de Admisión
        </div>
        <div class="signature">
            <b>Dirección General</b><br>
            G.U.E. Andrómeda
        </div>
    </div>

    <div class="qr-seal">
        <div id="qrcode"></div>
        <div style="text-align: right; font-size: 11px; color: #64748b;">
            Puno, julio de 2026<br>
            <i>Documento Oficial Emitido por el Sistema Integrado Andromeda</i>
        </div>
    </div>
</div>

<script>
    <% if (res != null) { %>
    new QRCode(document.getElementById("qrcode"), {
        text: "<%= urlVerificacion %>",
        width: 75,
        height: 75
    });
    <% } %>

    function generarPDF() {
        const elemento = document.getElementById('contenidoDiploma');
        const opciones = {
            margin:       8,
            filename:     'Diploma_Honor_GUE_Andromeda_<%= (res != null) ? res.getNumDocumento() : "Estudiante" %>.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { scale: 2 },
            jsPDF:        { unit: 'mm', format: 'a4', orientation: 'landscape' }
        };
        html2pdf().set(opciones).from(elemento).save();
    }
</script>

</body>
</html>