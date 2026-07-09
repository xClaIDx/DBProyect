/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.AlumnoDAO;
import finesi.app.andromeda.modelo.Alumno;
import java.io.IOException;
import java.time.LocalDate;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "RegistroController", urlPatterns = {"/registro"})
public class RegistroController extends HttpServlet {
    
    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 1. Recolección exhaustiva de parámetros HTML
            String numDocumento = request.getParameter("numDocumento");
            String nombres = request.getParameter("nombres");
            String apPaterno = request.getParameter("apPaterno");
            String apMaterno = request.getParameter("apMaterno");
            String fechaNacRaw = request.getParameter("fechaNacimiento");
            String celular = request.getParameter("celular");
            String correo = request.getParameter("correo");
            String ubigeoNac = request.getParameter("ubigeoNacimiento");
            String ubigeoDom = request.getParameter("ubigeoDomicilio");
            
            int idPeriodo = Integer.parseInt(request.getParameter("idPeriodo"));
            int idGrado = Integer.parseInt(request.getParameter("idGrado"));
            int idSeccion = Integer.parseInt(request.getParameter("idSeccion"));
            int idCarrera = Integer.parseInt(request.getParameter("idCarrera"));

            // 2. Parseo seguro de la fecha
            LocalDate fechaNacimiento = LocalDate.parse(fechaNacRaw);

            // 3. Mapeo estructural hacia la entidad Alumno (DTO)
            Alumno postulante = new Alumno();
            postulante.setNumDocumento(numDocumento);
            postulante.setNombres(nombres);
            postulante.setApPaterno(apPaterno);
            postulante.setApMaterno(apMaterno);
            postulante.setFechaNacimiento(fechaNacimiento);
            postulante.setCelular(celular);
            postulante.setCorreo(correo);
            postulante.setUbigeoNacimiento(ubigeoNac);
            postulante.setUbigeoDomicilio(ubigeoDom);
            postulante.setIdGrado(idGrado);
            postulante.setIdSeccion(idSeccion);
            
            // Atributos de la relación transaccional intermedia
            postulante.setIdPeriodo(idPeriodo);
            postulante.setIdCarrera(idCarrera);

            // 4. Delegación transaccional al DAO
            Long idGenerado = alumnoDAO.registrarMatriculaCompleta(postulante);

            if (idGenerado != null) {
                // Éxito: Despacho automático hacia la constancia oficial
                response.sendRedirect(request.getContextPath() + "/certificado?dni=" + numDocumento);
            } else {
                response.sendRedirect(request.getContextPath() + "/home?estado=error");
            }
            
        } catch (Exception e) {
            System.err.println("[ERROR ANDROMEDA] Error en RegistroController crítico: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/home?estado=error");
        }
    }
}