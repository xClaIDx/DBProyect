/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.AlumnoDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Controlador principal encargado de cargar la portada y formularios.
 */
@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // Precarga opcional de listas si el DAO cuenta con metodos maestros
            var grados = alumnoDAO.obtenerGrados();
            var periodos = alumnoDAO.obtenerPeriodosActivos();
            var areas = alumnoDAO.obtenerAreas();

            request.setAttribute("mapaGrados", grados);
            request.setAttribute("mapaPeriodos", periodos);
            request.setAttribute("listaAreas", areas);

        } catch (Exception e) {
            // Manejo preventivo si los catálogos aún no están poblados
            System.out.println("[INFO ANDROMEDA] Cargando portada inicial (sin maestras o conectando): " + e.getMessage());
        }

        // Redirige directamente al index.jsp principal
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}