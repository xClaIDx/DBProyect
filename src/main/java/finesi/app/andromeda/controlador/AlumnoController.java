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

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

/**
 * Controlador (Servlet) para manejar las peticiones web relacionadas con Alumno.
 * Intercepta las solicitudes HTTP, interactua con el DAO y redirige a las vistas (JSP).
 */
@WebServlet(name = "AlumnoController", urlPatterns = {"/alumnos"})
public class AlumnoController extends HttpServlet {

    // Instanciamos nuestro DAO para poder usar sus metodos de base de datos
    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    /**
     * Maneja las peticiones de tipo GET (Cuando el usuario entra a la pagina o recarga).
     * Su objetivo es extraer los datos y enviarlos a la vista.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtenemos la lista de alumnos desde PostgreSQL a traves del DAO
        List<Alumno> lista = alumnoDAO.listarAlumnos();
        
        // 2. Guardamos la lista en la peticion (request) con la etiqueta "listaAlumnos"
        // para que la pagina web (JSP) pueda leerla e imprimirla en una tabla.
        request.setAttribute("listaAlumnos", lista);
        
        // 3. Redirigimos (despachamos) la peticion hacia nuestro archivo visual (alumnos.jsp)
        request.getRequestDispatcher("alumnos.jsp").forward(request, response);
    }

    /**
     * Maneja las peticiones de tipo POST (Cuando el usuario hace clic en "Guardar" en el formulario).
     * Su objetivo es recibir los textos, armar el objeto y mandarlo a guardar.
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Recibimos los datos enviados desde los <input> del formulario HTML/JSP
        String numDocumento = request.getParameter("numDocumento");
        String nombres = request.getParameter("nombres");
        String apPaterno = request.getParameter("apPaterno");
        String apMaterno = request.getParameter("apMaterno");
        String fechaNacimiento = request.getParameter("fechaNacimiento");
        String celular = request.getParameter("celular");
        String correo = request.getParameter("correo");
        
        // Los datos llegan como texto (String), por lo que debemos convertir los numeros
        int idGrado = Integer.parseInt(request.getParameter("idGrado"));
        int idSeccion = 1; // Forzamos un valor por defecto para este ejercicio

        // 2. Construimos el objeto Modelo con los datos recibidos
        Alumno nuevoAlumno = new Alumno();
        nuevoAlumno.setNumDocumento(numDocumento);
        nuevoAlumno.setNombres(nombres);
        nuevoAlumno.setApPaterno(apPaterno);
        nuevoAlumno.setApMaterno(apMaterno);
        nuevoAlumno.setFechaNacimiento(LocalDate.parse(fechaNacimiento));
        nuevoAlumno.setCelular(celular);
        nuevoAlumno.setCorreo(correo);
        nuevoAlumno.setIdGrado(idGrado);
        nuevoAlumno.setIdSeccion(idSeccion);

        // 3. Llamamos al DAO para ejecutar el INSERT en PostgreSQL
        boolean registrado = alumnoDAO.registrarAlumno(nuevoAlumno);

        // 4. Patrón Post-Redirect-Get: Redirigimos nuevamente a la URL "/alumnos" por metodo GET
        // Esto evita que si el usuario presiona F5, el formulario se reenvie y se duplique el alumno.
        if (registrado) {
            response.sendRedirect("alumnos");
        } else {
            // Si algo falla, redirigimos pero enviamos una bandera de error en la URL
            response.sendRedirect("alumnos?error=true");
        }
    }
}