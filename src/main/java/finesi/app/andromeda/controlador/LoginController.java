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

@WebServlet(name = "LoginController", urlPatterns = {"/login", "/LoginController"})
public class LoginController extends HttpServlet {

    private final UsuarioDAO usuarioDAO = new UsuarioDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null || username.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("error", "Por favor, ingrese sus credenciales completas.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        Usuario user = usuarioDAO.validarLogin(username.trim(), password.trim());

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("usuarioLogueado", user);
            session.setAttribute("rol", user.getRol());

            // Redirección inteligente por ROL
            switch (user.getRol().toUpperCase()) {
                case "ADMIN":
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
                    break;
                case "DOCENTE":
                    response.sendRedirect(request.getContextPath() + "/docente/dashboard.jsp");
                    break;
                case "ALUMNO":
                default:
                    response.sendRedirect(request.getContextPath() + "/alumno/dashboard.jsp");
                    break;
            }
        } else {
            request.setAttribute("error", "Usuario o contraseña incorrectos, o la cuenta está inactiva.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}