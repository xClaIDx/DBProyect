package finesi.app.andromeda.controlador;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */


import finesi.app.andromeda.dao.AlumnoDAO;
import finesi.app.andromeda.modelo.Alumno;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CertificadoServlet", urlPatterns = {"/certificado"})
public class CertificadoServlet extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String dni = request.getParameter("dni");
        
        if (dni != null && !dni.trim().isEmpty()) {
            // Buscamos la data relacional completa del alumno
            Alumno certificado = alumnoDAO.obtenerDatosCertificado(dni);
            
            if (certificado != null) {
                // Inyectamos el objeto 'alumno' a la vista
                request.setAttribute("alumno", certificado);
                request.getRequestDispatcher("certificado.jsp").forward(request, response);
                return; // Cortamos la ejecución aquí
            }
        }
        
        // Si no envía DNI o no se encuentra, lo devolvemos al inicio
        response.sendRedirect(request.getContextPath() + "/home?estado=error");
    }
}