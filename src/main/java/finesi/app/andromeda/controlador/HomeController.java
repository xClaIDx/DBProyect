/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.AlumnoDAO; // <--- Importa TU DAO REAL
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "HomeController", urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    // 1. Instanciamos tu DAO real
    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 2. Cargamos los datos reales desde la BD
        request.setAttribute("mapaGrados", alumnoDAO.obtenerGrados());
        request.setAttribute("mapaPeriodos", alumnoDAO.obtenerPeriodosActivos());
        
        // (Asegúrate de tener también un método en DAO para listar áreas)
        // request.setAttribute("listaAreas", alumnoDAO.listarAreas());
        
        // 3. Enviamos a la vista
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }
}