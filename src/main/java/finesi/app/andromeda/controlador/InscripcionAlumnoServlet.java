/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.conexion.ConexionDB;
import finesi.app.andromeda.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "InscripcionAlumnoServlet", urlPatterns = {"/alumno/inscribir", "/alumno/cancelarInscripcion"})
public class InscripcionAlumnoServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        Usuario user = (Usuario) request.getSession().getAttribute("usuarioLogueado");

        if (user == null || !"ALUMNO".equalsIgnoreCase(user.getRol())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?estado=requiere_login");
            return;
        }

        String path = request.getServletPath();

        try (Connection conn = ConexionDB.getConnection()) {

            if ("/alumno/inscribir".equals(path)) {
                long idAlumno = Long.parseLong(request.getParameter("idAlumno"));
                int idPeriodo = Integer.parseInt(request.getParameter("idPeriodo"));
                int idCarrera = Integer.parseInt(request.getParameter("idCarrera"));

                String sql = "INSERT INTO public.postulante (id_alumno, id_periodo, id_carrera) VALUES (?, ?, ?)";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setLong(1, idAlumno);
                    stmt.setInt(2, idPeriodo);
                    stmt.setInt(3, idCarrera);
                    stmt.executeUpdate();
                }
                request.getSession().setAttribute("msgExito", "¡Te has inscrito correctamente al simulacro!");

            } else if ("/alumno/cancelarInscripcion".equals(path)) {
                long idPostulante = Long.parseLong(request.getParameter("idPostulante"));

                String sql = "DELETE FROM public.postulante WHERE id_postulante = ?";
                try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                    stmt.setLong(1, idPostulante);
                    stmt.executeUpdate();
                }
                request.getSession().setAttribute("msgExito", "Inscripción cancelada correctamente.");
            }

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("msgError", "Ocurrió un problema: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/alumno/dashboard.jsp");
    }
}