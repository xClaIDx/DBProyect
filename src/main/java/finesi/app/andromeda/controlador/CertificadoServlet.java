package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.AlumnoDAO;
import finesi.app.andromeda.dao.PostulanteDAO;
import finesi.app.andromeda.dao.ResultadoDAO;
import finesi.app.andromeda.modelo.Alumno;
import finesi.app.andromeda.modelo.Postulante;
import finesi.app.andromeda.modelo.ResultadoDetalle;
import finesi.app.andromeda.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet(name = "CertificadoServlet", urlPatterns = {"/CertificadoServlet", "/documento"})
public class CertificadoServlet extends HttpServlet {

    private final AlumnoDAO alumnoDAO = new AlumnoDAO();
    private final PostulanteDAO postulanteDAO = new PostulanteDAO();
    private final ResultadoDAO resultadoDAO = new ResultadoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tipo = request.getParameter("tipo"); // 'constancia' o 'boleta'
        String dni = request.getParameter("dni");

        // Si no se envía DNI en la URL, se toma el del usuario en sesión
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

        if ("constancia".equalsIgnoreCase(tipo)) {
            Alumno al = alumnoDAO.obtenerPorDni(dni);
            if (al != null) {
                Postulante post = postulanteDAO.obtenerPostulacion(al.getIdAlumno(), 1);
                request.setAttribute("alumno", al);
                request.setAttribute("postulante", post);
                // Redirige al archivo en la raíz webapp/ o assets/ según corresponda
                request.getRequestDispatcher("/constancia_oficial.jsp").forward(request, response);
                return;
            }
        } else {
            ResultadoDetalle resultado = resultadoDAO.obtenerResultadoPorDni(dni);
            if (resultado != null) {
                request.setAttribute("resultado", resultado);
                request.getRequestDispatcher("/certificado.jsp").forward(request, response);
                return;
            }
        }

        request.setAttribute("error", "No se encontraron registros para generar el documento.");
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}