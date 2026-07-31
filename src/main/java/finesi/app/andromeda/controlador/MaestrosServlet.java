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

        // 1. Verificación de Sesión y Rol
        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRol())) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?estado=sin_permiso");
            return; // Detiene la ejecución para evitar doble redirección
        }

        String accion = request.getParameter("accion");

        try {
            if ("crearArea".equalsIgnoreCase(accion)) {
                String nombreArea = request.getParameter("nombreArea");
                maestrosDAO.guardarArea(nombreArea);
                request.getSession().setAttribute("msgExitoAdmin", "Área creada con éxito.");

            } else if ("crearCarrera".equalsIgnoreCase(accion)) {
                int idArea = Integer.parseInt(request.getParameter("idArea"));
                String nombreCarrera = request.getParameter("nombreCarrera");
                maestrosDAO.guardarCarrera(idArea, nombreCarrera);
                request.getSession().setAttribute("msgExitoAdmin", "Carrera creada con éxito.");

            } else if ("crearPeriodo".equalsIgnoreCase(accion)) {
                String nombrePeriodo = request.getParameter("nombrePeriodo");
                int anio = Integer.parseInt(request.getParameter("anio"));
                int ciclo = Integer.parseInt(request.getParameter("ciclo"));
                String fechaInicioStr = request.getParameter("fechaInicioStr");
                String fechaExamenStr = request.getParameter("fechaExamenStr");

                boolean exito;
                // Si vienen fechas desde el formulario modal, usa la creación completa con fechas
                if (fechaInicioStr != null && !fechaInicioStr.trim().isEmpty() &&
                    fechaExamenStr != null && !fechaExamenStr.trim().isEmpty()) {
                    exito = maestrosDAO.crearPeriodoSimulacro(nombrePeriodo, anio, ciclo, fechaInicioStr, fechaExamenStr);
                } else {
                    exito = maestrosDAO.guardarPeriodo(nombrePeriodo, anio, ciclo);
                }

                if (exito) {
                    request.getSession().setAttribute("msgExitoAdmin", "Nuevo período de simulacro guardado y activado correctamente.");
                } else {
                    request.getSession().setAttribute("msgErrorAdmin", "No se pudo registrar el período en la base de datos.");
                }

            } else if ("cambiarEstadoPeriodo".equalsIgnoreCase(accion)) {
                int idPeriodo = Integer.parseInt(request.getParameter("idPeriodo"));
                String nuevoEstado = request.getParameter("nuevoEstado");
                if (nuevoEstado == null) {
                    nuevoEstado = request.getParameter("estado");
                }
                boolean exito = maestrosDAO.cambiarEstadoPeriodo(idPeriodo, nuevoEstado);
                if (exito) {
                    request.getSession().setAttribute("msgExitoAdmin", "Estado del período actualizado a: " + nuevoEstado);
                } else {
                    request.getSession().setAttribute("msgErrorAdmin", "No se pudo actualizar el estado del período.");
                }

            } else if ("crearExamen".equalsIgnoreCase(accion)) {
                String nombreExamen = request.getParameter("nombreExamen");
                Date fecha = Date.valueOf(request.getParameter("fechaExamen"));
                String tipo = request.getParameter("tipoExamen");
                maestrosDAO.guardarExamen(nombreExamen, fecha, tipo);
                request.getSession().setAttribute("msgExitoAdmin", "Examen guardado con éxito.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("msgErrorAdmin", "Error al procesar la solicitud: " + e.getMessage());
        }

        // 2. Redirección final segura
        if (!response.isCommitted()) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
        }
    }
}