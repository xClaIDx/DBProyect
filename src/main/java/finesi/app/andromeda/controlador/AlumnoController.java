/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.AlumnoDAO;
import finesi.app.andromeda.modelo.Alumno;
import finesi.app.andromeda.modelo.Usuario;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

/**
 * Controlador para gestionar la lista e inscripción de Alumnos.
 */
@WebServlet(name = "AlumnoController", urlPatterns = {"/alumnos"})
public class AlumnoController extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // BARRERA DE SEGURIDAD (Validación de Sesión y Rol)
        HttpSession sesion = request.getSession(false);
        Usuario user = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;
        
        if (user == null || (!"ADMIN".equals(user.getRol()) && !"DOCENTE".equals(user.getRol()))) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=requiere_login");
            return;
        }

        // 1. Obtener la lista de alumnos desde PostgreSQL
        // Nota: Si en tu AlumnoDAO el método se llama listarTodos() u obtenerPorDni, aseguramos la llamada
        List<Alumno> lista = alumnoDAO.listarAlumnos();
        
        // 2. Muestra de Métricas (KPIs)
        int totalAlumnos = (lista != null) ? lista.size() : 0;
        
        // 3. Inyección de atributos a la vista
        request.setAttribute("listaAlumnos", lista);
        request.setAttribute("totalRegistrados", totalAlumnos);
        
        // 4. Redirección a la vista protegida
        request.getRequestDispatcher("/assets/alumnos.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");

        String numDocumento = request.getParameter("numDocumento");
        String nombres = request.getParameter("nombres");
        String apPaterno = request.getParameter("apPaterno");
        String apMaterno = request.getParameter("apMaterno");
        String fechaNacimiento = request.getParameter("fechaNacimiento");
        String celular = request.getParameter("celular");
        String correo = request.getParameter("correo");
        
        int idGrado = 1;
        int idSeccion = 1;
        
        try {
            if (request.getParameter("idGrado") != null) {
                idGrado = Integer.parseInt(request.getParameter("idGrado"));
            }
            if (request.getParameter("idSeccion") != null) {
                idSeccion = Integer.parseInt(request.getParameter("idSeccion"));
            }
        } catch (NumberFormatException e) {
            // Valores por defecto en caso de formato inválido
        }

        // Construcción del objeto Alumno
        Alumno nuevoAlumno = new Alumno();
        nuevoAlumno.setNumDocumento(numDocumento);
        nuevoAlumno.setNombres(nombres);
        nuevoAlumno.setApPaterno(apPaterno);
        nuevoAlumno.setApMaterno(apMaterno);
        
        if (fechaNacimiento != null && !fechaNacimiento.isEmpty()) {
            nuevoAlumno.setFechaNacimiento(Date.valueOf(fechaNacimiento));
        }
        
        nuevoAlumno.setCelular(celular);
        nuevoAlumno.setCorreo(correo);
        nuevoAlumno.setIdGrado(idGrado);
        nuevoAlumno.setIdSeccion(idSeccion);

        // Registro atómico (crea cuenta de usuario DNI/DNI + Registro Alumno)
        boolean registrado = alumnoDAO.registrarAlumnoConUsuario(nuevoAlumno);

        if (registrado) {
            response.sendRedirect("alumnos?mensaje=registrado");
        } else {
            response.sendRedirect("alumnos?error=true");
        }
    }
}