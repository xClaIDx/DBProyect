/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.ExamenDAO;
import finesi.app.andromeda.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin/asignarAula"})
public class AdminServlet extends HttpServlet {

    private final ExamenDAO examenDAO = new ExamenDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Usuario user = (session != null) ? (Usuario) session.getAttribute("usuarioLogueado") : null;

        // Validación de seguridad para Rol ADMIN
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRol())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?estado=sin_permiso");
            return;
        }

        try {
            int idDocente = Integer.parseInt(request.getParameter("idDocente"));
            int idPeriodo = Integer.parseInt(request.getParameter("idPeriodo"));
            String aula = request.getParameter("aula");
            String pabellon = request.getParameter("pabellon");

            String detalleAula = "Pabellon: " + pabellon + " - Aula: " + aula;

            // Registra la asignación en public.log_calificacion
            boolean exito = examenDAO.asignarDocenteAula(idDocente, idPeriodo, detalleAula);

            if (exito) {
                session.setAttribute("msgExitoAdmin", "¡Asignación de Aula (" + detalleAula + ") registrada correctamente!");
            } else {
                session.setAttribute("msgErrorAdmin", "No se pudo registrar la asignación del aula.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("msgErrorAdmin", "Error en los datos ingresados: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
    }
}