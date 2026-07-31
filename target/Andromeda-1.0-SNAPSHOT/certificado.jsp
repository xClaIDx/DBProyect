<%-- 
    Document   : certificado
    Created on : 21 may. 2026, 9:28:30 a. m.
    Author     : klaidneil
--%>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="finesi.app.andromeda.modelo.ResultadoDetalle"%>
<%
    ResultadoDetalle res = (ResultadoDetalle) request.getAttribute("resultado");
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ficha de Resultados de Examen</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 30px; color: #222; }
        .cert-box { border: 2px solid #002b49; padding: 30px; max-width: 800px; margin: 0 auto; }
        .header { text-align: center; border-bottom: 2px solid #002b49; padding-bottom: 15px; margin-bottom: 20px; }
        .header h2 { margin: 0; color: #002b49; font-size: 22px; }
        .header h3 { margin: 5px 0 0 0; font-size: 16px; color: #555; }
        .table-data { width: 100%; border-collapse: collapse; margin-bottom: 20px; font-size: 14px; }
        .table-data td { padding: 6px 10px; }
        .table-data td.label { font-weight: bold; width: 30%; background-color: #f2f2f2; }
        .table-results { width: 100%; border-collapse: collapse; margin-top: 15px; font-size: 14px; }
        .table-results th, .table-results td { border: 1px solid #333; padding: 8px 12px; text-align: center; }
        .table-results th { background-color: #002b49; color: white; }
        .total-row { font-weight: bold; background-color: #e6f2ff; }
        .footer-date { margin-top: 30px; text-align: right; font-size: 13px; }
        @media print { .no-print { display: none; } }
    </style>
</head>
<body>

<div class="no-print" style="text-align: center; margin-bottom: 20px;">
    <button onclick="window.print()" style="padding: 10px 20px; background: #002b49; color: white; border: none; cursor: pointer; font-size: 14px; border-radius: 4px;">🖨️ Imprimir Ficha de Resultados</button>
</div>

<div class="cert-box">
    <div class="header">
        <h2>UNIVERSIDAD MERCEDARIA "SAN PEDRO NOLASCO"</h2>
        <h3><%= (res != null) ? res.getNombreExamen() : "II Simulacro de Admisión 2026" %></h3>
    </div>

    <h4 style="text-align: center; margin-bottom: 15px;">CONSTANCIA OFICIAL DE RESULTADOS</h4>

    <% if (res != null) { %>
    <table class="table-data" border="1" bordercolor="#ccc">
        <tr>
            <td class="label">Participante:</td>
            <td><b><%= res.getNombreAlumno() %></b></td>
        </tr>
        <tr>
            <td class="label">Documento de Identidad:</td>
            <td><%= res.getNumDocumento() %></td>
        </tr>
        <tr>
            <td class="label">Grado y Sección:</td>
            <td><%= res.getGradoSeccion() %></td>
        </tr>
        <tr>
            <td class="label">Área a la que postula:</td>
            <td><%= res.getAreaPostulacion() %></td>
        </tr>
        <tr>
            <td class="label">Carrera Profesional:</td>
            <td><%= res.getCarreraProfesional() %></td>
        </tr>
        <tr>
            <td class="label">Fecha de Evaluación:</td>
            <td><%= res.getFechaExamen() %></td>
        </tr>
    </table>

    <h5 style="margin-top: 20px;">Desglose de Calificaciones por Criterio:</h5>
    <table class="table-results">
        <thead>
            <tr>
                <th>Prueba / Criterio</th>
                <th>Calificativo Obtenido</th>
                <th>Calificativo Ideal</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td style="text-align: left;">Competencias académicas (70 preguntas)</td>
                <td><b><%= res.getNotaCompetencias() %></b></td>
                <td>60 puntos</td>
            </tr>
            <tr>
                <td style="text-align: left;">Psicotécnico (20 preguntas)</td>
                <td><b><%= res.getNotaPsicotecnico() %></b></td>
                <td>20 puntos</td>
            </tr>
            <tr>
                <td style="text-align: left;">Prueba de redacción</td>
                <td><b><%= res.getNotaRedaccion() %></b></td>
                <td>10 puntos</td>
            </tr>
            <tr>
                <td style="text-align: left;">Entrevista personal</td>
                <td><b><%= res.getNotaEntrevista() %></b></td>
                <td>10 puntos</td>
            </tr>
            <tr class="total-row">
                <td style="text-align: left;">Puntaje total</td>
                <td style="color: #002b49; font-size: 16px;"><b><%= res.getPuntajeTotal() %></b></td>
                <td>100 puntos</td>
            </tr>
        </tbody>
    </table>

    <div style="margin-top: 20px; font-size: 13px;">
        <span>Posición General: <b><%= res.getPosicionGeneral() %></b></span> | 
        <span>Posición en Carrera: <b><%= res.getPosicionCarrera() %></b></span>
    </div>

    <div class="footer-date">
        Puno, julio de 2026
    </div>
    <% } else { %>
        <p style="text-align: center; color: red;">No se encontraron resultados registrados para este estudiante.</p>
    <% } %>
</div>

</body>
</html>