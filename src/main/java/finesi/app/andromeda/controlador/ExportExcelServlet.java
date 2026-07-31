/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.ResultadoDAO;
import finesi.app.andromeda.modelo.ResultadoDetalle;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.xssf.usermodel.XSSFColor;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet(name = "ExportExcelServlet", urlPatterns = {"/exportarExcel", "/exportar/excel"})
public class ExportExcelServlet extends HttpServlet {

    private final ResultadoDAO resultadoDAO = new ResultadoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        // 1. Obtención de Filtros desde el Ranking
        String idPeriodoParam = request.getParameter("idPeriodo");
        Integer idPeriodo = null;
        if (idPeriodoParam != null && !idPeriodoParam.trim().isEmpty() && !idPeriodoParam.equals("0")) {
            try {
                idPeriodo = Integer.parseInt(idPeriodoParam);
            } catch (NumberFormatException e) {
                idPeriodo = null;
            }
        }

        String areaFiltro = request.getParameter("area");
        if (areaFiltro == null || areaFiltro.trim().isEmpty()) {
            areaFiltro = "TODAS";
        }

        // 2. Consulta de Datos desde la BD
        List<ResultadoDetalle> lista = resultadoDAO.listarRankingsPorPeriodo(idPeriodo);

        // 3. Filtrado secundario por Área Académica
        final String filtroArea = areaFiltro.toLowerCase().trim();
        if (!"todas".equals(filtroArea) && lista != null) {
            lista = lista.stream()
                .filter(r -> {
                    String a = (r.getAreaAcademica() != null) ? r.getAreaAcademica().toLowerCase() : "";
                    if (filtroArea.contains("ing") && a.contains("ing")) return true;
                    if (filtroArea.contains("bio") && a.contains("bio")) return true;
                    if (filtroArea.contains("soc") && a.contains("soc")) return true;
                    return a.equalsIgnoreCase(filtroArea);
                })
                .collect(Collectors.toList());
        }

        // 4. Configurar Content-Type oficial de Excel (.xlsx)
        String fileName = "Ranking_Simulacro_" + (idPeriodo != null ? idPeriodo : "General") + "_" + areaFiltro + ".xlsx";
        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");

        // 5. Construcción del Documento Excel estilizado
        try (Workbook workbook = new XSSFWorkbook();
             OutputStream out = response.getOutputStream()) {

            Sheet sheet = workbook.createSheet("Ranking Oficial");
            sheet.setDisplayGridlines(true);

            // --- ESTILOS DE FUENTE Y RELLENO ---
            // Título Principal
            CellStyle titleStyle = workbook.createCellStyle();
            Font titleFont = workbook.createFont();
            titleFont.setFontName("Calibri");
            titleFont.setFontHeightInPoints((short) 14);
            titleFont.setBold(true);
            titleFont.setColor(IndexedColors.WHITE.getIndex());
            titleStyle.setFont(titleFont);
            titleStyle.setFillForegroundColor(new XSSFColor(new byte[]{(byte) 15, (byte) 23, (byte) 42}, null)); // #0F172A
            titleStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            titleStyle.setAlignment(HorizontalAlignment.CENTER);
            titleStyle.setVerticalAlignment(VerticalAlignment.CENTER);

            // Encabezados de Columna
            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setFontName("Calibri");
            headerFont.setFontHeightInPoints((short) 11);
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(new XSSFColor(new byte[]{(byte) 30, (byte) 58, (byte) 138}, null)); // #1E3A8A
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);
            headerStyle.setAlignment(HorizontalAlignment.CENTER);
            headerStyle.setVerticalAlignment(VerticalAlignment.CENTER);
            headerStyle.setWrapText(true);

            // Bordes Finos
            CellStyle baseStyle = workbook.createCellStyle();
            baseStyle.setBorderTop(BorderStyle.THIN);
            baseStyle.setBorderBottom(BorderStyle.THIN);
            baseStyle.setBorderLeft(BorderStyle.THIN);
            baseStyle.setBorderRight(BorderStyle.THIN);

            // Formato Decimal (0.00)
            DataFormat format = workbook.createDataFormat();
            CellStyle numberStyle = workbook.createCellStyle();
            numberStyle.cloneStyleFrom(baseStyle);
            numberStyle.setDataFormat(format.getFormat("0.00"));

            // Estilo para Ingresante Top 3 (Amarillo suave)
            CellStyle top3Style = workbook.createCellStyle();
            top3Style.cloneStyleFrom(baseStyle);
            top3Style.setFillForegroundColor(new XSSFColor(new byte[]{(byte) 254, (byte) 243, (byte) 199}, null)); // #FEF3C7
            top3Style.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            // --- FILAS DE ENCABEZADO ---
            // Fila 1: Banner Título
            Row rowTitle = sheet.createRow(0);
            rowTitle.setHeightInPoints(35);
            Cell cellTitle = rowTitle.createCell(0);
            cellTitle.setCellValue("GRAN UNIDAD ESCOLAR ANDRÓMEDA — CUADRO GENERAL DE MÉRITOS");
            cellTitle.setCellStyle(titleStyle);
            sheet.addMergedRegion(new CellRangeAddress(0, 0, 0, 10));

            // Fila 2: Cabeceras de Tabla
            Row rowHeader = sheet.createRow(2);
            rowHeader.setHeightInPoints(28);
            String[] headers = {
                "Puesto", "DNI", "Apellidos y Nombres", "Área Académica", "Carrera Profesional",
                "Competencias (60pts)", "Psicotécnico (20pts)", "Redacción (10pts)", "Entrevista (10pts)",
                "Puntaje Total (100pts)", "Condición"
            };

            for (int i = 0; i < headers.length; i++) {
                Cell cell = rowHeader.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            // --- LLENADO DE DATOS ---
            int rowIndex = 3;
            if (lista != null && !lista.isEmpty()) {
                for (ResultadoDetalle r : lista) {
                    Row row = sheet.createRow(rowIndex++);
                    row.setHeightInPoints(22);

                    boolean esTop3 = (r.getPosicionGeneral() != null && r.getPosicionGeneral() <= 3 && r.getPosicionGeneral() > 0);
                    CellStyle currentStyle = esTop3 ? top3Style : baseStyle;

                    // Columnas de Texto
                    createCell(row, 0, "N° " + (r.getPosicionGeneral() != null ? r.getPosicionGeneral() : 0), currentStyle);
                    createCell(row, 1, r.getNumDocumento() != null ? r.getNumDocumento() : "", currentStyle);
                    createCell(row, 2, r.getNombreAlumno() != null ? r.getNombreAlumno() : "", currentStyle);
                    createCell(row, 3, r.getAreaAcademica() != null ? r.getAreaAcademica() : "", currentStyle);
                    createCell(row, 4, r.getCarreraProfesional() != null ? r.getCarreraProfesional() : "", currentStyle);

                    // Columnas Numéricas con Formato 0.00
                    createNumberCell(row, 5, r.getNotaCompetencias() != null ? r.getNotaCompetencias().doubleValue() : 0.0, numberStyle);
                    createNumberCell(row, 6, r.getNotaPsicotecnico() != null ? r.getNotaPsicotecnico().doubleValue() : 0.0, numberStyle);
                    createNumberCell(row, 7, r.getNotaRedaccion() != null ? r.getNotaRedaccion().doubleValue() : 0.0, numberStyle);
                    createNumberCell(row, 8, r.getNotaEntrevista() != null ? r.getNotaEntrevista().doubleValue() : 0.0, numberStyle);
                    createNumberCell(row, 9, r.getPuntajeTotal() != null ? r.getPuntajeTotal().doubleValue() : 0.0, numberStyle);

                    // Condición
                    createCell(row, 10, esTop3 ? "INGRESANTE TOP 3" : "EVALUADO", currentStyle);
                }
            }

            // Ajuste automático del ancho de columnas
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
                sheet.setColumnWidth(i, sheet.getColumnWidth(i) + 1200); // Espaciado extra
            }

            // Guardar flujo de salida
            workbook.write(out);
            out.flush();
        }
    }

    private void createCell(Row row, int column, String value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }

    private void createNumberCell(Row row, int column, double value, CellStyle style) {
        Cell cell = row.createCell(column);
        cell.setCellValue(value);
        cell.setCellStyle(style);
    }
}