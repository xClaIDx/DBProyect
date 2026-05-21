/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.AlumnoDAO;
import finesi.app.andromeda.modelo.Alumno;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "EditarAlumnoController", urlPatterns = {"/editarAlumno"})
public class EditarAlumnoController extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    // ==========================================================
    // PASO 1: Cuando el usuario hace clic en el botón "Editar" (GET)
    // ==========================================================
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Seguridad: Verificar sesión
        HttpSession sesion = request.getSession(false);
        if (sesion == null || sesion.getAttribute("adminLogueado") == null) {
            response.sendRedirect(request.getContextPath() + "/?estado=requiere_login");
            return;
        }

        // Capturar el ID de la URL (ej: /editarAlumno?id=5)
        String idParam = request.getParameter("id");
        if (idParam != null) {
            Long id = Long.parseLong(idParam);
            Alumno alumno = alumnoDAO.obtenerAlumnoPorId(id);
            
            if (alumno != null) {
                // Si encontramos al alumno, lo empaquetamos y lo mandamos a la vista de edición
                request.setAttribute("alumnoEditar", alumno);
                request.getRequestDispatcher("editar.jsp").forward(request, response);
                return;
            }
        }
        // Si hay error o no existe, volver a la tabla
        response.sendRedirect("alumnos");
    }

    // ==========================================================
    // PASO 2: Cuando el usuario le da "Guardar" al formulario (POST)
    // ==========================================================
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Capturar los datos actualizados del formulario
        Long id = Long.parseLong(request.getParameter("idAlumno"));
        String dni = request.getParameter("numDocumento");
        String nombres = request.getParameter("nombres");
        String apPaterno = request.getParameter("apPaterno");
        String apMaterno = request.getParameter("apMaterno");

        // 2. Armar el objeto
        Alumno alumnoEditado = new Alumno();
        alumnoEditado.setIdAlumno(id);
        alumnoEditado.setNumDocumento(dni);
        alumnoEditado.setNombres(nombres);
        alumnoEditado.setApPaterno(apPaterno);
        alumnoEditado.setApMaterno(apMaterno);

        // 3. Mandar a guardar
        boolean exito = alumnoDAO.actualizarAlumno(alumnoEditado);

        // 4. Redirigir
        if (exito) {
            response.sendRedirect("alumnos?mensaje=editado");
        } else {
            response.sendRedirect("alumnos?mensaje=error_editar");
        }
    }
}