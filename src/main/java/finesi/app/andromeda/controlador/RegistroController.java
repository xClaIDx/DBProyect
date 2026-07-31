/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.dao.AlumnoDAO;
import finesi.app.andromeda.modelo.Alumno;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

@WebServlet(name = "RegistroController", urlPatterns = {"/registro"})
public class RegistroController extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        try {
            // 1. Capturar datos del formulario modal de inscripción
            String numDocumento = request.getParameter("numDocumento");
            String nombres = request.getParameter("nombres");
            String apPaterno = request.getParameter("apPaterno");
            String apMaterno = request.getParameter("apMaterno");
            String fechaNacimiento = request.getParameter("fechaNacimiento");
            String celular = request.getParameter("celular");
            String correo = request.getParameter("correo");
            String ubigeoNac = request.getParameter("ubigeoNacimiento");
            String ubigeoDom = request.getParameter("ubigeoDomicilio");

            int idGrado = Integer.parseInt(request.getParameter("idGrado"));
            int idSeccion = Integer.parseInt(request.getParameter("idSeccion"));
            
            // Nuevos parámetros clave de postulación
            int idPeriodo = Integer.parseInt(request.getParameter("idPeriodo"));
            int idCarrera = Integer.parseInt(request.getParameter("idCarrera"));

            // 2. Construir objeto Alumno
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
            nuevoAlumno.setUbigeoNacimiento(ubigeoNac);
            nuevoAlumno.setUbigeoDomicilio(ubigeoDom);
            nuevoAlumno.setIdGrado(idGrado);
            nuevoAlumno.setIdSeccion(idSeccion);

            // 3. Ejecutar registro atómico (Crea Usuario + Alumno y devuelve ID de alumno generado)
            boolean registrado = alumnoDAO.registrarAlumnoConUsuario(nuevoAlumno);

            if (registrado) {
                // Obtenemos el id_alumno recién creado mediante el DNI
                Alumno alumnoCreado = alumnoDAO.obtenerPorDni(numDocumento);
                
                if (alumnoCreado != null) {
                    // 4. Insertar automáticamente la postulación activa en public.postulante
                    registrarPostulacion(alumnoCreado.getIdAlumno(), idPeriodo, idCarrera);
                }

                request.getSession().setAttribute("mensajeExito", "¡Inscripción exitosa al Simulacro! Ya puedes iniciar sesión con tu DNI.");
                response.sendRedirect(request.getContextPath() + "/index.jsp?estado=exito");
            } else {
                request.setAttribute("error", "Ocurrió un problema al guardar el registro. Verifique sus datos.");
                request.getRequestDispatcher("/index.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error interno en el proceso de inscripción: " + e.getMessage());
            request.getRequestDispatcher("/index.jsp").forward(request, response);
        }
    }

    private void registrarPostulante(Long idAlumno, int idPeriodo, int idCarrera) {
        // Método auxiliar privado de inserción de postulante
    }

    private void registrarPostulacion(Long idAlumno, int idPeriodo, int idCarrera) {
        String sql = "INSERT INTO public.postulante (id_alumno, id_periodo, id_carrera) VALUES (?, ?, ?)";
        try (Connection conn = ConexionDB.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setLong(1, idAlumno);
            stmt.setInt(2, idPeriodo);
            stmt.setInt(3, idCarrera);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}