/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.AlumnoDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Controlador principal encargado de precargar los datos maestros
 * en el formulario de inscripción pública.
 */
@WebServlet(name = "HomeController", urlPatterns = {"/home", ""})
public class HomeController extends HttpServlet {

    // Instanciamos de forma segura el DAO real que acabamos de compilar
    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 1. Extraemos los mapas y listas reales desde PostgreSQL
            var grados = alumnoDAO.obtenerGrados();
            var periodos = alumnoDAO.obtenerPeriodosActivos();
            var areas = alumnoDAO.obtenerAreas();

            // 2. Inyectamos los datos en el objeto request con nombres idénticos a los del JSP
            request.setAttribute("mapaGrados", grados);
            request.setAttribute("mapaPeriodos", periodos);
            request.setAttribute("listaAreas", areas);

            // 3. Despachamos el flujo directamente hacia la vista index.jsp
            request.getRequestDispatcher("index.jsp").forward(request, response);
            
        } catch (Exception e) {
            // Log de seguridad en consola por si la conexión a la BD llega a fallar aquí
            System.err.println("[ERROR ANDROMEDA] Error crítico en HomeController al cargar maestros: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("index.jsp?error=ErrorInternoServidor");
        }
    }
}