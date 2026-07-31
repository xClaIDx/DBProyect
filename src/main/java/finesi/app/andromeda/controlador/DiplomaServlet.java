/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.ResultadoDAO;
import finesi.app.andromeda.modelo.ResultadoDetalle;
import finesi.app.andromeda.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "DiplomaServlet", urlPatterns = {"/diploma"})
public class DiplomaServlet extends HttpServlet {

    private final ResultadoDAO resultadoDAO = new ResultadoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String dni = request.getParameter("dni");

        // Si no se envía DNI en la URL, tomar el del usuario en sesión
        if (dni == null || dni.trim().isEmpty()) {
            Usuario u = (Usuario) request.getSession().getAttribute("usuarioLogueado");
            if (u != null) {
                dni = u.getUsername();
            }
        }

        if (dni == null || dni.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        ResultadoDetalle resultado = resultadoDAO.obtenerResultadoPorDni(dni);

        // Validación estricta: Solo posiciones 1, 2 o 3 en el Ranking General
        if (resultado != null && resultado.getPosicionGeneral() != null && resultado.getPosicionGeneral() <= 3 && resultado.getPosicionGeneral() > 0) {
            request.setAttribute("resultado", resultado);
            request.getRequestDispatcher("/diploma.jsp").forward(request, response);
        } else {
            // Si no está en el Top 3 o no tiene notas, denegar acceso
            request.getSession().setAttribute("msgError", "El Diploma de Honor está reservado exclusivamente para los estudiantes ubicados en el Top 3 del Cómputo General.");
            response.sendRedirect(request.getContextPath() + "/alumno/dashboard.jsp");
        }
    }
}