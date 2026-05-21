/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package finesi.app.andromeda.controlador;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controlador para destruir la sesión del usuario.
 */
@WebServlet(name = "LogoutController", urlPatterns = {"/logout"})
public class LogoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Obtenemos la sesión actual (sin crear una nueva)
        HttpSession sesion = request.getSession(false);
        
        // 2. Si existe la sesión, la destruimos
        if (sesion != null) {
            sesion.invalidate();
        }
        
        // 3. Redirigimos al inicio con un mensaje de despedida
        response.sendRedirect(request.getContextPath() + "/?estado=logout");
    }
}