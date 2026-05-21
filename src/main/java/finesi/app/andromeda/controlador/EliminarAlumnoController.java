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
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "EliminarAlumnoController", urlPatterns = {"/eliminarAlumno"})
public class EliminarAlumnoController extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. SEGURIDAD: Validar que el administrador tenga su sesión activa
        HttpSession sesion = request.getSession(false);
        if (sesion == null || sesion.getAttribute("adminLogueado") == null) {
            response.sendRedirect(request.getContextPath() + "/?estado=requiere_login");
            return;
        }

        // 2. Capturar el ID del alumno que viene desde el botón de la vista
        String idParam = request.getParameter("idAlumno");
        
        if (idParam != null && !idParam.isEmpty()) {
            try {
                Long id = Long.parseLong(idParam);
                
                // 3. Ejecutar la eliminación
                boolean exito = alumnoDAO.eliminarAlumno(id);
                
                // 4. Redirigir al dashboard con un mensaje de éxito o error
                if (exito) {
                    response.sendRedirect("alumnos?mensaje=eliminado");
                } else {
                    response.sendRedirect("alumnos?mensaje=error_eliminar");
                }
            } catch (NumberFormatException e) {
                // Si alguien altera el HTML y envía letras en vez de un número
                response.sendRedirect("alumnos?mensaje=error_eliminar");
            }
        }
    }
}