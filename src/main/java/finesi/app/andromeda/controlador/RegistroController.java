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

/**
 * Controlador de Acceso Público para el Registro de Postulantes.
 * Intercepta las solicitudes POST que vienen desde el Modal en index.jsp.
 */
@WebServlet(name = "RegistroController", urlPatterns = {"/registro"})
public class RegistroController extends HttpServlet {

    // Instanciamos el DAO que ya tienes creado
    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    /**
     * Solo implementamos doPost porque los datos del formulario 
     * viajan de forma oculta (método POST por seguridad).
     * @param request
     * @param response
     * @throws jakarta.servlet.ServletException
     * @throws java.io.IOException
     */
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirigimos al inicio si alguien intenta acceder por URL directa
        response.sendRedirect(request.getContextPath() + "/");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Recibimos los nuevos datos
        Alumno postulante = new Alumno();
        postulante.setNumDocumento(request.getParameter("numDocumento"));
        postulante.setNombres(request.getParameter("nombres"));
        // ... setear el resto de datos ...
        postulante.setCiclo(request.getParameter("ciclo"));
        postulante.setArea(request.getParameter("area"));
        postulante.setIdCarrera(Integer.valueOf(request.getParameter("idCarrera")));
        postulante.setIdPeriodo(Integer.valueOf(request.getParameter("idPeriodo")));
        postulante.setFechaNacimiento(LocalDate.now()); // Ajusta según tu formulario
        postulante.setIdGrado(2); // Ejemplo

        // 2. Ejecutamos la matrícula (Registro en Alumno y Postulante simultáneamente)
        Long idPostulante = alumnoDAO.registrarMatriculaCompleta(postulante);

        // 3. Si tuvo éxito, enviamos al usuario al certificado
        if (idPostulante != null) {
            // Redirigimos al servlet del certificado con el DNI para que este lo busque
            response.sendRedirect("certificado?dni=" + postulante.getNumDocumento());
        } else {
            response.sendRedirect("?estado=error");
        }
    }
}