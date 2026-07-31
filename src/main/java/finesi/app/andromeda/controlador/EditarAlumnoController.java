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

@WebServlet(name = "EditarAlumnoController", urlPatterns = {"/editarAlumno"})
public class EditarAlumnoController extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        HttpSession sesion = request.getSession(false);
        Usuario user = (sesion != null) ? (Usuario) sesion.getAttribute("usuarioLogueado") : null;

        if (user == null || (!"ADMIN".equals(user.getRol()) && !"DOCENTE".equals(user.getRol()))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?estado=sin_permiso");
            return;
        }

        try {
            Long id = Long.parseLong(request.getParameter("idAlumno"));
            String dni = request.getParameter("numDocumento");
            String nombres = request.getParameter("nombres");
            String apPaterno = request.getParameter("apPaterno");
            String apMaterno = request.getParameter("apMaterno");
            String fechaNac = request.getParameter("fechaNacimiento");
            String celular = request.getParameter("celular");
            String correo = request.getParameter("correo");

            int idGrado = Integer.parseInt(request.getParameter("idGrado"));
            int idSeccion = Integer.parseInt(request.getParameter("idSeccion"));
            int idCarrera = Integer.parseInt(request.getParameter("idCarrera"));
            int idPeriodo = Integer.parseInt(request.getParameter("idPeriodo"));

            Alumno a = new Alumno();
            a.setIdAlumno(id);
            a.setNumDocumento(dni);
            a.setNombres(nombres);
            a.setApPaterno(apPaterno);
            a.setApMaterno(apMaterno);
            if (fechaNac != null && !fechaNac.trim().isEmpty()) {
                a.setFechaNacimiento(Date.valueOf(fechaNac));
            }
            a.setCelular(celular);
            a.setCorreo(correo);
            a.setIdGrado(idGrado);
            a.setIdSeccion(idSeccion);

            boolean exito = alumnoDAO.actualizarAlumnoCompleto(a, idCarrera, idPeriodo);

            if (exito) {
                request.getSession().setAttribute("msgExitoAdmin", "¡Ficha completa del alumno actualizada correctamente!");
            } else {
                request.getSession().setAttribute("msgErrorAdmin", "Error al guardar los cambios del alumno.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msgErrorAdmin", "Excepción al editar alumno: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
    }
}