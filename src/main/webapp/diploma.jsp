<%-- 
    Document   : diploma
    Created on : 30 jul 2026, 9:49:01 p.m.
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
    <title>Diploma de Honor Oficial</title>
    <style>
        body { font-family: 'Georgia', serif; background-color: #fcfbfa; padding: 30px; text-align: center; }
        .diploma-box { border: 10px double #b8860b; padding: 40px; max-width: 900px; margin: 0 auto; background: #fff; box-shadow: 0 0 20px rgba(0,0,0,0.15); }
        .header h1 { color: #002b49; font-size: 28px; margin: 0; }
        .header h3 { color: #b8860b; font-size: 18px; margin-top: 5px; text-transform: uppercase; }
        .title { font-size: 32px; font-weight: bold; margin: 30px 0; color: #002b49; text-transform: uppercase; letter-spacing: 2px; }
        .recipient { font-size: 26px; font-weight: bold; color: #b8860b; border-bottom: 2px solid #b8860b; display: inline-block; padding: 5px 30px; margin: 15px 0; }
        .body-text { font-size: 16px; line-height: 1.8; color: #333; margin: 25px 40px; }
        .footer { margin-top: 60px; display: flex; justify-content: space-around; }
        .signature { border-top: 1px solid #333; width: 220px; font-size: 12px; padding-top: 5px; }
        @media print { .no-print { display: none; } }
    </style>
</head>
<body>

<div class="no-print" style="margin-bottom: 20px;">
    <button onclick="window.print()" style="padding: 10px 25px; background: #b8860b; color: white; border: none; font-size: 16px; cursor: pointer; border-radius: 4px; font-weight: bold;">🖨️ Imprimir Diploma de Honor</button>
</div>

<div class="diploma-box">
    <div class="header">
        <h1>UNIVERSIDAD MERCEDARIA "SAN PEDRO NOLASCO"</h1>
        <h3>Comisión de Admisión & Gobierno Académico</h3>
    </div>

    <div class="title">DIPLOMA DE MERITO Y HONOR</div>

    <p style="font-size: 15px; color: #555;">Otorgado con distinción especial a:</p>

    <div class="recipient">
        <%= (res != null) ? res.getNombreAlumno().toUpperCase() : "NOMBRE DEL ESTUDIANTE" %>
    </div>

    <div class="body-text">
        Por haber obtenido el <b>PUESTO N° <%= (res != null) ? res.getPosicionGeneral() : "1" %></b> en el Cómputo General del
        <b>II Simulacro de Admisión 2026</b>, alcanzando un puntaje destacado de 
        <b><%= (res != null) ? res.getPuntajeTotal() : "0.00" %> puntos</b> para la carrera profesional de 
        <b><%= (res != null) ? res.getCarreraProfesional() : "CARRERA" %></b>.
    </div>

    <div class="footer">
        <div class="signature">
            <b>Comisión de Simulacro</b><br>
            Presidente de Admisión
        </div>
        <div class="signature">
            <b>Rectorado</b><br>
            Universidad Mercedaria
        </div>
    </div>

    <p style="font-size: 11px; color: #888; margin-top: 40px;">Puno, julio de 2026 — Documento Oficial Emitido por el Sistema Integrado Andromeda</p>
</div>

</body>
</html>
