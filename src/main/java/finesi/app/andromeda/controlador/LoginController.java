package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.UsuarioDAO;
import finesi.app.andromeda.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

/**
 * Controlador para la Autenticación del Sistema.
 * Conectado a la base de datos real mediante UsuarioDAO.
 */
@WebServlet(name = "LoginController", urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Capturamos credenciales enviadas desde index.jsp
        String username = request.getParameter("username");
        String clave = request.getParameter("password");
        
        // 2. Consultamos a la base de datos
        Usuario usuarioLogueado = usuarioDAO.autenticar(username, clave);
        
        // 3. Verificamos el resultado
        if (usuarioLogueado != null) {
            
            // ¡CREAMOS LA SESIÓN DE FORMA SEGURA!
            HttpSession sesion = request.getSession();
            sesion.setAttribute("usuarioActivo", usuarioLogueado);
            sesion.setAttribute("rolUsuario", usuarioLogueado.getRol());
            
            // COMPATIBILIDAD CON VISTAS ANTERIORES:
            // Tus controladores antiguos (como AlumnoController) validan con "adminLogueado"
            if ("ADMIN".equals(usuarioLogueado.getRol())) {
                sesion.setAttribute("adminLogueado", true);
                sesion.setAttribute("nombreAdmin", usuarioLogueado.getUsername());
            }
            
            // 4. Redireccionamiento Dinámico según el Rol
            switch (usuarioLogueado.getRol()) {
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/alumnos"); 
                    break;
                case "DOCENTE":
                    response.sendRedirect(request.getContextPath() + "/panel_docente"); 
                    break;
                case "ALUMNO":
                    response.sendRedirect(request.getContextPath() + "/panel_alumno"); 
                    break;
                default:
                    sesion.invalidate();
                    response.sendRedirect(request.getContextPath() + "/?estado=error");
                    break;
            }
            
        } else {
            // Si retorna null, las credenciales no existen o la cuenta está inactiva
            response.sendRedirect(request.getContextPath() + "/?estado=error_login");
        }
    }
}