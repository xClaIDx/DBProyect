<%-- 
    Document   : certificado
    Created on : 21 may. 2026, 9:28:30 a. m.
    Author     : klaidneil
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="finesi.app.andromeda.modelo.ResultadoDetalle"%>
<%
    ResultadoDetalle res = (ResultadoDetalle) request.getAttribute("resultado");
    String urlVerificacion = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() 
                            + request.getContextPath() + "/documento?tipo=boleta&dni=" + (res != null ? res.getNumDocumento() : "");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Constancia de Resultados - G.U.E. Andrómeda</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; margin: 20px; color: #222; background-color: #f4f6f9; }
        .cert-box { border: 2px solid #0f172a; padding: 35px; max-width: 800px; margin: 0 auto; background: #fff; box-shadow: 0 4px 12px rgba(0,0,0,0.08); }
        
        /* Cabecera con Logo Institucional */
        .header-container { display: flex; align-items: center; justify-content: space-between; border-bottom: 3px double #0f172a; padding-bottom: 15px; margin-bottom: 20px; }
        .header-logo { max-height: 75px; width: auto; object-fit: contain; }
        .header-text { text-align: right; flex-grow: 1; padding-left: 15px; }
        .header-text h2 { margin: 0; color: #0f172a; font-size: 20px; font-weight: 800; letter-spacing: 0.5px; }
        .header-text h3 { margin: 4px 0 0 0; font-size: 14px; color: #475569; font-weight: 600; }
        .header-text p { margin: 2px 0 0 0; font-size: 12px; color: #64748b; }

        .document-title { text-align: center; margin: 20px 0; color: #1e3a8a; font-size: 16px; font-weight: bold; letter-spacing: 1.5px; text-transform: uppercase; }

        .table-data { width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 13.5px; }
        .table-data td { padding: 8px 12px; border: 1px solid #cbd5e1; }
        .table-data td.label { font-weight: bold; width: 35%; background-color: #f8fafc; color: #1e293b; }
        
        .table-results { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 13.5px; }
        .table-results th, .table-results td { border: 1px solid #475569; padding: 8px 12px; text-align: center; }
        .table-results th { background-color: #0f172a; color: white; font-weight: 600; }
        .total-row { font-weight: bold; background-color: #eff6ff; }
        
        .qr-section { display: flex; justify-content: space-between; align-items: center; margin-top: 25px; padding-top: 15px; border-top: 1px dashed #cbd5e1; }
        .qr-box { display: flex; align-items: center; gap: 15px; }
        .qr-text { font-size: 11px; color: #64748b; max-width: 260px; line-height: 1.35; }
        .footer-date { text-align: right; font-size: 12px; font-weight: bold; color: #0f172a; }

        @media print { .no-print { display: none !important; } body { background: #fff; margin: 0; } }
    </style>
</head>
<body>

<div class="no-print" style="text-align: center; margin-bottom: 20px; display: flex; justify-content: center; gap: 10px;">
    <button onclick="generarPDF()" style="padding: 10px 22px; background: #2563eb; color: white; border: none; cursor: pointer; font-size: 14px; border-radius: 6px; font-weight: bold; transition: 0.2s;">📥 Descargar Constancia PDF</button>
    <button onclick="window.print()" style="padding: 10px 22px; background: #0f172a; color: white; border: none; cursor: pointer; font-size: 14px; border-radius: 6px; font-weight: bold;">🖨️ Imprimir</button>
</div>

<div class="cert-box" id="contenidoDocumento">
    <div class="header-container">
        <img src="${pageContext.request.contextPath}/assets/images/logo.png" alt="Logo G.U.E. Andrómeda" class="header-logo">
        <div class="header-text">
            <h2>GRAN UNIDAD ESCOLAR ANDRÓMEDA</h2>
            <h3>Comisión Central de Admisión y Evaluación</h3>
            <p><%= (res != null) ? res.getNombreExamen() : "II Simulacro Oficial de Admisión 2026" %></p>
        </div>
    </div>

    <div class="document-title">CONSTANCIA OFICIAL DE RESULTADOS</div>

    <% if (res != null) { %>
    <table class="table-data">
        <tr>
            <td class="label">Estudiante / Postulante:</td>
            <td><b><%= res.getNombreAlumno() %></b></td>
        </tr>
        <tr>
            <td class="label">Documento de Identidad (DNI):</td>
            <td><%= res.getNumDocumento() %></td>
        </tr>
        <tr>
            <td class="label">Área Académica:</td>
            <td><%= res.getAreaAcademica() %></td>
        </tr>
        <tr>
            <td class="label">Carrera Profesional Destino:</td>
            <td><%= res.getCarreraProfesional() %></td>
        </tr>
    </table>

    <h5 style="margin-top: 18px; margin-bottom: 8px; color: #0f172a; font-size: 14px;">Cuadro Desglosado de Calificaciones:</h5>
    <table class="table-results">
        <thead>
            <tr>
                <th>Criterio / Evaluación</th>
                <th>Puntaje Obtenido</th>
                <th>Puntaje Máximo</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td style="text-align: left;">Competencias Académicas</td>
                <td><b><%= res.getNotaCompetencias() %></b></td>
                <td>60.00 pts</td>
            </tr>
            <tr>
                <td style="text-align: left;">Evaluación Psicotécnica</td>
                <td><b><%= res.getNotaPsicotecnico() %></b></td>
                <td>20.00 pts</td>
            </tr>
            <tr>
                <td style="text-align: left;">Prueba de Redacción</td>
                <td><b><%= res.getNotaRedaccion() %></b></td>
                <td>10.00 pts</td>
            </tr>
            <tr>
                <td style="text-align: left;">Entrevista Personal</td>
                <td><b><%= res.getNotaEntrevista() %></b></td>
                <td>10.00 pts</td>
            </tr>
            <tr class="total-row">
                <td style="text-align: left;">PUNTAJE TOTAL ACUMULADO</td>
                <td style="color: #1e3a8a; font-size: 15px;"><b><%= res.getPuntajeTotal() %></b></td>
                <td>100.00 pts</td>
            </tr>
        </tbody>
    </table>

    <div style="margin-top: 18px; font-size: 13px; background: #f1f5f9; padding: 10px; border-radius: 6px; text-align: center; border: 1px solid #e2e8f0;">
        <span>Mérito General Obtenido: <b style="color: #0f172a;">Puesto N° <%= res.getPosicionGeneral() %></b></span>
    </div>

    <div class="qr-section">
        <div class="qr-box">
            <div id="qrcode"></div>
            <div class="qr-text">
                <b>Verificación Digital QR</b><br>
                Escanea este código para validar la autenticidad del documento registrado en la plataforma G.U.E. Andrómeda.
            </div>
        </div>
        <div class="footer-date">
            Puno, julio de 2026
        </div>
    </div>
    <% } else { %>
        <p style="text-align: center; color: #ef4444; font-weight: bold; margin: 40px 0;">No se encontraron registros de evaluación para el estudiante consultado.</p>
    <% } %>
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
        const elemento = document.getElementById('contenidoDocumento');
        const opciones = {
            margin:       10,
            filename:     'Constancia_GUE_Andromeda_<%= (res != null) ? res.getNumDocumento() : "Estudiante" %>.pdf',
            image:        { type: 'jpeg', quality: 0.98 },
            html2canvas:  { scale: 2 },
            jsPDF:        { unit: 'mm', format: 'a4', orientation: 'portrait' }
        };
        html2pdf().set(opciones).from(elemento).save();
    }
</script>

</body>
</html>