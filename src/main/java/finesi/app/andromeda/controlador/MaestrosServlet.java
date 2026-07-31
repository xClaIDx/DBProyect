package finesi.app.andromeda.controlador;

import finesi.app.andromeda.dao.MaestrosDAO;
import finesi.app.andromeda.modelo.Usuario;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;

@WebServlet(name = "MaestrosServlet", urlPatterns = {"/admin/maestros"})
public class MaestrosServlet extends HttpServlet {

    private final MaestrosDAO maestrosDAO = new MaestrosDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        Usuario user = (Usuario) request.getSession().getAttribute("usuarioLogueado");

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRol())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?estado=sin_permiso");
            return;
        }

        String accion = request.getParameter("accion");

        try {
            if ("crearArea".equalsIgnoreCase(accion)) {
                String nombreArea = request.getParameter("nombreArea");
                maestrosDAO.guardarArea(nombreArea);
            } else if ("crearCarrera".equalsIgnoreCase(accion)) {
                int idArea = Integer.parseInt(request.getParameter("idArea"));
                String nombreCarrera = request.getParameter("nombreCarrera");
                maestrosDAO.guardarCarrera(idArea, nombreCarrera);
            } else if ("crearPeriodo".equalsIgnoreCase(accion)) {
                String nombrePeriodo = request.getParameter("nombrePeriodo");
                int anio = Integer.parseInt(request.getParameter("anio"));
                int ciclo = Integer.parseInt(request.getParameter("ciclo"));
                maestrosDAO.guardarPeriodo(nombrePeriodo, anio, ciclo);
            } else if ("crearExamen".equalsIgnoreCase(accion)) {
                String nombreExamen = request.getParameter("nombreExamen");
                Date fecha = Date.valueOf(request.getParameter("fechaExamen"));
                String tipo = request.getParameter("tipoExamen");
                maestrosDAO.guardarExamen(nombreExamen, fecha, tipo);
            }
            request.getSession().setAttribute("msgExitoAdmin", "Registro maestro guardado con éxito.");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msgErrorAdmin", "Error al procesar el registro: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
    }
}