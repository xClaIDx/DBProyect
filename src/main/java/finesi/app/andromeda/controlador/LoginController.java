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
 * Controlador para la Autenticación del Sistema.
 * Recibe las credenciales desde la Landing Page (index.jsp).
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Capturamos lo que el usuario escribió en la barra lateral
        String usuario = request.getParameter("username");
        String clave = request.getParameter("password");
        
        // 2. Validamos las credenciales (Más adelante esto consultará al DAO)
        // Usaremos tu usuario de base de datos como credencial de prueba
        if ("admin".equals(usuario) && "Andromeda".equals(clave)) {
            
            // 3. ¡CREAMOS LA SESIÓN! 
            // Esto es como darle un "Gafete VIP" al usuario para que navegue por el sistema
            HttpSession sesion = request.getSession();
            sesion.setAttribute("adminLogueado", true);
            sesion.setAttribute("nombreAdmin", "Neil"); // Podremos usar esto en el Dashboard
            
            // 4. Redirigimos al área privada
            response.sendRedirect("alumnos");
            
        } else {
            // Si falla, lo devolvemos al inicio con una bandera de error
            response.sendRedirect(request.getContextPath() + "/?estado=error_login");
        }
    }
}