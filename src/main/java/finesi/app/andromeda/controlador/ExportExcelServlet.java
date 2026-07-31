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

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "ExportExcelServlet", urlPatterns = {"/exportar/excel"})
public class ExportExcelServlet extends HttpServlet {

    private final ResultadoDAO resultadoDAO = new ResultadoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"Ranking_Simulacro_2026.csv\"");

        List<ResultadoDetalle> rankings = resultadoDAO.listarRankings();

        try (PrintWriter out = response.getWriter()) {
            // Cabecera CSV compatible con Excel
            out.println("Puesto;DNI;Postulante;Area;Carrera;Competencias (60);Psicotecnico (20);Redaccion (10);Entrevista (10);Puntaje Total (100)");

            for (ResultadoDetalle r : rankings) {
                out.printf("%d;%s;%s;%s;%s;%.2f;%.2f;%.2f;%.2f;%.2f%n",
                    r.getPosicionGeneral(),
                    r.getNumDocumento(),
                    r.getNombreAlumno(),
                    r.getAreaPostulacion(),
                    r.getCarreraProfesional(),
                    r.getNotaCompetencias(),
                    r.getNotaPsicotecnico(),
                    r.getNotaRedaccion(),
                    r.getNotaEntrevista(),
                    r.getPuntajeTotal()
                );
            }
        }
    }
}