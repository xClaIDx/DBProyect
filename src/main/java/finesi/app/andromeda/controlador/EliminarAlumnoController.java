/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.AlumnoDAO;
import finesi.app.andromeda.modelo.Usuario;

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
        
        HttpSession sesion = request.getSession(false);
        Usuario user = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;

        if (user == null || !"ADMIN".equals(user.getRol())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=sin_permiso");
            return;
        }

        String idParam = request.getParameter("idAlumno");
        
        if (idParam != null && !idParam.isEmpty()) {
            try {
                Long id = Long.parseLong(idParam);
                boolean exito = alumnoDAO.eliminarAlumno(id);
                
                if (exito) {
                    request.getSession().setAttribute("msgExitoAdmin", "Alumno eliminado correctamente de la base de datos.");
                } else {
                    request.getSession().setAttribute("msgErrorAdmin", "No se pudo eliminar el registro del alumno.");
                }
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("msgErrorAdmin", "ID de alumno inválido.");
            }
        }
        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
    }
}